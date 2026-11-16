package com.petcare.models;

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

    public AppointmentBalance(int appointmentId, String appointmentType, String status,
                               BigDecimal totalAmount, BigDecimal paidOrPendingAmount, Timestamp createdAt) {
        this.appointmentId = appointmentId;
        this.appointmentType = appointmentType;
        this.status = status;
        this.totalAmount = totalAmount;
        this.paidOrPendingAmount = paidOrPendingAmount;
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

    public BigDecimal getRemainingAmount() {
        return totalAmount.subtract(paidOrPendingAmount);
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
