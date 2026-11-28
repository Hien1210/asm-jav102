package com.petcare.services;

import com.petcare.models.Shifts;
import java.time.*;
import java.time.format.DateTimeParseException;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

/** Read-only date boundaries and totals for the staff workspace. */
public final class StaffViewPolicy {
    private StaffViewPolicy() { }
    public record Range(LocalDate from,LocalDate to) {
        public LocalDate getFrom() { return from; }
        public LocalDate getTo() { return to; }
    }
    public static LocalDate date(String raw,LocalDate fallback) {
        try { return raw==null||raw.isBlank()?fallback:LocalDate.parse(raw); }
        catch(DateTimeParseException e) { throw new IllegalArgumentException("Ngày không hợp lệ."); }
    }
    public static Range week(LocalDate today,String mode,String from,String to) {
        String selected=mode==null||mode.isBlank()?"current":mode;
        LocalDate monday=today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        return switch(selected) {
            case "current" -> new Range(monday,monday.plusDays(6));
            case "next" -> new Range(monday.plusDays(7),monday.plusDays(13));
            case "custom" -> {
                if(from==null||from.isBlank()||to==null||to.isBlank()) throw new IllegalArgumentException("Chọn đủ ngày bắt đầu và kết thúc.");
                LocalDate start=date(from,today),end=date(to,today);
                if(end.isBefore(start)||end.isAfter(start.plusDays(30))) throw new IllegalArgumentException("Khoảng ngày phải từ 1 đến 31 ngày.");
                yield new Range(start,end);
            }
            default -> throw new IllegalArgumentException("Khoảng tuần không hợp lệ.");
        };
    }
    public static long minutes(List<Shifts> shifts) {
        return shifts.stream().filter(s->s.getStartTime()!=null&&s.getEndTime()!=null)
                .mapToLong(s->Duration.between(s.getStartTime(),s.getEndTime()).toMinutes()).sum();
    }
}
