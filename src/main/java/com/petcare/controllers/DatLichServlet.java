package com.petcare.controllers;

import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.daos.ServiceDAO;
import com.petcare.daos.ServiceDAOImpl;
import com.petcare.daos.StaffDAO;
import com.petcare.daos.StaffDAOImpl;
import com.petcare.models.Pets;
import com.petcare.models.Services;
import com.petcare.models.StaffOption;
import com.petcare.models.Users;
import com.petcare.services.BookingService;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import com.petcare.websocket.NotificationEndpoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DatLichServlet", urlPatterns = {"/customer/dat-lich"})
public class DatLichServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PetDAO petDAO = new PetDAOImpl();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }
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

        try {
            if ("addPet".equals(action)) {
                handleAddPet(request, customerId);
            } else {
                handleBooking(request, customerId);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

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
        try {
            request.setAttribute("pets", petDAO.findByOwner(customerId));

            List<Services> services = serviceDAO.findActiveBookable();
            Map<Services, List<StaffOption>> staffByService = new LinkedHashMap<>();
            for (Services service : services) {
                staffByService.put(service, staffDAO.findActiveStaffForService(service.getServiceId()));
            }
            request.setAttribute("staffByService", staffByService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được dữ liệu đặt lịch. Vui lòng thử lại.");
        }
    }

    private void handleAddPet(HttpServletRequest request, int customerId) throws SQLException {
        String name = trim(request.getParameter("petName"));
        String species = trim(request.getParameter("petSpecies"));
        if (ValidationUtil.isBlank(name) || ValidationUtil.isBlank(species)) {
            throw new IllegalArgumentException("Vui lòng nhập tên và loài thú cưng.");
        }
        Pets pet = new Pets();
        pet.setOwnerId(customerId);
        pet.setName(name);
        pet.setSpecies(species);
        pet.setBreed(trim(request.getParameter("petBreed")));
        petDAO.create(pet);
        request.setAttribute("successMessage", "Đã thêm thú cưng \"" + name + "\".");
    }

    private void handleBooking(HttpServletRequest request, int customerId) throws SQLException {
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
            petId = Integer.parseInt(petIdParam);
            serviceId = Integer.parseInt(parts[0]);
            staffId = Integer.parseInt(parts[1]);
            start = LocalDateTime.of(LocalDate.parse(dateParam), LocalTime.parse(timeParam));
        } catch (NumberFormatException | DateTimeParseException e) {
            throw new IllegalArgumentException("Thông tin đặt lịch không hợp lệ.");
        }

        if (start.isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Thời gian đặt lịch phải ở trong tương lai.");
        }

        int appointmentId = bookingService.bookService(customerId, petId, serviceId, staffId, start);
        request.setAttribute("successMessage",
                "Đặt lịch thành công! Mã lịch hẹn của bạn là #" + appointmentId + ".");

        String customerName = SessionUtil.getCurrentUser(request).getFullName();
        NotificationEndpoint.notifyUser(customerId, "booking_success", "Đặt lịch thành công",
                "Lịch hẹn #" + appointmentId + " của bạn đã được ghi nhận, vui lòng chờ xác nhận.");
        NotificationEndpoint.notifyRoles(new String[]{Users.ROLE_ADMIN, Users.ROLE_STAFF}, "new_booking",
                "Lịch hẹn mới",
                customerName + " vừa đặt lịch hẹn mới #" + appointmentId + ".");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
