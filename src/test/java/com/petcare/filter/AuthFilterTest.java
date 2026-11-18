package com.petcare.filter;

import com.petcare.models.Users;
import com.petcare.services.AuthService;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import static org.junit.jupiter.api.Assertions.*;

class AuthFilterTest {
    @Test void lockedAccountLosesExistingSession() throws Exception { check(false, "ADMIN", "ADMIN", "/login"); }
    @Test void roleRevocationAppliesToExistingSession() throws Exception { check(true, "ADMIN", "CUSTOMER", "403"); }

    private void check(boolean active, String oldRole, String freshRole, String expected) throws Exception {
        Users stale = new Users(7,"QA","qa@example.test","0901111222",null,oldRole,true,null);
        Users fresh = new Users(7,"QA","qa@example.test","0901111222",null,freshRole,active,null);
        AtomicReference<Users> sessionUser = new AtomicReference<>(stale);
        AtomicBoolean invalidated = new AtomicBoolean();
        HttpSession session = (HttpSession) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpSession.class}, (p,m,a) -> {
                    if (m.getName().equals("getAttribute")) return sessionUser.get();
                    if (m.getName().equals("setAttribute") && a[0].equals("currentUser")) sessionUser.set((Users)a[1]);
                    if (m.getName().equals("invalidate")) invalidated.set(true);
                    return null;
                });
        HttpServletRequest request = (HttpServletRequest) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpServletRequest.class}, (p,m,a) -> switch(m.getName()) {
                    case "getSession" -> session;
                    case "getRequestURI" -> "/petcare/admin/tai-khoan";
                    case "getContextPath" -> "/petcare";
                    default -> null;
                });
        AtomicReference<String> result = new AtomicReference<>();
        HttpServletResponse response = (HttpServletResponse) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpServletResponse.class}, (p,m,a) -> {
                    if (m.getName().equals("sendRedirect")) result.set((String)a[0]);
                    if (m.getName().equals("sendError")) result.set(a[0].toString());
                    return null;
                });
        AuthService auth = new AuthService(null) { @Override public Users getUserById(int id) { return fresh; } };
        new AuthFilter(auth).doFilter(request,response,(req,resp) -> fail("Stale access must be rejected"));
        assertTrue(result.get().endsWith(expected));
        if (!active) assertTrue(invalidated.get());
    }
}
