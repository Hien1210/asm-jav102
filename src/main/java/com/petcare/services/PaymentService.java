package com.petcare.services;

import com.petcare.daos.PaymentDAO;
import com.petcare.daos.PaymentDAOImpl;
import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class PaymentService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang xử lý giao dịch khác, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51016, "Không thể thanh toán cho lịch hẹn ở trạng thái nháp.");
        FRIENDLY_ERRORS.put(51017, "Yêu cầu hoàn tiền không hợp lệ.");
        FRIENDLY_ERRORS.put(51018, "Tổng số tiền thanh toán vượt quá số tiền còn lại của lịch hẹn.");
        FRIENDLY_ERRORS.put(51019, "Số tiền hoàn vượt quá số tiền đã thanh toán.");
        FRIENDLY_ERRORS.put(51026, "Giao dịch đã hoàn tất hoặc thất bại nên không thể thay đổi.");
        FRIENDLY_ERRORS.put(51038, "Thiếu mã chống trùng giao dịch (idempotency key).");
        FRIENDLY_ERRORS.put(51039, "Mã giao dịch đã được sử dụng cho giao dịch khác, vui lòng tải lại trang.");
        FRIENDLY_ERRORS.put(51040, "Lịch hẹn không tồn tại hoặc chưa ở trạng thái hợp lệ.");
        FRIENDLY_ERRORS.put(51041, "Thanh toán trực tuyến yêu cầu mã tham chiếu giao dịch.");
        FRIENDLY_ERRORS.put(51042, "Không tìm thấy giao dịch thanh toán.");
        FRIENDLY_ERRORS.put(51043, "Giao dịch này đã chốt trạng thái cuối và không thể cập nhật thêm.");
        FRIENDLY_ERRORS.put(2627, "Mã giao dịch bị trùng lặp, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(2601, "Mã giao dịch bị trùng lặp, vui lòng thử lại.");
    }

    private final PaymentDAO paymentDAO;

    public PaymentService() {
        this(new PaymentDAOImpl());
    }

    public PaymentService(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    public List<AppointmentBalance> getPayableAppointments(int customerId) throws SQLException {
        return paymentDAO.findPayableAppointments(customerId);
    }

    public List<Payments> getPaymentHistory(int customerId) throws SQLException {
        return paymentDAO.findByCustomer(customerId);
    }

    /**
     * Initiates a CASH or ONLINE charge via dbo.RecordPayment (status = PENDING).
     * Verifies ownership, payable status, and remaining balance before calling DB.
     */
    public int initiatePayment(int customerId, int appointmentId, BigDecimal amount, String method, UUID paymentKey)
            throws SQLException {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Số tiền thanh toán phải lớn hơn 0.");
        }
        BigDecimal normalizedAmount = amount.setScale(2, RoundingMode.HALF_UP);

        String normalizedMethod = method == null ? "" : method.trim().toUpperCase();
        if (!Payments.METHOD_CASH.equals(normalizedMethod) && !Payments.METHOD_ONLINE.equals(normalizedMethod)) {
            throw new IllegalArgumentException("Phương thức thanh toán phải là Tiền mặt (CASH) hoặc Trực tuyến (ONLINE).");
        }

        UUID key = paymentKey != null ? paymentKey : UUID.randomUUID();

        AppointmentBalance target = null;
        for (AppointmentBalance appt : paymentDAO.findPayableAppointments(customerId)) {
            if (appt.getAppointmentId() == appointmentId) {
                target = appt;
                break;
            }
        }
        if (target == null) {
            throw new IllegalArgumentException("Lịch hẹn không tồn tại, không thuộc tài khoản của bạn hoặc đã bị hủy.");
        }
        if (target.getRemainingAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Lịch hẹn #" + appointmentId + " đã được thanh toán đủ hoặc đang chờ xác nhận đủ.");
        }
        if (normalizedAmount.compareTo(target.getRemainingAmount()) > 0) {
            throw new IllegalArgumentException("Số tiền thanh toán không được vượt quá số tiền còn lại ("
                    + target.getFormattedRemainingAmount() + ").");
        }

        String transactionRef = null;
        if (Payments.METHOD_ONLINE.equals(normalizedMethod)) {
            String suffix = key.toString().replace("-", "").substring(0, 12).toUpperCase();
            transactionRef = "PC-ONL-" + appointmentId + "-" + suffix;
        }

        try {
            return paymentDAO.recordPayment(appointmentId, normalizedAmount, normalizedMethod, key, transactionRef);
        } catch (SQLException e) {
            throw translate(e, "Không thể khởi tạo giao dịch thanh toán. Vui lòng thử lại.");
        }
    }

    /** Confirms a PENDING ONLINE payment belonging to customerId (simulated gateway callback -> PAID). */
    public Payments confirmOnlinePayment(int customerId, int paymentId) throws SQLException {
        Payments payment = paymentDAO.findByIdForCustomer(paymentId, customerId);
        if (payment == null) {
            throw new IllegalArgumentException("Không tìm thấy giao dịch thuộc tài khoản của bạn.");
        }
        if (!Payments.TYPE_CHARGE.equals(payment.getPaymentType())
                || !Payments.METHOD_ONLINE.equals(payment.getMethod())) {
            throw new IllegalArgumentException("Chỉ có thể tự xác nhận cho giao dịch thanh toán trực tuyến (ONLINE).");
        }
        if (!Payments.STATUS_PENDING.equals(payment.getStatus())) {
            throw new IllegalArgumentException("Giao dịch này đã ở trạng thái cuối (" + payment.getStatusLabel() + ").");
        }
        try {
            paymentDAO.setStatus(paymentId, Payments.STATUS_PAID);
            payment.setStatus(Payments.STATUS_PAID);
            return payment;
        } catch (SQLException e) {
            throw translate(e, "Không thể xác nhận thanh toán trực tuyến.");
        }
    }

    /** Cancels a PENDING payment attempt belonging to customerId (-> FAILED) so remaining balance is freed. */
    public Payments cancelPendingPayment(int customerId, int paymentId) throws SQLException {
        Payments payment = paymentDAO.findByIdForCustomer(paymentId, customerId);
        if (payment == null) {
            throw new IllegalArgumentException("Không tìm thấy giao dịch thuộc tài khoản của bạn.");
        }
        if (!Payments.TYPE_CHARGE.equals(payment.getPaymentType())
                || !Payments.STATUS_PENDING.equals(payment.getStatus())) {
            throw new IllegalArgumentException("Chỉ có thể hủy giao dịch đang chờ xử lý.");
        }
        try {
            paymentDAO.setStatus(paymentId, Payments.STATUS_FAILED);
            payment.setStatus(Payments.STATUS_FAILED);
            return payment;
        } catch (SQLException e) {
            throw translate(e, "Không thể hủy giao dịch đang chờ.");
        }
    }

    private SQLException translate(SQLException e, String fallback) {
        return new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(), fallback),
                e.getSQLState(), e.getErrorCode(), e);
    }
}
