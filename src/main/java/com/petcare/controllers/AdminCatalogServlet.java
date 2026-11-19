package com.petcare.controllers;

import com.petcare.daos.AdminCatalogDAO;
import com.petcare.models.Users;
import com.petcare.services.AdminModule;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/** Shared request lifecycle for the five catalog screens. */
public abstract class AdminCatalogServlet extends HttpServlet {
    protected final AdminModule module;
    private final AdminCatalogDAO dao;
    protected AdminCatalogServlet(AdminModule module) { this(module,new AdminCatalogDAO()); }
    protected AdminCatalogServlet(AdminModule module,AdminCatalogDAO dao) { this.module=module; this.dao=dao; }

    private boolean authorize(HttpServletRequest req,HttpServletResponse resp) throws IOException {
        if (!SessionUtil.isLoggedIn(req)) { resp.sendRedirect(req.getContextPath()+"/login"); return false; }
        if (!SessionUtil.hasRole(req,Users.ROLE_ADMIN)) { resp.sendError(403); return false; }
        return true;
    }
    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
        req.setCharacterEncoding("UTF-8"); resp.setCharacterEncoding("UTF-8");
        if (!authorize(req,resp)) return;
        if (req.getSession().getAttribute("adminCsrfToken")==null)
            req.getSession().setAttribute("adminCsrfToken",UUID.randomUUID().toString());
        Map<String,Object> edit=new HashMap<>();
        try {
            if (req.getParameter("id")!=null) {
                int id=positiveId(req.getParameter("id"));
                edit=dao.find(module,id);
                if(edit==null) { resp.sendError(404); return; }
                if(module==AdminModule.COMBOS) req.setAttribute("selectedServices",dao.comboServices(id));
            }
        } catch (IllegalArgumentException e) { resp.sendError(400,e.getMessage()); return; }
        catch (SQLException e) { req.setAttribute("errorMessage",sqlMessage(e)); }
        req.setAttribute("edit",edit);
        render(req,resp);
    }
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
        req.setCharacterEncoding("UTF-8"); resp.setCharacterEncoding("UTF-8");
        if(!authorize(req,resp)) return;
        Object token=req.getSession().getAttribute("adminCsrfToken");
        if(!(token instanceof String) || !token.equals(req.getParameter("csrfToken"))) { resp.sendError(403); return; }
        Map<String,String> input=new LinkedHashMap<>();
        for(var field:module.getFields()) input.put(field.getName(),req.getParameter(field.getName()));
        try {
            String action=req.getParameter("action");
            if("delete".equals(action)) dao.delete(module,positiveId(req.getParameter("id")));
            else if("save".equals(action)) {
                String rawId=req.getParameter("id");
                Integer id=rawId==null||rawId.isBlank()?null:positiveId(rawId);
                LinkedHashSet<Integer> services=new LinkedHashSet<>();
                String[] selected=req.getParameterValues("serviceIds");
                if(selected!=null) for(String item:selected) services.add(positiveId(item));
                dao.save(module,id,module.validate(input),new ArrayList<>(services));
            } else throw new IllegalArgumentException("Hành động không hợp lệ.");
            req.getSession().setAttribute("adminFlash","Đã lưu thay đổi.");
            resp.sendRedirect(req.getContextPath()+"/admin/"+module.getPath());
            return;
        } catch (IllegalArgumentException e) { req.setAttribute("errorMessage",e.getMessage()); }
        catch (SQLException e) { req.setAttribute("errorMessage",sqlMessage(e)); }
        if ("save".equals(req.getParameter("action"))) {
            input.put(module.getId(),req.getParameter("id"));
            req.setAttribute("edit",input);
        } else {
            req.setAttribute("edit",Map.of());
        }
        List<Integer> selected=new ArrayList<>();
        String[] raw=req.getParameterValues("serviceIds");
        if(raw!=null) for(String item:raw) { try { selected.add(positiveId(item)); } catch(IllegalArgumentException ignored) { } }
        req.setAttribute("selectedServices",selected);
        render(req,resp);
    }
    private void render(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException {
        req.setAttribute("module",module);
        req.setAttribute("modules",AdminModule.values());
        Object flash=req.getSession().getAttribute("adminFlash");
        req.getSession().removeAttribute("adminFlash");
        req.setAttribute("successMessage",flash);
        try {
            req.setAttribute("rows",dao.list(module));
            if(module==AdminModule.SHIFTS) req.setAttribute("people",dao.users("STAFF"));
            if(module==AdminModule.PETS) req.setAttribute("people",dao.users("CUSTOMER"));
            if(module==AdminModule.COMBOS) req.setAttribute("services",dao.list(AdminModule.SERVICES));
        } catch(SQLException e) { req.setAttribute("errorMessage",sqlMessage(e)); resp.setStatus(503); }
        req.getRequestDispatcher("/WEB-INF/views/admin/catalog.jsp").forward(req,resp);
    }
    static int positiveId(String raw) {
        try { int id=Integer.parseInt(raw); if(id>0) return id; } catch(NumberFormatException ignored) { }
        throw new IllegalArgumentException("Mã dữ liệu không hợp lệ.");
    }
    static String sqlMessage(SQLException e) {
        return switch(e.getErrorCode()) {
            case 547 -> "Dữ liệu đang được sử dụng hoặc tài khoản liên quan không tồn tại. Không thể thực hiện thao tác này.";
            case 2601,2627 -> "Dữ liệu bị trùng (ví dụ mã phòng). Vui lòng kiểm tra lại.";
            case 51004 -> "Ca làm việc trùng với ca đã có của nhân viên.";
            case 51009 -> "Thay đổi ca làm việc ảnh hưởng lịch hẹn đang hoạt động.";
            case 51011 -> "Phòng đang có lịch lưu trú, không thể chuyển sang bảo trì.";
            case 51002 -> "Chủ thú cưng phải có vai trò khách hàng.";
            case 51003 -> "Ca làm việc phải thuộc nhân viên.";
            case 229 -> "Ứng dụng chưa được cấp quyền quản lý dữ liệu này. Liên hệ quản trị cơ sở dữ liệu.";
            case 2812 -> "Chưa cài đặt chức năng quản trị trong cơ sở dữ liệu. Cần áp dụng migration admin_catalog.sql.";
            case 51101 -> "Dữ liệu không tồn tại hoặc đã bị xóa.";
            case 51102 -> "Combo cần ít nhất một dịch vụ đang hoạt động và không thuộc lưu trú.";
            default -> "Không thể lưu hoặc tải dữ liệu. Vui lòng thử lại.";
        };
    }
}
