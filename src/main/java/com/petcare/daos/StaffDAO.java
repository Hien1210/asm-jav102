package com.petcare.daos;

import com.petcare.models.StaffOption;

import java.sql.SQLException;
import java.util.List;

public interface StaffDAO {

    /** Active staff who can perform the given service (see dbo.ListActiveStaffForService). */
    List<StaffOption> findActiveStaffForService(int serviceId) throws SQLException;
}
