package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;

public class Rooms {
    public static final String STATUS_AVAILABLE = "AVAILABLE";
    public static final String STATUS_OCCUPIED = "OCCUPIED";
    public static final String STATUS_MAINTENANCE = "MAINTENANCE";

    private Integer roomId;
    private String roomCode;
    private String roomType;
    private BigDecimal dailyRate = BigDecimal.ZERO;
    private String status;

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
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

    public BigDecimal getDailyRate() {
        return dailyRate;
    }

    public void setDailyRate(BigDecimal dailyRate) {
        this.dailyRate = dailyRate != null ? dailyRate : BigDecimal.ZERO;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getFormattedDailyRate() {
        return DateUtil.formatVnd(dailyRate);
    }

    public String getStatusLabel() {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case STATUS_AVAILABLE -> "Sẵn sàng";
            case STATUS_OCCUPIED -> "Đang có khách";
            case STATUS_MAINTENANCE -> "Bảo trì";
            default -> status;
        };
    }
}
