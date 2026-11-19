package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDateTime;

public class Pets {
    private Integer petId;
    private Integer ownerId;
    private String name;
    private String species;
    private String breed;
    private BigDecimal weightKg;
    private Date birthDate;
    private String medicalNotes;
    private LocalDateTime createdAt;
    private int appointmentCount;

    public Integer getPetId() {
        return petId;
    }

    public void setPetId(Integer petId) {
        this.petId = petId;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getBreed() {
        return breed;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public BigDecimal getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(BigDecimal weightKg) {
        this.weightKg = weightKg;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getMedicalNotes() {
        return medicalNotes;
    }

    public void setMedicalNotes(String medicalNotes) {
        this.medicalNotes = medicalNotes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getAppointmentCount() {
        return appointmentCount;
    }

    public void setAppointmentCount(int appointmentCount) {
        this.appointmentCount = appointmentCount;
    }

    public String getFormattedBirthDate() {
        return birthDate == null ? "" : DateUtil.formatDate(birthDate.toLocalDate());
    }

    public String getBirthDateIso() {
        return birthDate == null ? "" : birthDate.toLocalDate().toString();
    }

    public String getFormattedCreatedAt() {
        return DateUtil.formatDateTime(createdAt);
    }
}
