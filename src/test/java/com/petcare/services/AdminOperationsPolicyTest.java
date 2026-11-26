package com.petcare.services;

import org.junit.jupiter.api.Test;
import java.time.LocalDate;
import static org.junit.jupiter.api.Assertions.*;

class AdminOperationsPolicyTest {
    @Test void includesEntireEndDate() {
        var range=AdminOperationsPolicy.range("2026-11-01","2026-11-19",LocalDate.of(2026,11,1),LocalDate.of(2026,11,19));
        assertEquals("2026-11-20T00:00",range.getUntil().toLocalDateTime().toString());
    }
    @Test void rejectsInvalidOrUnboundedRanges() {
        for(String[] values:new String[][]{{"bad","2026-11-19"},{"2026-11-20","2026-11-01"},{"2025-01-01","2026-11-19"}})
            assertThrows(IllegalArgumentException.class,()->AdminOperationsPolicy.range(values[0],values[1],LocalDate.now(),LocalDate.now()));
    }
    @Test void preventsJumpingStraightToCompleted() {
        assertThrows(IllegalArgumentException.class,()->AdminOperationsPolicy.checkTransition("PENDING","COMPLETED",null));
    }
    @Test void missingStatusIsAValidationError() {
        assertThrows(IllegalArgumentException.class,()->AdminOperationsPolicy.checkTransition("PENDING",null,null));
    }
    @Test void requiresCancellationReason() {
        assertThrows(IllegalArgumentException.class,()->AdminOperationsPolicy.checkTransition("CONFIRMED","CANCELLED"," "));
        assertThrows(IllegalArgumentException.class,()->AdminOperationsPolicy.checkTransition("CONFIRMED","CANCELLED","x".repeat(256)));
        assertDoesNotThrow(()->AdminOperationsPolicy.checkTransition("CONFIRMED","CANCELLED","Khách đổi kế hoạch"));
    }
    @Test void terminalAppointmentsCannotBeReopened() {
        for(String state:new String[]{"COMPLETED","CANCELLED","NO_SHOW","DRAFT"})
            assertTrue(AdminOperationsPolicy.nextStates(state).isEmpty());
    }
    @Test void matchesExistingDatabaseTransitions() {
        assertTrue(AdminOperationsPolicy.nextStates("CONFIRMED").contains("CHECKED_IN"));
        assertTrue(AdminOperationsPolicy.nextStates("CHECKED_IN").contains("COMPLETED"));
        assertFalse(AdminOperationsPolicy.nextStates("IN_PROGRESS").contains("NO_SHOW"));
    }
}
