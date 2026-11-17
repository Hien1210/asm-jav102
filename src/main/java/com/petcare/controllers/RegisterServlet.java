package com.petcare.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register", "/dang-ky"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        fullName = (fullName != null) ? fullName.trim() : "";
        phone = (phone != null) ? phone.trim() : "";
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword : "";

        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("email", email);

        if (fullName.isEmpty() || phone.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ họ tên, số điện thoại và mật khẩu.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Mật khẩu tạo mới phải có tối thiểu 8 ký tự.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu nhập lại không khớp với mật khẩu vừa tạo.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("loggedInUser", fullName);
        session.setAttribute("loggedInPhone", phone);

        response.sendRedirect(request.getContextPath() + "/login");
    }
}

