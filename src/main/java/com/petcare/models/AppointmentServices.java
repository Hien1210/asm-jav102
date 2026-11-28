package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class AppointmentServices {
    private Integer appointmentId;
    private Integer serviceId;
    private Integer staffId;
    private LocalDateTime scheduledStart;
    private LocalDateTime scheduledEnd;
    private BigDecimal priceAtBooking;
    private String lineStatus;

    private String serviceName;
    private String serviceCategory;
    private String staffName;

    // Joined display fields for the staff's "my appointments" view.
    private String appointmentStatus;
    private String customerName;
    private String customerPhone;
    private String petName;
    private String petSpecies;
    private String petBreed;
    private String medicalNotes;
    public String getPetSpecies() { return petSpecies; }
    public void setPetSpecies(String value) { petSpecies=value; }
    public String getPetBreed() { return petBreed; }
    public void setPetBreed(String value) { petBreed=value; }
    public String getMedicalNotes() { return medicalNotes; }
    public void setMedicalNotes(String value) { medicalNotes=value; }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public LocalDateTime getScheduledStart() {
        return scheduledStart;
    }

    public void setScheduledStart(LocalDateTime scheduledStart) {
        this.scheduledStart = scheduledStart;
    }

    public LocalDateTime getScheduledEnd() {
        return scheduledEnd;
    }

    public void setScheduledEnd(LocalDateTime scheduledEnd) {
        this.scheduledEnd = scheduledEnd;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    public String getLineStatus() {
        return lineStatus;
    }

    public void setLineStatus(String lineStatus) {
        this.lineStatus = lineStatus;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceCategory() {
        return serviceCategory;
    }

    public void setServiceCategory(String serviceCategory) {
        this.serviceCategory = serviceCategory;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getFormattedStart() {
        return DateUtil.formatDateTime(scheduledStart);
    }

    public String getFormattedEndTime() {
        return scheduledEnd == null ? "" : DateUtil.formatTime(scheduledEnd.toLocalTime());
    }

    public String getFormattedPrice() {
        return DateUtil.formatVnd(priceAtBooking);
    }

    public String getLineStatusLabel() {
        if (lineStatus == null) {
            return "";
        }
        return switch (lineStatus) {
            case "PENDING" -> "Chờ thực hiện";
            case "IN_PROGRESS" -> "Đang thực hiện";
            case "COMPLETED" -> "Hoàn thành";
            case "CANCELLED" -> "Đã hủy";
            default -> lineStatus;
        };
    }

    public String getAppointmentStatus() {
        return appointmentStatus;
    }

    public void setAppointmentStatus(String appointmentStatus) {
        this.appointmentStatus = appointmentStatus;
    }

    public String getAppointmentStatusLabel() {
        Appointments tmp = new Appointments();
        tmp.setStatus(appointmentStatus);
        return tmp.getStatusLabel();
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }
}
