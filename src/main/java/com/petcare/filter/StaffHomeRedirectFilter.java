package com.petcare.filter;

import com.petcare.models.Users;
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

@WebFilter(urlPatterns = {"/home", "/trang-chu", "/index.jsp"})
public class StaffHomeRedirectFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        // The same URL can be visited before and after a change of session.
        resp.setHeader("Cache-Control", "no-store");
        if (SessionUtil.hasRole(req, Users.ROLE_STAFF)) {
            resp.sendRedirect(req.getContextPath() + "/staff/lich-hen");
            return;
        }
        chain.doFilter(request, response);
    }
}
