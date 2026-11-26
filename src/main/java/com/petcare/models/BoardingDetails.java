package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class BoardingDetails {
    private Integer appointmentId;
    private Integer roomId;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private BigDecimal dailyRateAtBooking;
    private LocalDateTime actualCheckIn;
    private LocalDateTime actualCheckOut;

    private String roomCode;
    private String roomType;

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public BigDecimal getDailyRateAtBooking() {
        return dailyRateAtBooking;
    }

    public void setDailyRateAtBooking(BigDecimal dailyRateAtBooking) {
        this.dailyRateAtBooking = dailyRateAtBooking;
    }

    public LocalDateTime getActualCheckIn() {
        return actualCheckIn;
    }

    public void setActualCheckIn(LocalDateTime actualCheckIn) {
        this.actualCheckIn = actualCheckIn;
    }

    public LocalDateTime getActualCheckOut() {
        return actualCheckOut;
    }

    public void setActualCheckOut(LocalDateTime actualCheckOut) {
        this.actualCheckOut = actualCheckOut;
    }

    public String getRoomCode() {
        return roomCode;
    }

    public void setRoomCode(String roomCode) {
        this.roomCode = roomCode;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public long getNights() {
        if (checkInDate == null || checkOutDate == null) {
            return 0;
        }
        return Math.max(0, ChronoUnit.DAYS.between(checkInDate, checkOutDate));
    }

    public String getFormattedCheckInDate() {
        return DateUtil.formatDate(checkInDate);
    }

    public String getFormattedCheckOutDate() {
        return DateUtil.formatDate(checkOutDate);
    }

    public String getFormattedDailyRate() {
        return DateUtil.formatVnd(dailyRateAtBooking);
    }

    public String getFormattedActualCheckIn() {
        return DateUtil.formatDateTime(actualCheckIn);
    }

    public String getFormattedActualCheckOut() {
        return DateUtil.formatDateTime(actualCheckOut);
    }
}
