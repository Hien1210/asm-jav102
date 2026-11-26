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

@WebServlet(name = "DatLaiMatKhauServlet", urlPatterns = {"/dat-lai-mat-khau"})
public class DatLaiMatKhauServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("token", request.getParameter("token"));
        request.getRequestDispatcher("/datLaiMatKhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        newPassword = (newPassword != null) ? newPassword : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword : "";
        request.setAttribute("token", token);

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu nhập lại không khớp với mật khẩu vừa tạo.");
            request.getRequestDispatcher("/datLaiMatKhau.jsp").forward(request, response);
            return;
        }

        try {
            authService.resetPasswordWithToken(token, newPassword);
            HttpSession session = request.getSession(true);
            session.setAttribute("successMessage", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/datLaiMatKhau.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu SQL Server: " + e.getMessage());
            request.getRequestDispatcher("/datLaiMatKhau.jsp").forward(request, response);
        }
    }
}
