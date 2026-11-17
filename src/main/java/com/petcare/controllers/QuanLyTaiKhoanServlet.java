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

@WebServlet(name = "QuanLyTaiKhoanServlet", urlPatterns = {"/admin/tai-khoan"})
public class QuanLyTaiKhoanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> VALID_ROLES = Set.of("CUSTOMER", "STAFF", "ADMIN");

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireAdmin(request, response)) {
            return;
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
        if (!SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private void handleCreate(HttpServletRequest request) throws SQLException {
        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String role = trim(request.getParameter("role"));

        if (ValidationUtil.isBlank(fullName) || ValidationUtil.isBlank(email)
                || password == null || password.length() < 8) {
            throw new IllegalArgumentException("Vui lòng điền họ tên, email hợp lệ và mật khẩu tối thiểu 8 ký tự.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Email không hợp lệ.");
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
        accountDAO.create(account);
    }

    private void handleUpdate(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String role = trim(request.getParameter("role"));

        if (ValidationUtil.isBlank(fullName) || !ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Vui lòng điền họ tên và email hợp lệ.");
        }
        if (!VALID_ROLES.contains(role)) {
            throw new IllegalArgumentException("Vai trò không hợp lệ.");
        }
        Integer currentUserId = SessionUtil.getUserId(request);
        if (currentUserId != null && currentUserId == userId && !"ADMIN".equals(role)) {
            throw new IllegalArgumentException("Không thể tự bỏ quyền quản trị của chính mình.");
        }

        Users account = new Users();
        account.setUserId(userId);
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setRole(role);
        accountDAO.update(account);
    }

    private void handleToggleActive(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        boolean active = "true".equals(request.getParameter("active"));

        Integer currentUserId = SessionUtil.getUserId(request);
        if (currentUserId != null && currentUserId == userId && !active) {
            throw new IllegalArgumentException("Không thể tự khóa tài khoản của chính mình.");
        }
        accountDAO.setActive(userId, active);
    }

    private void handleResetPassword(HttpServletRequest request) throws SQLException {
        int userId = parseUserId(request);
        String newPassword = request.getParameter("newPassword");
        if (newPassword == null || newPassword.length() < 8) {
            throw new IllegalArgumentException("Mật khẩu mới phải có tối thiểu 8 ký tự.");
        }
        accountDAO.resetPassword(userId, AuthService.hashPassword(newPassword));
    }

    private int parseUserId(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("userId"));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Thiếu hoặc sai mã tài khoản.");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String friendlySqlMessage(SQLException e) {
        if (e.getErrorCode() == 51050) {
            return "Email đã được sử dụng bởi tài khoản khác.";
        }
        if (e.getErrorCode() == 51051) {
            return "Tài khoản không tồn tại.";
        }
        return "Không thể lưu thay đổi. Vui lòng thử lại.";
    }
}
