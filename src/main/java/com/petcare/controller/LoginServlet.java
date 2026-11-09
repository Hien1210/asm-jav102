package com.petcare.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

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

        // Lưu thông tin đăng nhập vào session
        HttpSession session = request.getSession(true);
        session.setAttribute("loggedInUser", identifier);
        if ("on".equals(remember) || "true".equals(remember)) {
            session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 ngày
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }
}

