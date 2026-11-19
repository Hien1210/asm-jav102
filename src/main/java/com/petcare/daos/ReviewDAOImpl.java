package com.petcare.daos;

import com.petcare.models.Appointments;
import com.petcare.models.Reviews;
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
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public void submitReview(int appointmentId, int customerId, int rating, String comment) throws SQLException {
        String cleanComment = (comment == null || comment.isBlank()) ? null : comment.trim();
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SubmitReview(?,?,?,?)}")) {
            stmt.setInt(1, appointmentId);
            stmt.setInt(2, customerId);
            stmt.setByte(3, (byte) rating);
            if (cleanComment != null) {
                stmt.setString(4, cleanComment);
            } else {
                stmt.setNull(4, Types.NVARCHAR);
            }
            stmt.execute();
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(
                        "EXEC dbo.SubmitReview @appointment_id = @p0, @customer_id = @p1, "
                        + "@rating = @p2, @comment = @p3;",
                        DBUtil.localIntParam(appointmentId),
                        DBUtil.localIntParam(customerId),
                        DBUtil.localIntParam(rating),
                        DBUtil.localStringParam(cleanComment));
                return;
            }
            throw e;
        }
    }

    @Override
    public List<Reviews> findByCustomer(int customerId) throws SQLException {
        List<Reviews> list = new ArrayList<>();
        String sql = "SELECT r.review_id, r.appointment_id, r.customer_id, r.rating, r.comment, r.created_at, "
                + "u.full_name AS customer_name, p.name AS pet_name, p.species AS pet_species, "
                + "a.appointment_type, c.name AS combo_name "
                + "FROM dbo.Reviews r "
                + "JOIN dbo.Appointments a ON a.appointment_id = r.appointment_id "
                + "JOIN dbo.Users u ON u.user_id = r.customer_id "
                + "JOIN dbo.Pets p ON p.pet_id = a.pet_id "
                + "LEFT JOIN dbo.Combos c ON c.combo_id = a.combo_id "
                + "WHERE r.customer_id = ? "
                + "ORDER BY r.created_at DESC, r.review_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReviewRow(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE r.customer_id = ?", "WHERE r.customer_id = @p0");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(customerId))) {
                    list.add(mapLocalReviewRow(cols));
                }
                return list;
            }
            throw e;
        }
    }

    @Override
    public List<Appointments> findReviewableAppointments(int customerId) throws SQLException {
        List<Appointments> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.customer_id, a.pet_id, a.appointment_type, a.combo_id, "
                + "a.status, a.created_at, a.updated_at, a.total_amount, "
                + "p.name AS pet_name, p.species AS pet_species, c.name AS combo_name "
                + "FROM dbo.Appointments a "
                + "JOIN dbo.Pets p ON p.pet_id = a.pet_id "
                + "LEFT JOIN dbo.Combos c ON c.combo_id = a.combo_id "
                + "WHERE a.customer_id = ? AND a.status = 'COMPLETED' "
                + "  AND NOT EXISTS (SELECT 1 FROM dbo.Reviews r WHERE r.appointment_id = a.appointment_id) "
                + "ORDER BY a.updated_at DESC, a.appointment_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointments appt = new Appointments();
                    appt.setAppointmentId(rs.getInt("appointment_id"));
                    appt.setCustomerId(rs.getInt("customer_id"));
                    appt.setPetId(rs.getInt("pet_id"));
                    appt.setAppointmentType(rs.getString("appointment_type"));
                    int comboId = rs.getInt("combo_id");
                    appt.setComboId(rs.wasNull() ? null : comboId);
                    appt.setStatus(rs.getString("status"));
                    Timestamp created = rs.getTimestamp("created_at");
                    Timestamp updated = rs.getTimestamp("updated_at");
                    appt.setCreatedAt(created != null ? created.toLocalDateTime() : null);
                    appt.setUpdatedAt(updated != null ? updated.toLocalDateTime() : null);
                    appt.setTotalAmount(rs.getBigDecimal("total_amount"));
                    appt.setPetName(rs.getString("pet_name"));
                    appt.setPetSpecies(rs.getString("pet_species"));
                    appt.setComboName(rs.getString("combo_name"));
                    list.add(appt);
                }
            }
            return list;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("WHERE a.customer_id = ?", "WHERE a.customer_id = @p0");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(customerId))) {
                    Appointments appt = new Appointments();
                    appt.setAppointmentId(Integer.parseInt(cols[0]));
                    appt.setCustomerId(Integer.parseInt(cols[1]));
                    appt.setPetId(Integer.parseInt(cols[2]));
                    appt.setAppointmentType(cols[3]);
                    appt.setComboId(cols[4] != null && !cols[4].isEmpty() ? Integer.parseInt(cols[4]) : null);
                    appt.setStatus(cols[5]);
                    appt.setCreatedAt(DateUtil.parseLocalDateTime(cols[6]));
                    appt.setUpdatedAt(DateUtil.parseLocalDateTime(cols[7]));
                    appt.setTotalAmount(new BigDecimal(cols[8]));
                    appt.setPetName(cols[9]);
                    appt.setPetSpecies(cols[10]);
                    appt.setComboName(cols[11]);
                    list.add(appt);
                }
                return list;
            }
            throw e;
        }
    }

    @Override
    public List<Reviews> findRecentPublicReviews(int limit) throws SQLException {
        int safeLimit = Math.max(1, Math.min(limit, 20));
        List<Reviews> list = new ArrayList<>();
        String sql = "SELECT TOP (?) r.review_id, r.appointment_id, r.customer_id, r.rating, r.comment, r.created_at, "
                + "u.full_name AS customer_name, p.name AS pet_name, p.species AS pet_species, "
                + "a.appointment_type, c.name AS combo_name "
                + "FROM dbo.Reviews r "
                + "JOIN dbo.Appointments a ON a.appointment_id = r.appointment_id "
                + "JOIN dbo.Users u ON u.user_id = r.customer_id "
                + "JOIN dbo.Pets p ON p.pet_id = a.pet_id "
                + "LEFT JOIN dbo.Combos c ON c.combo_id = a.combo_id "
                + "ORDER BY r.created_at DESC, r.review_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, safeLimit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapReviewRow(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = sql.replace("TOP (?)", "TOP (@p0)");
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(safeLimit))) {
                    list.add(mapLocalReviewRow(cols));
                }
                return list;
            }
            throw e;
        }
    }

    private Reviews mapReviewRow(ResultSet rs) throws SQLException {
        Reviews r = new Reviews();
        r.setReviewId(rs.getInt("review_id"));
        r.setAppointmentId(rs.getInt("appointment_id"));
        r.setCustomerId(rs.getInt("customer_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        Timestamp ts = rs.getTimestamp("created_at");
        r.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        r.setCustomerName(rs.getString("customer_name"));
        r.setPetName(rs.getString("pet_name"));
        r.setPetSpecies(rs.getString("pet_species"));
        r.setAppointmentType(rs.getString("appointment_type"));
        String comboName = rs.getString("combo_name");
        if (comboName != null && !comboName.isBlank()) {
            r.setSummaryLabel(comboName);
        } else if (Appointments.TYPE_BOARDING.equals(r.getAppointmentType())) {
            r.setSummaryLabel("Lưu trú khách sạn thú cưng");
        } else {
            r.setSummaryLabel("Dịch vụ chăm sóc thú cưng");
        }
        return r;
    }

    private Reviews mapLocalReviewRow(String[] cols) {
        Reviews r = new Reviews();
        r.setReviewId(Integer.parseInt(cols[0]));
        r.setAppointmentId(Integer.parseInt(cols[1]));
        r.setCustomerId(Integer.parseInt(cols[2]));
        r.setRating(Integer.parseInt(cols[3]));
        r.setComment(cols[4]);
        r.setCreatedAt(DateUtil.parseLocalDateTime(cols[5]));
        r.setCustomerName(cols[6]);
        r.setPetName(cols[7]);
        r.setPetSpecies(cols[8]);
        r.setAppointmentType(cols[9]);
        String comboName = cols[10];
        if (comboName != null && !comboName.isBlank()) {
            r.setSummaryLabel(comboName);
        } else if (Appointments.TYPE_BOARDING.equals(r.getAppointmentType())) {
            r.setSummaryLabel("Lưu trú khách sạn thú cưng");
        } else {
            r.setSummaryLabel("Dịch vụ chăm sóc thú cưng");
        }
        return r;
    }
}
