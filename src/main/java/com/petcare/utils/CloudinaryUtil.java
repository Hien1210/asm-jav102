package com.petcare.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Pure-JDK signed REST client for Cloudinary Upload API v1_1.
 * Reads credentials from ConfigUtil ("cloudinary.url" / env CLOUDINARY_URL)
 * or separate keys (cloudinary.cloudName, cloudinary.apiKey, cloudinary.apiSecret).
 */
public final class CloudinaryUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(CloudinaryUtil.class);
    public static final int MAX_IMAGE_BYTES = 8 * 1024 * 1024; // 8 MB

    private static final Pattern SECURE_URL_PATTERN =
            Pattern.compile("\"secure_url\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
    private static final Pattern ERROR_MSG_PATTERN =
            Pattern.compile("\"error\"\\s*:\\s*\\{[^}]*\"message\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(15))
            .build();

    private CloudinaryUtil() { }

    public record Credentials(String cloudName, String apiKey, String apiSecret) { }

    public record ImageFormat(String extension, String mimeType) { }

    public static Credentials resolveCredentials() {
        String rawUrl = ConfigUtil.get("cloudinary.url", "CLOUDINARY_URL", "");
        if (rawUrl != null && !rawUrl.isBlank() && !"CHANGE_ME".equalsIgnoreCase(rawUrl.trim())) {
            return parseCloudinaryUrl(rawUrl.trim());
        }
        String cloudName = ConfigUtil.get("cloudinary.cloudName", "CLOUDINARY_CLOUD_NAME", "").trim();
        String apiKey = ConfigUtil.get("cloudinary.apiKey", "CLOUDINARY_API_KEY", "").trim();
        String apiSecret = ConfigUtil.get("cloudinary.apiSecret", "CLOUDINARY_API_SECRET", "").trim();
        if (!cloudName.isEmpty() && !apiKey.isEmpty() && !apiSecret.isEmpty()) {
            return new Credentials(cloudName, apiKey, apiSecret);
        }
        throw new IllegalStateException(
                "Cloudinary chưa được cấu hình. Vui lòng thiết lập CLOUDINARY_URL hoặc cloudinary.url trong application-local.properties.");
    }

    public static boolean isConfigured() {
        try {
            resolveCredentials();
            return true;
        } catch (IllegalStateException e) {
            return false;
        }
    }

    public static Credentials parseCloudinaryUrl(String rawUrl) {
        if (rawUrl == null || !rawUrl.startsWith("cloudinary://")) {
            throw new IllegalStateException("Định dạng CLOUDINARY_URL không hợp lệ (phải có dạng cloudinary://api_key:api_secret@cloud_name).");
        }
        String rest = rawUrl.substring("cloudinary://".length()).trim();
        int atIdx = rest.lastIndexOf('@');
        if (atIdx <= 0 || atIdx >= rest.length() - 1) {
            throw new IllegalStateException("CLOUDINARY_URL thiếu cloud_name, api_key hoặc api_secret.");
        }
        String userInfo = rest.substring(0, atIdx);
        String cloudPart = rest.substring(atIdx + 1);
        int slashIdx = cloudPart.indexOf('/');
        if (slashIdx >= 0) {
            cloudPart = cloudPart.substring(0, slashIdx);
        }
        int queryIdx = cloudPart.indexOf('?');
        if (queryIdx >= 0) {
            cloudPart = cloudPart.substring(0, queryIdx);
        }
        int sep = userInfo.indexOf(':');
        if (sep <= 0 || sep >= userInfo.length() - 1) {
            throw new IllegalStateException("CLOUDINARY_URL thiếu api_key hoặc api_secret.");
        }
        String apiKey = userInfo.substring(0, sep).trim();
        String apiSecret = userInfo.substring(sep + 1).trim();
        String cloudName = cloudPart.trim();
        if (cloudName.isEmpty() || apiKey.isEmpty() || apiSecret.isEmpty()) {
            throw new IllegalStateException("CLOUDINARY_URL thiếu cloud_name, api_key hoặc api_secret.");
        }
        return new Credentials(cloudName, apiKey, apiSecret);
    }

    /**
     * Validates image size and inspects leading magic bytes (JPEG, PNG, WebP, GIF).
     */
    public static ImageFormat validateImageBytes(byte[] bytes) {
        if (bytes == null || bytes.length == 0) {
            throw new IllegalArgumentException("Tệp ảnh trống. Vui lòng chọn ảnh hợp lệ.");
        }
        if (bytes.length > MAX_IMAGE_BYTES) {
            throw new IllegalArgumentException("Ảnh vượt quá dung lượng tối đa 8 MB.");
        }
        if (bytes.length >= 3
                && (bytes[0] & 0xFF) == 0xFF
                && (bytes[1] & 0xFF) == 0xD8
                && (bytes[2] & 0xFF) == 0xFF) {
            return new ImageFormat("jpg", "image/jpeg");
        }
        if (bytes.length >= 8
                && (bytes[0] & 0xFF) == 0x89
                && bytes[1] == 0x50
                && bytes[2] == 0x4E
                && bytes[3] == 0x47
                && bytes[4] == 0x0D
                && bytes[5] == 0x0A
                && bytes[6] == 0x1A
                && bytes[7] == 0x0A) {
            return new ImageFormat("png", "image/png");
        }
        if (bytes.length >= 12
                && bytes[0] == 'R' && bytes[1] == 'I' && bytes[2] == 'F' && bytes[3] == 'F'
                && bytes[8] == 'W' && bytes[9] == 'E' && bytes[10] == 'B' && bytes[11] == 'P') {
            return new ImageFormat("webp", "image/webp");
        }
        if (bytes.length >= 6
                && bytes[0] == 'G' && bytes[1] == 'I' && bytes[2] == 'F'
                && bytes[3] == '8' && (bytes[4] == '7' || bytes[4] == '9') && bytes[5] == 'a') {
            return new ImageFormat("gif", "image/gif");
        }
        throw new IllegalArgumentException("Định dạng ảnh không được hỗ trợ. Vui lòng chọn ảnh JPG, PNG, WebP hoặc GIF.");
    }

    /**
     * Uploads validated image bytes to Cloudinary and returns the HTTPS secure_url.
     */
    public static String uploadImage(byte[] imageBytes, String folder, String filenameBase) throws IOException {
        ImageFormat format = validateImageBytes(imageBytes);
        Credentials creds = resolveCredentials();
        String safeFolder = (folder != null && !folder.isBlank()) ? folder.trim() : "petcare/uploads";
        String safeBase = (filenameBase != null && !filenameBase.isBlank())
                ? filenameBase.replaceAll("[^a-zA-Z0-9_-]", "")
                : "img";
        String fileName = safeBase + "." + format.extension();

        long timestamp = System.currentTimeMillis() / 1000L;
        Map<String, String> signedParams = new TreeMap<>();
        signedParams.put("folder", safeFolder);
        signedParams.put("timestamp", String.valueOf(timestamp));
        String signature = computeSignature(signedParams, creds.apiSecret());

        String boundary = "----PetCareCloudinary" + UUID.randomUUID().toString().replace("-", "");
        byte[] body = buildMultipartBody(boundary, creds.apiKey(), safeFolder, timestamp, signature,
                fileName, format.mimeType(), imageBytes);

        URI endpoint = URI.create("https://api.cloudinary.com/v1_1/" + creds.cloudName() + "/image/upload");
        HttpRequest request = HttpRequest.newBuilder(endpoint)
                .timeout(Duration.ofSeconds(30))
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofByteArray(body))
                .build();

        HttpResponse<String> response;
        try {
            response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Quá trình tải ảnh lên Cloudinary bị gián đoạn.", e);
        }

        String responseBody = response.body() != null ? response.body() : "";
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            String apiError = extractJsonString(ERROR_MSG_PATTERN, responseBody);
            throw new IOException("Cloudinary từ chối tải ảnh (HTTP " + response.statusCode() + ")"
                    + (apiError != null ? ": " + apiError : "."));
        }

        String secureUrl = extractJsonString(SECURE_URL_PATTERN, responseBody);
        if (secureUrl == null || !secureUrl.startsWith("https://")) {
            throw new IOException("Cloudinary không trả về đường dẫn secure_url hợp lệ.");
        }
        return secureUrl;
    }

    /**
     * Best-effort delete of an existing Cloudinary image by its URL. Never throws.
     */
    public static void deleteByUrl(String cloudinaryUrl) {
        if (!isCloudinaryUrl(cloudinaryUrl)) {
            return;
        }
        String publicId = extractPublicId(cloudinaryUrl);
        if (publicId == null) {
            return;
        }
        try {
            Credentials creds = resolveCredentials();
            long timestamp = System.currentTimeMillis() / 1000L;
            Map<String, String> signedParams = new TreeMap<>();
            signedParams.put("public_id", publicId);
            signedParams.put("timestamp", String.valueOf(timestamp));
            String signature = computeSignature(signedParams, creds.apiSecret());

            String form = "public_id=" + urlEncode(publicId)
                    + "&api_key=" + urlEncode(creds.apiKey())
                    + "&timestamp=" + timestamp
                    + "&signature=" + urlEncode(signature);

            URI endpoint = URI.create("https://api.cloudinary.com/v1_1/" + creds.cloudName() + "/image/destroy");
            HttpRequest request = HttpRequest.newBuilder(endpoint)
                    .timeout(Duration.ofSeconds(15))
                    .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(form, StandardCharsets.UTF_8))
                    .build();
            HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.discarding());
        } catch (Exception e) {
            if (e instanceof InterruptedException) {
                Thread.currentThread().interrupt();
            }
            LOGGER.warn("Không thể xóa ảnh Cloudinary publicId={}: {}", publicId, e.getMessage());
        }
    }

    public static boolean isCloudinaryUrl(String url) {
        return url != null && url.startsWith("https://res.cloudinary.com/");
    }

    public static String extractPublicId(String cloudinaryUrl) {
        if (cloudinaryUrl == null || cloudinaryUrl.isBlank()) {
            return null;
        }
        int uploadIdx = cloudinaryUrl.indexOf("/upload/");
        if (uploadIdx < 0) {
            return null;
        }
        String afterUpload = cloudinaryUrl.substring(uploadIdx + "/upload/".length());
        int queryIdx = afterUpload.indexOf('?');
        if (queryIdx >= 0) {
            afterUpload = afterUpload.substring(0, queryIdx);
        }
        // Skip optional transformation segments and version segment (v1234567890/)
        String[] segments = afterUpload.split("/");
        int start = 0;
        for (int i = 0; i < segments.length - 1; i++) {
            if (segments[i].matches("v\\d+")) {
                start = i + 1;
                break;
            }
        }
        StringBuilder sb = new StringBuilder();
        for (int i = start; i < segments.length; i++) {
            if (sb.length() > 0) sb.append('/');
            sb.append(segments[i]);
        }
        String joined = sb.toString();
        int dotIdx = joined.lastIndexOf('.');
        if (dotIdx > 0) {
            joined = joined.substring(0, dotIdx);
        }
        return joined.isBlank() ? null : joined;
    }

    /**
     * Computes Cloudinary's documented SHA-1 signature:
     * alphabetical key=value pairs joined with '&', followed directly by api_secret.
     */
    public static String computeSignature(Map<String, String> params, String apiSecret) {
        TreeMap<String, String> sorted = new TreeMap<>(params);
        StringBuilder payload = new StringBuilder();
        for (Map.Entry<String, String> entry : sorted.entrySet()) {
            if (entry.getValue() == null || entry.getValue().isEmpty()) {
                continue;
            }
            if (payload.length() > 0) {
                payload.append('&');
            }
            payload.append(entry.getKey()).append('=').append(entry.getValue());
        }
        payload.append(apiSecret);
        return sha1Hex(payload.toString());
    }

    private static String sha1Hex(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] digest = md.digest(text.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder(digest.length * 2);
            for (byte b : digest) {
                hex.append(Character.forDigit((b >> 4) & 0xF, 16));
                hex.append(Character.forDigit(b & 0xF, 16));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-1 algorithm unavailable", e);
        }
    }

    private static byte[] buildMultipartBody(String boundary, String apiKey, String folder,
                                             long timestamp, String signature,
                                             String fileName, String mimeType, byte[] fileBytes) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream(fileBytes.length + 1024);
        writeFormField(out, boundary, "api_key", apiKey);
        writeFormField(out, boundary, "folder", folder);
        writeFormField(out, boundary, "timestamp", String.valueOf(timestamp));
        writeFormField(out, boundary, "signature", signature);

        out.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        out.write(("Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n")
                .getBytes(StandardCharsets.UTF_8));
        out.write(("Content-Type: " + mimeType + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
        out.write(fileBytes);
        out.write("\r\n".getBytes(StandardCharsets.UTF_8));
        out.write(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));
        return out.toByteArray();
    }

    private static void writeFormField(ByteArrayOutputStream out, String boundary, String name, String value)
            throws IOException {
        out.write(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        out.write(("Content-Disposition: form-data; name=\"" + name + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
        out.write(value.getBytes(StandardCharsets.UTF_8));
        out.write("\r\n".getBytes(StandardCharsets.UTF_8));
    }

    private static String extractJsonString(Pattern pattern, String json) {
        if (json == null) return null;
        Matcher m = pattern.matcher(json);
        if (!m.find()) return null;
        return m.group(1)
                .replace("\\/", "/")
                .replace("\\\"", "\"")
                .replace("\\\\", "\\");
    }

    private static String urlEncode(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
