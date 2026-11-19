package com.petcare.models;

import java.math.BigDecimal;

public class Services {
    private Integer serviceId;
    private String name;
    private String description;
    private String category;
    private int durationMinutes;
    private BigDecimal price;
    private boolean active;

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getFormattedPrice() {
        return com.petcare.utils.DateUtil.formatVnd(price);
    }

    public String getCategoryLabel() {
        if (category == null) {
            return "";
        }
        return switch (category) {
            case "GROOMING" -> "Grooming & Spa";
            case "MEDICAL" -> "Khám thú y";
            case "VACCINATION" -> "Tiêm phòng";
            case "BOARDING" -> "Lưu trú";
            case "OTHER" -> "Dịch vụ khác";
            default -> category;
        };
    }
}
