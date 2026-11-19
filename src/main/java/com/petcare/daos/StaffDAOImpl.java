package com.petcare.daos;

import com.petcare.models.Shifts;
import com.petcare.models.StaffOption;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public List<StaffOption> findActiveStaffForService(int serviceId) throws SQLException {
        List<StaffOption> staff = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement stmt = conn.prepareCall("{call dbo.ListActiveStaffForService(?)}")) {
                stmt.setInt(1, serviceId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        staff.add(new StaffOption(rs.getInt("user_id"), rs.getString("full_name")));
                    }
                }
                return staff;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "SELECT u.user_id, u.full_name FROM dbo.Users u "
                            + "JOIN dbo.StaffSkills sk ON sk.staff_id = u.user_id "
                            + "WHERE sk.service_id = ? AND u.role = 'STAFF' AND u.is_active = 1 "
                            + "ORDER BY u.full_name";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, serviceId);
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                staff.add(new StaffOption(rs.getInt("user_id"), rs.getString("full_name")));
                            }
                        }
                    }
                    return staff;
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                for (String[] cols : DBUtil.queryLocalSql(
                        "EXEC dbo.ListActiveStaffForService @service_id = @p0",
                        DBUtil.localIntParam(serviceId))) {
                    staff.add(new StaffOption(Integer.parseInt(cols[0]), cols[1]));
                }
                return staff;
            }
            throw e;
        }
    }

    @Override
    public List<Shifts> findUpcomingShifts(LocalDate fromDate, LocalDate toDate) throws SQLException {
        List<Shifts> shifts = new ArrayList<>();
        String sql = "SELECT sh.shift_id, sh.staff_id, u.full_name, sh.work_date, sh.start_time, sh.end_time "
                + "FROM dbo.Shifts sh "
                + "JOIN dbo.Users u ON u.user_id = sh.staff_id "
                + "WHERE u.role = 'STAFF' AND u.is_active = 1 AND sh.work_date BETWEEN ? AND ? "
                + "ORDER BY sh.work_date, sh.start_time, u.full_name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(fromDate));
            stmt.setDate(2, Date.valueOf(toDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Shifts shift = new Shifts();
                    shift.setShiftId(rs.getInt("shift_id"));
                    shift.setStaffId(rs.getInt("staff_id"));
                    shift.setStaffName(rs.getString("full_name"));
                    shift.setWorkDate(rs.getDate("work_date").toLocalDate());
                    shift.setStartTime(rs.getTime("start_time").toLocalTime());
                    shift.setEndTime(rs.getTime("end_time").toLocalTime());
                    shifts.add(shift);
                }
            }
            return shifts;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT sh.shift_id, sh.staff_id, u.full_name, sh.work_date, sh.start_time, sh.end_time "
                        + "FROM dbo.Shifts sh "
                        + "JOIN dbo.Users u ON u.user_id = sh.staff_id "
                        + "WHERE u.role = 'STAFF' AND u.is_active = 1 AND sh.work_date BETWEEN CONVERT(DATE, @p0) AND CONVERT(DATE, @p1) "
                        + "ORDER BY sh.work_date, sh.start_time, u.full_name";
                for (String[] cols : DBUtil.queryLocalSql(localSql,
                        DBUtil.localLocalDateParam(fromDate), DBUtil.localLocalDateParam(toDate))) {
                    Shifts shift = new Shifts();
                    shift.setShiftId(Integer.parseInt(cols[0]));
                    shift.setStaffId(Integer.parseInt(cols[1]));
                    shift.setStaffName(cols[2]);
                    shift.setWorkDate(DateUtil.parseLocalDate(cols[3]));
                    shift.setStartTime(DateUtil.parseLocalTime(cols[4]));
                    shift.setEndTime(DateUtil.parseLocalTime(cols[5]));
                    shifts.add(shift);
                }
                return shifts;
            }
            // If SELECT on dbo.Shifts is denied on an older remote DB, return empty list gracefully.
            if (e.getErrorCode() == 229) {
                return shifts;
            }
            throw e;
        }
    }

    @Override
    public List<Shifts> findShiftsForStaff(int staffId, LocalDate fromDate, LocalDate toDate) throws SQLException {
        List<Shifts> shifts = new ArrayList<>();
        String sql = "SELECT sh.shift_id, sh.staff_id, u.full_name, sh.work_date, sh.start_time, sh.end_time "
                + "FROM dbo.Shifts sh "
                + "JOIN dbo.Users u ON u.user_id = sh.staff_id "
                + "WHERE sh.staff_id = ? AND sh.work_date BETWEEN ? AND ? "
                + "ORDER BY sh.work_date, sh.start_time";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setDate(2, Date.valueOf(fromDate));
            stmt.setDate(3, Date.valueOf(toDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Shifts shift = new Shifts();
                    shift.setShiftId(rs.getInt("shift_id"));
                    shift.setStaffId(rs.getInt("staff_id"));
                    shift.setStaffName(rs.getString("full_name"));
                    shift.setWorkDate(rs.getDate("work_date").toLocalDate());
                    shift.setStartTime(rs.getTime("start_time").toLocalTime());
                    shift.setEndTime(rs.getTime("end_time").toLocalTime());
                    shifts.add(shift);
                }
            }
            return shifts;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT sh.shift_id, sh.staff_id, u.full_name, sh.work_date, sh.start_time, sh.end_time "
                        + "FROM dbo.Shifts sh "
                        + "JOIN dbo.Users u ON u.user_id = sh.staff_id "
                        + "WHERE sh.staff_id = @p0 AND sh.work_date BETWEEN CONVERT(DATE, @p1) AND CONVERT(DATE, @p2) "
                        + "ORDER BY sh.work_date, sh.start_time";
                for (String[] cols : DBUtil.queryLocalSql(localSql,
                        DBUtil.localIntParam(staffId), DBUtil.localLocalDateParam(fromDate),
                        DBUtil.localLocalDateParam(toDate))) {
                    Shifts shift = new Shifts();
                    shift.setShiftId(Integer.parseInt(cols[0]));
                    shift.setStaffId(Integer.parseInt(cols[1]));
                    shift.setStaffName(cols[2]);
                    shift.setWorkDate(DateUtil.parseLocalDate(cols[3]));
                    shift.setStartTime(DateUtil.parseLocalTime(cols[4]));
                    shift.setEndTime(DateUtil.parseLocalTime(cols[5]));
                    shifts.add(shift);
                }
                return shifts;
            }
            if (e.getErrorCode() == 229) {
                return shifts;
            }
            throw e;
        }
    }
}
