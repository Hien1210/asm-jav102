package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Appointments {
    public static final String TYPE_SERVICE = "SERVICE";
    public static final String TYPE_BOARDING = "BOARDING";

    public static final String STATUS_DRAFT = "DRAFT";
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_CONFIRMED = "CONFIRMED";
    public static final String STATUS_CHECKED_IN = "CHECKED_IN";
    public static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_NO_SHOW = "NO_SHOW";

    private Integer appointmentId;
    private Integer customerId;
    private Integer petId;
    private String appointmentType;
    private Integer comboId;
    private String status;
    private String cancelReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BigDecimal subtotalAmount = BigDecimal.ZERO;
    private BigDecimal comboPriceAtBooking;
    private BigDecimal adjustmentAmount = BigDecimal.ZERO;
    private BigDecimal totalAmount = BigDecimal.ZERO;

    // Joined display fields
    private String petName;
    private String petSpecies;
    private String comboName;
    private List<AppointmentServices> serviceLines = new ArrayList<>();
    private BoardingDetails boardingDetail;
    private Reviews review;
    private BigDecimal paidAmount = BigDecimal.ZERO;
    private BigDecimal pendingAmount = BigDecimal.ZERO;
    private BigDecimal refundedAmount = BigDecimal.ZERO;

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getPetId() {
        return petId;
    }

    public void setPetId(Integer petId) {
        this.petId = petId;
    }

    public String getAppointmentType() {
        return appointmentType;
    }

    public void setAppointmentType(String appointmentType) {
        this.appointmentType = appointmentType;
    }

    public Integer getComboId() {
        return comboId;
    }

    public void setComboId(Integer comboId) {
        this.comboId = comboId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public BigDecimal getSubtotalAmount() {
        return subtotalAmount;
    }

    public void setSubtotalAmount(BigDecimal subtotalAmount) {
        this.subtotalAmount = subtotalAmount != null ? subtotalAmount : BigDecimal.ZERO;
    }

    public BigDecimal getComboPriceAtBooking() {
        return comboPriceAtBooking;
    }

    public void setComboPriceAtBooking(BigDecimal comboPriceAtBooking) {
        this.comboPriceAtBooking = comboPriceAtBooking;
    }

    public BigDecimal getAdjustmentAmount() {
        return adjustmentAmount;
    }

    public void setAdjustmentAmount(BigDecimal adjustmentAmount) {
        this.adjustmentAmount = adjustmentAmount != null ? adjustmentAmount : BigDecimal.ZERO;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

    public String getPetSpecies() {
        return petSpecies;
    }

    public void setPetSpecies(String petSpecies) {
        this.petSpecies = petSpecies;
    }

    public String getComboName() {
        return comboName;
    }

    public void setComboName(String comboName) {
        this.comboName = comboName;
    }

    public List<AppointmentServices> getServiceLines() {
        return serviceLines;
    }

    public void setServiceLines(List<AppointmentServices> serviceLines) {
        this.serviceLines = serviceLines != null ? serviceLines : new ArrayList<>();
    }

    public BoardingDetails getBoardingDetail() {
        return boardingDetail;
    }

    public void setBoardingDetail(BoardingDetails boardingDetail) {
        this.boardingDetail = boardingDetail;
    }

    public Reviews getReview() {
        return review;
    }

    public void setReview(Reviews review) {
        this.review = review;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount != null ? paidAmount : BigDecimal.ZERO;
    }

    public BigDecimal getPendingAmount() {
        return pendingAmount;
    }

    public void setPendingAmount(BigDecimal pendingAmount) {
        this.pendingAmount = pendingAmount != null ? pendingAmount : BigDecimal.ZERO;
    }

    public BigDecimal getRefundedAmount() {
        return refundedAmount;
    }

    public void setRefundedAmount(BigDecimal refundedAmount) {
        this.refundedAmount = refundedAmount != null ? refundedAmount : BigDecimal.ZERO;
    }

    public BigDecimal getRemainingAmount() {
        BigDecimal reserved = paidAmount.add(pendingAmount);
        BigDecimal rem = totalAmount.subtract(reserved);
        return rem.compareTo(BigDecimal.ZERO) > 0 ? rem : BigDecimal.ZERO;
    }

    public boolean isCancellable() {
        return STATUS_PENDING.equals(status) || STATUS_CONFIRMED.equals(status);
    }

    public boolean isReviewable() {
        return STATUS_COMPLETED.equals(status) && review == null;
    }

    public boolean isPayable() {
        return !STATUS_DRAFT.equals(status)
                && !STATUS_CANCELLED.equals(status)
                && !STATUS_NO_SHOW.equals(status)
                && getRemainingAmount().compareTo(BigDecimal.ZERO) > 0;
    }

    public String getFormattedTotalAmount() {
        return DateUtil.formatVnd(totalAmount);
    }

    public String getFormattedSubtotalAmount() {
        return DateUtil.formatVnd(subtotalAmount);
    }

    public String getFormattedAdjustmentAmount() {
        return DateUtil.formatVnd(adjustmentAmount);
    }

    public String getFormattedPaidAmount() {
        return DateUtil.formatVnd(paidAmount);
    }

    public String getFormattedPendingAmount() {
        return DateUtil.formatVnd(pendingAmount);
    }

    public String getFormattedRemainingAmount() {
        return DateUtil.formatVnd(getRemainingAmount());
    }

    public String getFormattedCreatedAt() {
        return DateUtil.formatDateTime(createdAt);
    }

    public String getStatusLabel() {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case STATUS_DRAFT -> "Nháp";
            case STATUS_PENDING -> "Chờ xác nhận";
            case STATUS_CONFIRMED -> "Đã xác nhận";
            case STATUS_CHECKED_IN -> "Đã check-in";
            case STATUS_IN_PROGRESS -> "Đang thực hiện";
            case STATUS_COMPLETED -> "Hoàn thành";
            case STATUS_CANCELLED -> "Đã hủy";
            case STATUS_NO_SHOW -> "Vắng mặt";
            default -> status;
        };
    }

    public String getTypeLabel() {
        if (TYPE_BOARDING.equals(appointmentType)) {
            return "Lưu trú khách sạn";
        }
        if (comboId != null) {
            return "Gói Combo";
        }
        return "Dịch vụ chăm sóc";
    }
}
