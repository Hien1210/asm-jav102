package com.petcare.controllers;

import com.petcare.daos.AdminOperationsDAO;
import com.petcare.models.Users;
import com.petcare.services.AdminOperationsPolicy.Range;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class AdminOperationsServletTest {
    private final Map<String,Object> session=new HashMap<>();
    private final Map<String,String> params=new HashMap<>();
    private String role="ADMIN",path="/admin/lich-hen",redirect;
    private int status,writes,reads;
    @SuppressWarnings("unchecked") private <T>T proxy(Class<T> type,java.lang.reflect.InvocationHandler handler) {
        return (T)Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{type},handler);
    }
    private void run(boolean post) throws Exception {
        if(role!=null) session.put("currentUser",new Users(1,"QA","qa@test.vn",null,null,role,true,null));
        HttpSession httpSession=proxy(HttpSession.class,(p,m,a)->{
            if(m.getName().equals("getAttribute")) return session.get(a[0]);
            if(m.getName().equals("setAttribute")) session.put((String)a[0],a[1]);
            if(m.getName().equals("removeAttribute")) session.remove(a[0]);
            return null;
        });
        HttpServletRequest req=proxy(HttpServletRequest.class,(p,m,a)->switch(m.getName()) {
            case "getSession" -> httpSession;
            case "getContextPath" -> "/petcare";
            case "getServletPath" -> path;
            case "getParameter" -> params.get(a[0]);
            case "getRequestDispatcher" -> proxy(RequestDispatcher.class,(d,method,args)->null);
            default -> null;
        });
        HttpServletResponse resp=proxy(HttpServletResponse.class,(p,m,a)->{
            if(m.getName().equals("sendError")||m.getName().equals("setStatus")) status=(int)a[0];
            if(m.getName().equals("sendRedirect")) redirect=(String)a[0];
            return null;
        });
        var dao=new AdminOperationsDAO() {
            @Override public Page appointments(Range range,String status,String type,String q,int page) { reads++; return new Page(List.of(),0,1,1); }
            @Override public int changeStatus(int actor,int id,String expected,String state,String reason) { writes++; return 3; }
        };
        var servlet=new AdminOperationsServlet(dao);
        if(post) servlet.doPost(req,resp); else servlet.doGet(req,resp);
    }
    @Test void customerAndStaffCannotAccessAdmin() throws Exception {
        role="CUSTOMER"; run(false); assertEquals(403,status); assertEquals(0,reads);
        role="STAFF"; path="/admin/bao-cao"; run(false); assertEquals(403,status);
    }
    @Test void missingCsrfCannotWrite() throws Exception { run(true); assertEquals(403,status); assertEquals(0,writes); }
    @Test void validPostRedirectsAndWritesOnce() throws Exception {
        session.put("adminCsrfToken","token"); params.putAll(Map.of("csrfToken","token","action","status","appointmentId","1","expectedStatus","PENDING","status","CONFIRMED"));
        run(true); assertEquals(1,writes); assertTrue(redirect.contains("?id=1"));
    }
    @Test void invalidTransitionNeverReachesDao() throws Exception {
        session.put("adminCsrfToken","token"); params.putAll(Map.of("csrfToken","token","action","status","appointmentId","1","expectedStatus","PENDING","status","COMPLETED"));
        run(true); assertEquals(0,writes); assertNotNull(session.get("adminOperationsError"));
    }
    @Test void reportsDoNotAcceptWrites() throws Exception { path="/admin/bao-cao"; run(true); assertEquals(405,status); assertEquals(0,writes); }
    @Test void invalidRangeNeverQueriesDatabase() throws Exception { params.put("from","invalid"); run(false); assertEquals(400,status); assertEquals(0,reads); }
}
