package com.petcare.controllers;

import com.petcare.daos.AdminCatalogDAO;
import com.petcare.models.Users;
import com.petcare.services.AdminModule;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.*;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.sql.SQLException;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class AdminCatalogServletTest {
    private final Map<String,Object> session=new HashMap<>();
    private final Map<String,String> params=new HashMap<>();
    private final Map<String,Object> attributes=new HashMap<>();
    private int writes,status;
    private String redirect;
    @SuppressWarnings("unchecked") private <T> T proxy(Class<T> type,java.lang.reflect.InvocationHandler handler) {
        return (T)Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{type},handler);
    }
    private void post(boolean rejectDelete) throws Exception {
        session.put("currentUser",new Users(1,"Admin","qa@test.vn",null,null,"ADMIN",true,null));
        session.put("adminCsrfToken","token");
        var dao=new AdminCatalogDAO() {
            @Override public List<Map<String,Object>> list(AdminModule module) { return List.of(); }
            @Override public int save(AdminModule module,Integer id,Map<String,Object> values,List<Integer> services) { writes++; return 3; }
            @Override public void delete(AdminModule module,int id) throws SQLException {
                if(rejectDelete) throw new SQLException("Referenced","23000",547);
                writes++;
            }
        };
        HttpSession httpSession=proxy(HttpSession.class,(p,m,a)->{
            if(m.getName().equals("getAttribute")) return session.get(a[0]);
            if(m.getName().equals("setAttribute")) session.put((String)a[0],a[1]);
            if(m.getName().equals("removeAttribute")) session.remove(a[0]);
            return null;
        });
        HttpServletRequest req=proxy(HttpServletRequest.class,(p,m,a)->switch(m.getName()) {
            case "getSession" -> httpSession;
            case "getParameter" -> params.get(a[0]);
            case "getContextPath" -> "/petcare";
            case "setAttribute" -> { attributes.put((String)a[0],a[1]); yield null; }
            case "getRequestDispatcher" -> proxy(RequestDispatcher.class,(d,method,args)->null);
            default -> null;
        });
        HttpServletResponse resp=proxy(HttpServletResponse.class,(p,m,a)->{
            if(m.getName().equals("sendError")||m.getName().equals("setStatus")) status=(int)a[0];
            if(m.getName().equals("sendRedirect")) redirect=(String)a[0];
            return null;
        });
        new AdminCatalogServlet(AdminModule.ROOMS,dao){}.doPost(req,resp);
    }
    @Test void rejectsMissingCsrfBeforeWrite() throws Exception {
        params.putAll(Map.of("action","delete","id","1")); post(false);
        assertEquals(403,status); assertEquals(0,writes);
    }
    @Test void invalidRoomNeverReachesDatabase() throws Exception {
        params.putAll(Map.of("csrfToken","token","action","save","room_code","A1","daily_rate","-2","status","AVAILABLE")); post(false);
        assertEquals(0,writes); assertNotNull(attributes.get("errorMessage"));
    }
    @Test void successfulSaveRedirectsToPreventRefreshResubmit() throws Exception {
        params.putAll(Map.of("csrfToken","token","action","save","room_code","A1","daily_rate","200000","status","AVAILABLE")); post(false);
        assertEquals(1,writes); assertEquals("/petcare/admin/phong",redirect);
    }
    @Test void failedDeleteDoesNotPresentBlankEditOfExistingRecord() throws Exception {
        params.putAll(Map.of("csrfToken","token","action","delete","id","1")); post(true);
        assertEquals(Map.of(),attributes.get("edit")); assertNotNull(attributes.get("errorMessage"));
    }
}
