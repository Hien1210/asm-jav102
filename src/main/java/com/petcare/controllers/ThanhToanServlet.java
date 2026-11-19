package com.petcare.controllers;

import com.petcare.models.Users;
import com.petcare.services.PaymentService;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import com.petcare.websocket.NotificationEndpoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet(name = "ThanhToanServlet", urlPatterns = {"/customer/thanh-toan"})
public class ThanhToanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }
        loadFormData(request);
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
        try {
            handlePay(request, customerId);
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        loadFormData(request);
        request.getRequestDispatcher("/customer/thanhToan.jsp").forward(request, response);
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

    private void loadFormData(HttpServletRequest request) {
        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        try {
            request.setAttribute("appointments", paymentService.getPayableAppointments(customerId));
        } catch (SQLException e) {
            request.setAttribute("errorMessage",
                    "Không tải được danh sách lịch hẹn cần thanh toán. Vui lòng thử lại.");
        }
    }

    private void handlePay(HttpServletRequest request, int customerId) throws SQLException {
        String appointmentIdParam = request.getParameter("appointmentId");
        String amountParam = request.getParameter("amount");
        String method = request.getParameter("method");

        if (ValidationUtil.isBlank(appointmentIdParam) || ValidationUtil.isBlank(amountParam)
                || ValidationUtil.isBlank(method)) {
            throw new IllegalArgumentException("Vui lòng chọn lịch hẹn, số tiền và phương thức thanh toán.");
        }

        int appointmentId;
        BigDecimal amount;
        try {
            appointmentId = Integer.parseInt(appointmentIdParam);
            amount = new BigDecimal(amountParam.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số tiền hoặc lịch hẹn không hợp lệ.");
        }

        int paymentId = paymentService.initiatePayment(customerId, appointmentId, amount, method, UUID.randomUUID());

        String customerName = SessionUtil.getCurrentUser(request).getFullName();
        if ("ONLINE".equals(method)) {
            paymentService.confirmOnlinePayment(customerId, paymentId);
            request.setAttribute("successMessage",
                    "Thanh toán online thành công! Mã giao dịch nội bộ #" + paymentId + ".");
            NotificationEndpoint.notifyUser(customerId, "payment_success", "Thanh toán thành công",
                    "Thanh toán #" + paymentId + " cho lịch hẹn #" + appointmentId + " đã được ghi nhận.");
        } else {
            request.setAttribute("successMessage", "Đã ghi nhận yêu cầu thanh toán tiền mặt #" + paymentId
                    + ". Vui lòng đến quầy để nhân viên xác nhận và hoàn tất thanh toán.");
            NotificationEndpoint.notifyUser(customerId, "payment_pending", "Đang chờ thanh toán tiền mặt",
                    "Yêu cầu thanh toán #" + paymentId + " cho lịch hẹn #" + appointmentId
                            + " đang chờ nhân viên xác nhận tại quầy.");
        }
        NotificationEndpoint.notifyRoles(new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF}, "new_payment",
                "Thanh toán mới",
                customerName + " vừa yêu cầu thanh toán cho lịch hẹn #" + appointmentId + ".");
    }
}
