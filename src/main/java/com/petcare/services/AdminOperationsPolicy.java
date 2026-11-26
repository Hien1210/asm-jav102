package com.petcare.services;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

public final class AdminOperationsPolicy {
    private AdminOperationsPolicy() { }
    public static final Map<String,String> STATUS_LABELS;
    static {
        Map<String,String> labels=new LinkedHashMap<>();
        labels.put("DRAFT","Nháp"); labels.put("PENDING","Chờ xác nhận"); labels.put("CONFIRMED","Đã xác nhận");
        labels.put("CHECKED_IN","Đã tiếp nhận"); labels.put("IN_PROGRESS","Đang thực hiện");
        labels.put("COMPLETED","Hoàn thành"); labels.put("CANCELLED","Đã hủy"); labels.put("NO_SHOW","Vắng mặt");
        STATUS_LABELS=Collections.unmodifiableMap(labels);
    }
    public static List<String> nextStates(String status) {
        if(status==null) return List.of();
        return switch(status) {
            case "PENDING" -> List.of("CONFIRMED","CANCELLED","NO_SHOW");
            case "CONFIRMED" -> List.of("CHECKED_IN","CANCELLED","NO_SHOW");
            case "CHECKED_IN" -> List.of("IN_PROGRESS","COMPLETED","CANCELLED");
            case "IN_PROGRESS" -> List.of("COMPLETED","CANCELLED");
            default -> List.of();
        };
    }
    public static void checkTransition(String from,String to,String reason) {
        if(to==null||!nextStates(from).contains(to)) throw new IllegalArgumentException("Không thể chuyển sang trạng thái này. Vui lòng tải lại lịch hẹn.");
        if("CANCELLED".equals(to) && (reason==null || reason.isBlank() || reason.trim().length()>255))
            throw new IllegalArgumentException("Vui lòng nhập lý do hủy, tối đa 255 ký tự.");
    }
    public static String statusFilter(String value) {
        String result=value==null||value.isBlank()?"ALL":value.trim();
        if(!"ALL".equals(result)&&!STATUS_LABELS.containsKey(result)) throw new IllegalArgumentException("Trạng thái lọc không hợp lệ.");
        return result;
    }
    public static String typeFilter(String value) {
        String result=value==null||value.isBlank()?"ALL":value.trim();
        if(!List.of("ALL","SERVICE","BOARDING").contains(result)) throw new IllegalArgumentException("Loại lịch hẹn không hợp lệ.");
        return result;
    }
    public static Range range(String from,String to,LocalDate defaultFrom,LocalDate defaultTo) {
        try {
            LocalDate start=from==null||from.isBlank()?defaultFrom:LocalDate.parse(from.trim());
            LocalDate end=to==null||to.isBlank()?defaultTo:LocalDate.parse(to.trim());
            if(start.getYear()<1900||end.getYear()>9998||end.isBefore(start)||ChronoUnit.DAYS.between(start,end)>365)
                throw new IllegalArgumentException();
            return new Range(start,end);
        } catch(RuntimeException e) { throw new IllegalArgumentException("Khoảng ngày không hợp lệ. Chọn từ ngày đến ngày, tối đa 366 ngày."); }
    }
    public static final class Range {
        private final LocalDate from,to;
        private Range(LocalDate from,LocalDate to) { this.from=from; this.to=to; }
        public LocalDate getFrom() { return from; }
        public LocalDate getTo() { return to; }
        public Timestamp getStart() { return Timestamp.valueOf(from.atStartOfDay()); }
        public Timestamp getUntil() { return Timestamp.valueOf(to.plusDays(1).atStartOfDay()); }
    }
}
