package com.petcare.services;

import com.petcare.daos.AppointmentDAO;
import com.petcare.daos.AppointmentDAOImpl;
import com.petcare.daos.StaffDAO;
import com.petcare.daos.StaffDAOImpl;
import com.petcare.models.AppointmentServices;
import com.petcare.models.Appointments;
import com.petcare.models.Shifts;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Lịch làm việc (ca) và lịch hẹn được giao cho một nhân viên cụ thể. */
public class StaffScheduleService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51022, "Trạng thái lịch hẹn hiện tại không thể chuyển sang trạng thái yêu cầu.");
        FRIENDLY_ERRORS.put(51036, "Lịch hẹn không tồn tại.");
    }

    private final StaffDAO staffDAO;
    private final AppointmentDAO appointmentDAO;

    public StaffScheduleService() {
        this.staffDAO = new StaffDAOImpl();
        this.appointmentDAO = new AppointmentDAOImpl();
    }

    /** The staff member's own shifts within [fromDate, toDate]. */
    public List<Shifts> getMyShifts(int staffId, LocalDate fromDate, LocalDate toDate) throws SQLException {
        return staffDAO.findShiftsForStaff(staffId, fromDate, toDate);
    }

    /** The staff member's assigned service lines within [fromDate, toDate]. */
    public List<AppointmentServices> getMyAppointments(int staffId, LocalDate fromDate, LocalDate toDate)
            throws SQLException {
        return appointmentDAO.findServiceLinesByStaff(staffId, fromDate, toDate);
    }

    /**
     * Staff tự chuyển trạng thái lịch hẹn (check-in / bắt đầu / hoàn thành) khi mình là nhân viên
     * duy nhất thực hiện lịch hẹn đó. Nếu lịch hẹn có nhiều nhân viên khác cùng tham gia (gói
     * combo), yêu cầu đổi trạng thái ở nơi khác (ví dụ quản trị viên) để tránh một nhân viên tự ý
     * đổi trạng thái ảnh hưởng tới phần việc của người khác.
     */
    public void advanceStatus(int staffId, int appointmentId, String newStatus) throws SQLException {
        if (!Appointments.STATUS_CHECKED_IN.equals(newStatus)
                && !Appointments.STATUS_IN_PROGRESS.equals(newStatus)
                && !Appointments.STATUS_COMPLETED.equals(newStatus)) {
            throw new IllegalArgumentException("Hành động không hợp lệ.");
        }
        if (!appointmentDAO.isSoleStaffOnAppointment(appointmentId, staffId)) {
            throw new IllegalArgumentException(
                    "Lịch hẹn này không thuộc riêng bạn hoặc có nhân viên khác cùng thực hiện.");
        }
        try {
            appointmentDAO.setStatus(appointmentId, newStatus, null);
        } catch (SQLException e) {
            throw new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(),
                    "Không thể cập nhật trạng thái lịch hẹn. Vui lòng thử lại."), e.getSQLState(), e);
        }
    }
}
