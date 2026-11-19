package com.petcare.daos;

import com.petcare.models.Notifications;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {

    private Notifications mapRow(ResultSet rs) throws SQLException {
        Notifications n = new Notifications();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        int apptId = rs.getInt("appointment_id");
        n.setAppointmentId(rs.wasNull() ? null : apptId);
        n.setType(rs.getString("type"));
        n.setChannel(rs.getString("channel"));
        n.setContent(rs.getString("content"));
        n.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        n.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return n;
    }

    private Notifications mapLocalRow(String[] cols) {
        Notifications n = new Notifications();
        n.setNotificationId(Integer.parseInt(cols[0]));
        n.setUserId(Integer.parseInt(cols[1]));
        n.setAppointmentId(cols[2] != null && !cols[2].isEmpty() ? Integer.parseInt(cols[2]) : null);
        n.setType(cols[3]);
        n.setChannel(cols[4]);
        n.setContent(cols[5]);
        n.setStatus(cols[6]);
        n.setCreatedAt(DateUtil.parseLocalDateTime(cols[7]));
        return n;
    }

    @Override
    public List<Notifications> findByUser(int userId, String typeFilter) throws SQLException {
        List<Notifications> list = new ArrayList<>();
        boolean filterType = typeFilter != null && !typeFilter.isBlank() && !"ALL".equalsIgnoreCase(typeFilter);
        String sql = "SELECT notification_id, user_id, appointment_id, type, channel, content, status, created_at "
                + "FROM dbo.Notifications WHERE user_id = ?"
                + (filterType ? " AND type = ?" : "")
                + " ORDER BY created_at DESC, notification_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            if (filterType) {
                stmt.setString(2, typeFilter.trim().toUpperCase());
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT notification_id, user_id, appointment_id, type, channel, content, status, created_at "
                        + "FROM dbo.Notifications WHERE user_id = @p0"
                        + (filterType ? " AND type = @p1" : "")
                        + " ORDER BY created_at DESC, notification_id DESC";
                List<String[]> rows = filterType
                        ? DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(userId),
                                DBUtil.localStringParam(typeFilter.trim().toUpperCase()))
                        : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(userId));
                for (String[] cols : rows) {
                    list.add(mapLocalRow(cols));
                }
                return list;
            }
            throw e;
        }
    }

    @Override
    public int create(int userId, Integer appointmentId, String type, String channel, String content, String status)
            throws SQLException {
        String safeStatus = (status == null || status.isBlank()) ? Notifications.STATUS_SENT : status;
        String safeContent = content != null && content.length() > 500 ? content.substring(0, 500) : content;
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.CreateNotification(?,?,?,?,?,?,?)}")) {
                cs.setInt(1, userId);
                if (appointmentId != null) {
                    cs.setInt(2, appointmentId);
                } else {
                    cs.setNull(2, Types.INTEGER);
                }
                cs.setString(3, type);
                cs.setString(4, channel);
                cs.setString(5, safeContent);
                cs.setString(6, safeStatus);
                cs.registerOutParameter(7, Types.INTEGER);
                cs.execute();
                return cs.getInt(7);
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "INSERT INTO dbo.Notifications(user_id, appointment_id, type, channel, content, status) "
                            + "VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setInt(1, userId);
                        if (appointmentId != null) {
                            ps.setInt(2, appointmentId);
                        } else {
                            ps.setNull(2, Types.INTEGER);
                        }
                        ps.setString(3, type);
                        ps.setString(4, channel);
                        ps.setString(5, safeContent);
                        ps.setString(6, safeStatus);
                        ps.executeUpdate();
                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            return keys.next() ? keys.getInt(1) : 0;
                        }
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                return DBUtil.executeLocalScalarInt(
                        "DECLARE @nid INT; "
                        + "EXEC dbo.CreateNotification @user_id = @p0, @appointment_id = @p1, @type = @p2, "
                        + "@channel = @p3, @content = @p4, @status = @p5, @notification_id = @nid OUTPUT; "
                        + "SELECT @nid;",
                        DBUtil.localIntParam(userId),
                        DBUtil.localNullableIntParam(appointmentId),
                        DBUtil.localStringParam(type),
                        DBUtil.localStringParam(channel),
                        DBUtil.localStringParam(safeContent),
                        DBUtil.localStringParam(safeStatus));
            }
            throw e;
        }
    }
}
