package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.time.LocalDateTime;

public class Notifications {
    public static final String TYPE_REMINDER = "REMINDER";
    public static final String TYPE_CONFIRMATION = "CONFIRMATION";
    public static final String TYPE_CANCELLATION = "CANCELLATION";
    public static final String TYPE_OTHER = "OTHER";

    public static final String CHANNEL_EMAIL = "EMAIL";
    public static final String CHANNEL_SMS = "SMS";
    public static final String CHANNEL_PUSH = "PUSH";

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_SENT = "SENT";
    public static final String STATUS_FAILED = "FAILED";

    private Integer notificationId;
    private Integer userId;
    private Integer appointmentId;
    private String type;
    private String channel;
    private String content;
    private String status;
    private LocalDateTime createdAt;

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Integer appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedCreatedAt() {
        return DateUtil.formatDateTime(createdAt);
    }

    public String getTypeLabel() {
        if (type == null) {
            return "";
        }
        return switch (type) {
            case TYPE_CONFIRMATION -> "Xác nhận lịch";
            case TYPE_CANCELLATION -> "Hủy lịch";
            case TYPE_REMINDER -> "Nhắc lịch";
            case TYPE_OTHER -> "Hệ thống";
            default -> type;
        };
    }
}
