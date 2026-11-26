package com.petcare.controllers;

import com.petcare.daos.AdminOperationsDAO;
import com.petcare.models.Users;
import com.petcare.services.AdminOperationsPolicy;
import com.petcare.utils.DateUtil;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet(urlPatterns={"/admin/lich-hen","/admin/bao-cao"})
public class AdminOperationsServlet extends HttpServlet {
    private final AdminOperationsDAO dao;
    public AdminOperationsServlet() { this(new AdminOperationsDAO()); }
    AdminOperationsServlet(AdminOperationsDAO dao) { this.dao=dao; }
    private boolean authorize(HttpServletRequest req,HttpServletResponse resp) throws IOException {
        if(!SessionUtil.isLoggedIn(req)) { resp.sendRedirect(req.getContextPath()+"/login"); return false; }
        if(!SessionUtil.hasRole(req,Users.ROLE_ADMIN)) { resp.sendError(403); return false; }
        return true;
    }
    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp) throws IOException,ServletException {
        req.setCharacterEncoding("UTF-8"); resp.setCharacterEncoding("UTF-8");
        if(!authorize(req,resp)) return;
        if(req.getSession().getAttribute("adminCsrfToken")==null) req.getSession().setAttribute("adminCsrfToken",UUID.randomUUID().toString());
        boolean report="/admin/bao-cao".equals(req.getServletPath());
        LocalDate today=DateUtil.todayVn();
        req.setAttribute("fromDate",req.getParameter("from")); req.setAttribute("toDate",req.getParameter("to"));
        req.setAttribute("statusLabels",AdminOperationsPolicy.STATUS_LABELS);
        Object flash=req.getSession().getAttribute("adminOperationsFlash");
        req.getSession().removeAttribute("adminOperationsFlash"); req.setAttribute("successMessage",flash);
        Object error=req.getSession().getAttribute("adminOperationsError");
        req.getSession().removeAttribute("adminOperationsError"); req.setAttribute("errorMessage",error);
        try {
            var range=AdminOperationsPolicy.range(req.getParameter("from"),req.getParameter("to"),report?today.withDayOfMonth(1):today.minusDays(7),report?today:today.plusDays(30));
            req.setAttribute("fromDate",range.getFrom()); req.setAttribute("toDate",range.getTo());
            if(report) {
                var data=dao.report(range);
                if("csv".equals(req.getParameter("format"))) {
                    resp.setContentType("text/csv; charset=UTF-8");
                    resp.setHeader("Content-Disposition","attachment; filename=petcare-report-"+range.getFrom()+"-"+range.getTo()+".csv");
                    data.writeCsv(resp.getWriter()); return;
                }
                req.setAttribute("report",data);
            } else {
                String status=AdminOperationsPolicy.statusFilter(req.getParameter("status"));
                String type=AdminOperationsPolicy.typeFilter(req.getParameter("type"));
                String search=req.getParameter("q")==null?"":req.getParameter("q").trim();
                if(search.length()>100) throw new IllegalArgumentException("Từ khóa tìm kiếm tối đa 100 ký tự.");
                int page=req.getParameter("page")==null?1:positiveInt(req.getParameter("page"));
                req.setAttribute("statusFilter",status); req.setAttribute("typeFilter",type); req.setAttribute("query",search);
                req.setAttribute("pageData",dao.appointments(range,status,type,search,page));
                if(req.getParameter("id")!=null) {
                    var detail=dao.detail(positiveInt(req.getParameter("id")));
                    if(detail==null) { resp.sendError(404); return; }
                    req.setAttribute("detail",detail); req.setAttribute("nextStatuses",AdminOperationsPolicy.nextStates((String)detail.get("status")));
                }
            }
        } catch(IllegalArgumentException e) { resp.setStatus(400); req.setAttribute("errorMessage",e.getMessage()); }
        catch(SQLException e) { resp.setStatus(503); req.setAttribute("errorMessage",sqlMessage(e)); }
        req.getRequestDispatcher(report?"/WEB-INF/views/admin/reports.jsp":"/WEB-INF/views/admin/appointments.jsp").forward(req,resp);
    }
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8"); resp.setCharacterEncoding("UTF-8");
        if(!authorize(req,resp)) return;
        if(!"/admin/lich-hen".equals(req.getServletPath())) { resp.sendError(405); return; }
        Object token=req.getSession().getAttribute("adminCsrfToken");
        if(!(token instanceof String)||!token.equals(req.getParameter("csrfToken"))) { resp.sendError(403); return; }
        int id=0;
        try {
            if(!"status".equals(req.getParameter("action"))) throw new IllegalArgumentException("Hành động không hợp lệ.");
            id=positiveInt(req.getParameter("appointmentId"));
            String next=req.getParameter("status"),expected=req.getParameter("expectedStatus"),reason=req.getParameter("cancelReason");
            AdminOperationsPolicy.checkTransition(expected,next,reason);
            dao.changeStatus(SessionUtil.getCurrentUser(req).getUserId(),id,expected,next,reason);
            req.getSession().setAttribute("adminOperationsFlash","Đã cập nhật lịch hẹn #"+id+" thành "+AdminOperationsPolicy.STATUS_LABELS.get(next)+".");
        } catch(IllegalArgumentException e) { req.getSession().setAttribute("adminOperationsError",e.getMessage()); }
        catch(SQLException e) { req.getSession().setAttribute("adminOperationsError",sqlMessage(e)); }
        resp.sendRedirect(req.getContextPath()+"/admin/lich-hen"+(id>0?"?id="+id+"#appointment-detail":""));
    }
    private static int positiveInt(String value) {
        try { int id=Integer.parseInt(value); if(id>0) return id; } catch(NumberFormatException ignored) { }
        throw new IllegalArgumentException("Mã lịch hoặc số trang không hợp lệ.");
    }
    private static String sqlMessage(SQLException e) {
        return switch(e.getErrorCode()) {
            case 51022 -> "Không thể chuyển trạng thái. Lịch có thể vừa được cập nhật, vui lòng tải lại.";
            case 51036 -> "Lịch hẹn không tồn tại.";
            case 51037 -> "Vui lòng nhập lý do hủy lịch.";
            case 51014 -> "Chưa đủ điều kiện hoàn tất dịch vụ hoặc trả phòng.";
            case 1205 -> "Lịch đang được xử lý đồng thời. Vui lòng tải lại và thử lại.";
            default -> "Không thể truy cập hoặc cập nhật dữ liệu hệ thống. Vui lòng thử lại hoặc liên hệ quản trị triển khai.";
        };
    }
}
