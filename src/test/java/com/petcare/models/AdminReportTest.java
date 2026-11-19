package com.petcare.models;

import org.junit.jupiter.api.Test;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class AdminReportTest {
    @Test void computesNetFromPaidDailyReceiptsAndRefundsAndExportsSameNumbers() throws Exception {
        var day=new AdminReport.Day(LocalDate.of(2026,11,19),new BigDecimal("350000.00"),new BigDecimal("50000.00"),3);
        var report=new AdminReport(List.of(day),Map.of("COMPLETED",1L,"PENDING",2L),List.of(),1,2);
        assertEquals(new BigDecimal("300000.00"),report.getNet());
        assertEquals(3,report.getAppointments()); assertEquals(1,report.getCompleted());
        StringWriter writer=new StringWriter(); report.writeCsv(writer);
        assertTrue(writer.toString().contains("2026-11-19,3,350000.00,50000.00,300000.00\r\n"));
        assertTrue(writer.toString().startsWith("\ufeffNgày"));
    }
    @Test void emptyReportAndRefundOnlyDayAreSafe() {
        var empty=new AdminReport(List.of(),Map.of(),List.of(),0,0);
        assertEquals(0,empty.getNet().signum());
        var day=new AdminReport.Day(LocalDate.of(2026,11,19),BigDecimal.ZERO,new BigDecimal("50000"),0);
        var report=new AdminReport(List.of(day),Map.of(),List.of(),0,0);
        assertEquals(new BigDecimal("-50000"),report.getNet()); assertEquals(100,day.getBarPercent());
    }
}
