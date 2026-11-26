package com.petcare.utils;

/**
 * Utility for generating responsive, brand-aligned HTML emails for PetCare.
 * Compatible with major email clients (Gmail, Outlook, Apple Mail, Webmail).
 */
public final class EmailTemplateUtil {

    private EmailTemplateUtil() { }

    /**
     * Builds the HTML email body for account registration email verification.
     *
     * @param recipientName    full name of the user
     * @param verificationLink absolute link with verification token
     * @param validHours       number of hours the link remains valid
     * @return full HTML document string
     */
    public static String buildEmailVerificationHtml(String recipientName, String verificationLink, int validHours) {
        String safeName = escapeHtml(recipientName != null && !recipientName.isBlank() ? recipientName.trim() : "Quý khách");
        String safeLink = escapeHtml(verificationLink);

        String tag = "✨ XÁC THỰC TÀI KHOẢN";
        String heading = "Kích hoạt tài khoản PetCare";
        String intro = "Cảm ơn bạn đã đăng ký tài khoản tại <strong>PetCare</strong>! "
                + "Để hoàn tất đăng ký và bắt đầu trải nghiệm dịch vụ chăm sóc, làm đẹp và lưu trú thú cưng cao cấp, "
                + "vui lòng xác thực địa chỉ email của bạn bằng cách nhấn vào nút bên dưới.";
        String buttonText = "Xác thực email ngay";
        String expiryNotice = "Liên kết xác thực có hiệu lực trong vòng <strong>" + validHours + " giờ</strong>. "
                + "Sau thời gian này, bạn sẽ cần đăng ký lại hoặc yêu cầu gửi lại email xác thực.";
        String securityNote = "Nếu bạn không thực hiện đăng ký tài khoản tại PetCare, bạn hoàn toàn có thể an tâm bỏ qua email này.";

        return buildCardTemplate(safeName, safeLink, tag, heading, intro, buttonText, expiryNotice, securityNote, false);
    }

    /**
     * Builds the HTML email body for password reset request.
     *
     * @param recipientName full name of the user
     * @param resetLink     absolute link with password reset token
     * @param validMinutes  number of minutes the link remains valid
     * @return full HTML document string
     */
    public static String buildPasswordResetHtml(String recipientName, String resetLink, int validMinutes) {
        String safeName = escapeHtml(recipientName != null && !recipientName.isBlank() ? recipientName.trim() : "Quý khách");
        String safeLink = escapeHtml(resetLink);

        String tag = "🔒 BẢO MẬT TÀI KHOẢN";
        String heading = "Yêu cầu đặt lại mật khẩu";
        String intro = "Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản <strong>PetCare</strong> của bạn. "
                + "Nếu bạn là người gửi yêu cầu này, vui lòng nhấn vào nút bên dưới để tiến hành tạo mật khẩu mới.";
        String buttonText = "Đặt lại mật khẩu";
        String expiryNotice = "Vì lý do bảo mật, liên kết này chỉ có hiệu lực trong vòng <strong>" + validMinutes + " phút</strong> "
                + "và sẽ tự động vô hiệu hóa sau 1 lần sử dụng.";
        String securityNote = "Nếu bạn <strong>không</strong> yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này. "
                + "Mật khẩu hiện tại của bạn vẫn được giữ an toàn tuyệt đối.";

        return buildCardTemplate(safeName, safeLink, tag, heading, intro, buttonText, expiryNotice, securityNote, true);
    }

    private static String buildCardTemplate(String safeName, String safeLink, String tag, String heading,
                                            String intro, String buttonText, String expiryNotice,
                                            String securityNote, boolean isWarning) {
        String expiryBg = isWarning ? "#FFFBEB" : "#F0FDF4";
        String expiryBorder = isWarning ? "#FDE68A" : "#BBF7D0";
        String expiryColor = isWarning ? "#92400E" : "#166534";
        String expiryIcon = isWarning ? "⏳" : "⏱";

        return "<!DOCTYPE html>\n"
                + "<html lang=\"vi\" xmlns=\"http://www.w3.org/1999/xhtml\">\n"
                + "<head>\n"
                + "  <meta charset=\"UTF-8\" />\n"
                + "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />\n"
                + "  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n"
                + "  <title>PetCare</title>\n"
                + "  <!--[if mso]>\n"
                + "  <style type=\"text/css\">\n"
                + "    table, td, div, p, a { font-family: -apple-system, Arial, sans-serif !important; }\n"
                + "  </style>\n"
                + "  <![endif]-->\n"
                + "</head>\n"
                + "<body style=\"margin:0;padding:0;background-color:#F1FBF7;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;-webkit-font-smoothing:antialiased;color:#475569;\">\n"
                + "  <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background-color:#F1FBF7;padding:32px 12px;margin:0 auto;\">\n"
                + "    <tr>\n"
                + "      <td align=\"center\">\n"
                + "        <!-- Main Card -->\n"
                + "        <table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"max-width:580px;width:100%;background-color:#FFFFFF;border-radius:18px;overflow:hidden;border:1px solid #C5ECE0;box-shadow:0 10px 28px rgba(7,92,69,0.08);\">\n"
                + "          <!-- Header Banner -->\n"
                + "          <tr>\n"
                + "            <td align=\"center\" style=\"background:linear-gradient(135deg,#075C45 0%,#008F68 100%);background-color:#075C45;padding:34px 24px 28px;text-align:center;\">\n"
                + "              <div style=\"display:inline-block;width:52px;height:52px;line-height:52px;background-color:rgba(255,255,255,0.18);border-radius:14px;text-align:center;font-size:28px;margin-bottom:10px;\">🐾</div>\n"
                + "              <div style=\"font-size:26px;font-weight:800;color:#FFFFFF;letter-spacing:-0.5px;margin:0 0 4px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;\">PetCare</div>\n"
                + "              <div style=\"font-size:12px;font-weight:600;color:#D9F7EC;letter-spacing:1.2px;text-transform:uppercase;\">Pet Spa &amp; Grooming Lounge</div>\n"
                + "            </td>\n"
                + "          </tr>\n"
                + "          <!-- Body Content -->\n"
                + "          <tr>\n"
                + "            <td style=\"padding:36px 32px 28px;\">\n"
                + "              <!-- Tag Badge -->\n"
                + "              <div style=\"display:inline-block;padding:5px 14px;background-color:#D9F7EC;color:#075C45;border-radius:20px;font-size:11px;font-weight:700;letter-spacing:0.6px;text-transform:uppercase;margin-bottom:18px;\">" + tag + "</div>\n"
                + "              <!-- Heading -->\n"
                + "              <h1 style=\"margin:0 0 16px;font-size:22px;font-weight:700;color:#102235;line-height:1.35;\">" + heading + "</h1>\n"
                + "              <!-- Greeting -->\n"
                + "              <p style=\"margin:0 0 14px;font-size:16px;font-weight:600;color:#102235;line-height:1.5;\">Xin chào <span style=\"color:#075C45;\">" + safeName + "</span>,</p>\n"
                + "              <!-- Intro Paragraph -->\n"
                + "              <p style=\"margin:0 0 24px;font-size:15px;line-height:1.65;color:#475569;\">" + intro + "</p>\n"
                + "              <!-- Button Center -->\n"
                + "              <table role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:100%;margin:26px 0 28px;\">\n"
                + "                <tr>\n"
                + "                  <td align=\"center\">\n"
                + "                    <a href=\"" + safeLink + "\" target=\"_blank\" style=\"display:inline-block;background-color:#075C45;background:linear-gradient(135deg,#075C45 0%,#008F68 100%);color:#FFFFFF !important;font-size:15px;font-weight:700;text-decoration:none;padding:14px 36px;border-radius:10px;box-shadow:0 4px 14px rgba(7,92,69,0.28);text-align:center;\">" + buttonText + " &rarr;</a>\n"
                + "                  </td>\n"
                + "                </tr>\n"
                + "              </table>\n"
                + "              <!-- Expiry Box -->\n"
                + "              <div style=\"background-color:" + expiryBg + ";border:1px solid " + expiryBorder + ";border-radius:10px;padding:14px 18px;margin:0 0 22px;font-size:14px;line-height:1.6;color:" + expiryColor + ";\">\n"
                + "                <span style=\"font-size:16px;margin-right:4px;\">" + expiryIcon + "</span> " + expiryNotice + "\n"
                + "              </div>\n"
                + "              <!-- Fallback Direct Link -->\n"
                + "              <p style=\"margin:0 0 6px;font-size:13px;line-height:1.5;color:#64748B;\">Nếu nút bấm phía trên không hoạt động, bạn hãy sao chép và dán liên kết sau vào trình duyệt:</p>\n"
                + "              <p style=\"margin:0 0 22px;word-break:break-all;font-size:12px;line-height:1.5;\"><a href=\"" + safeLink + "\" style=\"color:#008F68;text-decoration:underline;\">" + safeLink + "</a></p>\n"
                + "              <!-- Security Note -->\n"
                + "              <div style=\"padding-top:18px;border-top:1px dashed #E2E8F0;font-size:13px;line-height:1.6;color:#64748B;font-style:italic;\">\n"
                + "                " + securityNote + "\n"
                + "              </div>\n"
                + "            </td>\n"
                + "          </tr>\n"
                + "          <!-- Card Footer -->\n"
                + "          <tr>\n"
                + "            <td style=\"background-color:#F8FAFC;border-top:1px solid #E2E8F0;padding:24px 32px;text-align:center;font-size:12px;line-height:1.6;color:#64748B;\">\n"
                + "              <div style=\"font-weight:700;color:#102235;margin-bottom:4px;\">🐾 PetCare — Hệ thống Chăm sóc &amp; Khách sạn Thú cưng Chuyên nghiệp</div>\n"
                + "              <div>Hotline hỗ trợ: <strong style=\"color:#075C45;\">1900 8888</strong> &bull; Email: <a href=\"mailto:support@petcare.vn\" style=\"color:#008F68;text-decoration:none;\">support@petcare.vn</a></div>\n"
                + "              <div style=\"margin-top:8px;font-size:11px;color:#94A3B8;\">&copy; 2026 PetCare. Toàn bộ quyền được bảo lưu.</div>\n"
                + "            </td>\n"
                + "          </tr>\n"
                + "        </table>\n"
                + "      </td>\n"
                + "    </tr>\n"
                + "  </table>\n"
                + "</body>\n"
                + "</html>";
    }

    public static String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
