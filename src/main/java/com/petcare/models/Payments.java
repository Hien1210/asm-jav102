package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.UUID;

public class Payments {
    public static final String METHOD_CASH = "CASH";
    public static final String METHOD_ONLINE = "ONLINE";

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_PAID = "PAID";
    public static final String STATUS_FAILED = "FAILED";

    public static final String TYPE_CHARGE = "CHARGE";
    public static final String TYPE_REFUND = "REFUND";

    private Integer paymentId;
    private Integer appointmentId;
    private BigDecimal amount;
    private String method;
    private String status;
    private String transactionRef;
    private Timestamp paidAt;
    private UUID paymentKey;
    private String paymentType;
    private Integer originalPaymentId;

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionRef() {
        return transactionRef;
    }

    public void setTransactionRef(String transactionRef) {
        this.transactionRef = transactionRef;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }

    public UUID getPaymentKey() {
        return paymentKey;
    }

    public void setPaymentKey(UUID paymentKey) {
        this.paymentKey = paymentKey;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public Integer getOriginalPaymentId() {
        return originalPaymentId;
    }

    public void setOriginalPaymentId(Integer originalPaymentId) {
        this.originalPaymentId = originalPaymentId;
    }

    public String getFormattedAmount() {
        return DateUtil.formatVnd(amount);
    }

    public String getFormattedPaidAt() {
        return paidAt == null ? "" : DateUtil.formatDateTime(paidAt.toLocalDateTime());
    }

    public String getMethodLabel() {
        if (METHOD_ONLINE.equals(method)) {
            return "Trực tuyến (Online)";
        }
        if (METHOD_CASH.equals(method)) {
            return "Tiền mặt tại quầy";
        }
        return method != null ? method : "";
    }

    public String getStatusLabel() {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case STATUS_PENDING -> "Đang chờ";
            case STATUS_PAID -> "Đã thanh toán";
            case STATUS_FAILED -> "Thất bại / Đã hủy";
            default -> status;
        };
    }

    public String getPaymentTypeLabel() {
        return TYPE_REFUND.equals(paymentType) ? "Hoàn tiền" : "Thanh toán";
    }
}
