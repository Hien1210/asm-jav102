package com.petcare.controllers;

import com.petcare.models.Appointments;
import com.petcare.models.Notifications;
import com.petcare.models.Users;
import com.petcare.services.BookingService;
import com.petcare.services.NotificationService;
import com.petcare.utils.SessionUtil;
import com.petcare.websocket.NotificationEndpoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "LichHenKhachHangServlet", urlPatterns = {"/customer/lich-hen"})
public class LichHenKhachHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }
        popFlash(request);

        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        String statusFilter = trimOrDefault(request.getParameter("status"), "ALL");
        String typeFilter = trimOrDefault(request.getParameter("type"), "ALL");

        request.setAttribute("activeCustomerNav", "appointments");
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("typeFilter", typeFilter);

        try {
            List<Appointments> allAppointments = bookingService.listCustomerAppointments(customerId, "ALL", "ALL");
            int totalCount = allAppointments.size();
            int activeCount = 0;
            int completedCount = 0;
            int cancelledCount = 0;
            for (Appointments appt : allAppointments) {
                String st = appt.getStatus();
                if (Appointments.STATUS_PENDING.equals(st) || Appointments.STATUS_CONFIRMED.equals(st)
                        || Appointments.STATUS_CHECKED_IN.equals(st) || Appointments.STATUS_IN_PROGRESS.equals(st)) {
                    activeCount++;
                } else if (Appointments.STATUS_COMPLETED.equals(st)) {
                    completedCount++;
                } else if (Appointments.STATUS_CANCELLED.equals(st) || Appointments.STATUS_NO_SHOW.equals(st)) {
                    cancelledCount++;
                }
            }
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("cancelledCount", cancelledCount);

            List<Appointments> filtered = ("ALL".equalsIgnoreCase(statusFilter) && "ALL".equalsIgnoreCase(typeFilter))
                    ? allAppointments
                    : bookingService.listCustomerAppointments(customerId, statusFilter, typeFilter);
            request.setAttribute("appointments", filtered);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách lịch hẹn: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/lichHenDanhSach.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }

        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        String customerName = SessionUtil.getCurrentUser(request).getFullName();
        String action = request.getParameter("action");
        HttpSession session = request.getSession(true);

        try {
            if ("cancel".equals(action)) {
                int appointmentId;
                try {
                    appointmentId = Integer.parseInt(trimOrDefault(request.getParameter("appointmentId"), ""));
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Mã lịch hẹn không hợp lệ.");
                }
                String reason = request.getParameter("cancelReason");
                bookingService.cancelByCustomer(customerId, appointmentId, reason);

                session.setAttribute("apptSuccess", "Đã hủy lịch hẹn #" + appointmentId + " thành công.");
                notificationService.notifyCustomer(
                        customerId,
                        appointmentId,
                        Notifications.TYPE_CANCELLATION,
                        "booking_cancelled",
                        "Đã hủy lịch hẹn",
                        "Lịch hẹn #" + appointmentId + " của bạn đã được hủy. Lý do: " + reason.trim());
                NotificationEndpoint.notifyRoles(
                        new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF},
                        "booking_cancelled",
                        "Khách hàng hủy lịch",
                        customerName + " vừa hủy lịch hẹn #" + appointmentId + ".");
            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException | SQLException e) {
            session.setAttribute("apptError", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer/lich-hen");
    }

    private boolean requireCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_CUSTOMER)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private void popFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object success = session.getAttribute("apptSuccess");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("apptSuccess");
        }
        Object error = session.getAttribute("apptError");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("apptError");
        }
    }

    private String trimOrDefault(String value, String fallback) {
        return (value == null || value.isBlank()) ? fallback : value.trim();
    }
}
