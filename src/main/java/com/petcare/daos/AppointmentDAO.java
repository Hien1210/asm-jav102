package com.petcare.daos;

import com.petcare.models.Appointments;
import com.petcare.models.ServiceBookingItem;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

public interface AppointmentDAO {

    /**
     * Books a single service for a pet with one staff member, via dbo.BookServiceAppointment.
     * Returns the new appointment_id.
     */
    int bookService(int customerId, int petId, int serviceId, int staffId,
                     Timestamp scheduledStart, Timestamp scheduledEnd) throws SQLException;
}
