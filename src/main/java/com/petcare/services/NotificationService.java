package com.petcare.services;

import com.petcare.daos.NotificationDAO;
import com.petcare.daos.NotificationDAOImpl;
import com.petcare.models.Notifications;
import com.petcare.websocket.NotificationEndpoint;

import java.sql.SQLException;
import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this(new NotificationDAOImpl());
    }

    public NotificationService(NotificationDAO notificationDAO) {
        this.notificationDAO = notificationDAO;
    }

    public List<Notifications> listUserNotifications(int userId, String typeFilter) throws SQLException {
        return notificationDAO.findByUser(userId, typeFilter);
    }

    /**
     * Persists a PUSH notification into dbo.Notifications (best-effort so DB permission gaps
     * never block the primary booking/payment/cancel action) and sends a realtime WebSocket toast.
     */
    public void notifyCustomer(int userId, Integer appointmentId, String dbType,
                               String wsType, String title, String content) {
        try {
            notificationDAO.create(userId, appointmentId, dbType,
                    Notifications.CHANNEL_PUSH, content, Notifications.STATUS_SENT);
        } catch (SQLException ignored) {
            // Do not fail the customer action if dbo.Notifications write is unavailable.
        }
        NotificationEndpoint.notifyUser(userId, wsType, title, content);
    }
}
