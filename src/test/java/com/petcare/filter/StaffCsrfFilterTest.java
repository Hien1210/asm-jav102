package com.petcare.filter;

import com.petcare.models.Users;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class StaffCsrfFilterTest {
    private final Map<String,Object> session=new HashMap<>();
    private String method="GET",submitted,encoding;
    private int error;
    private boolean passed;
    @SuppressWarnings("unchecked") private <T>T proxy(Class<T> type,java.lang.reflect.InvocationHandler handler) {
        return (T)Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{type},handler);
    }
    private void run() throws Exception {
        HttpSession s=proxy(HttpSession.class,(p,m,a)->{
            if(m.getName().equals("getAttribute")) return session.get(a[0]);
            if(m.getName().equals("setAttribute")) session.put((String)a[0],a[1]);
            return null;
        });
        HttpServletRequest req=proxy(HttpServletRequest.class,(p,m,a)->switch(m.getName()) {
            case "getSession" -> s;
            case "getMethod" -> method;
            case "getParameter" -> { assertEquals("UTF-8",encoding,"Set encoding before parsing form body"); yield submitted; }
            case "setCharacterEncoding" -> {encoding=(String)a[0];yield null;}
            default -> null;
        });
        HttpServletResponse resp=proxy(HttpServletResponse.class,(p,m,a)->{if(m.getName().equals("sendError"))error=(int)a[0];return null;});
        new StaffCsrfFilter().doFilter(req,resp,(a,b)->passed=true);
    }
    private void staff() { session.put("currentUser",new Users(2,"QA","qa@example.test",null,null,"STAFF",true,null)); }
    @Test void staffGetIssuesToken() throws Exception {staff();run();assertNotNull(session.get("staffCsrfToken"));assertTrue(passed);}
    @Test void repeatedGetKeepsToken() throws Exception {staff();session.put("staffCsrfToken","existing");run();assertEquals("existing",session.get("staffCsrfToken"));}
    @Test void missingTokenCannotPost() throws Exception {staff();method="POST";run();assertEquals(403,error);assertFalse(passed);}
    @Test void wrongTokenCannotPost() throws Exception {staff();method="POST";session.put("staffCsrfToken","expected");submitted="wrong";run();assertEquals(403,error);assertFalse(passed);}
    @Test void validTokenCanPostAndPreservesUtf8() throws Exception {staff();method="POST";session.put("staffCsrfToken","expected");submitted="expected";run();assertTrue(passed);assertEquals(0,error);}
    @Test void guestContinuesToAuthenticationFilter() throws Exception {run();assertTrue(passed);assertNull(session.get("staffCsrfToken"));}
}
