package com.petcare.daos;

import java.sql.SQLException;
import java.sql.Timestamp;

public interface AppointmentDAO {

    /**
     * Books a single service for a pet with one staff member, via dbo.BookServiceAppointment.
     * Returns the new appointment_id.
     */
    int bookService(int customerId, int petId, int serviceId, int staffId,
                     Timestamp scheduledStart, Timestamp scheduledEnd) throws SQLException;
}
