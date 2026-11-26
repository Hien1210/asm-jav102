package com.petcare.controllers;

import com.petcare.daos.ServiceDAO;
import com.petcare.daos.ServiceDAOImpl;
import com.petcare.daos.StaffDAO;
import com.petcare.daos.StaffDAOImpl;
import com.petcare.models.Services;
import com.petcare.models.StaffOption;
import com.petcare.models.Users;
import com.petcare.services.WalkInBookingService;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.DateUtil;
import com.petcare.utils.ValidationUtil;
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

/**
 * Nhân viên/lễ tân tạo lịch hẹn và thu tiền ngay tại quầy cho khách không tự đặt lịch trên
 * website (khách vãng lai). Khách được tra/tạo theo số điện thoại, không cần tài khoản đăng nhập.
 */
@WebServlet(name = "DatLichTaiQuayServlet", urlPatterns = {"/staff/dat-lich-tai-quay"})
public class DatLichTaiQuayServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ServiceDAO serviceDAO = new ServiceDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();
    private final WalkInBookingService walkInService = new WalkInBookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (!requireStaff(request, response)) {
            return;
        }
        loadServiceOptions(request);
        request.getRequestDispatcher("/WEB-INF/views/staff/datLichTaiQuay.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (!requireStaff(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("timKhach".equals(action)) {
                handleFindCustomer(request);
            } else if ("themThuCung".equals(action)) {
                handleAddPet(request);
            } else if ("datLichVaThu".equals(action)) {
                handleBookAndPay(request);
            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        loadServiceOptions(request);
        request.getRequestDispatcher("/WEB-INF/views/staff/datLichTaiQuay.jsp").forward(request, response);
    }

    private boolean requireStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        if (!SessionUtil.hasRole(request, Users.ROLE_STAFF, Users.ROLE_ADMIN)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private void loadServiceOptions(HttpServletRequest request) {
        request.setAttribute("minimumBookingDate", DateUtil.todayVn());
        try {
            List<Services> services = serviceDAO.findActiveBookable();
            Map<Services, List<StaffOption>> staffByService = new LinkedHashMap<>();
            for (Services service : services) {
                staffByService.put(service, staffDAO.findActiveStaffForService(service.getServiceId()));
            }
            request.setAttribute("staffByService", staffByService);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách dịch vụ. Vui lòng thử lại.");
        }
    }

    private void handleFindCustomer(HttpServletRequest request) throws SQLException {
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("fullName");

        Users customer = walkInService.findOrCreateCustomer(fullName, phone);
        request.setAttribute("customer", customer);
        request.setAttribute("pets", walkInService.listPets(customer.getUserId()));
    }

    private void handleAddPet(HttpServletRequest request) throws SQLException {
        int customerId = requireCustomerId(request);
        String name = request.getParameter("petName");
        String species = request.getParameter("petSpecies");
        String breed = request.getParameter("petBreed");

        Users selectedCustomer = walkInService.getCustomer(customerId);
        request.setAttribute("customer", selectedCustomer);
        request.setAttribute("pets", walkInService.listPets(customerId));
        walkInService.addPet(customerId, name, species, breed);
        request.setAttribute("successMessage", "Đã thêm thú cưng \"" + trim(name) + "\" cho khách.");

        Users customer = walkInService.getCustomer(customerId);
        request.setAttribute("customer", customer);
        request.setAttribute("pets", walkInService.listPets(customerId));
    }

    private void handleBookAndPay(HttpServletRequest request) throws SQLException {
        int customerId = requireCustomerId(request);
        Users customer = walkInService.getCustomer(customerId);
        request.setAttribute("customer", customer);
        request.setAttribute("pets", walkInService.listPets(customerId));

        String petIdParam = request.getParameter("petId");
        String staffChoice = request.getParameter("staffChoice");
        String dateParam = request.getParameter("bookingDate");
        String timeParam = request.getParameter("bookingTime");
        String method = request.getParameter("method");
        String transactionRef = request.getParameter("transactionRef");

        if (ValidationUtil.isBlank(petIdParam) || ValidationUtil.isBlank(staffChoice)
                || ValidationUtil.isBlank(dateParam) || ValidationUtil.isBlank(timeParam)
                || ValidationUtil.isBlank(method)) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ thú cưng, dịch vụ, thời gian và phương thức.");
        }
        if ("ONLINE".equals(method) && ValidationUtil.isBlank(transactionRef)) {
            throw new IllegalArgumentException("Vui lòng nhập mã giao dịch khi thu tiền Online.");
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

        int appointmentId = walkInService.bookAndSettleAtCounter(
                customerId, petId, serviceId, staffId, start, method, transactionRef);
        request.setAttribute("successMessage", "Đã tạo và thu tiền lịch hẹn #" + appointmentId
                + " cho khách " + customer.getFullName() + " (" + customer.getPhone() + ").");
    }

    private int requireCustomerId(HttpServletRequest request) {
        String customerIdParam = request.getParameter("customerId");
        if (ValidationUtil.isBlank(customerIdParam)) {
            throw new IllegalArgumentException("Vui lòng tìm khách hàng trước.");
        }
        try {
            return Integer.parseInt(customerIdParam);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Khách hàng không hợp lệ.");
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
