package com.petcare.services;

import com.petcare.daos.PaymentDAO;
import com.petcare.daos.PaymentDAOImpl;
import com.petcare.models.AppointmentBalance;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class PaymentService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang xử lý thanh toán khác, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51016, "Lịch hẹn chưa được xác nhận, không thể thanh toán.");
        FRIENDLY_ERRORS.put(51018, "Số tiền vượt quá số còn phải thanh toán của lịch hẹn.");
        FRIENDLY_ERRORS.put(51038, "Không tạo được mã thanh toán, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51039, "Yêu cầu thanh toán bị trùng, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51040, "Lịch hẹn chưa được xác nhận, không thể thanh toán.");
        FRIENDLY_ERRORS.put(51041, "Thanh toán online cần nhập mã giao dịch.");
    }

    private final PaymentDAO paymentDAO;

    public PaymentService() {
        this.paymentDAO = new PaymentDAOImpl();
    }

    /** The customer's own appointments that still have an outstanding balance. */
    public List<AppointmentBalance> listPayable(int customerId) throws SQLException {
        List<AppointmentBalance> payable = new ArrayList<>();
        for (AppointmentBalance balance : paymentDAO.findPayableAppointments(customerId)) {
            if (balance.getRemainingAmount().signum() > 0) {
                payable.add(balance);
            }
        }
        return payable;
    }

    /**
     * Records and immediately settles a payment for one of the customer's own appointments.
     * This project has no real payment gateway, so a CASH or ONLINE charge is marked PAID right
     * after being recorded (a front-desk cash receipt or a successful online charge).
     *
     * @return the new payment_id
     */
    public int pay(int customerId, int appointmentId, BigDecimal amount, String method, String transactionRef)
            throws SQLException {
        AppointmentBalance target = findOwned(customerId, appointmentId);
        if (target == null) {
            throw new IllegalArgumentException("Lịch hẹn không hợp lệ hoặc không thuộc tài khoản của bạn.");
        }
        if (amount == null || amount.signum() <= 0) {
            throw new IllegalArgumentException("Số tiền thanh toán phải lớn hơn 0.");
        }
        if (amount.compareTo(target.getRemainingAmount()) > 0) {
            throw new IllegalArgumentException("Số tiền vượt quá số còn phải thanh toán ("
                    + target.getRemainingAmount() + " đ).");
        }
        if (!"CASH".equals(method) && !"ONLINE".equals(method)) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ.");
        }
        String ref = transactionRef == null ? null : transactionRef.trim();
        if (ref != null && ref.isEmpty()) {
            ref = null;
        }
        if ("ONLINE".equals(method) && ref == null) {
            throw new IllegalArgumentException("Vui lòng nhập mã giao dịch thanh toán online.");
        }
        if (ref != null && ref.length() > 100) {
            throw new IllegalArgumentException("Mã giao dịch quá dài.");
        }

        try {
            int paymentId = paymentDAO.recordPayment(appointmentId, amount, method, UUID.randomUUID(),
                    "ONLINE".equals(method) ? ref : null);
            paymentDAO.setStatus(paymentId, "PAID");
            return paymentId;
        } catch (SQLException e) {
            throw new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(),
                    "Không thể ghi nhận thanh toán. Vui lòng kiểm tra lại và thử lại."), e.getSQLState(), e);
        }
    }

    private AppointmentBalance findOwned(int customerId, int appointmentId) throws SQLException {
        for (AppointmentBalance balance : listPayable(customerId)) {
            if (balance.getAppointmentId() == appointmentId) {
                return balance;
            }
        }
        return null;
    }
}
