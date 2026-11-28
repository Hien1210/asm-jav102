package com.petcare.daos;

import com.microsoft.sqlserver.jdbc.SQLServerCallableStatement;
import com.microsoft.sqlserver.jdbc.SQLServerDataTable;
import com.petcare.models.AppointmentServices;
import com.petcare.models.Appointments;
import com.petcare.models.BoardingDetails;
import com.petcare.models.Reviews;
import com.petcare.models.ServiceBookingItem;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AppointmentDAOImpl implements AppointmentDAO {

    private static final String SELECT_APPOINTMENTS_BASE =
            "SELECT a.appointment_id, a.customer_id, a.pet_id, a.appointment_type, a.combo_id, a.status, "
            + "a.cancel_reason, a.created_at, a.updated_at, a.subtotal_amount, a.combo_price_at_booking, "
            + "a.adjustment_amount, a.total_amount, "
            + "p.name AS pet_name, p.species AS pet_species, c.name AS combo_name, "
            + "ISNULL((SELECT SUM(pay.amount) FROM dbo.Payments pay WHERE pay.appointment_id = a.appointment_id "
            + "        AND pay.payment_type = 'CHARGE' AND pay.status = 'PAID'), 0) AS paid_amount, "
            + "ISNULL((SELECT SUM(pay.amount) FROM dbo.Payments pay WHERE pay.appointment_id = a.appointment_id "
            + "        AND pay.payment_type = 'CHARGE' AND pay.status = 'PENDING'), 0) AS pending_amount, "
            + "ISNULL((SELECT SUM(pay.amount) FROM dbo.Payments pay WHERE pay.appointment_id = a.appointment_id "
            + "        AND pay.payment_type = 'REFUND' AND pay.status = 'PAID'), 0) AS refunded_amount, "
            + "r.review_id, r.rating, r.comment AS review_comment, r.created_at AS review_created_at "
            + "FROM dbo.Appointments a "
            + "JOIN dbo.Pets p ON p.pet_id = a.pet_id "
            + "LEFT JOIN dbo.Combos c ON c.combo_id = a.combo_id "
            + "LEFT JOIN dbo.Reviews r ON r.appointment_id = a.appointment_id ";

    private static final String SELECT_SERVICE_LINES_BY_CUSTOMER =
            "SELECT s.appointment_id, s.service_id, s.staff_id, s.scheduled_start, s.scheduled_end, "
            + "s.price_at_booking, s.line_status, svc.name AS service_name, svc.category AS service_category, "
            + "u.full_name AS staff_name "
            + "FROM dbo.AppointmentServices s "
            + "JOIN dbo.Appointments a ON a.appointment_id = s.appointment_id "
            + "JOIN dbo.Services svc ON svc.service_id = s.service_id "
            + "JOIN dbo.Users u ON u.user_id = s.staff_id "
            + "WHERE a.customer_id = ? "
            + "ORDER BY s.appointment_id, s.scheduled_start, s.service_id";

    private static final String SELECT_BOARDING_BY_CUSTOMER =
            "SELECT b.appointment_id, b.room_id, b.check_in_date, b.check_out_date, b.daily_rate_at_booking, "
            + "b.actual_check_in, b.actual_check_out, rm.room_code, rm.room_type "
            + "FROM dbo.BoardingDetails b "
            + "JOIN dbo.Appointments a ON a.appointment_id = b.appointment_id "
            + "JOIN dbo.Rooms rm ON rm.room_id = b.room_id "
            + "WHERE a.customer_id = ?";

    @Override
    public int bookService(int customerId, int petId, int serviceId, int staffId,
                           Timestamp scheduledStart, Timestamp scheduledEnd) throws SQLException {
        List<ServiceBookingItem> items = List.of(
                new ServiceBookingItem(serviceId, staffId,
                        scheduledStart.toLocalDateTime(), scheduledEnd.toLocalDateTime()));
        return bookServices(customerId, petId, items, null);
    }

    @Override
    public int bookServices(int customerId, int petId, List<ServiceBookingItem> items, Integer comboId)
            throws SQLException {
        SQLServerDataTable tvp = new SQLServerDataTable();
        tvp.addColumnMetadata("service_id", Types.INTEGER);
        tvp.addColumnMetadata("staff_id", Types.INTEGER);
        tvp.addColumnMetadata("scheduled_start", Types.TIMESTAMP);
        tvp.addColumnMetadata("scheduled_end", Types.TIMESTAMP);
        for (ServiceBookingItem item : items) {
            tvp.addRow(item.getServiceId(), item.getStaffId(),
                    Timestamp.valueOf(item.getScheduledStart()),
                    Timestamp.valueOf(item.getScheduledEnd()));
        }

        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.BookServiceAppointment(?,?,?,?,?)}")) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, petId);
            ((SQLServerCallableStatement) stmt).setStructured(3, "dbo.ServiceBookingItems", tvp);
            if (comboId != null) {
                stmt.setInt(4, comboId);
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.execute();
            return stmt.getInt(5);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                return bookServicesLocal(customerId, petId, items, comboId);
            }
            throw e;
        }
    }

    private int bookServicesLocal(int customerId, int petId, List<ServiceBookingItem> items, Integer comboId)
            throws SQLException {
        StringBuilder sql = new StringBuilder("DECLARE @items dbo.ServiceBookingItems; ");
        List<String> params = new ArrayList<>();
        params.add(DBUtil.localIntParam(customerId));
        params.add(DBUtil.localIntParam(petId));
        params.add(DBUtil.localNullableIntParam(comboId));

        int pIdx = 3;
        for (ServiceBookingItem item : items) {
            sql.append("INSERT INTO @items(service_id, staff_id, scheduled_start, scheduled_end) VALUES (")
                    .append("@p").append(pIdx++).append(", ")
                    .append("@p").append(pIdx++).append(", ")
                    .append("CONVERT(DATETIME2, @p").append(pIdx++).append("), ")
                    .append("CONVERT(DATETIME2, @p").append(pIdx++).append(")); ");
            params.add(DBUtil.localIntParam(item.getServiceId()));
            params.add(DBUtil.localIntParam(item.getStaffId()));
            params.add(DBUtil.localLocalDateTimeParam(item.getScheduledStart()));
            params.add(DBUtil.localLocalDateTimeParam(item.getScheduledEnd()));
        }
        sql.append("DECLARE @aid INT; ")
                .append("EXEC dbo.BookServiceAppointment @customer_id = @p0, @pet_id = @p1, ")
                .append("@items = @items, @combo_id = @p2, @appointment_id = @aid OUTPUT; ")
                .append("SELECT @aid;");

        return DBUtil.executeLocalScalarInt(sql.toString(), params.toArray(new String[0]));
    }

    @Override
    public int bookBoarding(int customerId, int petId, int roomId, LocalDate checkInDate, LocalDate checkOutDate)
            throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.BookBoardingAppointment(?,?,?,?,?,?)}")) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, petId);
            stmt.setInt(3, roomId);
            stmt.setDate(4, Date.valueOf(checkInDate));
            stmt.setDate(5, Date.valueOf(checkOutDate));
            stmt.registerOutParameter(6, Types.INTEGER);
            stmt.execute();
            return stmt.getInt(6);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                return DBUtil.executeLocalScalarInt(
                        "DECLARE @aid INT, @dIn DATE = CONVERT(DATE, @p3), @dOut DATE = CONVERT(DATE, @p4); "
                        + "EXEC dbo.BookBoardingAppointment @customer_id = @p0, @pet_id = @p1, @room_id = @p2, "
                        + "@check_in_date = @dIn, @check_out_date = @dOut, "
                        + "@appointment_id = @aid OUTPUT; "
                        + "SELECT @aid;",
                        DBUtil.localIntParam(customerId),
                        DBUtil.localIntParam(petId),
                        DBUtil.localIntParam(roomId),
                        DBUtil.localLocalDateParam(checkInDate),
                        DBUtil.localLocalDateParam(checkOutDate));
            }
            throw e;
        }
    }

    @Override
    public List<Appointments> findByCustomer(int customerId, String statusFilter, String typeFilter)
            throws SQLException {
        boolean hasStatus = statusFilter != null && !statusFilter.isBlank() && !"ALL".equalsIgnoreCase(statusFilter);
        boolean hasType = typeFilter != null && !typeFilter.isBlank() && !"ALL".equalsIgnoreCase(typeFilter);

        Map<Integer, Appointments> map = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection()) {
            StringBuilder sql = new StringBuilder(SELECT_APPOINTMENTS_BASE).append("WHERE a.customer_id = ?");
            if (hasStatus) {
                sql.append(" AND a.status = ?");
            }
            if (hasType) {
                sql.append(" AND a.appointment_type = ?");
            }
            sql.append(" ORDER BY a.created_at DESC, a.appointment_id DESC");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int idx = 1;
                ps.setInt(idx++, customerId);
                if (hasStatus) {
                    ps.setString(idx++, statusFilter.trim().toUpperCase());
                }
                if (hasType) {
                    ps.setString(idx++, typeFilter.trim().toUpperCase());
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Appointments appt = mapAppointmentRow(rs);
                        map.put(appt.getAppointmentId(), appt);
                    }
                }
            }
            if (!map.isEmpty()) {
                attachServiceLinesJdbc(conn, customerId, map);
                attachBoardingDetailsJdbc(conn, customerId, map);
            }
            return new ArrayList<>(map.values());
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                return findByCustomerLocal(customerId, hasStatus ? statusFilter.trim().toUpperCase() : null,
                        hasType ? typeFilter.trim().toUpperCase() : null);
            }
            throw e;
        }
    }

    @Override
    public Appointments findDetailByIdForCustomer(int appointmentId, int customerId) throws SQLException {
        Map<Integer, Appointments> map = new LinkedHashMap<>();
        String sql = SELECT_APPOINTMENTS_BASE + "WHERE a.appointment_id = ? AND a.customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                Appointments appt = mapAppointmentRow(rs);
                map.put(appt.getAppointmentId(), appt);
            }
            attachServiceLinesJdbc(conn, customerId, map);
            attachBoardingDetailsJdbc(conn, customerId, map);
            return map.get(appointmentId);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = SELECT_APPOINTMENTS_BASE + "WHERE a.appointment_id = @p0 AND a.customer_id = @p1";
                List<String[]> rows = DBUtil.queryLocalSql(localSql,
                        DBUtil.localIntParam(appointmentId), DBUtil.localIntParam(customerId));
                if (rows.isEmpty()) {
                    return null;
                }
                Appointments appt = mapLocalAppointmentRow(rows.get(0));
                map.put(appt.getAppointmentId(), appt);
                attachDetailsLocal(customerId, map);
                return map.get(appointmentId);
            }
            throw e;
        }
    }

    @Override
    public void cancelAppointment(int appointmentId, String cancelReason) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SetAppointmentStatus(?,?,?)}")) {
            stmt.setInt(1, appointmentId);
            stmt.setString(2, Appointments.STATUS_CANCELLED);
            stmt.setString(3, cancelReason);
            stmt.execute();
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(
                        "EXEC dbo.SetAppointmentStatus @appointment_id = @p0, @status = 'CANCELLED', @cancel_reason = @p1;",
                        DBUtil.localIntParam(appointmentId),
                        DBUtil.localStringParam(cancelReason));
                return;
            }
            throw e;
        }
    }

    private List<Appointments> findByCustomerLocal(int customerId, String statusFilter, String typeFilter)
            throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_APPOINTMENTS_BASE).append("WHERE a.customer_id = @p0");
        List<String> params = new ArrayList<>();
        params.add(DBUtil.localIntParam(customerId));
        int idx = 1;
        if (statusFilter != null) {
            sql.append(" AND a.status = @p").append(idx++);
            params.add(DBUtil.localStringParam(statusFilter));
        }
        if (typeFilter != null) {
            sql.append(" AND a.appointment_type = @p").append(idx++);
            params.add(DBUtil.localStringParam(typeFilter));
        }
        sql.append(" ORDER BY a.created_at DESC, a.appointment_id DESC");

        Map<Integer, Appointments> map = new LinkedHashMap<>();
        for (String[] cols : DBUtil.queryLocalSql(sql.toString(), params.toArray(new String[0]))) {
            Appointments appt = mapLocalAppointmentRow(cols);
            map.put(appt.getAppointmentId(), appt);
        }
        if (!map.isEmpty()) {
            attachDetailsLocal(customerId, map);
        }
        return new ArrayList<>(map.values());
    }

    private void attachServiceLinesJdbc(Connection conn, int customerId, Map<Integer, Appointments> map)
            throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(SELECT_SERVICE_LINES_BY_CUSTOMER)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointments appt = map.get(rs.getInt("appointment_id"));
                    if (appt == null) {
                        continue;
                    }
                    AppointmentServices line = new AppointmentServices();
                    line.setAppointmentId(rs.getInt("appointment_id"));
                    line.setServiceId(rs.getInt("service_id"));
                    line.setStaffId(rs.getInt("staff_id"));
                    Timestamp startTs = rs.getTimestamp("scheduled_start");
                    Timestamp endTs = rs.getTimestamp("scheduled_end");
                    line.setScheduledStart(startTs != null ? startTs.toLocalDateTime() : null);
                    line.setScheduledEnd(endTs != null ? endTs.toLocalDateTime() : null);
                    line.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    line.setLineStatus(rs.getString("line_status"));
                    line.setServiceName(rs.getString("service_name"));
                    line.setServiceCategory(rs.getString("service_category"));
                    line.setStaffName(rs.getString("staff_name"));
                    appt.getServiceLines().add(line);
                }
            }
        }
    }

    private void attachBoardingDetailsJdbc(Connection conn, int customerId, Map<Integer, Appointments> map)
            throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(SELECT_BOARDING_BY_CUSTOMER)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointments appt = map.get(rs.getInt("appointment_id"));
                    if (appt == null) {
                        continue;
                    }
                    BoardingDetails detail = new BoardingDetails();
                    detail.setAppointmentId(rs.getInt("appointment_id"));
                    detail.setRoomId(rs.getInt("room_id"));
                    detail.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
                    detail.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
                    detail.setDailyRateAtBooking(rs.getBigDecimal("daily_rate_at_booking"));
                    Timestamp actualIn = rs.getTimestamp("actual_check_in");
                    Timestamp actualOut = rs.getTimestamp("actual_check_out");
                    detail.setActualCheckIn(actualIn != null ? actualIn.toLocalDateTime() : null);
                    detail.setActualCheckOut(actualOut != null ? actualOut.toLocalDateTime() : null);
                    detail.setRoomCode(rs.getString("room_code"));
                    detail.setRoomType(rs.getString("room_type"));
                    appt.setBoardingDetail(detail);
                }
            }
        }
    }

    private void attachDetailsLocal(int customerId, Map<Integer, Appointments> map) throws SQLException {
        String svcSql = SELECT_SERVICE_LINES_BY_CUSTOMER.replace("WHERE a.customer_id = ?", "WHERE a.customer_id = @p0");
        for (String[] cols : DBUtil.queryLocalSql(svcSql, DBUtil.localIntParam(customerId))) {
            int apptId = Integer.parseInt(cols[0]);
            Appointments appt = map.get(apptId);
            if (appt == null) {
                continue;
            }
            AppointmentServices line = new AppointmentServices();
            line.setAppointmentId(apptId);
            line.setServiceId(Integer.parseInt(cols[1]));
            line.setStaffId(Integer.parseInt(cols[2]));
            line.setScheduledStart(DateUtil.parseLocalDateTime(cols[3]));
            line.setScheduledEnd(DateUtil.parseLocalDateTime(cols[4]));
            line.setPriceAtBooking(new BigDecimal(cols[5]));
            line.setLineStatus(cols[6]);
            line.setServiceName(cols[7]);
            line.setServiceCategory(cols[8]);
            line.setStaffName(cols[9]);
            appt.getServiceLines().add(line);
        }

        String boardSql = SELECT_BOARDING_BY_CUSTOMER.replace("WHERE a.customer_id = ?", "WHERE a.customer_id = @p0");
        for (String[] cols : DBUtil.queryLocalSql(boardSql, DBUtil.localIntParam(customerId))) {
            int apptId = Integer.parseInt(cols[0]);
            Appointments appt = map.get(apptId);
            if (appt == null) {
                continue;
            }
            BoardingDetails detail = new BoardingDetails();
            detail.setAppointmentId(apptId);
            detail.setRoomId(Integer.parseInt(cols[1]));
            detail.setCheckInDate(DateUtil.parseLocalDate(cols[2]));
            detail.setCheckOutDate(DateUtil.parseLocalDate(cols[3]));
            detail.setDailyRateAtBooking(new BigDecimal(cols[4]));
            detail.setActualCheckIn(DateUtil.parseLocalDateTime(cols[5]));
            detail.setActualCheckOut(DateUtil.parseLocalDateTime(cols[6]));
            detail.setRoomCode(cols[7]);
            detail.setRoomType(cols[8]);
            appt.setBoardingDetail(detail);
        }
    }

    private Appointments mapAppointmentRow(ResultSet rs) throws SQLException {
        Appointments appt = new Appointments();
        appt.setAppointmentId(rs.getInt("appointment_id"));
        appt.setCustomerId(rs.getInt("customer_id"));
        appt.setPetId(rs.getInt("pet_id"));
        appt.setAppointmentType(rs.getString("appointment_type"));
        int comboId = rs.getInt("combo_id");
        appt.setComboId(rs.wasNull() ? null : comboId);
        appt.setStatus(rs.getString("status"));
        appt.setCancelReason(rs.getString("cancel_reason"));
        Timestamp created = rs.getTimestamp("created_at");
        Timestamp updated = rs.getTimestamp("updated_at");
        appt.setCreatedAt(created != null ? created.toLocalDateTime() : null);
        appt.setUpdatedAt(updated != null ? updated.toLocalDateTime() : null);
        appt.setSubtotalAmount(rs.getBigDecimal("subtotal_amount"));
        appt.setComboPriceAtBooking(rs.getBigDecimal("combo_price_at_booking"));
        appt.setAdjustmentAmount(rs.getBigDecimal("adjustment_amount"));
        appt.setTotalAmount(rs.getBigDecimal("total_amount"));
        appt.setPetName(rs.getString("pet_name"));
        appt.setPetSpecies(rs.getString("pet_species"));
        appt.setComboName(rs.getString("combo_name"));
        appt.setPaidAmount(rs.getBigDecimal("paid_amount"));
        appt.setPendingAmount(rs.getBigDecimal("pending_amount"));
        appt.setRefundedAmount(rs.getBigDecimal("refunded_amount"));

        int reviewId = rs.getInt("review_id");
        if (!rs.wasNull()) {
            Reviews review = new Reviews();
            review.setReviewId(reviewId);
            review.setAppointmentId(appt.getAppointmentId());
            review.setCustomerId(appt.getCustomerId());
            review.setRating(rs.getInt("rating"));
            review.setComment(rs.getString("review_comment"));
            Timestamp revTs = rs.getTimestamp("review_created_at");
            review.setCreatedAt(revTs != null ? revTs.toLocalDateTime() : null);
            appt.setReview(review);
        }
        return appt;
    }

    private Appointments mapLocalAppointmentRow(String[] cols) {
        Appointments appt = new Appointments();
        appt.setAppointmentId(Integer.parseInt(cols[0]));
        appt.setCustomerId(Integer.parseInt(cols[1]));
        appt.setPetId(Integer.parseInt(cols[2]));
        appt.setAppointmentType(cols[3]);
        appt.setComboId(cols[4] != null && !cols[4].isEmpty() ? Integer.parseInt(cols[4]) : null);
        appt.setStatus(cols[5]);
        appt.setCancelReason(cols[6]);
        appt.setCreatedAt(DateUtil.parseLocalDateTime(cols[7]));
        appt.setUpdatedAt(DateUtil.parseLocalDateTime(cols[8]));
        appt.setSubtotalAmount(parseDecimal(cols[9]));
        appt.setComboPriceAtBooking(cols[10] != null && !cols[10].isEmpty() ? new BigDecimal(cols[10]) : null);
        appt.setAdjustmentAmount(parseDecimal(cols[11]));
        appt.setTotalAmount(parseDecimal(cols[12]));
        appt.setPetName(cols[13]);
        appt.setPetSpecies(cols[14]);
        appt.setComboName(cols[15]);
        appt.setPaidAmount(parseDecimal(cols[16]));
        appt.setPendingAmount(parseDecimal(cols[17]));
        appt.setRefundedAmount(parseDecimal(cols[18]));
        if (cols[19] != null && !cols[19].isEmpty()) {
            Reviews review = new Reviews();
            review.setReviewId(Integer.parseInt(cols[19]));
            review.setAppointmentId(appt.getAppointmentId());
            review.setCustomerId(appt.getCustomerId());
            review.setRating(Integer.parseInt(cols[20]));
            review.setComment(cols[21]);
            review.setCreatedAt(DateUtil.parseLocalDateTime(cols[22]));
            appt.setReview(review);
        }
        return appt;
    }

    private BigDecimal parseDecimal(String raw) {
        return (raw == null || raw.isBlank()) ? BigDecimal.ZERO : new BigDecimal(raw);
    }

    @Override
    public void setStatus(int appointmentId, String status, String cancelReason) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SetAppointmentStatus(?,?,?)}")) {
            stmt.setInt(1, appointmentId);
            stmt.setString(2, status);
            if (cancelReason != null) {
                stmt.setString(3, cancelReason);
            } else {
                stmt.setNull(3, Types.NVARCHAR);
            }
            stmt.execute();
        }
    }

    @Override
    public List<AppointmentServices> findServiceLinesByStaff(int staffId, LocalDate fromDate, LocalDate toDate)
            throws SQLException {
        List<AppointmentServices> lines = new ArrayList<>();
        String sql = "SELECT s.appointment_id, s.service_id, s.staff_id, s.scheduled_start, s.scheduled_end, "
                + "s.price_at_booking, s.line_status, svc.name AS service_name, svc.category AS service_category, "
                + "u.full_name AS staff_name, a.status AS appointment_status, "
                + "cust.full_name AS customer_name, cust.phone AS customer_phone, p.name AS pet_name, p.species AS pet_species,p.breed AS pet_breed,p.medical_notes "
                + "FROM dbo.AppointmentServices s "
                + "JOIN dbo.Appointments a ON a.appointment_id = s.appointment_id "
                + "JOIN dbo.Services svc ON svc.service_id = s.service_id "
                + "JOIN dbo.Users u ON u.user_id = s.staff_id "
                + "JOIN dbo.Users cust ON cust.user_id = a.customer_id "
                + "JOIN dbo.Pets p ON p.pet_id = a.pet_id "
                + "WHERE s.staff_id = ? AND CAST(s.scheduled_start AS DATE) BETWEEN ? AND ? "
                + "ORDER BY s.scheduled_start";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setDate(2, Date.valueOf(fromDate));
            ps.setDate(3, Date.valueOf(toDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AppointmentServices line = new AppointmentServices();
                    line.setAppointmentId(rs.getInt("appointment_id"));
                    line.setServiceId(rs.getInt("service_id"));
                    line.setStaffId(rs.getInt("staff_id"));
                    Timestamp startTs = rs.getTimestamp("scheduled_start");
                    Timestamp endTs = rs.getTimestamp("scheduled_end");
                    line.setScheduledStart(startTs != null ? startTs.toLocalDateTime() : null);
                    line.setScheduledEnd(endTs != null ? endTs.toLocalDateTime() : null);
                    line.setPriceAtBooking(rs.getBigDecimal("price_at_booking"));
                    line.setLineStatus(rs.getString("line_status"));
                    line.setServiceName(rs.getString("service_name"));
                    line.setServiceCategory(rs.getString("service_category"));
                    line.setStaffName(rs.getString("staff_name"));
                    line.setAppointmentStatus(rs.getString("appointment_status"));
                    line.setCustomerName(rs.getString("customer_name"));
                    line.setCustomerPhone(rs.getString("customer_phone"));
                    line.setPetName(rs.getString("pet_name"));
                    line.setPetSpecies(rs.getString("pet_species"));
                    line.setPetBreed(rs.getString("pet_breed"));
                    line.setMedicalNotes(rs.getString("medical_notes"));
                    lines.add(line);
                }
            }
        }
        return lines;
    }

    @Override
    public boolean isSoleStaffOnAppointment(int appointmentId, int staffId) throws SQLException {
        String sql = "SELECT COUNT(CASE WHEN staff_id = ? THEN 1 END) AS mine, "
                + "COUNT(CASE WHEN staff_id <> ? THEN 1 END) AS others "
                + "FROM dbo.AppointmentServices WHERE appointment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setInt(2, staffId);
            ps.setInt(3, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                return rs.getInt("mine") > 0 && rs.getInt("others") == 0;
            }
        }
    }
}
