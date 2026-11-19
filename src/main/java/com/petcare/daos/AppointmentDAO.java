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

    /** Books 1..100 services (optionally as a combo) for a pet in one SERVICE appointment. */
    int bookServices(int customerId, int petId, List<ServiceBookingItem> items, Integer comboId) throws SQLException;

    /** Books a boarding room for a pet via dbo.BookBoardingAppointment. */
    int bookBoarding(int customerId, int petId, int roomId, LocalDate checkInDate, LocalDate checkOutDate)
            throws SQLException;

    /** The customer's own appointments, optionally filtered by status/type, with service/boarding details attached. */
    List<Appointments> findByCustomer(int customerId, String statusFilter, String typeFilter) throws SQLException;

    /** A single appointment with full detail, only if it belongs to customerId. */
    Appointments findDetailByIdForCustomer(int appointmentId, int customerId) throws SQLException;

    /** Cancels an appointment via dbo.SetAppointmentStatus(..., 'CANCELLED', cancelReason). */
    void cancelAppointment(int appointmentId, String cancelReason) throws SQLException;

    /**
     * CONFIRMED/CHECKED_IN/IN_PROGRESS/COMPLETED/CANCELLED/NO_SHOW via dbo.SetAppointmentStatus.
     * cancelReason is required only when status is CANCELLED.
     */
    void setStatus(int appointmentId, String status, String cancelReason) throws SQLException;
}
