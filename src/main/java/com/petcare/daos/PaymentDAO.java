package com.petcare.daos;

import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface PaymentDAO {

    /** The customer's own published (non-DRAFT, non-CANCELLED) appointments with an outstanding balance. */
    List<AppointmentBalance> findPayableAppointments(int customerId) throws SQLException;

    List<Payments> findByAppointment(int appointmentId) throws SQLException;

    /** Records a charge/refund via dbo.RecordPayment; returns the payment_id. */
    int recordPayment(int appointmentId, BigDecimal amount, String method, UUID paymentKey,
                       String transactionRef) throws SQLException;

    /** PAID or FAILED, via dbo.SetPaymentStatus. */
    void setStatus(int paymentId, String status) throws SQLException;
}
