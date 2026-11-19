package com.petcare.services;

import com.petcare.daos.AppointmentDAO;
import com.petcare.daos.AppointmentDAOImpl;
import com.petcare.daos.ComboDAO;
import com.petcare.daos.ComboDAOImpl;
import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.daos.RoomDAO;
import com.petcare.daos.RoomDAOImpl;
import com.petcare.daos.ServiceDAO;
import com.petcare.daos.ServiceDAOImpl;
import com.petcare.models.Appointments;
import com.petcare.models.Combos;
import com.petcare.models.Pets;
import com.petcare.models.Rooms;
import com.petcare.models.ServiceBookingItem;
import com.petcare.models.Services;
import com.petcare.utils.DateUtil;
import com.petcare.utils.ValidationUtil;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class BookingService {

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang xử lý booking khác, vui lòng thử lại.");
        FRIENDLY_ERRORS.put(51008, "Tài khoản của bạn hiện không hoạt động.");
        FRIENDLY_ERRORS.put(51009, "Khung giờ chọn không nằm trong ca làm việc hoặc giờ mở cửa của cơ sở.");
        FRIENDLY_ERRORS.put(51010, "Nhân viên hoặc thú cưng đã có lịch hẹn trùng giờ này.");
        FRIENDLY_ERRORS.put(51011, "Phòng lưu trú này đang bảo trì, vui lòng chọn phòng khác.");
        FRIENDLY_ERRORS.put(51012, "Phòng hoặc thú cưng đã có lịch lưu trú trùng khoảng ngày này.");
        FRIENDLY_ERRORS.put(51013, "Thú cưng đang có lịch dịch vụ trùng với khoảng ngày lưu trú.");
        FRIENDLY_ERRORS.put(51022, "Trạng thái lịch hẹn hiện tại không thể chuyển sang trạng thái yêu cầu.");
        FRIENDLY_ERRORS.put(51023, "Danh sách dịch vụ đặt không khớp với gói combo đã chọn.");
        FRIENDLY_ERRORS.put(51030, "Vui lòng chọn từ 1 đến 100 dịch vụ khác nhau.");
        FRIENDLY_ERRORS.put(51031, "Thú cưng không thuộc tài khoản của bạn hoặc tài khoản đã bị khóa.");
        FRIENDLY_ERRORS.put(51032, "Dịch vụ hoặc nhân viên thực hiện không hợp lệ.");
        FRIENDLY_ERRORS.put(51033, "Gói combo không tồn tại hoặc đã ngừng áp dụng.");
        FRIENDLY_ERRORS.put(51034, "Ngày trả phòng phải sau ngày nhận phòng.");
        FRIENDLY_ERRORS.put(51035, "Phòng không tồn tại hoặc đang bảo trì.");
        FRIENDLY_ERRORS.put(51036, "Lịch hẹn không tồn tại.");
        FRIENDLY_ERRORS.put(51037, "Vui lòng nhập lý do hủy lịch hẹn.");
    }

    private final PetDAO petDAO;
    private final ServiceDAO serviceDAO;
    private final ComboDAO comboDAO;
    private final RoomDAO roomDAO;
    private final AppointmentDAO appointmentDAO;

    public BookingService() {
        this(new PetDAOImpl(), new ServiceDAOImpl(), new ComboDAOImpl(), new RoomDAOImpl(), new AppointmentDAOImpl());
    }

    public BookingService(PetDAO petDAO, ServiceDAO serviceDAO, ComboDAO comboDAO,
                          RoomDAO roomDAO, AppointmentDAO appointmentDAO) {
        this.petDAO = petDAO;
        this.serviceDAO = serviceDAO;
        this.comboDAO = comboDAO;
        this.roomDAO = roomDAO;
        this.appointmentDAO = appointmentDAO;
    }

    /** Books one service for one pet with one staff member at the given start time. */
    public int bookService(int customerId, int petId, int serviceId, int staffId, LocalDateTime start)
            throws SQLException {
        verifyOwnedPet(customerId, petId);
        Services service = verifyBookableService(serviceId);
        if (start == null || start.isBefore(DateUtil.nowVn())) {
            throw new IllegalArgumentException("Thời gian đặt lịch phải ở trong tương lai.");
        }

        LocalDateTime end = start.plusMinutes(service.getDurationMinutes());
        try {
            return appointmentDAO.bookService(customerId, petId, serviceId, staffId,
                    Timestamp.valueOf(start), Timestamp.valueOf(end));
        } catch (SQLException e) {
            throw translate(e, "Không thể đặt lịch. Vui lòng kiểm tra lại thông tin và thử lại.");
        }
    }

    /** Books 1..100 distinct services in one SERVICE appointment. */
    public int bookMultipleServices(int customerId, int petId, List<ServiceBookingItem> rawItems) throws SQLException {
        verifyOwnedPet(customerId, petId);
        if (rawItems == null || rawItems.isEmpty() || rawItems.size() > 100) {
            throw new IllegalArgumentException("Vui lòng chọn từ 1 đến 100 dịch vụ khác nhau.");
        }
        LocalDateTime now = DateUtil.nowVn();
        Set<Integer> seenServiceIds = new HashSet<>();
        List<ServiceBookingItem> resolved = new ArrayList<>();

        for (ServiceBookingItem raw : rawItems) {
            if (!seenServiceIds.add(raw.getServiceId())) {
                throw new IllegalArgumentException("Không được chọn trùng cùng một dịch vụ trong một lịch hẹn.");
            }
            Services service = verifyBookableService(raw.getServiceId());
            if (raw.getScheduledStart() == null || raw.getScheduledStart().isBefore(now)) {
                throw new IllegalArgumentException("Thời gian đặt lịch cho mọi dịch vụ phải ở trong tương lai.");
            }
            LocalDateTime end = raw.getScheduledStart().plusMinutes(service.getDurationMinutes());
            resolved.add(new ServiceBookingItem(raw.getServiceId(), raw.getStaffId(), raw.getScheduledStart(), end));
        }

        validateNoPetOverlap(resolved);

        try {
            return appointmentDAO.bookServices(customerId, petId, resolved, null);
        } catch (SQLException e) {
            throw translate(e, "Không thể đặt lịch nhiều dịch vụ. Vui lòng kiểm tra khung giờ và thử lại.");
        }
    }

    /**
     * Books an active Combo: automatically chains its services sequentially from {@code startTime}
     * (matching exact duration_minutes per service and preventing pet overlap) using the chosen staff per service.
     */
    public int bookCombo(int customerId, int petId, int comboId,
                         LocalDateTime startTime, Map<Integer, Integer> staffByServiceId) throws SQLException {
        verifyOwnedPet(customerId, petId);
        if (startTime == null || startTime.isBefore(DateUtil.nowVn())) {
            throw new IllegalArgumentException("Thời gian bắt đầu combo phải ở trong tương lai.");
        }
        Combos combo = comboDAO.findByIdWithServices(comboId);
        if (combo == null || !combo.isActive() || combo.getServices().isEmpty()) {
            throw new IllegalArgumentException("Gói combo không tồn tại hoặc đã ngừng áp dụng.");
        }

        List<ServiceBookingItem> items = new ArrayList<>();
        LocalDateTime cursor = startTime;
        for (Services svc : combo.getServices()) {
            if (!svc.isActive() || Appointments.TYPE_BOARDING.equalsIgnoreCase(svc.getCategory())) {
                throw new IllegalArgumentException("Dịch vụ trong gói combo hiện không khả dụng.");
            }
            Integer staffId = staffByServiceId != null ? staffByServiceId.get(svc.getServiceId()) : null;
            if (staffId == null || staffId <= 0) {
                throw new IllegalArgumentException("Vui lòng chọn nhân viên cho dịch vụ \"" + svc.getName() + "\".");
            }
            LocalDateTime end = cursor.plusMinutes(svc.getDurationMinutes());
            if (!cursor.toLocalDate().equals(end.toLocalDate())) {
                throw new IllegalArgumentException("Các dịch vụ trong combo phải kết thúc trong cùng một ngày.");
            }
            items.add(new ServiceBookingItem(svc.getServiceId(), staffId, cursor, end));
            cursor = end;
        }

        try {
            return appointmentDAO.bookServices(customerId, petId, items, comboId);
        } catch (SQLException e) {
            throw translate(e, "Không thể đặt gói combo. Vui lòng kiểm tra ca làm việc và thử lại.");
        }
    }

    /** Books a boarding room for one pet via dbo.BookBoardingAppointment. */
    public int bookBoarding(int customerId, int petId, int roomId, LocalDate checkIn, LocalDate checkOut)
            throws SQLException {
        verifyOwnedPet(customerId, petId);
        if (checkIn == null || checkOut == null) {
            throw new IllegalArgumentException("Vui lòng chọn ngày nhận phòng và ngày trả phòng.");
        }
        if (checkIn.isBefore(DateUtil.todayVn())) {
            throw new IllegalArgumentException("Ngày nhận phòng không được ở trong quá khứ.");
        }
        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("Ngày trả phòng phải sau ngày nhận phòng ít nhất 1 ngày.");
        }
        Rooms room = roomDAO.findById(roomId);
        if (room == null || Rooms.STATUS_MAINTENANCE.equalsIgnoreCase(room.getStatus())) {
            throw new IllegalArgumentException("Phòng không tồn tại hoặc đang bảo trì.");
        }

        try {
            return appointmentDAO.bookBoarding(customerId, petId, roomId, checkIn, checkOut);
        } catch (SQLException e) {
            throw translate(e, "Không thể đặt phòng lưu trú. Vui lòng kiểm tra lịch phòng và thử lại.");
        }
    }

    /** Cancels a PENDING or CONFIRMED appointment owned by customerId with a required reason. */
    public void cancelByCustomer(int customerId, int appointmentId, String cancelReason) throws SQLException {
        String cleanReason = cancelReason == null ? "" : cancelReason.trim();
        if (ValidationUtil.isBlank(cleanReason)) {
            throw new IllegalArgumentException("Vui lòng nhập lý do hủy lịch hẹn.");
        }
        if (cleanReason.length() > 255) {
            throw new IllegalArgumentException("Lý do hủy tối đa 255 ký tự.");
        }

        Appointments appt = appointmentDAO.findDetailByIdForCustomer(appointmentId, customerId);
        if (appt == null) {
            throw new IllegalArgumentException("Lịch hẹn không tồn tại hoặc không thuộc tài khoản của bạn.");
        }
        if (!appt.isCancellable()) {
            throw new IllegalArgumentException(
                    "Chỉ có thể hủy lịch hẹn đang ở trạng thái Chờ xác nhận hoặc Đã xác nhận.");
        }

        try {
            appointmentDAO.cancelAppointment(appointmentId, cleanReason);
        } catch (SQLException e) {
            throw translate(e, "Không thể hủy lịch hẹn lúc này. Vui lòng thử lại.");
        }
    }

    public List<Appointments> listCustomerAppointments(int customerId, String statusFilter, String typeFilter)
            throws SQLException {
        return appointmentDAO.findByCustomer(customerId, statusFilter, typeFilter);
    }

    private Pets verifyOwnedPet(int customerId, int petId) throws SQLException {
        Pets pet = petDAO.findById(petId);
        if (pet == null || pet.getOwnerId() == null || pet.getOwnerId() != customerId) {
            throw new IllegalArgumentException("Thú cưng không thuộc tài khoản của bạn.");
        }
        return pet;
    }

    private Services verifyBookableService(int serviceId) throws SQLException {
        Services service = serviceDAO.findById(serviceId);
        if (service == null || !service.isActive()
                || Appointments.TYPE_BOARDING.equalsIgnoreCase(service.getCategory())) {
            throw new IllegalArgumentException("Dịch vụ không tồn tại hoặc đã ngừng hoạt động.");
        }
        return service;
    }

    private void validateNoPetOverlap(List<ServiceBookingItem> items) {
        for (int i = 0; i < items.size(); i++) {
            ServiceBookingItem a = items.get(i);
            for (int j = i + 1; j < items.size(); j++) {
                ServiceBookingItem b = items.get(j);
                if (a.getScheduledStart().isBefore(b.getScheduledEnd())
                        && b.getScheduledStart().isBefore(a.getScheduledEnd())) {
                    throw new IllegalArgumentException(
                            "Các dịch vụ cho cùng một thú cưng không được trùng khung giờ với nhau.");
                }
            }
        }
    }

    private SQLException translate(SQLException e, String fallback) {
        return new SQLException(FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(), fallback),
                e.getSQLState(), e.getErrorCode(), e);
    }
}
