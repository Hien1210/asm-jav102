package com.petcare.controllers;

import com.petcare.daos.BusinessHoursDAO;
import com.petcare.daos.BusinessHoursDAOImpl;
import com.petcare.daos.ComboDAO;
import com.petcare.daos.ComboDAOImpl;
import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.daos.RoomDAO;
import com.petcare.daos.RoomDAOImpl;
import com.petcare.daos.ServiceDAO;
import com.petcare.daos.ServiceDAOImpl;
import com.petcare.daos.StaffDAO;
import com.petcare.daos.StaffDAOImpl;
import com.petcare.models.Combos;
import com.petcare.models.Notifications;
import com.petcare.models.Pets;
import com.petcare.models.ServiceBookingItem;
import com.petcare.models.Services;
import com.petcare.models.StaffOption;
import com.petcare.models.Users;
import com.petcare.services.BookingService;
import com.petcare.services.NotificationService;
import com.petcare.services.PetService;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import com.petcare.websocket.NotificationEndpoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DatLichServlet", urlPatterns = {"/customer/dat-lich"})
public class DatLichServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PetDAO petDAO = new PetDAOImpl();
    private final PetService petService = new PetService();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();
    private final ComboDAO comboDAO = new ComboDAOImpl();
    private final RoomDAO roomDAO = new RoomDAOImpl();
    private final BusinessHoursDAO businessHoursDAO = new BusinessHoursDAOImpl();
    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }
        String tab = trim(request.getParameter("tab"));
        if (!tab.equals("combo") && !tab.equals("boarding") && !tab.equals("multi")) {
            tab = "service";
        }
        request.setAttribute("activeTab", tab);
        request.setAttribute("preselectedPetId", trim(request.getParameter("petId")));
        request.setAttribute("preselectedComboId", trim(request.getParameter("comboId")));
        request.setAttribute("preselectedRoomId", trim(request.getParameter("roomId")));

        loadFormData(request);
        request.getRequestDispatcher("/customer/datLich.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        String activeTab = "service";

        try {
            if ("addPet".equals(action)) {
                handleAddPet(request, customerId);
            } else if ("book".equals(action)) {
                activeTab = "service";
                handleSingleServiceBooking(request, customerId);
            } else if ("bookMulti".equals(action)) {
                activeTab = "multi";
                handleMultiServiceBooking(request, customerId);
            } else if ("bookCombo".equals(action)) {
                activeTab = "combo";
                handleComboBooking(request, customerId);
            } else if ("bookBoarding".equals(action)) {
                activeTab = "boarding";
                handleBoardingBooking(request, customerId);
            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        request.setAttribute("activeTab", activeTab);
        loadFormData(request);
        request.getRequestDispatcher("/customer/datLich.jsp").forward(request, response);
    }

    private boolean requireCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_CUSTOMER)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private void loadFormData(HttpServletRequest request) {
        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        LocalDate today = DateUtil.todayVn();
        request.setAttribute("activeCustomerNav", "booking");
        request.setAttribute("todayIso", today.toString());
        request.setAttribute("tomorrowIso", today.plusDays(1).toString());
        request.setAttribute("dayAfterTomorrowIso", today.plusDays(2).toString());

        try {
            request.setAttribute("pets", petDAO.findByOwner(customerId));

            List<Services> services = serviceDAO.findActiveBookable();
            Map<Services, List<StaffOption>> staffByService = new LinkedHashMap<>();
            Map<Integer, List<StaffOption>> staffByServiceId = new LinkedHashMap<>();
            for (Services service : services) {
                List<StaffOption> staffList = staffDAO.findActiveStaffForService(service.getServiceId());
                staffByService.put(service, staffList);
                staffByServiceId.put(service.getServiceId(), staffList);
            }
            request.setAttribute("servicesList", services);
            request.setAttribute("staffByService", staffByService);
            request.setAttribute("staffByServiceId", staffByServiceId);

            List<Combos> combos = comboDAO.findActiveWithServices();
            request.setAttribute("combos", combos);

            request.setAttribute("rooms", roomDAO.findBookableRooms());
            request.setAttribute("businessHours", businessHoursDAO.findAll());
            request.setAttribute("upcomingShifts", staffDAO.findUpcomingShifts(today, today.plusDays(6)));
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được dữ liệu đặt lịch. Vui lòng thử lại.");
        }
    }

    private void handleAddPet(HttpServletRequest request, int customerId) throws SQLException {
        String name = trim(request.getParameter("petName"));
        String species = trim(request.getParameter("petSpecies"));
        String breed = trim(request.getParameter("petBreed"));
        String weightParam = trim(request.getParameter("petWeight"));
        String birthParam = trim(request.getParameter("petBirthDate"));
        String notes = trim(request.getParameter("petMedicalNotes"));

        if (ValidationUtil.isBlank(name) || ValidationUtil.isBlank(species)
                || name.length() > 100 || species.length() > 50 || breed.length() > 100) {
            throw new IllegalArgumentException("Vui lòng nhập tên và loài thú cưng.");
        }

        BigDecimal weight = null;
        if (!weightParam.isEmpty()) {
            try {
                weight = new BigDecimal(weightParam.replace(',', '.'));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Cân nặng thú cưng không hợp lệ.");
            }
        }
        LocalDate birthDate = null;
        if (!birthParam.isEmpty()) {
            try {
                birthDate = LocalDate.parse(birthParam);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Ngày sinh thú cưng không hợp lệ.");
            }
        }

        petService.createPet(customerId, name, species, breed, weight, birthDate, notes);
        request.setAttribute("successMessage", "Đã thêm thú cưng \"" + name + "\".");
    }

    private void handleSingleServiceBooking(HttpServletRequest request, int customerId) throws SQLException {
        String petIdParam = request.getParameter("petId");
        String staffChoice = request.getParameter("staffChoice");
        String dateParam = request.getParameter("bookingDate");
        String timeParam = request.getParameter("bookingTime");

        if (ValidationUtil.isBlank(petIdParam) || ValidationUtil.isBlank(staffChoice)
                || ValidationUtil.isBlank(dateParam) || ValidationUtil.isBlank(timeParam)) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ thú cưng, dịch vụ/nhân viên, ngày và giờ.");
        }

        String[] parts = staffChoice.split("_");
        if (parts.length != 2) {
            throw new IllegalArgumentException("Lựa chọn dịch vụ/nhân viên không hợp lệ.");
        }

        int petId;
        int serviceId;
        int staffId;
        LocalDateTime start;
        try {
            petId = Integer.parseInt(petIdParam.trim());
            serviceId = Integer.parseInt(parts[0].trim());
            staffId = Integer.parseInt(parts[1].trim());
            start = LocalDateTime.of(LocalDate.parse(dateParam.trim()), LocalTime.parse(timeParam.trim()));
        } catch (NumberFormatException | DateTimeParseException e) {
            throw new IllegalArgumentException("Thông tin đặt lịch không hợp lệ.");
        }

        if (start.isBefore(DateUtil.nowVn())) {
            throw new IllegalArgumentException("Thời gian đặt lịch phải ở trong tương lai.");
        }

        int appointmentId = bookingService.bookService(customerId, petId, serviceId, staffId, start);
        recordBookingSuccess(request, customerId, appointmentId,
                "Đặt lịch thành công! Mã lịch hẹn của bạn là #" + appointmentId + ".");
    }

    private void handleMultiServiceBooking(HttpServletRequest request, int customerId) throws SQLException {
        String petIdParam = request.getParameter("petId");
        String[] staffChoices = request.getParameterValues("multiStaffChoice");
        String[] dates = request.getParameterValues("multiDate");
        String[] times = request.getParameterValues("multiTime");

        if (ValidationUtil.isBlank(petIdParam) || staffChoices == null || dates == null || times == null
                || staffChoices.length == 0
                || staffChoices.length != dates.length
                || staffChoices.length != times.length) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ thú cưng và thông tin từng dịch vụ.");
        }

        int petId;
        try {
            petId = Integer.parseInt(petIdParam.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Mã thú cưng không hợp lệ.");
        }

        List<ServiceBookingItem> items = new ArrayList<>();
        for (int i = 0; i < staffChoices.length; i++) {
            String choice = trim(staffChoices[i]);
            String d = trim(dates[i]);
            String t = trim(times[i]);
            if (choice.isEmpty() || d.isEmpty() || t.isEmpty()) {
                throw new IllegalArgumentException("Vui lòng điền đủ dịch vụ/nhân viên, ngày và giờ cho dòng #" + (i + 1) + ".");
            }
            String[] parts = choice.split("_");
            if (parts.length != 2) {
                throw new IllegalArgumentException("Lựa chọn dịch vụ/nhân viên ở dòng #" + (i + 1) + " không hợp lệ.");
            }
            try {
                int serviceId = Integer.parseInt(parts[0].trim());
                int staffId = Integer.parseInt(parts[1].trim());
                LocalDateTime start = LocalDateTime.of(LocalDate.parse(d), LocalTime.parse(t));
                items.add(new ServiceBookingItem(serviceId, staffId, start));
            } catch (NumberFormatException | DateTimeParseException e) {
                throw new IllegalArgumentException("Thời gian hoặc dịch vụ ở dòng #" + (i + 1) + " không hợp lệ.");
            }
        }

        int appointmentId = bookingService.bookMultipleServices(customerId, petId, items);
        recordBookingSuccess(request, customerId, appointmentId,
                "Đặt lịch nhiều dịch vụ thành công! Mã lịch hẹn của bạn là #" + appointmentId + ".");
    }

    private void handleComboBooking(HttpServletRequest request, int customerId) throws SQLException {
        String petIdParam = request.getParameter("petId");
        String comboIdParam = request.getParameter("comboId");
        String dateParam = request.getParameter("comboDate");
        String timeParam = request.getParameter("comboTime");

        if (ValidationUtil.isBlank(petIdParam) || ValidationUtil.isBlank(comboIdParam)
                || ValidationUtil.isBlank(dateParam) || ValidationUtil.isBlank(timeParam)) {
            throw new IllegalArgumentException("Vui lòng chọn thú cưng, gói combo, ngày và giờ bắt đầu.");
        }

        int petId;
        int comboId;
        LocalDateTime start;
        try {
            petId = Integer.parseInt(petIdParam.trim());
            comboId = Integer.parseInt(comboIdParam.trim());
            start = LocalDateTime.of(LocalDate.parse(dateParam.trim()), LocalTime.parse(timeParam.trim()));
        } catch (NumberFormatException | DateTimeParseException e) {
            throw new IllegalArgumentException("Thông tin đặt gói combo không hợp lệ.");
        }

        Combos combo = comboDAO.findByIdWithServices(comboId);
        if (combo == null || !combo.isActive() || combo.getServices().isEmpty()) {
            throw new IllegalArgumentException("Gói combo không tồn tại hoặc đã ngừng áp dụng.");
        }

        Map<Integer, Integer> staffByServiceId = new HashMap<>();
        for (Services svc : combo.getServices()) {
            String staffParam = request.getParameter("comboStaff_" + comboId + "_" + svc.getServiceId());
            if (ValidationUtil.isBlank(staffParam)) {
                staffParam = request.getParameter("comboStaff_" + svc.getServiceId());
            }
            if (ValidationUtil.isBlank(staffParam)) {
                throw new IllegalArgumentException("Vui lòng chọn nhân viên thực hiện cho dịch vụ \"" + svc.getName() + "\".");
            }
            try {
                staffByServiceId.put(svc.getServiceId(), Integer.parseInt(staffParam.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Nhân viên được chọn cho dịch vụ \"" + svc.getName() + "\" không hợp lệ.");
            }
        }

        int appointmentId = bookingService.bookCombo(customerId, petId, comboId, start, staffByServiceId);
        recordBookingSuccess(request, customerId, appointmentId,
                "Đặt gói combo thành công! Mã lịch hẹn của bạn là #" + appointmentId + ".");
    }

    private void handleBoardingBooking(HttpServletRequest request, int customerId) throws SQLException {
        String petIdParam = request.getParameter("petId");
        String roomIdParam = request.getParameter("roomId");
        String checkInParam = request.getParameter("checkInDate");
        String checkOutParam = request.getParameter("checkOutDate");

        if (ValidationUtil.isBlank(petIdParam) || ValidationUtil.isBlank(roomIdParam)
                || ValidationUtil.isBlank(checkInParam) || ValidationUtil.isBlank(checkOutParam)) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ thú cưng, phòng lưu trú, ngày nhận và ngày trả phòng.");
        }

        int petId;
        int roomId;
        LocalDate checkIn;
        LocalDate checkOut;
        try {
            petId = Integer.parseInt(petIdParam.trim());
            roomId = Integer.parseInt(roomIdParam.trim());
            checkIn = LocalDate.parse(checkInParam.trim());
            checkOut = LocalDate.parse(checkOutParam.trim());
        } catch (NumberFormatException | DateTimeParseException e) {
            throw new IllegalArgumentException("Thông tin đặt phòng lưu trú không hợp lệ.");
        }

        int appointmentId = bookingService.bookBoarding(customerId, petId, roomId, checkIn, checkOut);
        recordBookingSuccess(request, customerId, appointmentId,
                "Đặt phòng lưu trú thành công! Mã lịch hẹn của bạn là #" + appointmentId + ".");
    }

    private void recordBookingSuccess(HttpServletRequest request, int customerId, int appointmentId, String bannerMessage) {
        request.setAttribute("successMessage", bannerMessage);
        request.setAttribute("createdAppointmentId", appointmentId);

        String customerName = SessionUtil.getCurrentUser(request).getFullName();
        notificationService.notifyCustomer(
                customerId,
                appointmentId,
                Notifications.TYPE_CONFIRMATION,
                "booking_success",
                "Đặt lịch thành công",
                "Lịch hẹn #" + appointmentId + " của bạn đã được ghi nhận, vui lòng chờ xác nhận.");
        NotificationEndpoint.notifyRoles(new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF}, "new_booking",
                "Lịch hẹn mới",
                customerName + " vừa đặt lịch hẹn mới #" + appointmentId + ".");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
