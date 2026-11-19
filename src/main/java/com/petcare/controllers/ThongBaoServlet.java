package com.petcare.controllers;

import com.petcare.models.Users;
import com.petcare.services.NotificationService;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ThongBaoServlet", urlPatterns = {"/customer/thong-bao"})
public class ThongBaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_CUSTOMER)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        String typeFilter = request.getParameter("type");
        if (typeFilter == null || typeFilter.isBlank()) {
            typeFilter = "ALL";
        } else {
            typeFilter = typeFilter.trim().toUpperCase();
        }

        request.setAttribute("activeCustomerNav", "notifications");
        request.setAttribute("typeFilter", typeFilter);

        try {
            request.setAttribute("notifications", notificationService.listUserNotifications(customerId, typeFilter));
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách thông báo: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/thongBao.jsp").forward(request, response);
    }
}
