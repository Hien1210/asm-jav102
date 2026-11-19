package com.petcare.daos;

import com.petcare.models.Services;

import java.sql.SQLException;
import java.util.List;

public interface ServiceDAO {

    /** Active, bookable (non-BOARDING) services. */
    List<Services> findActiveBookable() throws SQLException;

    Services findById(int serviceId) throws SQLException;
}
