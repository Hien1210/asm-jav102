package com.petcare.controllers;

import com.petcare.models.Appointments;
import com.petcare.models.Users;
import com.petcare.services.StaffScheduleService;
import com.petcare.services.StaffViewPolicy;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

/** Nhân viên xem lịch hẹn được giao và cập nhật tiến độ (check-in / bắt đầu / hoàn thành). */
@WebServlet(name = "LichHenNhanVienServlet", urlPatterns = {"/staff/lich-hen"})
public class LichHenNhanVienServlet extends HttpServlet {
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
        loadAppointments(request);
        request.getRequestDispatcher("/WEB-INF/views/staff/quanLyLichHen.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireStaff(request, response)) {
            return;
        }

        int staffId = SessionUtil.getCurrentUser(request).getUserId();
        try {
            handleAdvanceStatus(request, staffId);
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        loadAppointments(request);
        request.getRequestDispatcher("/WEB-INF/views/staff/quanLyLichHen.jsp").forward(request, response);
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

    private void loadAppointments(HttpServletRequest request) {
        int staffId = SessionUtil.getCurrentUser(request).getUserId();
        try {
            LocalDate today = StaffViewPolicy.date(request.getParameter("date"),DateUtil.todayVn());
            request.setAttribute("appointmentDate",today);
            request.setAttribute("appointments",
                    staffScheduleService.getMyAppointments(staffId, today, today));
        } catch(IllegalArgumentException e) {
            request.setAttribute("errorMessage",e.getMessage());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được lịch hẹn được giao. Vui lòng thử lại.");
        }
    }

    private void handleAdvanceStatus(HttpServletRequest request, int staffId) throws SQLException {
        String appointmentIdParam = request.getParameter("appointmentId");
        String newStatus = request.getParameter("newStatus");
        if (ValidationUtil.isBlank(appointmentIdParam) || ValidationUtil.isBlank(newStatus)) {
            throw new IllegalArgumentException("Vui lòng chọn lịch hẹn và hành động hợp lệ.");
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdParam);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Lịch hẹn không hợp lệ.");
        }

        staffScheduleService.advanceStatus(staffId, appointmentId, newStatus);

        String label = switch (newStatus) {
            case Appointments.STATUS_CHECKED_IN -> "check-in";
            case Appointments.STATUS_IN_PROGRESS -> "bắt đầu thực hiện";
            case Appointments.STATUS_COMPLETED -> "hoàn thành";
            default -> "cập nhật";
        };
        request.setAttribute("successMessage", "Đã " + label + " lịch hẹn #" + appointmentId + ".");
    }
}
