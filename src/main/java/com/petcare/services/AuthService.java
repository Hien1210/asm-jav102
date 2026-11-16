package com.petcare.services;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.models.Users;
import com.petcare.utils.ValidationUtil;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;

public class AuthService {
    private static final int BCRYPT_COST = 12;
    private final AccountDAO accountDAO;

    public AuthService() {
        this(new AccountDAOImpl());
    }

    public AuthService(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
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

    public Users registerCustomer(String fullName, String phone, String email, String rawPassword)
            throws SQLException {
        String cleanName = fullName != null ? fullName.trim() : "";
        String cleanPhone = ValidationUtil.normalizePhone(phone);
        String cleanEmail = ValidationUtil.normalizeEmail(email);

        if (cleanName.isEmpty()) {
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

        return accountDAO.create(newUser);
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
        return user;
    }

    public Users getUserById(int userId) throws SQLException {
        return accountDAO.findById(userId);
    }

    public Users updateProfile(int userId, String fullName, String phone, String email) throws SQLException {
        String cleanName = fullName != null ? fullName.trim() : "";
        String cleanPhone = ValidationUtil.normalizePhone(phone);
        String cleanEmail = ValidationUtil.normalizeEmail(email);

        if (cleanName.isEmpty()) {
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
        accountDAO.updateProfile(current);
        return current;
    }

    public void changePassword(int userId, String currentPassword, String newPassword) throws SQLException {
        Users current = accountDAO.findById(userId);
        if (current == null) {
            throw new IllegalArgumentException("Không tìm thấy thông tin tài khoản.");
        }
        if (currentPassword == null || !verifyPassword(currentPassword, current.getPasswordHash())) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không chính xác.");
        }
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 8 ký tự.");
        }
        accountDAO.updatePassword(userId, hashPassword(newPassword));
    }
}
