package com.petcare.filter;

import com.petcare.models.Users;
import com.petcare.services.AuthService;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/staff/*", "/customer/*"})
public class AuthFilter implements Filter {

    private final AuthService authService;

    public AuthFilter() {
        this(new AuthService());
    }

    public AuthFilter(AuthService authService) {
        this.authService = authService;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        Users currentUser = SessionUtil.getCurrentUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            Users freshUser = authService.getUserById(currentUser.getUserId());
            if (freshUser == null || !freshUser.isActive()) {
                SessionUtil.clearSession(req);
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            SessionUtil.refreshSessionUser(req, freshUser);
        } catch (SQLException e) {
            resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                    "Không thể xác minh tài khoản. Vui lòng thử lại sau.");
            return;
        }

        String path = req.getRequestURI().substring(req.getContextPath().length());
        if (path.startsWith("/admin/") && !SessionUtil.hasRole(req, Users.ROLE_ADMIN)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Quản trị viên (ADMIN) mới có quyền truy cập khu vực này.");
            return;
        }
        if (path.startsWith("/staff/") && !SessionUtil.hasRole(req, Users.ROLE_STAFF, Users.ROLE_ADMIN)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Nhân viên (STAFF) hoặc Quản trị viên (ADMIN) mới có quyền truy cập.");
            return;
        }
        if (path.startsWith("/customer/") && !SessionUtil.hasRole(req, Users.ROLE_CUSTOMER, Users.ROLE_STAFF, Users.ROLE_ADMIN)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }

        chain.doFilter(request, response);
    }
}
