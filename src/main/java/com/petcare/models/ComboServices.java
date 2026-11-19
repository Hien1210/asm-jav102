package com.petcare.models;

public class ComboServices {
    private Integer comboId;
    private Integer serviceId;

    public ComboServices() { }

    public ComboServices(Integer comboId, Integer serviceId) {
        this.comboId = comboId;
        this.serviceId = serviceId;
    }

    public Integer getComboId() {
        return comboId;
    }

    public void setComboId(Integer comboId) {
        this.comboId = comboId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
}
