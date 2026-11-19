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

    /**
     * Books 1..100 distinct services (or an exact combo when comboId != null)
     * via dbo.BookServiceAppointment.
     */
    int bookServices(int customerId, int petId, List<ServiceBookingItem> items, Integer comboId)
            throws SQLException;

    /** Books a boarding room stay via dbo.BookBoardingAppointment. */
    int bookBoarding(int customerId, int petId, int roomId, LocalDate checkInDate, LocalDate checkOutDate)
            throws SQLException;

    /** Lists all appointments owned by a customer, optionally filtered by status and type. */
    List<Appointments> findByCustomer(int customerId, String statusFilter, String typeFilter) throws SQLException;

    /** Loads full details of one appointment if and only if owned by customerId. */
    Appointments findDetailByIdForCustomer(int appointmentId, int customerId) throws SQLException;

    /** Cancels an appointment via dbo.SetAppointmentStatus. */
    void cancelAppointment(int appointmentId, String cancelReason) throws SQLException;
}
