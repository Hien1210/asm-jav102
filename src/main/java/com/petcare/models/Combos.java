package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Combos {
    private Integer comboId;
    private String name;
    private String description;
    private BigDecimal price = BigDecimal.ZERO;
    private boolean active;
    private List<Services> services = new ArrayList<>();

    public Integer getComboId() {
        return comboId;
    }

    public void setComboId(Integer comboId) {
        this.comboId = comboId;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price != null ? price : BigDecimal.ZERO;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public List<Services> getServices() {
        return services;
    }

    public void setServices(List<Services> services) {
        this.services = services != null ? services : new ArrayList<>();
    }

    public BigDecimal getOriginalTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (Services svc : services) {
            if (svc.getPrice() != null) {
                total = total.add(svc.getPrice());
            }
        }
        return total;
    }

    public BigDecimal getSavingsAmount() {
        BigDecimal diff = getOriginalTotalPrice().subtract(price);
        return diff.compareTo(BigDecimal.ZERO) > 0 ? diff : BigDecimal.ZERO;
    }

    public int getTotalDurationMinutes() {
        int total = 0;
        for (Services svc : services) {
            total += svc.getDurationMinutes();
        }
        return total;
    }

    public String getFormattedPrice() {
        return DateUtil.formatVnd(price);
    }

    public String getFormattedOriginalTotalPrice() {
        return DateUtil.formatVnd(getOriginalTotalPrice());
    }

    public String getFormattedSavingsAmount() {
        return DateUtil.formatVnd(getSavingsAmount());
    }
}
