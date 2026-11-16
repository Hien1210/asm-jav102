package com.petcare.services;

import com.petcare.daos.AppointmentDAO;
import com.petcare.daos.AppointmentDAOImpl;
import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.daos.ServiceDAO;
import com.petcare.daos.ServiceDAOImpl;
import com.petcare.models.Pets;
import com.petcare.models.Services;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

public class BookingService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang xử lý booking khác, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51031, "Thú cưng không thuộc tài khoản của bạn hoặc tài khoản đã bị khóa.");
        FRIENDLY_ERRORS.put(51032, "Dịch vụ hoặc nhân viên không hợp lệ.");
        FRIENDLY_ERRORS.put(51009, "Khung giờ chọn không nằm trong ca làm việc hoặc giờ mở cửa của cơ sở.");
        FRIENDLY_ERRORS.put(51010, "Nhân viên hoặc thú cưng đã có lịch hẹn trùng giờ này.");
        FRIENDLY_ERRORS.put(51008, "Tài khoản của bạn hiện không hoạt động.");
    }

    private final PetDAO petDAO;
    private final ServiceDAO serviceDAO;
    private final AppointmentDAO appointmentDAO;

    public BookingService() {
        this.petDAO = new PetDAOImpl();
        this.serviceDAO = new ServiceDAOImpl();
        this.appointmentDAO = new AppointmentDAOImpl();
    }

    /** Books one service for one pet with one staff member at the given start time. */
    public int bookService(int customerId, int petId, int serviceId, int staffId, LocalDateTime start)
            throws SQLException {
        Pets pet = petDAO.findById(petId);
        if (pet == null || pet.getOwnerId() == null || pet.getOwnerId() != customerId) {
            throw new IllegalArgumentException("Thú cưng không thuộc tài khoản của bạn.");
        }
        Services service = serviceDAO.findById(serviceId);
        if (service == null || !service.isActive()) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại hoặc đã ngừng hoạt động.");
        }

        LocalDateTime end = start.plusMinutes(service.getDurationMinutes());
        try {
            return appointmentDAO.bookService(customerId, petId, serviceId, staffId,
                    Timestamp.valueOf(start), Timestamp.valueOf(end));
        } catch (SQLException e) {
            throw new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(),
                    "Không thể đặt lịch. Vui lòng kiểm tra lại thông tin và thử lại."), e.getSQLState(), e);
        }
    }
}
