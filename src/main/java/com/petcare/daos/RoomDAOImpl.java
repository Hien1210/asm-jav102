package com.petcare.daos;

import com.petcare.models.Rooms;
import com.petcare.utils.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomDAOImpl implements RoomDAO {

    private Rooms mapRow(ResultSet rs) throws SQLException {
        Rooms room = new Rooms();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomCode(rs.getString("room_code"));
        room.setRoomType(rs.getString("room_type"));
        room.setDailyRate(rs.getBigDecimal("daily_rate"));
        room.setStatus(rs.getString("status"));
        return room;
    }

    private Rooms mapLocalRow(String[] cols) {
        Rooms room = new Rooms();
        room.setRoomId(Integer.parseInt(cols[0]));
        room.setRoomCode(cols[1]);
        room.setRoomType(cols[2]);
        room.setDailyRate(new BigDecimal(cols[3]));
        room.setStatus(cols[4]);
        return room;
    }

    @Override
    public List<Rooms> findBookableRooms() throws SQLException {
        List<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT room_id, room_code, room_type, daily_rate, status "
                + "FROM dbo.Rooms WHERE status <> 'MAINTENANCE' ORDER BY daily_rate, room_code";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                rooms.add(mapRow(rs));
            }
            return rooms;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                for (String[] cols : DBUtil.queryLocalSql(sql)) {
                    rooms.add(mapLocalRow(cols));
                }
                return rooms;
            }
            throw e;
        }
    }

    @Override
    public List<Rooms> findAvailableRoomsForDates(LocalDate checkIn, LocalDate checkOut) throws SQLException {
        List<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_code, r.room_type, r.daily_rate, r.status "
                + "FROM dbo.Rooms r "
                + "WHERE r.status <> 'MAINTENANCE' "
                + "  AND NOT EXISTS ("
                + "      SELECT 1 FROM dbo.BoardingDetails b "
                + "      JOIN dbo.Appointments a ON a.appointment_id = b.appointment_id "
                + "      WHERE b.room_id = r.room_id "
                + "        AND a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') "
                + "        AND b.check_in_date < ? AND b.check_out_date > ?"
                + "  ) "
                + "ORDER BY r.daily_rate, r.room_code";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(checkOut));
            stmt.setDate(2, Date.valueOf(checkIn));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapRow(rs));
                }
            }
            return rooms;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT r.room_id, r.room_code, r.room_type, r.daily_rate, r.status "
                        + "FROM dbo.Rooms r "
                        + "WHERE r.status <> 'MAINTENANCE' "
                        + "  AND NOT EXISTS ("
                        + "      SELECT 1 FROM dbo.BoardingDetails b "
                        + "      JOIN dbo.Appointments a ON a.appointment_id = b.appointment_id "
                        + "      WHERE b.room_id = r.room_id "
                        + "        AND a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') "
                        + "        AND b.check_in_date < CONVERT(DATE, @p0) AND b.check_out_date > CONVERT(DATE, @p1)"
                        + "  ) "
                        + "ORDER BY r.daily_rate, r.room_code";
                for (String[] cols : DBUtil.queryLocalSql(localSql,
                        DBUtil.localLocalDateParam(checkOut), DBUtil.localLocalDateParam(checkIn))) {
                    rooms.add(mapLocalRow(cols));
                }
                return rooms;
            }
            throw e;
        }
    }

    @Override
    public Rooms findById(int roomId) throws SQLException {
        String sql = "SELECT room_id, room_code, room_type, daily_rate, status FROM dbo.Rooms WHERE room_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT room_id, room_code, room_type, daily_rate, status FROM dbo.Rooms WHERE room_id = @p0";
                List<String[]> rows = DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(roomId));
                return rows.isEmpty() ? null : mapLocalRow(rows.get(0));
            }
            throw e;
        }
    }
}
