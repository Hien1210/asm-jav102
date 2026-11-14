package com.petcare.controller;

import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/ho-so"})
public class ProfileServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    private void popFlashAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object success = session.getAttribute("profileSuccess");
        if (success != null) {
            request.setAttribute("profileSuccess", success);
            session.removeAttribute("profileSuccess");
        }
        Object error = session.getAttribute("profileError");
        if (error != null) {
            request.setAttribute("profileError", error);
            session.removeAttribute("profileError");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Users currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        popFlashAttributes(request);

        try {
            Users freshUser = authService.getUserById(currentUser.getUserId());
            if (freshUser == null) {
                SessionUtil.clearSession(request);
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            SessionUtil.refreshSessionUser(request, freshUser);
        } catch (SQLException e) {
            if (request.getAttribute("profileError") == null) {
                request.setAttribute("profileError", "Không thể tải thông tin hồ sơ từ cơ sở dữ liệu: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Users currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String redirectTo = request.getParameter("redirectTo");
        HttpSession session = request.getSession(true);

        try {
            if ("changePassword".equalsIgnoreCase(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (newPassword == null || !newPassword.equals(confirmPassword)) {
                    throw new IllegalArgumentException("Mật khẩu mới và mật khẩu xác nhận không khớp.");
                }

                authService.changePassword(currentUser.getUserId(), currentPassword, newPassword);
                session.setAttribute("profileSuccess", "Đổi mật khẩu thành công!");
            } else {
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");

                Users updated = authService.updateProfile(currentUser.getUserId(), fullName, phone, email);
                SessionUtil.refreshSessionUser(request, updated);
                session.setAttribute("profileSuccess", "Cập nhật hồ sơ người dùng thành công!");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("profileError", e.getMessage());
        } catch (SQLException e) {
            session.setAttribute("profileError", "Lỗi truy vấn cơ sở dữ liệu SQL Server: " + e.getMessage());
        }

        if ("home".equalsIgnoreCase(redirectTo)) {
            response.sendRedirect(request.getContextPath() + "/home#ho-so-nguoi-dung");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
