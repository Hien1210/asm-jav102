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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/dang-nhap"})
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object successMsg = session.getAttribute("successMessage");
            if (successMsg != null) {
                request.setAttribute("successMessage", successMsg);
                session.removeAttribute("successMessage");
            }
            Object regId = session.getAttribute("registeredIdentifier");
            if (regId != null) {
                request.setAttribute("identifier", regId);
                session.removeAttribute("registeredIdentifier");
            }
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        identifier = (identifier != null) ? identifier.trim() : "";
        password = (password != null) ? password : "";

        if (identifier.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ số điện thoại/email và mật khẩu.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu phải có tối thiểu 6 ký tự.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            Users user = authService.authenticate(identifier, password);
            boolean rememberMe = "on".equalsIgnoreCase(remember) || "true".equalsIgnoreCase(remember);
            SessionUtil.storeAuthenticatedUser(request, user, rememberMe);

            response.sendRedirect(request.getContextPath() + "/home");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (SQLException e) {
            if (e.getErrorCode() == 229) {
                request.setAttribute("errorMessage",
                        "Tài khoản SQL 'petcare_backend' chưa được cấp quyền SELECT trên bảng dbo.Users. "
                        + "Vui lòng chạy file database/grant_auth_permissions.sql trên SQL Server.");
            } else {
                request.setAttribute("errorMessage", "Lỗi truy vấn cơ sở dữ liệu SQL Server: " + e.getMessage());
            }
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
