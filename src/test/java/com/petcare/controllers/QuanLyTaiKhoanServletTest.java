package com.petcare.controllers;

import com.petcare.daos.AccountDAO;
import com.petcare.models.Users;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import static org.junit.jupiter.api.Assertions.*;

class QuanLyTaiKhoanServletTest {
    private final Map<String, Object> session = new HashMap<>();
    private final Map<String, String> params = new HashMap<>();
    private final Map<String, Object> attributes = new HashMap<>();
    private final AtomicInteger writes = new AtomicInteger();
    private int status;

    @SuppressWarnings("unchecked")
    private <T> T proxy(Class<T> type, java.lang.reflect.InvocationHandler handler) {
        return (T) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{type}, handler);
    }

    private QuanLyTaiKhoanServlet servlet() throws Exception {
        Users admin = new Users(1,"Admin","admin@example.test",null,null,"ADMIN",true,null);
        session.put("currentUser", admin);
        AccountDAO dao = proxy(AccountDAO.class, (p,m,a) -> switch (m.getName()) {
            case "findAll" -> List.of();
            case "findById" -> (int)a[0] == 999 ? null : new Users(2,"Target","target@example.test",null,null,"CUSTOMER",true,null);
            case "create" -> { writes.incrementAndGet(); Users user = (Users)a[0]; user.setUserId(3); yield user; }
            case "updateRoleAndStatus", "updatePassword", "updateProfile" -> { writes.incrementAndGet(); yield true; }
            case "existsByEmail", "existsByPhone" -> false;
            default -> null;
        });
        return new QuanLyTaiKhoanServlet(dao);
    }

    private HttpServletRequest request() {
        HttpSession httpSession = proxy(HttpSession.class, (p,m,a) -> {
            if (m.getName().equals("getAttribute")) return session.get(a[0]);
            if (m.getName().equals("setAttribute")) session.put((String)a[0], a[1]);
            return null;
        });
        return proxy(HttpServletRequest.class, (p,m,a) -> switch (m.getName()) {
            case "getSession" -> httpSession;
            case "getParameter" -> params.get(a[0]);
            case "setAttribute" -> { attributes.put((String)a[0], a[1]); yield null; }
            case "getContextPath" -> "/petcare";
            case "getRequestDispatcher" -> proxy(RequestDispatcher.class, (d,method,args) -> null);
            default -> null;
        });
    }

    private HttpServletResponse response() {
        return proxy(HttpServletResponse.class, (p,m,a) -> {
            if (m.getName().equals("sendError")) status = (int)a[0];
            return null;
        });
    }

    @Test void postWithoutTokenCannotChangeAccount() throws Exception {
        var servlet = servlet();
        params.putAll(Map.of("action","toggleActive","userId","2","active","false"));
        servlet.doPost(request(), response());
        assertEquals(403, status);
        assertEquals(0, writes.get());
    }

    @Test void getIssuesTokenAndValidPostCanChangeAccount() throws Exception {
        var servlet = servlet();
        servlet.doGet(request(), response());
        String token = (String)session.get("adminCsrfToken");
        assertNotNull(token);
        params.putAll(Map.of("action","toggleActive","userId","2","active","false","csrfToken",token));
        servlet.doPost(request(), response());
        assertEquals(1, writes.get());
    }

    @Test void malformedActiveCannotSilentlyLockAccount() throws Exception {
        var servlet = servlet();
        session.put("adminCsrfToken", "valid-token");
        params.putAll(Map.of("action","toggleActive","userId","2","active","typo","csrfToken","valid-token"));
        servlet.doPost(request(), response());
        assertEquals(0, writes.get());
        assertNotNull(attributes.get("errorMessage"));
    }

    private void authorizedPost(Map<String, String> values) throws Exception {
        var servlet = servlet();
        session.put("adminCsrfToken", "valid-token");
        params.put("csrfToken", "valid-token");
        params.putAll(values);
        servlet.doPost(request(), response());
    }

    @Test void wrongTokenCannotResetPassword() throws Exception {
        authorizedPost(Map.of("action","resetPassword","userId","2","newPassword","Password@123","csrfToken","wrong"));
        assertEquals(403, status);
        assertEquals(0, writes.get());
    }

    @Test void adminCannotLockSelf() throws Exception {
        authorizedPost(Map.of("action","toggleActive","userId","1","active","false"));
        assertEquals(0, writes.get());
        assertNotNull(attributes.get("errorMessage"));
    }

    @Test void adminCannotRemoveOwnRole() throws Exception {
        authorizedPost(Map.of("action","update","userId","1","fullName","Admin","email","admin@example.test","role","CUSTOMER"));
        assertEquals(0, writes.get());
        assertNotNull(attributes.get("errorMessage"));
    }

    @Test void nonexistentResetTargetIsRejected() throws Exception {
        authorizedPost(Map.of("action","resetPassword","userId","999","newPassword","Password@123"));
        assertEquals(0, writes.get());
        assertNotNull(attributes.get("errorMessage"));
    }

    @Test void validAdminCreationSucceeds() throws Exception {
        authorizedPost(Map.of("action","create","fullName","New Admin","email","new@example.test","role","ADMIN","password","Password@123"));
        assertEquals(1, writes.get());
        assertNotNull(attributes.get("successMessage"));
    }

    @Test void customerCannotManageAccounts() throws Exception {
        var servlet = servlet();
        ((Users)session.get("currentUser")).setRole("CUSTOMER");
        params.putAll(Map.of("action","toggleActive","userId","2","active","false"));
        servlet.doPost(request(), response());
        assertEquals(0, writes.get());
        assertTrue(attributes.isEmpty());
    }
}
