package com.petcare.daos;

import com.petcare.models.BusinessHours;

import java.sql.SQLException;
import java.util.List;

public interface BusinessHoursDAO {
    List<BusinessHours> findAll() throws SQLException;
}
