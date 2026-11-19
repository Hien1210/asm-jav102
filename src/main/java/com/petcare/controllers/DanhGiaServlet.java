package com.petcare.controllers;

import com.petcare.models.Notifications;
import com.petcare.models.Users;
import com.petcare.services.NotificationService;
import com.petcare.services.ReviewService;
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

@WebServlet(name = "DanhGiaServlet", urlPatterns = {"/customer/danh-gia"})
public class DanhGiaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReviewService reviewService = new ReviewService();
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
        request.setAttribute("activeCustomerNav", "reviews");
        request.setAttribute("selectedAppointmentId", request.getParameter("appointmentId"));

        try {
            request.setAttribute("reviewableAppointments", reviewService.getReviewableAppointments(customerId));
            request.setAttribute("myReviews", reviewService.getCustomerReviews(customerId));
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được dữ liệu đánh giá: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/danhGia.jsp").forward(request, response);
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
            if ("submit".equals(action)) {
                int appointmentId;
                int rating;
                try {
                    appointmentId = Integer.parseInt(trim(request.getParameter("appointmentId")));
                    rating = Integer.parseInt(trim(request.getParameter("rating")));
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Thông tin lịch hẹn hoặc số sao đánh giá không hợp lệ.");
                }
                String comment = request.getParameter("comment");

                reviewService.submitReview(customerId, appointmentId, rating, comment);
                session.setAttribute("reviewSuccess",
                        "Cảm ơn bạn đã gửi đánh giá " + rating + " sao cho lịch hẹn #" + appointmentId + "!");

                notificationService.notifyCustomer(
                        customerId,
                        appointmentId,
                        Notifications.TYPE_OTHER,
                        "review_submitted",
                        "Đã ghi nhận đánh giá",
                        "Cảm ơn bạn đã đánh giá " + rating + "/5 sao cho lịch hẹn #" + appointmentId + ".");
                NotificationEndpoint.notifyRoles(
                        new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF},
                        "new_review",
                        "Đánh giá mới từ khách hàng",
                        customerName + " vừa đánh giá " + rating + "/5 sao cho lịch hẹn #" + appointmentId + ".");
            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException | SQLException e) {
            session.setAttribute("reviewError", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer/danh-gia");
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
        Object success = session.getAttribute("reviewSuccess");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("reviewSuccess");
        }
        Object error = session.getAttribute("reviewError");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("reviewError");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
