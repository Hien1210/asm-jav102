package com.petcare.controllers;

import com.petcare.models.Pets;
import com.petcare.models.Users;
import com.petcare.services.PetService;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import com.petcare.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "QuanLyThuCungServlet", urlPatterns = {"/customer/thu-cung"})
public class QuanLyThuCungServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PetService petService = new PetService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }
        popFlash(request);

        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        request.setAttribute("todayIso", DateUtil.todayVn().toString());
        request.setAttribute("activeCustomerNav", "pets");

        try {
            request.setAttribute("pets", petService.listMyPets(customerId));
            String editIdParam = request.getParameter("editId");
            if (!ValidationUtil.isBlank(editIdParam)) {
                try {
                    int editId = Integer.parseInt(editIdParam.trim());
                    Pets editingPet = petService.getMyPet(customerId, editId);
                    if (editingPet != null) {
                        request.setAttribute("editingPet", editingPet);
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy thú cưng cần chỉnh sửa.");
                    }
                } catch (NumberFormatException ignored) {
                    request.setAttribute("errorMessage", "Mã thú cưng không hợp lệ.");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Không tải được danh sách thú cưng: " + e.getMessage());
        }

        request.getRequestDispatcher("/customer/quanLyThuCung.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!requireCustomer(request, response)) {
            return;
        }

        int customerId = SessionUtil.getCurrentUser(request).getUserId();
        String action = request.getParameter("action");
        HttpSession session = request.getSession(true);

        try {
            if ("create".equals(action)) {
                String name = request.getParameter("name");
                String species = request.getParameter("species");
                String breed = request.getParameter("breed");
                BigDecimal weightKg = parseOptionalDecimal(request.getParameter("weightKg"));
                LocalDate birthDate = parseOptionalDate(request.getParameter("birthDate"));
                String medicalNotes = request.getParameter("medicalNotes");

                int petId = petService.createPet(customerId, name, species, breed, weightKg, birthDate, medicalNotes);
                session.setAttribute("petSuccess", "Đã thêm thú cưng \"" + name.trim() + "\" (#" + petId + ").");
            } else if ("update".equals(action)) {
                int petId = parseIntRequired(request.getParameter("petId"), "Mã thú cưng không hợp lệ.");
                String name = request.getParameter("name");
                String species = request.getParameter("species");
                String breed = request.getParameter("breed");
                BigDecimal weightKg = parseOptionalDecimal(request.getParameter("weightKg"));
                LocalDate birthDate = parseOptionalDate(request.getParameter("birthDate"));
                String medicalNotes = request.getParameter("medicalNotes");

                petService.updatePet(customerId, petId, name, species, breed, weightKg, birthDate, medicalNotes);
                session.setAttribute("petSuccess", "Đã cập nhật hồ sơ thú cưng \"" + name.trim() + "\".");
            } else if ("delete".equals(action)) {
                int petId = parseIntRequired(request.getParameter("petId"), "Mã thú cưng không hợp lệ.");
                petService.deletePet(customerId, petId);
                session.setAttribute("petSuccess", "Đã xóa thú cưng khỏi danh sách.");
            } else {
                throw new IllegalArgumentException("Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException | SQLException e) {
            session.setAttribute("petError", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer/thu-cung");
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

    private void popFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object success = session.getAttribute("petSuccess");
        if (success != null) {
            request.setAttribute("successMessage", success);
            session.removeAttribute("petSuccess");
        }
        Object error = session.getAttribute("petError");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            session.removeAttribute("petError");
        }
    }

    private int parseIntRequired(String raw, String message) {
        try {
            return Integer.parseInt(raw == null ? "" : raw.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private BigDecimal parseOptionalDecimal(String raw) {
        if (ValidationUtil.isBlank(raw)) {
            return null;
        }
        try {
            return new BigDecimal(raw.trim().replace(',', '.'));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Cân nặng phải là một số hợp lệ (ví dụ: 4.5).");
        }
    }

    private LocalDate parseOptionalDate(String raw) {
        if (ValidationUtil.isBlank(raw)) {
            return null;
        }
        try {
            return LocalDate.parse(raw.trim());
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Ngày sinh không đúng định dạng.");
        }
    }
}
