package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.time.LocalDate;
import java.time.LocalTime;

public class Shifts {
    private Integer shiftId;
    private Integer staffId;
    private LocalDate workDate;
    private LocalTime startTime;
    private LocalTime endTime;

    private String staffName;

    public Integer getShiftId() {
        return shiftId;
    }

    public void setShiftId(Integer shiftId) {
        this.shiftId = shiftId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public void setWorkDate(LocalDate workDate) {
        this.workDate = workDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getFormattedWorkDate() {
        return DateUtil.formatDate(workDate);
    }

    public String getFormattedRange() {
        return DateUtil.formatTime(startTime) + " - " + DateUtil.formatTime(endTime);
    }
}
