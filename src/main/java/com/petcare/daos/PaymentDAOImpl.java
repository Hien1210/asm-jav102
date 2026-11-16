package com.petcare.daos;

import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;
import com.petcare.utils.DBUtil;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PaymentDAOImpl implements PaymentDAO {

    private Payments mapRow(ResultSet rs) throws SQLException {
        Payments payment = new Payments();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setAppointmentId(rs.getInt("appointment_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setMethod(rs.getString("method"));
        payment.setStatus(rs.getString("status"));
        payment.setTransactionRef(rs.getString("transaction_ref"));
        payment.setPaidAt(rs.getTimestamp("paid_at"));
        String key = rs.getString("payment_key");
        payment.setPaymentKey(key != null ? UUID.fromString(key) : null);
        payment.setPaymentType(rs.getString("payment_type"));
        int originalId = rs.getInt("original_payment_id");
        payment.setOriginalPaymentId(rs.wasNull() ? null : originalId);
        return payment;
    }

    @Override
    public List<AppointmentBalance> findPayableAppointments(int customerId) throws SQLException {
        List<AppointmentBalance> result = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_type, a.status, a.total_amount, "
                + "ISNULL((SELECT SUM(p.amount) FROM dbo.Payments p "
                + "        WHERE p.appointment_id = a.appointment_id AND p.payment_type = 'CHARGE' "
                + "        AND p.status IN ('PENDING','PAID')), 0) AS paid_or_pending, "
                + "a.created_at "
                + "FROM dbo.Appointments a "
                + "WHERE a.customer_id = ? AND a.status NOT IN ('DRAFT', 'CANCELLED') "
                + "ORDER BY a.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    result.add(new AppointmentBalance(
                            rs.getInt("appointment_id"),
                            rs.getString("appointment_type"),
                            rs.getString("status"),
                            rs.getBigDecimal("total_amount"),
                            rs.getBigDecimal("paid_or_pending"),
                            rs.getTimestamp("created_at")));
                }
            }
        }
        return result;
    }

    @Override
    public List<Payments> findByAppointment(int appointmentId) throws SQLException {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT payment_id, appointment_id, amount, method, status, transaction_ref, "
                + "paid_at, payment_key, payment_type, original_payment_id "
                + "FROM dbo.Payments WHERE appointment_id = ? ORDER BY payment_id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapRow(rs));
                }
            }
        }
        return payments;
    }

    @Override
    public int recordPayment(int appointmentId, BigDecimal amount, String method, UUID paymentKey,
                              String transactionRef) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.RecordPayment(?,?,?,?,?,?,?,?)}")) {
            stmt.setInt(1, appointmentId);
            stmt.setBigDecimal(2, amount);
            stmt.setString(3, method);
            stmt.setObject(4, paymentKey);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.setString(6, "CHARGE");
            stmt.setNull(7, Types.INTEGER);
            if (transactionRef != null) {
                stmt.setString(8, transactionRef);
            } else {
                stmt.setNull(8, Types.NVARCHAR);
            }
            stmt.execute();
            return stmt.getInt(5);
        }
    }

    @Override
    public void setStatus(int paymentId, String status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SetPaymentStatus(?,?)}")) {
            stmt.setInt(1, paymentId);
            stmt.setString(2, status);
            stmt.execute();
        }
    }
}
