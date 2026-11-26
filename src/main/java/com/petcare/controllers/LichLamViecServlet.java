package com.petcare.controllers;

import com.petcare.models.Users;
import com.petcare.services.StaffScheduleService;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

/** Nhân viên xem lịch làm việc (ca) của chính mình trong 14 ngày tới. */
@WebServlet(name = "LichLamViecServlet", urlPatterns = {"/staff/lich-lam-viec"})
public class LichLamViecServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final StaffScheduleService staffScheduleService = new StaffScheduleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireStaff(request, response)) {
            return;
        }

        int staffId = SessionUtil.getCurrentUser(request).getUserId();
        try {
            LocalDate today = DateUtil.todayVn();
            request.setAttribute("shifts", staffScheduleService.getMyShifts(staffId, today, today.plusDays(13)));
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được lịch làm việc. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("/WEB-INF/views/staff/lichLamViec.jsp").forward(request, response);
    }

    private boolean requireStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_STAFF, Users.ROLE_ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }
}
