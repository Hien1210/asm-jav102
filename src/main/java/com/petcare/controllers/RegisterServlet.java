package com.petcare.controllers;

<<<<<<< HEAD:src/main/java/com/petcare/controllers/RegisterServlet.java
import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.utils.ValidationUtil;
=======
import com.petcare.models.Users;
import com.petcare.services.AuthService;
>>>>>>> bao:src/main/java/com/petcare/controller/RegisterServlet.java
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register", "/dang-ky"})
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        fullName = (fullName != null) ? fullName.trim() : "";
        phone = (phone != null) ? phone.trim() : "";
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword : "";

        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("email", email);

        if (fullName.isEmpty() || phone.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ họ tên, số điện thoại và mật khẩu.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Mật khẩu tạo mới phải có tối thiểu 8 ký tự.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu nhập lại không khớp với mật khẩu vừa tạo.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

<<<<<<< HEAD:src/main/java/com/petcare/controllers/RegisterServlet.java
        if (!email.isEmpty() && !ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Users account = new Users();
        account.setFullName(fullName);
        account.setEmail(email.isEmpty() ? phone + "@petcare.local" : email);
        account.setPhone(phone);
        account.setPasswordHash(AuthService.hashPassword(password));
        account.setRole("CUSTOMER");

        AccountDAO accountDAO = new AccountDAOImpl();
        try {
            accountDAO.create(account);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getErrorCode() == 51050
                    ? "Email hoặc số điện thoại này đã được đăng ký."
                    : "Không thể tạo tài khoản. Vui lòng thử lại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("loggedInUser", fullName);
        session.setAttribute("loggedInPhone", phone);
=======
        try {
            Users createdUser = authService.registerCustomer(fullName, phone, email, password);
>>>>>>> bao:src/main/java/com/petcare/controller/RegisterServlet.java

            HttpSession session = request.getSession(true);
            session.setAttribute("successMessage", "Đăng ký tài khoản thành công!");
            session.setAttribute("registeredIdentifier",
                    !email.isEmpty() ? createdUser.getEmail() : createdUser.getPhone());

            response.sendRedirect(request.getContextPath() + "/login");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (SQLException e) {
            if (e.getErrorCode() == 229) {
                request.setAttribute("errorMessage",
                        "Tài khoản SQL 'petcare_backend' chưa được cấp quyền SELECT/INSERT trên bảng dbo.Users. "
                        + "Vui lòng chạy file database/grant_auth_permissions.sql trên SQL Server.");
            } else if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                request.setAttribute("errorMessage", "Email hoặc số điện thoại này đã được đăng ký.");
            } else {
                request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu SQL Server: " + e.getMessage());
            }
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
