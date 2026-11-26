package com.petcare.utils;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class EmailTemplateUtilTest {

    @Test
    void emailVerificationHtmlContainsBrandAndUserInfo() {
        String html = EmailTemplateUtil.buildEmailVerificationHtml("Phan Thanh Hiền", "http://localhost:8080/xac-thuc-email?token=abc123xyz", 24);

        assertNotNull(html);
        assertTrue(html.contains("PetCare"));
        assertTrue(html.contains("Pet Spa &amp; Grooming Lounge"));
        assertTrue(html.contains("Phan Thanh Hiền"));
        assertTrue(html.contains("http://localhost:8080/xac-thuc-email?token=abc123xyz"));
        assertTrue(html.contains("24 giờ"));
        assertTrue(html.contains("Xác thực email ngay"));
        assertTrue(html.contains("XÁC THỰC TÀI KHOẢN"));
    }

    @Test
    void emailVerificationHtmlHandlesNullOrBlankName() {
        String html1 = EmailTemplateUtil.buildEmailVerificationHtml(null, "http://localhost/verify", 24);
        String html2 = EmailTemplateUtil.buildEmailVerificationHtml("   ", "http://localhost/verify", 24);

        assertTrue(html1.contains("Quý khách"));
        assertTrue(html2.contains("Quý khách"));
    }

    @Test
    void passwordResetHtmlContainsSecurityWarningAndTokenLink() {
        String html = EmailTemplateUtil.buildPasswordResetHtml("Nguyễn Văn A", "http://localhost:8080/dat-lai-mat-khau?token=sec456", 15);

        assertNotNull(html);
        assertTrue(html.contains("PetCare"));
        assertTrue(html.contains("Nguyễn Văn A"));
        assertTrue(html.contains("http://localhost:8080/dat-lai-mat-khau?token=sec456"));
        assertTrue(html.contains("15 phút"));
        assertTrue(html.contains("Đặt lại mật khẩu"));
        assertTrue(html.contains("BẢO MẬT TÀI KHOẢN"));
        assertTrue(html.contains("vô hiệu hóa sau 1 lần sử dụng"));
    }

    @Test
    void passwordResetHtmlHandlesNullOrBlankName() {
        String html = EmailTemplateUtil.buildPasswordResetHtml("", "http://localhost/reset", 15);
        assertTrue(html.contains("Quý khách"));
    }

    @Test
    void htmlEscapesSpecialCharactersToPreventInjection() {
        String dangerousName = "<b>Hack</b> & \"quote\" 'apostrophe'";
        String html = EmailTemplateUtil.buildEmailVerificationHtml(dangerousName, "http://localhost/verify?x=1&y=2", 24);

        assertFalse(html.contains("<b>Hack</b>"));
        assertTrue(html.contains("&lt;b&gt;Hack&lt;/b&gt;"));
        assertTrue(html.contains("&amp;"));
        assertTrue(html.contains("&quot;quote&quot;"));
        assertTrue(html.contains("&#39;apostrophe&#39;"));
    }

    @Test
    void escapeHtmlHandlesNull() {
        assertEquals("", EmailTemplateUtil.escapeHtml(null));
    }
}
