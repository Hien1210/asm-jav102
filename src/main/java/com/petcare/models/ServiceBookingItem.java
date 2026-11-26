package com.petcare.models;

import java.time.LocalDateTime;

/** One row in the dbo.ServiceBookingItems TVP passed to dbo.BookServiceAppointment. */
public class ServiceBookingItem {
    private final int serviceId;
    private final int staffId;
    private final LocalDateTime scheduledStart;
    private LocalDateTime scheduledEnd;

    public ServiceBookingItem(int serviceId, int staffId, LocalDateTime scheduledStart, LocalDateTime scheduledEnd) {
        this.serviceId = serviceId;
        this.staffId = staffId;
        this.scheduledStart = scheduledStart;
        this.scheduledEnd = scheduledEnd;
    }

    public ServiceBookingItem(int serviceId, int staffId, LocalDateTime scheduledStart) {
        this(serviceId, staffId, scheduledStart, null);
    }

    public int getServiceId() {
        return serviceId;
    }

    public int getStaffId() {
        return staffId;
    }

    public LocalDateTime getScheduledStart() {
        return scheduledStart;
    }

    public LocalDateTime getScheduledEnd() {
        return scheduledEnd;
    }

    public void setScheduledEnd(LocalDateTime scheduledEnd) {
        this.scheduledEnd = scheduledEnd;
    }
}
