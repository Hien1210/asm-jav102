package com.petcare.models;

/** Minimal staff identity for a booking dropdown (no credentials). */
public class StaffOption {
    private final int staffId;
    private final String fullName;

    public StaffOption(int staffId, String fullName) {
        this.staffId = staffId;
        this.fullName = fullName;
    }

    public int getStaffId() {
        return staffId;
    }

    public String getFullName() {
        return fullName;
    }
}
