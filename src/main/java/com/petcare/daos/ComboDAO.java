package com.petcare.daos;

import com.petcare.models.Combos;

import java.sql.SQLException;
import java.util.List;

public interface ComboDAO {

    /** All active combos along with their included services. */
    List<Combos> findActiveWithServices() throws SQLException;

    /** Single combo by ID along with its included services. */
    Combos findByIdWithServices(int comboId) throws SQLException;
}
