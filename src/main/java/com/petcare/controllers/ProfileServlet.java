package com.petcare.controllers;

import com.petcare.daos.UserMediaDAO;
import com.petcare.daos.UserMediaDAOImpl;
import com.petcare.models.AppointmentBalance;
import com.petcare.models.Appointments;
import com.petcare.models.Pets;
import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.services.BookingService;
import com.petcare.services.NotificationService;
import com.petcare.services.PaymentService;
import com.petcare.services.PetService;
import com.petcare.services.ReviewService;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/ho-so"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AuthService authService = new AuthService();
    private final PetService petService = new PetService();
    private final BookingService bookingService = new BookingService();
    private final PaymentService paymentService = new PaymentService();
    private final ReviewService reviewService = new ReviewService();
    private final NotificationService notificationService = new NotificationService();
    private final UserMediaDAO userMediaDAO = new UserMediaDAOImpl();

    private void popFlashAttributes(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object success = session.getAttribute("profileSuccess");
        if (success != null) {
            request.setAttribute("profileSuccess", success);
            session.removeAttribute("profileSuccess");
        }
        Object error = session.getAttribute("profileError");
        if (error != null) {
            request.setAttribute("profileError", error);
            session.removeAttribute("profileError");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Users currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        popFlashAttributes(request);

        Users effectiveUser = currentUser;
        try {
            Users freshUser = authService.getUserById(currentUser.getUserId());
            if (freshUser == null || !freshUser.isActive()) {
                SessionUtil.clearSession(request);
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            userMediaDAO.hydrate(freshUser);
            SessionUtil.refreshSessionUser(request, freshUser);
            effectiveUser = freshUser;
        } catch (SQLException e) {
            if (request.getAttribute("profileError") == null) {
                request.setAttribute("profileError", "Không thể tải thông tin hồ sơ từ cơ sở dữ liệu: " + e.getMessage());
            }
        }

        if (effectiveUser.isCustomer()) {
            loadCustomerSummary(request, effectiveUser.getUserId());
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void loadCustomerSummary(HttpServletRequest request, int customerId) {
        try {
            List<Pets> pets = petService.listMyPets(customerId);
            request.setAttribute("profilePets", pets);
            request.setAttribute("profilePetCount", pets.size());
        } catch (SQLException ignored) {
            request.setAttribute("profilePetCount", 0);
        }

        try {
            List<Appointments> appts = bookingService.listCustomerAppointments(customerId, "ALL", "ALL");
            int activeCount = 0;
            int completedCount = 0;
            for (Appointments a : appts) {
                String st = a.getStatus();
                if (Appointments.STATUS_PENDING.equals(st) || Appointments.STATUS_CONFIRMED.equals(st)
                        || Appointments.STATUS_CHECKED_IN.equals(st) || Appointments.STATUS_IN_PROGRESS.equals(st)) {
                    activeCount++;
                } else if (Appointments.STATUS_COMPLETED.equals(st)) {
                    completedCount++;
                }
            }
            request.setAttribute("profileAppointmentCount", appts.size());
            request.setAttribute("profileActiveAppointmentCount", activeCount);
            request.setAttribute("profileCompletedAppointmentCount", completedCount);
        } catch (SQLException ignored) {
            request.setAttribute("profileAppointmentCount", 0);
            request.setAttribute("profileActiveAppointmentCount", 0);
            request.setAttribute("profileCompletedAppointmentCount", 0);
        }

        try {
            BigDecimal remaining = BigDecimal.ZERO;
            for (AppointmentBalance b : paymentService.getPayableAppointments(customerId)) {
                remaining = remaining.add(b.getRemainingAmount());
            }
            request.setAttribute("profileRemainingRaw", remaining);
            request.setAttribute("profileRemainingBalance", DateUtil.formatVnd(remaining));
        } catch (SQLException ignored) {
            request.setAttribute("profileRemainingRaw", BigDecimal.ZERO);
            request.setAttribute("profileRemainingBalance", "0 đ");
        }

        try {
            request.setAttribute("profileReviewCount", reviewService.getCustomerReviews(customerId).size());
        } catch (SQLException ignored) {
            request.setAttribute("profileReviewCount", 0);
        }

        try {
            request.setAttribute("profileNotificationCount",
                    notificationService.listUserNotifications(customerId, "ALL").size());
        } catch (SQLException ignored) {
            request.setAttribute("profileNotificationCount", 0);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Users currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String redirectTo = request.getParameter("redirectTo");
        HttpSession session = request.getSession(true);

        try {
            if ("changePassword".equalsIgnoreCase(action)) {
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                if (newPassword == null || !newPassword.equals(confirmPassword)) {
                    throw new IllegalArgumentException("Mật khẩu mới và mật khẩu xác nhận không khớp.");
                }

                authService.changePassword(currentUser.getUserId(), currentPassword, newPassword);
                session.setAttribute("profileSuccess", "Đổi mật khẩu thành công!");
            } else {
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");

                Users updated = authService.updateProfile(currentUser.getUserId(), fullName, phone, email);
                SessionUtil.refreshSessionUser(request, updated);
                session.setAttribute("profileSuccess", "Cập nhật hồ sơ người dùng thành công!");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("profileError", e.getMessage());
        } catch (SQLException e) {
            session.setAttribute("profileError", "Lỗi truy vấn cơ sở dữ liệu SQL Server: " + e.getMessage());
        }

        if ("home".equalsIgnoreCase(redirectTo)) {
            response.sendRedirect(request.getContextPath() + "/home#ho-so-nguoi-dung");
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
