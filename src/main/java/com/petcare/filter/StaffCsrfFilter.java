package com.petcare.filter;

import com.petcare.models.Users;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

/** Protects every staff POST, including counter customer/pet creation and status updates. */
@WebFilter(filterName="StaffCsrfFilter",urlPatterns="/staff/*")
public class StaffCsrfFilter implements Filter {
    @Override public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)
            throws IOException,ServletException {
        HttpServletRequest req=(HttpServletRequest)request;
        HttpServletResponse resp=(HttpServletResponse)response;
        req.setCharacterEncoding("UTF-8");
        if(SessionUtil.hasRole(req,Users.ROLE_STAFF,Users.ROLE_ADMIN)) {
            HttpSession session=req.getSession(false);
            if("POST".equalsIgnoreCase(req.getMethod())) {
                Object expected=session.getAttribute("staffCsrfToken");
                if(!(expected instanceof String)||!expected.equals(req.getParameter("csrfToken"))) {
                    resp.sendError(403,"Phiên biểu mẫu không hợp lệ. Vui lòng tải lại trang nhân viên.");
                    return;
                }
            } else if("GET".equalsIgnoreCase(req.getMethod())&&session.getAttribute("staffCsrfToken")==null) {
                session.setAttribute("staffCsrfToken",UUID.randomUUID().toString());
            }
        }
        chain.doFilter(request,response);
    }
}
