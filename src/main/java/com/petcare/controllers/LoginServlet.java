package com.petcare.controllers;

import com.petcare.models.Users;
import com.petcare.services.AuthService;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
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

        Users user;
        try {
            user = new AuthService().authenticate(identifier, password);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không thể kết nối hệ thống. Vui lòng thử lại sau.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (user == null) {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng, hoặc tài khoản đã bị khóa.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Lưu thông tin đăng nhập vào session
        HttpSession session = request.getSession(true);
        session.setAttribute("loggedInUserId", user.getUserId());
        session.setAttribute("loggedInUser", user.getFullName());
        session.setAttribute("loggedInRole", user.getRole());
        if ("on".equals(remember) || "true".equals(remember)) {
            session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 ngày
        }

        if ("ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/tai-khoan");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}

