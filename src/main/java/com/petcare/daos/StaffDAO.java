package com.petcare.daos;

import com.petcare.models.Shifts;
import com.petcare.models.StaffOption;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public interface StaffDAO {

    /** Active staff who can perform the given service (see dbo.ListActiveStaffForService). */
    List<StaffOption> findActiveStaffForService(int serviceId) throws SQLException;

    /** Upcoming shifts for active staff within the given date range (inclusive). */
    List<Shifts> findUpcomingShifts(LocalDate fromDate, LocalDate toDate) throws SQLException;
}
