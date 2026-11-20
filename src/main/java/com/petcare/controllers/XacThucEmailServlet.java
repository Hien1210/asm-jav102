package com.petcare.controllers;

import com.petcare.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "XacThucEmailServlet", urlPatterns = {"/xac-thuc-email"})
public class XacThucEmailServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        try {
            authService.verifyEmail(request.getParameter("token"));
            session.setAttribute("successMessage", "Xác thực email thành công! Bạn có thể đăng nhập ngay bây giờ.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (SQLException e) {
            session.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu SQL Server: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
