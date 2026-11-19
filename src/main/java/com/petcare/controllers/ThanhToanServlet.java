package com.petcare.controllers;

import com.petcare.models.AppointmentBalance;
import com.petcare.models.Notifications;
import com.petcare.models.Payments;
import com.petcare.models.Users;
import com.petcare.services.NotificationService;
import com.petcare.services.PaymentService;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import com.petcare.websocket.NotificationEndpoint;
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
import java.util.UUID;

@WebServlet(name = "ThanhToanServlet", urlPatterns = {"/customer/thanh-toan"})
public class ThanhToanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String SESSION_PAYMENT_KEY = "customerPaymentIdempotencyKey";

    private final PaymentService paymentService = new PaymentService();
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
        HttpSession session = request.getSession(true);
        UUID freshKey = UUID.randomUUID();
        session.setAttribute(SESSION_PAYMENT_KEY, freshKey.toString());

        request.setAttribute("activeCustomerNav", "payments");
        request.setAttribute("paymentKey", freshKey.toString());
        request.setAttribute("selectedAppointmentId", request.getParameter("appointmentId"));

        try {
            List<AppointmentBalance> payable = paymentService.getPayableAppointments(customerId);
            List<Payments> history = paymentService.getPaymentHistory(customerId);

            BigDecimal totalRemaining = BigDecimal.ZERO;
            BigDecimal totalPaid = BigDecimal.ZERO;
            int pendingCount = 0;
            for (AppointmentBalance appt : payable) {
                totalRemaining = totalRemaining.add(appt.getRemainingAmount());
            }
            for (Payments p : history) {
                if (Payments.TYPE_CHARGE.equals(p.getPaymentType()) && Payments.STATUS_PAID.equals(p.getStatus())) {
                    totalPaid = totalPaid.add(p.getAmount());
                } else if (Payments.TYPE_REFUND.equals(p.getPaymentType()) && Payments.STATUS_PAID.equals(p.getStatus())) {
                    totalPaid = totalPaid.subtract(p.getAmount());
                }
                if (Payments.STATUS_PENDING.equals(p.getStatus())) {
                    pendingCount++;
                }
            }

            request.setAttribute("payableAppointments", payable);
            request.setAttribute("paymentHistory", history);
            request.setAttribute("formattedTotalRemaining", DateUtil.formatVnd(totalRemaining));
            request.setAttribute("formattedTotalPaid", DateUtil.formatVnd(totalPaid.max(BigDecimal.ZERO)));
            request.setAttribute("pendingCount", pendingCount);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được dữ liệu thanh toán: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/thanhToan.jsp").forward(request, response);
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
            if ("pay".equals(action)) {
                int appointmentId = parseIntRequired(request.getParameter("appointmentId"), "Vui lòng chọn lịch hẹn cần thanh toán.");
                BigDecimal amount = parseDecimalRequired(request.getParameter("amount"));
                String method = request.getParameter("method");
                UUID paymentKey = resolvePaymentKey(request, session);

                int paymentId = paymentService.initiatePayment(customerId, appointmentId, amount, method, paymentKey);
                session.removeAttribute(SESSION_PAYMENT_KEY);

                if (Payments.METHOD_ONLINE.equalsIgnoreCase(method)) {
                    session.setAttribute("paySuccess",
                            "Đã tạo yêu cầu thanh toán trực tuyến #" + paymentId + " cho lịch hẹn #" + appointmentId
                            + ". Vui lòng bấm \"Xác nhận đã thanh toán\" ở mục Giao dịch đang chờ để hoàn tất.");
                } else {
                    session.setAttribute("paySuccess",
                            "Đã đăng ký thanh toán tiền mặt tại quầy (#" + paymentId + ") cho lịch hẹn #" + appointmentId
                            + ". Nhân viên sẽ xác nhận khi bạn thanh toán trực tiếp.");
                }
            } else if ("confirmOnline".equals(action)) {
                int paymentId = parseIntRequired(request.getParameter("paymentId"), "Mã giao dịch không hợp lệ.");
                Payments settled = paymentService.confirmOnlinePayment(customerId, paymentId);

                session.setAttribute("paySuccess",
                        "Thanh toán trực tuyến #" + paymentId + " (" + settled.getFormattedAmount() + ") đã hoàn tất!");
                notificationService.notifyCustomer(
                        customerId,
                        settled.getAppointmentId(),
                        Notifications.TYPE_OTHER,
                        "payment_paid",
                        "Thanh toán thành công",
                        "Giao dịch #" + paymentId + " (" + settled.getFormattedAmount()
                                + ") cho lịch hẹn #" + settled.getAppointmentId() + " đã được thanh toán.");
                NotificationEndpoint.notifyRoles(
                        new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF},
                        "payment_paid",
                        "Khách hàng đã thanh toán Online",
                        customerName + " vừa thanh toán " + settled.getFormattedAmount()
                                + " cho lịch hẹn #" + settled.getAppointmentId() + ".");
            } else if ("cancelPending".equals(action)) {
                int paymentId = parseIntRequired(request.getParameter("paymentId"), "Mã giao dịch không hợp lệ.");
                paymentService.cancelPendingPayment(customerId, paymentId);
                session.setAttribute("paySuccess",
                        "Đã hủy yêu cầu thanh toán đang chờ #" + paymentId + ". Bạn có thể chọn phương thức khác.");
            } else {
                throw new IllegalArgumentException("Hành động thanh toán không hợp lệ.");
            }
        } catch (IllegalArgumentException | SQLException e) {
            session.setAttribute("payError", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer/thanh-toan");
    }

    private UUID resolvePaymentKey(HttpServletRequest request, HttpSession session) {
        String submitted = request.getParameter("paymentKey");
        if (!ValidationUtil.isBlank(submitted)) {
            try {
                return UUID.fromString(submitted.trim());
            } catch (IllegalArgumentException ignored) {
                throw new IllegalArgumentException("Mã chống trùng giao dịch không hợp lệ. Vui lòng tải lại trang.");
            }
        }
        Object sessionKey = session.getAttribute(SESSION_PAYMENT_KEY);
        if (sessionKey instanceof String s && !s.isBlank()) {
            return UUID.fromString(s);
        }
        return UUID.randomUUID();
    }

    private int parseIntRequired(String raw, String message) {
        try {
            return Integer.parseInt(raw == null ? "" : raw.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private BigDecimal parseDecimalRequired(String raw) {
        if (ValidationUtil.isBlank(raw)) {
            throw new IllegalArgumentException("Vui lòng nhập số tiền thanh toán.");
        }
        try {
            return new BigDecimal(raw.trim().replace(",", "").replace(" ", ""));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số tiền thanh toán không hợp lệ.");
        }
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
        Object success = session.getAttribute("paySuccess");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("paySuccess");
        }
        Object error = session.getAttribute("payError");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("payError");
        }
    }
}
