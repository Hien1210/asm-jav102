package com.petcare.services;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.daos.EmailVerificationDAO;
import com.petcare.daos.EmailVerificationDAOImpl;
import com.petcare.daos.PasswordResetDAO;
import com.petcare.daos.PasswordResetDAOImpl;
import com.petcare.models.Users;
import com.petcare.utils.MailUtil;
import com.petcare.utils.ValidationUtil;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Base64;

public class AuthService {
    private static final int BCRYPT_COST = 12;
    private static final int RESET_TOKEN_VALID_MINUTES = 15;
    private static final int VERIFICATION_TOKEN_VALID_HOURS = 24;
    private final AccountDAO accountDAO;
    private final PasswordResetDAO passwordResetDAO;
    private final EmailVerificationDAO emailVerificationDAO;
    private final MailSender mailSender;

    @FunctionalInterface
    public interface MailSender {
        void send(String to, String subject, String htmlBody) throws Exception;
    }

    public AuthService() {
        this(new AccountDAOImpl(), new PasswordResetDAOImpl());
    }

    public AuthService(AccountDAO accountDAO) {
        this(accountDAO, new PasswordResetDAOImpl());
    }

    public AuthService(AccountDAO accountDAO, PasswordResetDAO passwordResetDAO) {
        this(accountDAO, passwordResetDAO, new EmailVerificationDAOImpl(), MailUtil::send);
    }

    public AuthService(AccountDAO accountDAO, PasswordResetDAO passwordResetDAO, MailSender mailSender) {
        this(accountDAO, passwordResetDAO, new EmailVerificationDAOImpl(), mailSender);
    }

    public AuthService(AccountDAO accountDAO, PasswordResetDAO passwordResetDAO,
                        EmailVerificationDAO emailVerificationDAO, MailSender mailSender) {
        this.accountDAO = accountDAO;
        this.passwordResetDAO = passwordResetDAO;
        this.emailVerificationDAO = emailVerificationDAO;
        this.mailSender = mailSender;
    }

    public static String hashPassword(String rawPassword) {
        if (rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, rawPassword.toCharArray());
    }

    public static boolean verifyPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }
        if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            BCrypt.Result result = BCrypt.verifyer().verify(rawPassword.toCharArray(), storedHash);
            return result.verified;
        }
        return MessageDigest.isEqual(
                rawPassword.getBytes(StandardCharsets.UTF_8),
                storedHash.getBytes(StandardCharsets.UTF_8)
        );
    }

    public Users registerCustomer(String fullName, String phone, String email, String rawPassword,
                                   String verifyPageBaseUrl) throws SQLException {
        String cleanName = fullName != null ? fullName.trim() : "";
        String cleanPhone = ValidationUtil.normalizePhone(phone);
        String cleanEmail = ValidationUtil.normalizeEmail(email);

        if (cleanName.isEmpty() || cleanName.length() > 100) {
            throw new IllegalArgumentException("Vui lòng nhập họ và tên.");
        }
        if (!ValidationUtil.isValidPhone(cleanPhone)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ (ví dụ: 0912345678).");
        }
        if (cleanEmail.isEmpty()) {
            // Bảng dbo.Users yêu cầu email NOT NULL UNIQUE; nếu người dùng không nhập thì sinh từ SĐT
            cleanEmail = cleanPhone + "@petcare.vn";
        } else if (!ValidationUtil.isValidEmail(cleanEmail)) {
            throw new IllegalArgumentException("Địa chỉ Email không đúng định dạng.");
        }
        if (rawPassword == null || rawPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu tạo mới phải có tối thiểu 8 ký tự.");
        }

        if (accountDAO.existsByPhone(cleanPhone)) {
            throw new IllegalArgumentException("Số điện thoại này đã được đăng ký tài khoản.");
        }
        if (accountDAO.existsByEmail(cleanEmail)) {
            throw new IllegalArgumentException("Địa chỉ Email này đã được sử dụng.");
        }

        Users newUser = new Users();
        newUser.setFullName(cleanName);
        newUser.setPhone(cleanPhone);
        newUser.setEmail(cleanEmail);
        newUser.setPasswordHash(hashPassword(rawPassword));
        newUser.setRole(Users.ROLE_CUSTOMER);
        newUser.setActive(true);

        Users created = accountDAO.create(newUser);
        sendVerificationEmailBestEffort(created, verifyPageBaseUrl);
        return created;
    }

    /**
     * Sends a verification link and only then stores its token, so a mail outage never leaves
     * a brand-new account locked out with no way to ever receive the link that unlocks it.
     */
    private void sendVerificationEmailBestEffort(Users user, String verifyPageBaseUrl) {
        try {
            String rawToken = generateSecureToken();
            String link = verifyPageBaseUrl + "?token=" + rawToken;
            String body = "<p>Xin chào " + escapeHtml(user.getFullName()) + ",</p>"
                    + "<p>Nhấn vào liên kết bên dưới để xác thực email và kích hoạt tài khoản PetCare của bạn. "
                    + "Liên kết có hiệu lực trong " + VERIFICATION_TOKEN_VALID_HOURS + " giờ.</p>"
                    + "<p><a href=\"" + link + "\">Xác thực email</a></p>";
            mailSender.send(user.getEmail(), "PetCare - Xác thực email", body);
            emailVerificationDAO.createToken(user.getUserId(), sha256Hex(rawToken),
                    LocalDateTime.now().plusHours(VERIFICATION_TOKEN_VALID_HOURS));
        } catch (Exception mailError) {
            // Mail outage or DB hiccup: don't gate login on a link the user never received.
        }
    }

    public void verifyEmail(String rawToken) throws SQLException {
        if (rawToken == null || rawToken.isBlank()) {
            throw new IllegalArgumentException("Liên kết xác thực không hợp lệ hoặc đã hết hạn.");
        }
        Integer userId = emailVerificationDAO.consumeToken(sha256Hex(rawToken));
        if (userId == null) {
            throw new IllegalArgumentException("Liên kết xác thực không hợp lệ hoặc đã hết hạn.");
        }
    }

    public Users authenticate(String identifier, String rawPassword) throws SQLException {
        if (identifier == null || identifier.isBlank() || rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ số điện thoại/email và mật khẩu.");
        }
        Users user = accountDAO.findByIdentifier(identifier);
        if (user == null || !verifyPassword(rawPassword, user.getPasswordHash())) {
            throw new IllegalArgumentException("Số điện thoại/Email hoặc mật khẩu không chính xác.");
        }
        if (!user.isActive()) {
            throw new IllegalArgumentException("Tài khoản của bạn hiện đang bị khóa. Vui lòng liên hệ quản trị viên.");
        }
        if (emailVerificationDAO.hasPendingVerification(user.getUserId())) {
            throw new IllegalArgumentException(
                    "Vui lòng xác thực email trước khi đăng nhập. Kiểm tra hộp thư (kể cả Spam) để lấy liên kết xác thực.");
        }
        return user;
    }

    public Users getUserById(int userId) throws SQLException {
        return accountDAO.findById(userId);
    }

    public Users updateProfile(int userId, String fullName, String phone, String email) throws SQLException {
        String cleanName = fullName != null ? fullName.trim() : "";
        String cleanPhone = ValidationUtil.normalizePhone(phone);
        String cleanEmail = ValidationUtil.normalizeEmail(email);

        if (cleanName.isEmpty() || cleanName.length() > 100) {
            throw new IllegalArgumentException("Vui lòng nhập họ và tên.");
        }
        if (!ValidationUtil.isValidPhone(cleanPhone)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ (ví dụ: 0912345678).");
        }
        if (cleanEmail.isEmpty() || !ValidationUtil.isValidEmail(cleanEmail)) {
            throw new IllegalArgumentException("Địa chỉ Email không đúng định dạng.");
        }

        Users current = accountDAO.findById(userId);
        if (current == null) {
            throw new IllegalArgumentException("Không tìm thấy thông tin tài khoản.");
        }

        String existingPhone = ValidationUtil.normalizePhone(current.getPhone());
        if (!cleanPhone.equals(existingPhone)) {
            Users byPhone = accountDAO.findByPhone(cleanPhone);
            if (byPhone != null && byPhone.getUserId() != userId) {
                throw new IllegalArgumentException("Số điện thoại này đã được sử dụng bởi tài khoản khác.");
            }
        }

        String existingEmail = ValidationUtil.normalizeEmail(current.getEmail());
        if (!cleanEmail.equals(existingEmail)) {
            Users byEmail = accountDAO.findByEmail(cleanEmail);
            if (byEmail != null && byEmail.getUserId() != userId) {
                throw new IllegalArgumentException("Địa chỉ Email này đã được sử dụng bởi tài khoản khác.");
            }
        }

        current.setFullName(cleanName);
        current.setPhone(cleanPhone);
        current.setEmail(cleanEmail);
        if (!accountDAO.updateProfile(current)) {
            throw new SQLException("Không thể cập nhật hồ sơ tài khoản.");
        }
        return current;
    }

    public void changePassword(int userId, String currentPassword, String newPassword) throws SQLException {
        Users current = accountDAO.findById(userId);
        if (current == null) {
            throw new IllegalArgumentException("Không tìm thấy thông tin tài khoản.");
        }
        current = accountDAO.findByIdentifier(current.getEmail());
        if (current == null || current.getUserId() != userId) {
            throw new IllegalArgumentException("Không tìm thấy thông tin tài khoản.");
        }
        if (currentPassword == null || !verifyPassword(currentPassword, current.getPasswordHash())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác.");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 8 ký tự.");
        }
        if (!accountDAO.updatePassword(userId, hashPassword(newPassword))) {
            throw new SQLException("Không thể cập nhật mật khẩu tài khoản.");
        }
    }

    /**
     * Looks up the account and, if found and active, emails a reset link. Always returns
     * normally (never reveals whether the identifier matched an account) so the caller can
     * show the same message regardless; a mail-send failure is swallowed for the same reason.
     */
    public void requestPasswordReset(String identifier, String resetPageBaseUrl) throws SQLException {
        if (identifier == null || identifier.isBlank()) {
            return;
        }
        Users user = accountDAO.findByIdentifier(identifier.trim());
        if (user == null || !user.isActive() || user.getEmail() == null || user.getEmail().isBlank()) {
            return;
        }
        String rawToken = generateSecureToken();
        passwordResetDAO.createToken(user.getUserId(), sha256Hex(rawToken),
                LocalDateTime.now().plusMinutes(RESET_TOKEN_VALID_MINUTES));
        try {
            String link = resetPageBaseUrl + "?token=" + rawToken;
            String body = "<p>Xin chào " + escapeHtml(user.getFullName()) + ",</p>"
                    + "<p>Nhấn vào liên kết bên dưới để đặt lại mật khẩu PetCare của bạn. "
                    + "Liên kết có hiệu lực trong " + RESET_TOKEN_VALID_MINUTES + " phút.</p>"
                    + "<p><a href=\"" + link + "\">Đặt lại mật khẩu</a></p>"
                    + "<p>Nếu bạn không yêu cầu việc này, hãy bỏ qua email này.</p>";
            mailSender.send(user.getEmail(), "PetCare - Đặt lại mật khẩu", body);
        } catch (Exception mailError) {
            // Token is already stored; a mail outage should not fail the request or
            // leak account existence through an error response.
        }
    }

    public void resetPasswordWithToken(String rawToken, String newPassword) throws SQLException {
        if (rawToken == null || rawToken.isBlank()) {
            throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 8 ký tự.");
        }
        Integer userId = passwordResetDAO.consumeToken(sha256Hex(rawToken));
        if (userId == null) {
            throw new IllegalArgumentException("Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
        }
        if (!accountDAO.updatePassword(userId, hashPassword(newPassword))) {
            throw new SQLException("Không thể cập nhật mật khẩu tài khoản.");
        }
    }

    private static String generateSecureToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private static String sha256Hex(String value) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder(digest.length * 2);
            for (byte b : digest) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }

    private static String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
