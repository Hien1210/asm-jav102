package com.petcare.services;

import com.petcare.models.Shifts;
import java.time.*;
import java.util.List;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class StaffViewPolicyTest {
    private final LocalDate today=LocalDate.of(2026,11,28);
    @Test void currentWeekStartsMonday() { var r=StaffViewPolicy.week(today,"current",null,null); assertEquals(LocalDate.of(2026,11,23),r.from()); assertEquals(LocalDate.of(2026,11,29),r.to()); }
    @Test void nextWeekStartsFollowingMonday() { var r=StaffViewPolicy.week(today,"next",null,null); assertEquals(LocalDate.of(2026,11,30),r.from()); }
    @Test void explicitRangeIsPreserved() { var r=StaffViewPolicy.week(today,"custom","2026-11-01","2026-11-28"); assertEquals(LocalDate.of(2026,11,1),r.from()); }
    @Test void invalidRangesAreRejected() { assertThrows(IllegalArgumentException.class,()->StaffViewPolicy.week(today,"custom","bad","2026-11-28")); assertThrows(IllegalArgumentException.class,()->StaffViewPolicy.week(today,"custom","2026-11-28","2026-11-01")); assertThrows(IllegalArgumentException.class,()->StaffViewPolicy.week(today,"custom","2026-01-01","2026-11-28")); }
    @Test void invalidWeekIsRejected() { assertThrows(IllegalArgumentException.class,()->StaffViewPolicy.week(today,"invalid",null,null)); }
    @Test void shiftMinutesAreNotRoundedToWholeHours() { Shifts s=new Shifts();s.setStartTime(LocalTime.of(8,30));s.setEndTime(LocalTime.of(12,0));assertEquals(210,StaffViewPolicy.minutes(List.of(s))); }
    @Test void appointmentDateDefaultsToToday() { assertEquals(today,StaffViewPolicy.date(null,today)); }
    @Test void invalidAppointmentDateIsRejected() { assertThrows(IllegalArgumentException.class,()->StaffViewPolicy.date("2026-02-31",today)); }
}
