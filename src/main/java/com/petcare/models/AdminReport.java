package com.petcare.models;

import java.io.IOException;
import java.io.Writer;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;

/** Cash-basis receipts; totals are calculated from the same daily rows shown/exported. */
public class AdminReport {
    private final List<Day> days;
    private final Map<String,Long> statuses;
    private final List<Map<String,Object>> services;
    private final long customers,pets;
    public AdminReport(List<Day> days,Map<String,Long> statuses,List<Map<String,Object>> services,long customers,long pets) {
        this.days=List.copyOf(days); this.statuses=Collections.unmodifiableMap(new LinkedHashMap<>(statuses));
        this.services=List.copyOf(services); this.customers=customers; this.pets=pets;
        BigDecimal max=days.stream().map(d->d.getNet().abs()).max(BigDecimal::compareTo).orElse(BigDecimal.ZERO);
        for(Day day:days) day.barPercent=max.signum()==0?0:day.getNet().abs().multiply(BigDecimal.valueOf(100)).divide(max,0,RoundingMode.HALF_UP).intValue();
    }
    public List<Day> getDays() { return days; }
    public Map<String,Long> getStatuses() { return statuses; }
    public List<Map<String,Object>> getServices() { return services; }
    public long getCustomers() { return customers; }
    public long getPets() { return pets; }
    public long getAppointments() { return statuses.values().stream().mapToLong(Long::longValue).sum(); }
    public long getCompleted() { return statuses.getOrDefault("COMPLETED",0L); }
    public BigDecimal getCharges() { return days.stream().map(Day::getCharges).reduce(BigDecimal.ZERO,BigDecimal::add); }
    public BigDecimal getRefunds() { return days.stream().map(Day::getRefunds).reduce(BigDecimal.ZERO,BigDecimal::add); }
    public BigDecimal getNet() { return getCharges().subtract(getRefunds()); }
    public void writeCsv(Writer writer) throws IOException {
        writer.write("\ufeffNgày,Lịch tạo,Tiền thu,Hoàn tiền,Thực thu\r\n");
        for(Day day:days) writer.write(day.day+","+day.appointments+","+day.charges.toPlainString()+","+day.refunds.toPlainString()+","+day.getNet().toPlainString()+"\r\n");
    }
    public static final class Day {
        private final LocalDate day;
        private final BigDecimal charges,refunds;
        private final long appointments;
        private int barPercent;
        public Day(LocalDate day,BigDecimal charges,BigDecimal refunds,long appointments) {
            this.day=day; this.charges=charges; this.refunds=refunds; this.appointments=appointments;
        }
        public LocalDate getDay() { return day; }
        public BigDecimal getCharges() { return charges; }
        public BigDecimal getRefunds() { return refunds; }
        public BigDecimal getNet() { return charges.subtract(refunds); }
        public long getAppointments() { return appointments; }
        public int getBarPercent() { return barPercent; }
    }
}
