package com.petcare.daos;

import com.petcare.models.Notifications;

import java.sql.SQLException;
import java.util.List;

public interface NotificationDAO {

    List<Notifications> findByUser(int userId, String typeFilter) throws SQLException;

    int create(int userId, Integer appointmentId, String type, String channel, String content, String status)
            throws SQLException;
}
