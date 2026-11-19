package com.petcare.services;

import com.petcare.daos.PaymentDAO;
import com.petcare.daos.PaymentDAOImpl;
import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;

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
        this(new PaymentDAOImpl());
    }

    public PaymentService(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    /** The customer's own appointments that still have an outstanding balance. */
    public List<AppointmentBalance> getPayableAppointments(int customerId) throws SQLException {
        List<AppointmentBalance> payable = new ArrayList<>();
        for (AppointmentBalance balance : paymentDAO.findPayableAppointments(customerId)) {
            if (balance.getRemainingAmount().signum() > 0) {
                payable.add(balance);
            }
        }
        return payable;
    }

    /**
     * Records a PENDING charge for one of the customer's own appointments (self-service). For
     * ONLINE, a transaction reference is generated automatically (there is no real payment
     * gateway in this project). The charge stays PENDING until it is settled:
     * {@link #confirmOnlinePayment(int, int)} for ONLINE, or staff confirmation at the counter
     * for CASH.
     *
     * @return the new payment_id
     */
    public int initiatePayment(int customerId, int appointmentId, BigDecimal amount, String method, UUID paymentKey)
            throws SQLException {
        validateAmountAndMethod(amount, method);
        AppointmentBalance target = findOwned(customerId, appointmentId);
        if (target == null) {
            throw new IllegalArgumentException("Lịch hẹn không hợp lệ hoặc không thuộc tài khoản của bạn.");
        }
        if (amount.compareTo(target.getRemainingAmount()) > 0) {
            throw new IllegalArgumentException("Số tiền vượt quá số còn phải thanh toán ("
                    + target.getRemainingAmount() + " đ).");
        }

        String ref = Payments.METHOD_ONLINE.equals(method)
                ? "PC-ONL-" + appointmentId + "-" + System.currentTimeMillis()
                : null;
        return recordPaymentFriendly(appointmentId, amount, method, paymentKey, ref);
    }

    /**
     * Customer confirms their own ONLINE payment completed (simulates a successful gateway
     * callback, since there is no real gateway). CASH charges must be confirmed by staff at the
     * counter instead — a customer cannot self-confirm that they paid in cash.
     */
    public Payments confirmOnlinePayment(int customerId, int paymentId) throws SQLException {
        Payments payment = paymentDAO.findByIdForCustomer(paymentId, customerId);
        if (payment == null) {
            throw new IllegalArgumentException("Không tìm thấy thanh toán này.");
        }
        if (Payments.METHOD_CASH.equals(payment.getMethod())) {
            throw new IllegalArgumentException("Thanh toán tiền mặt phải được nhân viên xác nhận tại quầy.");
        }
        paymentDAO.setStatus(paymentId, Payments.STATUS_PAID);
        payment.setStatus(Payments.STATUS_PAID);
        return payment;
    }

    /**
     * Nhân viên thu tiền và xác nhận thanh toán ngay tại quầy (CASH hoặc ONLINE) cho lịch hẹn của
     * một khách bất kỳ — khác với {@link #confirmOnlinePayment}, đây là nhân viên xác nhận trực
     * tiếp trước mặt khách nên không bị chặn bởi luật "khách không tự xác nhận tiền mặt".
     *
     * @return the new payment_id
     */
    public int settleAtCounter(int customerId, int appointmentId, BigDecimal amount, String method,
                                String transactionRef) throws SQLException {
        validateAmountAndMethod(amount, method);
        AppointmentBalance target = findOwned(customerId, appointmentId);
        if (target == null) {
            throw new IllegalArgumentException("Lịch hẹn không hợp lệ hoặc không thuộc tài khoản của bạn.");
        }
        if (amount.compareTo(target.getRemainingAmount()) > 0) {
            throw new IllegalArgumentException("Số tiền vượt quá số còn phải thanh toán ("
                    + target.getRemainingAmount() + " đ).");
        }

        String ref = transactionRef == null ? null : transactionRef.trim();
        if (ref != null && ref.isEmpty()) {
            ref = null;
        }
        if (Payments.METHOD_ONLINE.equals(method) && ref == null) {
            throw new IllegalArgumentException("Vui lòng nhập mã giao dịch thanh toán online.");
        }
        if (ref != null && ref.length() > 100) {
            throw new IllegalArgumentException("Mã giao dịch quá dài.");
        }

        int paymentId = recordPaymentFriendly(appointmentId, amount, method, UUID.randomUUID(),
                Payments.METHOD_ONLINE.equals(method) ? ref : null);
        try {
            paymentDAO.setStatus(paymentId, Payments.STATUS_PAID);
        } catch (SQLException e) {
            throw new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(),
                    "Không thể xác nhận thanh toán. Vui lòng thử lại."), e.getSQLState(), e);
        }
        return paymentId;
    }

    private void validateAmountAndMethod(BigDecimal amount, String method) {
        if (amount == null || amount.signum() <= 0) {
            throw new IllegalArgumentException("Số tiền thanh toán phải lớn hơn 0.");
        }
        if (!Payments.METHOD_CASH.equals(method) && !Payments.METHOD_ONLINE.equals(method)) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ.");
        }
    }

    private int recordPaymentFriendly(int appointmentId, BigDecimal amount, String method, UUID paymentKey,
                                       String transactionRef) throws SQLException {
        try {
            return paymentDAO.recordPayment(appointmentId, amount, method, paymentKey, transactionRef);
        } catch (SQLException e) {
            throw new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(),
                    "Không thể ghi nhận thanh toán. Vui lòng kiểm tra lại và thử lại."), e.getSQLState(), e);
        }
    }

    private AppointmentBalance findOwned(int customerId, int appointmentId) throws SQLException {
        for (AppointmentBalance balance : getPayableAppointments(customerId)) {
            if (balance.getAppointmentId() == appointmentId) {
                return balance;
            }
        }
        return null;
    }
}
