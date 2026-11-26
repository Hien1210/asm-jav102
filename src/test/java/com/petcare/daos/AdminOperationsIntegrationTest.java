package com.petcare.daos;

import com.petcare.services.AdminOperationsPolicy;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import java.math.BigDecimal;
import java.time.LocalDate;
import static org.junit.jupiter.api.Assertions.*;

/** Only for the dedicated disposable operations fixture, never a user's PetCare database. */
@EnabledIfSystemProperty(named="petcare.operations.integration",matches="true")
class AdminOperationsIntegrationTest {
    private final AdminOperationsDAO dao=new AdminOperationsDAO();
    @BeforeEach void assertDisposableDatabase() throws Exception {
        try(var c=DBUtil.getConnection()) { assertTrue(c.getCatalog().startsWith("PetCareOperationsQA_"),"Refusing to mutate a non-QA database"); }
    }
    @Test void reportDoesNotMultiplyMoneyByServiceLinesAndIgnoresPendingFailed() throws Exception {
        var today=DateUtil.todayVn();
        var report=dao.report(AdminOperationsPolicy.range(today.toString(),today.toString(),today,today));
        assertEquals(0,new BigDecimal("350000").compareTo(report.getCharges()));
        assertEquals(0,new BigDecimal("50000").compareTo(report.getRefunds()));
        assertEquals(0,new BigDecimal("300000").compareTo(report.getNet()));
        assertEquals(3,report.getAppointments()); assertEquals(1,report.getCustomers()); assertEquals(2,report.getPets());
        assertEquals(1,report.getDays().size());
        var empty=dao.report(AdminOperationsPolicy.range("2098-01-01","2098-01-03",today,today));
        assertEquals(0,empty.getNet().signum()); assertEquals(3,empty.getDays().size());
    }
    @Test void calendarFiltersDetailsAndStatusWorkflowUseRealSchema() throws Exception {
        LocalDate from=LocalDate.of(2099,6,1),to=LocalDate.of(2099,6,4);
        var range=AdminOperationsPolicy.range(from.toString(),to.toString(),from,to);
        assertEquals(3,dao.appointments(range,"ALL","ALL","",1).getTotal());
        assertEquals(1,dao.appointments(range,"ALL","BOARDING","",1).getTotal());
        assertEquals(1,dao.appointments(range,"ALL","SERVICE","Ops Miu",1).getTotal());
        assertEquals(0,dao.appointments(range,"ALL","ALL","%",1).getTotal(),"Search wildcards must be literal");
        assertEquals(1,dao.appointments(range,"ALL","ALL","",999).getPage());
        assertNotNull(dao.detail(1)); assertNull(dao.detail(Integer.MAX_VALUE));
        assertEquals(2,((java.util.List<?>)dao.detail(1).get("services")).size());
        assertThrows(IllegalArgumentException.class,()->dao.changeStatus(2,1,"PENDING","CONFIRMED",null),"STAFF actor cannot manage admin status");
        dao.changeStatus(1,1,"PENDING","CONFIRMED",null);
        assertThrows(IllegalArgumentException.class,()->dao.changeStatus(1,1,"PENDING","CONFIRMED",null),"Stale requests cannot overwrite current state");
        dao.changeStatus(1,1,"CONFIRMED","CHECKED_IN",null);
        dao.changeStatus(1,1,"CHECKED_IN","IN_PROGRESS",null);
        dao.changeStatus(1,1,"IN_PROGRESS","COMPLETED",null);
        assertEquals("COMPLETED",dao.detail(1).get("status"));
        dao.changeStatus(1,2,"PENDING","CANCELLED","QA hủy lịch");
        assertEquals("QA hủy lịch",dao.detail(2).get("cancel_reason"));
        assertEquals("PENDING",dao.detail(3).get("status"));
    }
}
