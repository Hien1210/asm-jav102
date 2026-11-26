package com.petcare.daos;

import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PaymentDAOImpl implements PaymentDAO {

    public void confirmCounterCash(int paymentId, int actorId, int appointmentId) throws SQLException {
        String sql = "EXEC dbo.ConfirmCounterCash @payment_id = @p0, @actor_id = @p1, @appointment_id = @p2;";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DECLARE @p0 INT = ?, @p1 INT = ?, @p2 INT = ?; " + sql)) {
            stmt.setInt(1, paymentId);
            stmt.setInt(2, actorId);
            stmt.setInt(3, appointmentId);
            stmt.execute();
        } catch (SQLException e) {
            if (!DBUtil.isConnectionFailure(e)) {
                throw e;
            }
            DBUtil.executeLocalNonQuery(sql, DBUtil.localIntParam(paymentId),
                    DBUtil.localIntParam(actorId), DBUtil.localIntParam(appointmentId));
        }
    }

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

    private Payments mapLocalPaymentRow(String[] cols) {
        Payments payment = new Payments();
        payment.setPaymentId(Integer.parseInt(cols[0]));
        payment.setAppointmentId(Integer.parseInt(cols[1]));
        payment.setAmount(new BigDecimal(cols[2]));
        payment.setMethod(cols[3]);
        payment.setStatus(cols[4]);
        payment.setTransactionRef(cols[5]);
        LocalDateTime paidAt = DateUtil.parseLocalDateTime(cols[6]);
        payment.setPaidAt(paidAt != null ? Timestamp.valueOf(paidAt) : null);
        payment.setPaymentKey(cols[7] != null && !cols[7].isEmpty() ? UUID.fromString(cols[7]) : null);
        payment.setPaymentType(cols[8]);
        payment.setOriginalPaymentId(cols[9] != null && !cols[9].isEmpty() ? Integer.parseInt(cols[9]) : null);
        return payment;
    }

    @Override
    public List<AppointmentBalance> findPayableAppointments(int customerId) throws SQLException {
        List<AppointmentBalance> result = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.appointment_type, a.status, a.total_amount, "
                + "ISNULL((SELECT SUM(p.amount) FROM dbo.Payments p "
                + "        WHERE p.appointment_id = a.appointment_id AND p.payment_type = 'CHARGE' "
                + "        AND p.status IN ('PENDING','PAID')), 0) AS paid_or_pending, "
                + "a.created_at, pet.name AS pet_name, c.name AS combo_name "
                + "FROM dbo.Appointments a "
                + "JOIN dbo.Pets pet ON pet.pet_id = a.pet_id "
                + "LEFT JOIN dbo.Combos c ON c.combo_id = a.combo_id "
                + "WHERE a.customer_id = ? AND a.status NOT IN ('DRAFT', 'CANCELLED', 'NO_SHOW') "
                + "ORDER BY a.created_at DESC, a.appointment_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AppointmentBalance item = new AppointmentBalance(
                            rs.getInt("appointment_id"),
                            rs.getString("appointment_type"),
                            rs.getString("status"),
                            rs.getBigDecimal("total_amount"),
                            rs.getBigDecimal("paid_or_pending"),
                            rs.getTimestamp("created_at"));
                    item.setPetName(rs.getString("pet_name"));
                    item.setDescription(rs.getString("combo_name"));
                    result.add(item);
                }
            }
            return result;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE a.customer_id = ?", "WHERE a.customer_id = @p0");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(customerId))) {
                    LocalDateTime created = DateUtil.parseLocalDateTime(cols[5]);
                    AppointmentBalance item = new AppointmentBalance(
                            Integer.parseInt(cols[0]),
                            cols[1],
                            cols[2],
                            new BigDecimal(cols[3]),
                            new BigDecimal(cols[4]),
                            created != null ? Timestamp.valueOf(created) : null);
                    item.setPetName(cols[6]);
                    item.setDescription(cols[7]);
                    result.add(item);
                }
                return result;
            }
            throw e;
        }
    }

    @Override
    public List<Payments> findByAppointment(int appointmentId) throws SQLException {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT payment_id, appointment_id, amount, method, status, transaction_ref, "
                + "paid_at, payment_key, payment_type, original_payment_id "
                + "FROM dbo.Payments WHERE appointment_id = ? ORDER BY payment_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapRow(rs));
                }
            }
            return payments;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE appointment_id = ?", "WHERE appointment_id = @p0");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(appointmentId))) {
                    payments.add(mapLocalPaymentRow(cols));
                }
                return payments;
            }
            throw e;
        }
    }

    @Override
    public List<Payments> findByCustomer(int customerId) throws SQLException {
        List<Payments> payments = new ArrayList<>();
        String sql = "SELECT p.payment_id, p.appointment_id, p.amount, p.method, p.status, p.transaction_ref, "
                + "p.paid_at, p.payment_key, p.payment_type, p.original_payment_id "
                + "FROM dbo.Payments p "
                + "JOIN dbo.Appointments a ON a.appointment_id = p.appointment_id "
                + "WHERE a.customer_id = ? "
                + "ORDER BY p.payment_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapRow(rs));
                }
            }
            return payments;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE a.customer_id = ?", "WHERE a.customer_id = @p0");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(customerId))) {
                    payments.add(mapLocalPaymentRow(cols));
                }
                return payments;
            }
            throw e;
        }
    }

    @Override
    public Payments findByIdForCustomer(int paymentId, int customerId) throws SQLException {
        String sql = "SELECT p.payment_id, p.appointment_id, p.amount, p.method, p.status, p.transaction_ref, "
                + "p.paid_at, p.payment_key, p.payment_type, p.original_payment_id "
                + "FROM dbo.Payments p "
                + "JOIN dbo.Appointments a ON a.appointment_id = p.appointment_id "
                + "WHERE p.payment_id = ? AND a.customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            stmt.setInt(2, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE p.payment_id = ? AND a.customer_id = ?",
                        "WHERE p.payment_id = @p0 AND a.customer_id = @p1");
                List<String[]> rows = DBUtil.queryLocalSql(localSql,
                        DBUtil.localIntParam(paymentId), DBUtil.localIntParam(customerId));
                return rows.isEmpty() ? null : mapLocalPaymentRow(rows.get(0));
            }
            throw e;
        }
    }

    @Override
    public int recordPayment(int appointmentId, BigDecimal amount, String method, UUID paymentKey,
                             String transactionRef) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.RecordPayment(?,?,?,?,?,?,?,?)}")) {
            stmt.setInt(1, appointmentId);
            stmt.setBigDecimal(2, amount);
            stmt.setString(3, method);
            stmt.setString(4, paymentKey != null ? paymentKey.toString() : null);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.setString(6, Payments.TYPE_CHARGE);
            stmt.setNull(7, Types.INTEGER);
            if (transactionRef != null && !transactionRef.isBlank()) {
                stmt.setString(8, transactionRef.trim());
            } else {
                stmt.setNull(8, Types.NVARCHAR);
            }
            stmt.execute();
            return stmt.getInt(5);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String cleanRef = (transactionRef != null && !transactionRef.isBlank()) ? transactionRef.trim() : null;
                return DBUtil.executeLocalScalarInt(
                        "DECLARE @pid INT; "
                        + "EXEC dbo.RecordPayment @appointment_id = @p0, @amount = @p1, @method = @p2, "
                        + "@payment_key = @p3, @payment_id = @pid OUTPUT, @payment_type = 'CHARGE', "
                        + "@original_payment_id = NULL, @transaction_ref = @p4; "
                        + "SELECT @pid;",
                        DBUtil.localIntParam(appointmentId),
                        DBUtil.localDecimalParam(amount),
                        DBUtil.localStringParam(method),
                        DBUtil.localGuidParam(paymentKey),
                        DBUtil.localStringParam(cleanRef));
            }
            throw e;
        }
    }

    @Override
    public void setStatus(int paymentId, String status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SetPaymentStatus(?,?)}")) {
            stmt.setInt(1, paymentId);
            stmt.setString(2, status);
            stmt.execute();
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(
                        "EXEC dbo.SetPaymentStatus @payment_id = @p0, @status = @p1;",
                        DBUtil.localIntParam(paymentId),
                        DBUtil.localStringParam(status));
                return;
            }
            throw e;
        }
    }
}
