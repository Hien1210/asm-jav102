package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.Timestamp;

/** Read-only summary of one of the customer's own appointments, for the payment page. */
public class AppointmentBalance {
    private final int appointmentId;
    private final String appointmentType;
    private final String status;
    private final BigDecimal totalAmount;
    private final BigDecimal paidOrPendingAmount;
    private final Timestamp createdAt;
    private String petName;
    private String description;

    public AppointmentBalance(int appointmentId, String appointmentType, String status,
                               BigDecimal totalAmount, BigDecimal paidOrPendingAmount, Timestamp createdAt) {
        this.appointmentId = appointmentId;
        this.appointmentType = appointmentType;
        this.status = status;
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        this.paidOrPendingAmount = paidOrPendingAmount != null ? paidOrPendingAmount : BigDecimal.ZERO;
        this.createdAt = createdAt;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public String getAppointmentType() {
        return appointmentType;
    }

    public String getStatus() {
        return status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public BigDecimal getPaidOrPendingAmount() {
        return paidOrPendingAmount;
    }

    public BigDecimal getRemainingAmount() {
        BigDecimal rem = totalAmount.subtract(paidOrPendingAmount);
        return rem.compareTo(BigDecimal.ZERO) > 0 ? rem : BigDecimal.ZERO;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFormattedTotalAmount() {
        return DateUtil.formatVnd(totalAmount);
    }

    public String getFormattedPaidOrPendingAmount() {
        return DateUtil.formatVnd(paidOrPendingAmount);
    }

    public String getFormattedRemainingAmount() {
        return DateUtil.formatVnd(getRemainingAmount());
    }

    public String getFormattedCreatedAt() {
        return createdAt == null ? "" : DateUtil.formatDateTime(createdAt.toLocalDateTime());
    }

    public String getStatusLabel() {
        Appointments tmp = new Appointments();
        tmp.setStatus(status);
        return tmp.getStatusLabel();
    }

    public String getTypeLabel() {
        return Appointments.TYPE_BOARDING.equals(appointmentType) ? "Lưu trú khách sạn" : "Dịch vụ chăm sóc";
    }
}
