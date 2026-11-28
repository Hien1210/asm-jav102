package com.petcare.controllers;

import com.petcare.daos.PaymentDAOImpl;
import com.petcare.daos.StaffWorkspaceDAO;
import com.petcare.utils.DateUtil;
import java.math.BigDecimal;
import com.petcare.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/staff/thu-tien")
public class ThuTienMatServlet extends HttpServlet {
    private final PaymentDAOImpl payments = new PaymentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointment = request.getParameter("appointmentId");
        if (appointment != null) {
            try {
                int appointmentId = positiveId(appointment);
                request.setAttribute("appointmentId", appointmentId);
                request.setAttribute("pendingCash", payments.findByAppointment(appointmentId).stream()
                        .filter(p -> "CASH".equals(p.getMethod()) && "CHARGE".equals(p.getPaymentType())
                                && "PENDING".equals(p.getStatus()))
                        .toList());
            } catch (IllegalArgumentException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                request.setAttribute("error", "Mã lịch hẹn không hợp lệ.");
            } catch (SQLException e) {
                log("Could not load counter cash payments", e);
                response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                request.setAttribute("error", "Không thể tải khoản thu. Vui lòng thử lại.");
            }
        }
        var session = request.getSession(false);
        if (session != null) {
            request.setAttribute("cashReceipt", session.getAttribute("cashReceipt"));
            session.removeAttribute("cashReceipt");
        }
        response.setHeader("Cache-Control", "no-store");
        try {
            StaffWorkspaceDAO workspace=new StaffWorkspaceDAO();
            Integer selected=(Integer)request.getAttribute("appointmentId");
            var rows=workspace.pendingCash(selected);
            var history=workspace.cashHistory(DateUtil.todayVn());
            request.setAttribute("pendingCashRows",rows);
            request.setAttribute("cashHistory",history);
            request.setAttribute("cashPendingTotal",rows.stream().map(r->(BigDecimal)r.get("amount")).reduce(BigDecimal.ZERO,BigDecimal::add));
            request.setAttribute("cashPaidTotal",history.stream().map(r->(BigDecimal)r.get("amount")).reduce(BigDecimal.ZERO,BigDecimal::add));
            request.setAttribute("cashLoaded",true);
        } catch(SQLException e) {
            log("Could not load cash workspace",e);
            request.setAttribute("cashWorkspaceError","Không tải được tổng quan thu tiền. Vui lòng thử lại.");
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/thuTienMat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int paymentId = positiveId(request.getParameter("paymentId"));
            int appointmentId = positiveId(request.getParameter("appointmentId"));
            payments.confirmCounterCash(paymentId, SessionUtil.getCurrentUser(request).getUserId(), appointmentId);
            request.getSession(false).setAttribute("cashReceipt", paymentId);
            response.sendRedirect(request.getContextPath() + "/staff/thu-tien?appointmentId=" + appointmentId);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã giao dịch hoặc lịch hẹn không hợp lệ.");
        } catch (SQLException e) {
            if (e.getErrorCode() == 51042 || e.getErrorCode() == 51043) {
                response.sendError(HttpServletResponse.SC_CONFLICT, "Khoản thu này không thể xác nhận.");
            } else {
                log("Could not confirm counter cash payment", e);
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Không thể xác nhận khoản thu. Vui lòng thử lại.");
            }
        }
    }

    private int positiveId(String value) {
        int id = Integer.parseInt(value);
        if (id <= 0) {
            throw new IllegalArgumentException();
        }
        return id;
    }
}
