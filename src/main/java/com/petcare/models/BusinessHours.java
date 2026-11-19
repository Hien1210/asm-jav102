package com.petcare.models;

import com.petcare.utils.DateUtil;

import java.time.LocalTime;

public class BusinessHours {
    private int dayOfWeek;
    private LocalTime openTime;
    private LocalTime closeTime;
    private boolean closed;

    public int getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalTime getOpenTime() {
        return openTime;
    }

    public void setOpenTime(LocalTime openTime) {
        this.openTime = openTime;
    }

    public LocalTime getCloseTime() {
        return closeTime;
    }

    public void setCloseTime(LocalTime closeTime) {
        this.closeTime = closeTime;
    }

    public boolean isClosed() {
        return closed;
    }

    public void setClosed(boolean closed) {
        this.closed = closed;
    }

    public String getDayLabel() {
        return DateUtil.dayOfWeekLabel(dayOfWeek);
    }

    public String getFormattedRange() {
        if (closed || openTime == null || closeTime == null) {
            return "Nghỉ";
        }
        return DateUtil.formatTime(openTime) + " - " + DateUtil.formatTime(closeTime);
    }
}
