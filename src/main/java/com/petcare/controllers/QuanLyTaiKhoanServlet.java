package com.petcare.controllers;

import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;
import java.util.UUID;

@WebServlet(name = "QuanLyTaiKhoanServlet", urlPatterns = {"/admin/tai-khoan"})
public class QuanLyTaiKhoanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> VALID_ROLES = Set.of("CUSTOMER", "STAFF", "ADMIN");

    private final AccountDAO accountDAO;

    public QuanLyTaiKhoanServlet() {
        this(new AccountDAOImpl());
    }

    QuanLyTaiKhoanServlet(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireAdmin(request, response)) {
            return;
        }

        if (request.getSession().getAttribute("adminCsrfToken") == null) {
            request.getSession().setAttribute("adminCsrfToken", UUID.randomUUID().toString());
        }

        try {
            request.setAttribute("accounts", accountDAO.findAll());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách tài khoản. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("/admin/quanLiTaiKhoan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        Object expectedToken = request.getSession().getAttribute("adminCsrfToken");
        String submittedToken = request.getParameter("csrfToken");
        if (!(expectedToken instanceof String) || !expectedToken.equals(submittedToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Yêu cầu không hợp lệ. Vui lòng tải lại trang quản lý tài khoản.");
            return;
        }
        action = (action != null) ? action : "";

        try {
            switch (action) {
                case "create":
                    handleCreate(request);
                    request.setAttribute("successMessage", "Đã tạo tài khoản mới.");
                    break;
                case "update":
                    handleUpdate(request);
                    request.setAttribute("successMessage", "Đã lưu thông tin tài khoản.");
                    break;
                case "toggleActive":
                    handleToggleActive(request);
                    request.setAttribute("successMessage", "Đã cập nhật trạng thái tài khoản.");
                    break;
                case "resetPassword":
                    handleResetPassword(request);
                    request.setAttribute("successMessage", "Đã đặt lại mật khẩu.");
                    break;
                default:
                    request.setAttribute("errorMessage", "Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", friendlySqlMessage(e));
        }

        try {
            request.setAttribute("accounts", accountDAO.findAll());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách tài khoản. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("/admin/quanLiTaiKhoan.jsp").forward(request, response);
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private void handleCreate(HttpServletRequest request) throws SQLException {
        String fullName = trim(request.getParameter("fullName"));
        String email = ValidationUtil.normalizeEmail(request.getParameter("email"));
        String phone = ValidationUtil.normalizePhone(request.getParameter("phone"));
        String password = request.getParameter("password");
        String role = trim(request.getParameter("role"));

        if (ValidationUtil.isBlank(fullName) || ValidationUtil.isBlank(email)
                || password == null || password.length() < 8) {
            throw new IllegalArgumentException("Vui lòng điền họ tên, email hợp lệ và mật khẩu tối thiểu 8 ký tự.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Email không hợp lệ.");
        }
        if (fullName.length() > 100 || (!phone.isEmpty() && !ValidationUtil.isValidPhone(phone))) {
            throw new IllegalArgumentException("Họ tên tối đa 100 ký tự và số điện thoại phải hợp lệ.");
        }
        if (accountDAO.existsByEmail(email) || (!phone.isEmpty() && accountDAO.existsByPhone(phone))) {
            throw new IllegalArgumentException("Email hoặc số điện thoại đã được sử dụng.");
        }
        if (!VALID_ROLES.contains(role)) {
            throw new IllegalArgumentException("Vai trò không hợp lệ.");
        }

        Users account = new Users();
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setPasswordHash(AuthService.hashPassword(password));
        account.setRole(role);
        account.setActive(true);
        Users created = accountDAO.create(account);
        if (created == null || created.getUserId() <= 0) {
            throw new SQLException("Account creation did not return an identifier.");
        }
    }

    private int currentUserId(HttpServletRequest request) {
        Users current = SessionUtil.getCurrentUser(request);
        return current != null ? current.getUserId() : -1;
    }

    private void handleUpdate(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        String fullName = trim(request.getParameter("fullName"));
        String email = ValidationUtil.normalizeEmail(request.getParameter("email"));
        String phone = ValidationUtil.normalizePhone(request.getParameter("phone"));
        String role = trim(request.getParameter("role"));

        if (ValidationUtil.isBlank(fullName) || fullName.length() > 100 || !ValidationUtil.isValidEmail(email)
                || (!phone.isEmpty() && !ValidationUtil.isValidPhone(phone))) {
            throw new IllegalArgumentException("Vui lòng điền họ tên và email hợp lệ.");
        }
        if (!VALID_ROLES.contains(role)) {
            throw new IllegalArgumentException("Vai trò không hợp lệ.");
        }
        if (currentUserId(request) == userId && !"ADMIN".equals(role)) {
            throw new IllegalArgumentException("Không thể tự bỏ quyền quản trị của chính mình.");
        }

        Users account = accountDAO.findById(userId);
        if (account == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại.");
        }
        Users byEmail = accountDAO.findByEmail(email);
        Users byPhone = phone.isEmpty() ? null : accountDAO.findByPhone(phone);
        if ((byEmail != null && byEmail.getUserId() != userId)
                || (byPhone != null && byPhone.getUserId() != userId)) {
            throw new IllegalArgumentException("Email hoặc số điện thoại đã được sử dụng.");
        }
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setRole(role);
        if (!accountDAO.updateProfile(account)) {
            throw new IllegalArgumentException("Tài khoản không tồn tại hoặc chưa được cập nhật.");
        }
    }

    private void handleToggleActive(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        String activeValue = request.getParameter("active");
        if (!"true".equals(activeValue) && !"false".equals(activeValue)) {
            throw new IllegalArgumentException("Trạng thái tài khoản phải là true hoặc false.");
        }
        boolean active = Boolean.parseBoolean(activeValue);

        if (currentUserId(request) == userId && !active) {
            throw new IllegalArgumentException("Không thể tự khóa tài khoản của chính mình.");
        }
        Users target = accountDAO.findById(userId);
        if (target == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại.");
        }
        if (!accountDAO.updateRoleAndStatus(userId, target.getRole(), active)) {
            throw new IllegalArgumentException("Tài khoản không tồn tại hoặc chưa được cập nhật.");
        }
    }

    private void handleResetPassword(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        String newPassword = request.getParameter("newPassword");
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 8 ký tự.");
        }
        if (accountDAO.findById(userId) == null) {
            throw new IllegalArgumentException("Tài khoản không tồn tại.");
        }
        if (!accountDAO.updatePassword(userId, AuthService.hashPassword(newPassword))) {
            throw new IllegalArgumentException("Tài khoản không tồn tại hoặc chưa được cập nhật.");
        }
    }

    private int parseUserId(HttpServletRequest request) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (userId <= 0) throw new NumberFormatException();
            return userId;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Thiếu hoặc sai mã tài khoản.");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String friendlySqlMessage(SQLException e) {
        if (e.getErrorCode() == 51002) {
            return "Không thể đổi vai trò khách hàng đang sở hữu thú cưng.";
        }
        if (e.getErrorCode() == 51003) {
            return "Không thể đổi vai trò nhân viên đang có kỹ năng hoặc ca làm việc.";
        }
        if (e.getErrorCode() == 51008) {
            return "Không thể khóa khách hàng đang có lịch hẹn chưa kết thúc.";
        }
        if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
            return "Email đã được sử dụng bởi tài khoản khác.";
        }
        if (e.getErrorCode() == 229) {
            return "Tài khoản SQL 'petcare_backend' chưa được cấp đủ quyền trên bảng dbo.Users.";
        }
        return "Không thể lưu thay đổi. Vui lòng thử lại.";
    }
}
