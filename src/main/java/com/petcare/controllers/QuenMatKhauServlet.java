package com.petcare.controllers;

import com.petcare.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "QuenMatKhauServlet", urlPatterns = {"/quen-mat-khau"})
public class QuenMatKhauServlet extends HttpServlet {

    private static final String GENERIC_SUCCESS_MESSAGE =
            "Nếu số điện thoại/email này có tài khoản, PetCare đã gửi một email hướng dẫn đặt lại mật khẩu. "
            + "Vui lòng kiểm tra hộp thư (kể cả mục Spam).";

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String identifier = request.getParameter("identifier");
        identifier = (identifier != null) ? identifier.trim() : "";
        request.setAttribute("identifier", identifier);

        if (identifier.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập số điện thoại hoặc email đã đăng ký.");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        try {
            authService.requestPasswordReset(identifier, resetPageBaseUrl(request));
            request.setAttribute("successMessage", GENERIC_SUCCESS_MESSAGE);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu SQL Server: " + e.getMessage());
        }
        request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
    }

    private static String resetPageBaseUrl(HttpServletRequest request) {
        int port = request.getServerPort();
        String portPart = (port == 80 || port == 443) ? "" : ":" + port;
        return request.getScheme() + "://" + request.getServerName() + portPart
                + request.getContextPath() + "/dat-lai-mat-khau";
    }
}
