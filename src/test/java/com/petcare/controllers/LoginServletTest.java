package com.petcare.controllers;

import com.petcare.models.Users;
import com.petcare.services.AuthService;
import jakarta.servlet.http.*;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class LoginServletTest {
    @Test void staffLandsOnAssignedAppointments() throws Exception { check("STAFF", "/staff/lich-hen"); }
    @Test void adminKeepsAccountManagementLanding() throws Exception { check("ADMIN", "/admin/tai-khoan"); }
    @Test void customerKeepsHomeLanding() throws Exception { check("CUSTOMER", "/home"); }

    private void check(String role, String destination) throws Exception {
        Users user = new Users(2,"QA","qa@example.test","0901111222",null,role,true,null);
        Map<String,Object> attributes = new HashMap<>();
        HttpSession session = (HttpSession) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpSession.class}, (p,m,a) -> {
                    if(m.getName().equals("setAttribute")) attributes.put((String)a[0],a[1]);
                    return null;
                });
        HttpServletRequest request = (HttpServletRequest) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpServletRequest.class}, (p,m,a) -> switch(m.getName()) {
                    case "getParameter" -> switch((String)a[0]) {
                        case "identifier" -> "qa@example.test";
                        case "password" -> "test-password";
                        default -> null;
                    };
                    case "getSession" -> Boolean.TRUE.equals(a[0]) ? session : null;
                    case "getContextPath" -> "/petcare";
                    default -> null;
                });
        AtomicReference<String> redirect = new AtomicReference<>();
        HttpServletResponse response = (HttpServletResponse) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{HttpServletResponse.class}, (p,m,a) -> {
                    if(m.getName().equals("sendRedirect")) redirect.set((String)a[0]);
                    return null;
                });
        AuthService auth = new AuthService(null) {
            @Override public Users authenticate(String identifier,String password) { return user; }
        };
        new LoginServlet(auth).doPost(request,response);
        assertSame(user,attributes.get("currentUser"));
        assertEquals("/petcare"+destination,redirect.get());
    }
}
