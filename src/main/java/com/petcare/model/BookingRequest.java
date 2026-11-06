package com.petcare.model;

import java.io.Serializable;

public class BookingRequest implements Serializable {
    private String ownerName;
    private String phone;
    private String petName;
    private String petType;
    private String weightRange;
    private String serviceName;
    private String branch;
    private String bookingDate;
    private String timeSlot;
    private String notes;

    public BookingRequest() {
    }

    public BookingRequest(String ownerName, String phone, String petName, String petType,
                          String weightRange, String serviceName, String branch,
                          String bookingDate, String timeSlot, String notes) {
        this.ownerName = ownerName;
        this.phone = phone;
        this.petName = petName;
        this.petType = petType;
        this.weightRange = weightRange;
        this.serviceName = serviceName;
        this.branch = branch;
        this.bookingDate = bookingDate;
        this.timeSlot = timeSlot;
        this.notes = notes;
    }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }

    public String getPetType() { return petType; }
    public void setPetType(String petType) { this.petType = petType; }

    public String getWeightRange() { return weightRange; }
    public void setWeightRange(String weightRange) { this.weightRange = weightRange; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}

