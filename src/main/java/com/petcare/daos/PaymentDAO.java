package com.petcare.daos;

import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface PaymentDAO {

    /** The customer's own published (non-DRAFT, non-CANCELLED, non-NO_SHOW) appointments with payment totals. */
    List<AppointmentBalance> findPayableAppointments(int customerId) throws SQLException;

    List<Payments> findByAppointment(int appointmentId) throws SQLException;

    /** Full payment history (CHARGE and REFUND) for all appointments belonging to customerId. */
    List<Payments> findByCustomer(int customerId) throws SQLException;

    /** Loads a single payment only if its appointment belongs to customerId. */
    Payments findByIdForCustomer(int paymentId, int customerId) throws SQLException;

    /** Records a charge via dbo.RecordPayment; returns the payment_id. */
    int recordPayment(int appointmentId, BigDecimal amount, String method, UUID paymentKey,
                       String transactionRef) throws SQLException;

    /** PAID or FAILED, via dbo.SetPaymentStatus. */
    void setStatus(int paymentId, String status) throws SQLException;
}
