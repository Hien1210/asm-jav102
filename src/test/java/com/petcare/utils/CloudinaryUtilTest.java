package com.petcare.utils;

import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class CloudinaryUtilTest {

    @Test
    void parseCloudinaryUrlExtractsCredentials() {
        CloudinaryUtil.Credentials creds =
                CloudinaryUtil.parseCloudinaryUrl("cloudinary://123456:mySecretKey@demo_cloud");
        assertEquals("demo_cloud", creds.cloudName());
        assertEquals("123456", creds.apiKey());
        assertEquals("mySecretKey", creds.apiSecret());
    }

    @Test
    void parseCloudinaryUrlRejectsInvalidSchemeOrMissingParts() {
        assertThrows(IllegalStateException.class, () -> CloudinaryUtil.parseCloudinaryUrl("https://example.com"));
        assertThrows(IllegalStateException.class, () -> CloudinaryUtil.parseCloudinaryUrl("cloudinary://onlykey@cloud"));
        assertThrows(IllegalStateException.class, () -> CloudinaryUtil.parseCloudinaryUrl("cloudinary://:secret@cloud"));
    }

    @Test
    void computeSignatureMatchesOfficialCloudinaryVector() {
        // Cloudinary Upload API documentation SHA-1 test vector:
        // SHA1("eager=w_400,h_300,c_pad|w_260,h_200,c_crop&public_id=sample_image&timestamp=1315060510abcd")
        String sig = CloudinaryUtil.computeSignature(
                Map.of(
                        "timestamp", "1315060510",
                        "public_id", "sample_image",
                        "eager", "w_400,h_300,c_pad|w_260,h_200,c_crop"
                ),
                "abcd"
        );
        assertEquals("bfd09f95f331f558cbd1320e67aa8d488770583e", sig);
    }

    @Test
    void extractPublicIdHandlesVersionAndFolder() {
        assertEquals(
                "petcare/avatars/avatar_u3_12345",
                CloudinaryUtil.extractPublicId("https://res.cloudinary.com/dut8qxmt/image/upload/v1732170000/petcare/avatars/avatar_u3_12345.jpg")
        );
        assertEquals(
                "petcare/banners/banner_u3",
                CloudinaryUtil.extractPublicId("https://res.cloudinary.com/dut8qxmt/image/upload/c_fill,w_1600/v999/petcare/banners/banner_u3.webp?foo=1")
        );
        assertNull(CloudinaryUtil.extractPublicId("https://example.com/photo.jpg"));
        assertTrue(CloudinaryUtil.isCloudinaryUrl("https://res.cloudinary.com/dut8qxmt/image/upload/v1/test.jpg"));
        assertFalse(CloudinaryUtil.isCloudinaryUrl("https://evil.example/test.jpg"));
    }

    @Test
    void validateImageBytesAcceptsSupportedFormatsAndRejectsInvalid() {
        byte[] jpeg = new byte[]{(byte) 0xFF, (byte) 0xD8, (byte) 0xFF, (byte) 0xE0};
        assertEquals("image/jpeg", CloudinaryUtil.validateImageBytes(jpeg).mimeType());

        byte[] png = new byte[]{(byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
        assertEquals("image/png", CloudinaryUtil.validateImageBytes(png).mimeType());

        byte[] webp = "RIFF1234WEBPVP8 ".getBytes(StandardCharsets.US_ASCII);
        assertEquals("image/webp", CloudinaryUtil.validateImageBytes(webp).mimeType());

        byte[] gif = "GIF89a1234".getBytes(StandardCharsets.US_ASCII);
        assertEquals("image/gif", CloudinaryUtil.validateImageBytes(gif).mimeType());

        assertThrows(IllegalArgumentException.class, () -> CloudinaryUtil.validateImageBytes(new byte[0]));
        assertThrows(IllegalArgumentException.class,
                () -> CloudinaryUtil.validateImageBytes("<script>alert(1)</script>".getBytes(StandardCharsets.UTF_8)));
    }
}
