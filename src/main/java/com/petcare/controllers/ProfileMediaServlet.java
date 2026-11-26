package com.petcare.controllers;

import com.petcare.daos.UserMediaDAO;
import com.petcare.daos.UserMediaDAOImpl;
import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.utils.CloudinaryUtil;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

@WebServlet(name = "ProfileMediaServlet", urlPatterns = {"/profile/media"})
@MultipartConfig(
        fileSizeThreshold = 256 * 1024,
        maxFileSize = 8 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ProfileMediaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AuthService authService = new AuthService();
    private final UserMediaDAO userMediaDAO = new UserMediaDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        Users sessionUser = SessionUtil.getCurrentUser(request);
        if (sessionUser == null) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, false, "", "",
                    "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            return;
        }

        Users activeUser;
        try {
            activeUser = authService.getUserById(sessionUser.getUserId());
            if (activeUser == null || !activeUser.isActive()) {
                SessionUtil.clearSession(request);
                writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, false, "", "",
                        "Tài khoản không còn hoạt động.");
                return;
            }
            userMediaDAO.hydrate(activeUser);
        } catch (SQLException e) {
            writeJson(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE, false, "", "",
                    "Không thể xác minh tài khoản từ cơ sở dữ liệu: " + e.getMessage());
            return;
        }

        String type = request.getParameter("type");
        String action = request.getParameter("action");
        if (type == null || (!"avatar".equalsIgnoreCase(type) && !"banner".equalsIgnoreCase(type))) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, "", "",
                    "Loại ảnh không hợp lệ (chỉ hỗ trợ avatar hoặc banner).");
            return;
        }
        boolean isAvatar = "avatar".equalsIgnoreCase(type);
        String normalizedType = isAvatar ? "avatar" : "banner";
        String oldUrl = isAvatar ? activeUser.getAvatarUrl() : activeUser.getBannerUrl();

        try {
            if ("remove".equalsIgnoreCase(action)) {
                if (isAvatar) {
                    userMediaDAO.updateAvatarUrl(activeUser.getUserId(), null);
                    activeUser.setAvatarUrl(null);
                } else {
                    userMediaDAO.updateBannerUrl(activeUser.getUserId(), null);
                    activeUser.setBannerUrl(null);
                }
                activeUser.setMediaLoaded(true);
                SessionUtil.refreshSessionUser(request, activeUser);
                CloudinaryUtil.deleteByUrl(oldUrl);

                String msg = isAvatar
                        ? "Đã khôi phục ảnh đại diện mặc định."
                        : "Đã khôi phục ảnh bìa mặc định.";
                writeJson(response, HttpServletResponse.SC_OK, true, normalizedType, "", msg);
                return;
            }

            Part filePart;
            try {
                filePart = request.getPart("file");
            } catch (IllegalStateException sizeErr) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, normalizedType, "",
                        "Ảnh vượt quá dung lượng tối đa 8 MB.");
                return;
            }
            if (filePart == null || filePart.getSize() <= 0) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, normalizedType, "",
                        "Vui lòng chọn tệp ảnh để tải lên.");
                return;
            }
            if (filePart.getSize() > CloudinaryUtil.MAX_IMAGE_BYTES) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, normalizedType, "",
                        "Ảnh vượt quá dung lượng tối đa 8 MB.");
                return;
            }

            byte[] bytes;
            try (InputStream in = filePart.getInputStream()) {
                bytes = in.readAllBytes();
            }

            String folder = isAvatar ? "petcare/avatars" : "petcare/banners";
            String filenameBase = normalizedType + "_u" + activeUser.getUserId() + "_" + System.currentTimeMillis();
            String uploadedUrl = CloudinaryUtil.uploadImage(bytes, folder, filenameBase);

            try {
                if (isAvatar) {
                    userMediaDAO.updateAvatarUrl(activeUser.getUserId(), uploadedUrl);
                    activeUser.setAvatarUrl(uploadedUrl);
                } else {
                    userMediaDAO.updateBannerUrl(activeUser.getUserId(), uploadedUrl);
                    activeUser.setBannerUrl(uploadedUrl);
                }
            } catch (SQLException dbErr) {
                // Roll back orphan Cloudinary asset if DB save fails
                CloudinaryUtil.deleteByUrl(uploadedUrl);
                throw dbErr;
            }

            activeUser.setMediaLoaded(true);
            SessionUtil.refreshSessionUser(request, activeUser);

            if (oldUrl != null && !oldUrl.equals(uploadedUrl)) {
                CloudinaryUtil.deleteByUrl(oldUrl);
            }

            String msg = isAvatar
                    ? "Cập nhật ảnh đại diện thành công!"
                    : "Cập nhật ảnh bìa hồ sơ thành công!";
            writeJson(response, HttpServletResponse.SC_OK, true, normalizedType, uploadedUrl, msg);
        } catch (IllegalArgumentException e) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST, false, normalizedType, "", e.getMessage());
        } catch (IllegalStateException e) {
            writeJson(response, HttpServletResponse.SC_SERVICE_UNAVAILABLE, false, normalizedType, "", e.getMessage());
        } catch (SQLException e) {
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, false, normalizedType, "",
                    "Không thể lưu đường dẫn ảnh vào cơ sở dữ liệu: " + e.getMessage());
        } catch (IOException e) {
            writeJson(response, HttpServletResponse.SC_BAD_GATEWAY, false, normalizedType, "",
                    "Lỗi tải ảnh lên Cloudinary: " + e.getMessage());
        }
    }

    private static void writeJson(HttpServletResponse response, int status, boolean ok,
                                  String type, String url, String message) throws IOException {
        response.setStatus(status);
        String json = "{"
                + "\"ok\":" + ok + ","
                + "\"type\":\"" + escapeJson(type) + "\","
                + "\"url\":\"" + escapeJson(url) + "\","
                + "\"message\":\"" + escapeJson(message) + "\""
                + "}";
        response.getWriter().write(json);
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '\b' -> sb.append("\\b");
                case '\f' -> sb.append("\\f");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                default -> {
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
                }
            }
        }
        return sb.toString();
    }
}
