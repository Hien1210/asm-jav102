package com.petcare.daos;

import com.petcare.models.AdminReport;
import com.petcare.services.AdminOperationsPolicy;
import com.petcare.services.AdminOperationsPolicy.Range;
import com.petcare.utils.DBUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class AdminOperationsDAO {
    private static final int PAGE_SIZE=25;
    private static final String APPOINTMENTS_FROM=" FROM dbo.Appointments a JOIN dbo.Users u ON u.user_id=a.customer_id JOIN dbo.Pets p ON p.pet_id=a.pet_id "
            +"OUTER APPLY (SELECT MIN(scheduled_start) starts,MAX(scheduled_end) ends FROM dbo.AppointmentServices WHERE appointment_id=a.appointment_id) s "
            +"LEFT JOIN dbo.BoardingDetails b ON b.appointment_id=a.appointment_id "
            +"CROSS APPLY (SELECT COALESCE(s.starts,CAST(b.check_in_date AS DATETIME2),a.created_at) starts,COALESCE(s.ends,CAST(b.check_out_date AS DATETIME2),a.created_at) ends) d ";
    private static final String APPOINTMENTS_SELECT="SELECT a.appointment_id,a.customer_id,a.pet_id,a.appointment_type,a.status,a.cancel_reason,a.total_amount,a.created_at," 
            +"u.full_name customer_name,u.phone,u.email,p.name pet_name,p.species,d.starts,d.ends"+APPOINTMENTS_FROM;
    public Page appointments(Range range,String status,String type,String search,int requestedPage) throws SQLException {
        String where=" WHERE d.starts>=? AND d.starts<? AND (?='ALL' OR a.status=?) AND (?='ALL' OR a.appointment_type=?) "
                +"AND (?='' OR u.full_name LIKE ? ESCAPE '!' OR u.phone LIKE ? ESCAPE '!' OR p.name LIKE ? ESCAPE '!' OR CAST(a.appointment_id AS VARCHAR(20)) LIKE ? ESCAPE '!')";
        String like="%"+search.replace("!","!!").replace("%","!%").replace("_","!_").replace("[","![")+"%";
        List<Object> args=new ArrayList<>(List.of(range.getStart(),range.getUntil(),status,status,type,type,search,like,like,like,like));
        try(Connection c=DBUtil.getConnection()) {
            long total=((Number)query(c,"SELECT COUNT_BIG(*) total"+APPOINTMENTS_FROM+where,args.toArray()).get(0).get("total")).longValue();
            int pages=(int)Math.max(1,Math.min(Integer.MAX_VALUE,(total+PAGE_SIZE-1)/PAGE_SIZE));
            int page=Math.min(requestedPage,pages);
            args.add((long)(page-1)*PAGE_SIZE); args.add(PAGE_SIZE);
            var rows=query(c,APPOINTMENTS_SELECT+where+" ORDER BY d.starts DESC,a.appointment_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY",args.toArray());
            return new Page(rows,total,page,pages);
        }
    }
    public Map<String,Object> detail(int id) throws SQLException {
        try(Connection c=DBUtil.getConnection()) {
            var rows=query(c,APPOINTMENTS_SELECT+" WHERE a.appointment_id=?",id);
            if(rows.isEmpty()) return null;
            var detail=rows.get(0);
            detail.put("services",query(c,"SELECT s.service_id,v.name service_name,u.full_name staff_name,s.scheduled_start,s.scheduled_end,s.line_status,s.price_at_booking FROM dbo.AppointmentServices s JOIN dbo.Services v ON v.service_id=s.service_id JOIN dbo.Users u ON u.user_id=s.staff_id WHERE s.appointment_id=? ORDER BY s.scheduled_start",id));
            var boarding=query(c,"SELECT b.*,r.room_code,r.room_type FROM dbo.BoardingDetails b JOIN dbo.Rooms r ON r.room_id=b.room_id WHERE b.appointment_id=?",id);
            detail.put("boarding",boarding.isEmpty()?Map.of():boarding.get(0));
            detail.put("payments",query(c,"SELECT payment_id,amount,method,status,payment_type,paid_at,transaction_ref FROM dbo.Payments WHERE appointment_id=? ORDER BY payment_id DESC",id));
            return detail;
        }
    }
    public int changeStatus(int actorId,int id,String expected,String status,String reason) throws SQLException {
        try(Connection c=DBUtil.getConnection()) {
            c.setAutoCommit(false);
            try {
                var actor=query(c,"SELECT role,is_active FROM dbo.Users WITH (UPDLOCK,HOLDLOCK) WHERE user_id=?",actorId);
                if(actor.isEmpty()||!"ADMIN".equalsIgnoreCase((String)actor.get(0).get("role"))||!Boolean.TRUE.equals(actor.get(0).get("is_active")))
                    throw new IllegalArgumentException("Bạn không còn quyền quản trị đang hoạt động.");
                var rows=query(c,"SELECT status,customer_id FROM dbo.Appointments WITH (UPDLOCK,HOLDLOCK) WHERE appointment_id=?",id);
                if(rows.isEmpty()) throw new IllegalArgumentException("Lịch hẹn không tồn tại.");
                String current=(String)rows.get(0).get("status");
                if(!current.equals(expected)) throw new IllegalArgumentException("Trạng thái lịch đã thay đổi. Tải lại trang trước khi cập nhật.");
                AdminOperationsPolicy.checkTransition(current,status,reason);
                try(CallableStatement cs=c.prepareCall("{call dbo.SetAppointmentStatus(?,?,?)}")) {
                    cs.setInt(1,id); cs.setString(2,status); cs.setString(3,"CANCELLED".equals(status)?reason.trim():null); cs.execute();
                }
                c.commit(); return ((Number)rows.get(0).get("customer_id")).intValue();
            } catch(SQLException|RuntimeException e) { c.rollback(); throw e; }
        }
    }
    public AdminReport report(Range range) throws SQLException {
        try(Connection c=DBUtil.getConnection()) {
            Object[] bounds={range.getStart(),range.getUntil()};
            var bookings=query(c,"SELECT CONVERT(date,created_at) day,status,COUNT_BIG(*) total FROM dbo.Appointments WHERE created_at>=? AND created_at<? GROUP BY CONVERT(date,created_at),status",bounds);
            var payments=query(c,"SELECT CONVERT(date,paid_at) day,SUM(CASE WHEN payment_type='CHARGE' THEN amount ELSE 0 END) charges,SUM(CASE WHEN payment_type='REFUND' THEN amount ELSE 0 END) refunds FROM dbo.Payments WHERE status='PAID' AND paid_at>=? AND paid_at<? GROUP BY CONVERT(date,paid_at)",bounds);
            var services=query(c,"SELECT TOP(10) s.service_id,s.name,COUNT_BIG(*) uses FROM dbo.AppointmentServices l JOIN dbo.Services s ON s.service_id=l.service_id JOIN dbo.Appointments a ON a.appointment_id=l.appointment_id WHERE a.created_at>=? AND a.created_at<? AND a.status NOT IN ('DRAFT','CANCELLED','NO_SHOW') AND l.line_status<>'CANCELLED' GROUP BY s.service_id,s.name ORDER BY uses DESC,s.service_id",bounds);
            var counts=query(c,"SELECT (SELECT COUNT_BIG(*) FROM dbo.Users WHERE role='CUSTOMER' AND created_at>=? AND created_at<?) customers,(SELECT COUNT_BIG(*) FROM dbo.Pets WHERE created_at>=? AND created_at<?) pets",range.getStart(),range.getUntil(),range.getStart(),range.getUntil()).get(0);
            Map<String,Long> statuses=new LinkedHashMap<>();
            Map<LocalDate,Long> dailyBookings=new HashMap<>();
            for(var row:bookings) {
                long count=((Number)row.get("total")).longValue();
                statuses.merge((String)row.get("status"),count,Long::sum);
                dailyBookings.merge(((java.sql.Date)row.get("day")).toLocalDate(),count,Long::sum);
            }
            Map<LocalDate,Map<String,Object>> dailyPayments=new HashMap<>();
            for(var row:payments) dailyPayments.put(((java.sql.Date)row.get("day")).toLocalDate(),row);
            List<AdminReport.Day> days=new ArrayList<>();
            for(LocalDate day=range.getFrom();!day.isAfter(range.getTo());day=day.plusDays(1)) {
                var payment=dailyPayments.get(day);
                days.add(new AdminReport.Day(day,payment==null?BigDecimal.ZERO:(BigDecimal)payment.get("charges"),payment==null?BigDecimal.ZERO:(BigDecimal)payment.get("refunds"),dailyBookings.getOrDefault(day,0L)));
            }
            return new AdminReport(days,statuses,services,((Number)counts.get("customers")).longValue(),((Number)counts.get("pets")).longValue());
        }
    }
    private static List<Map<String,Object>> query(Connection c,String sql,Object...args) throws SQLException {
        try(PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setQueryTimeout(20);
            for(int i=0;i<args.length;i++) ps.setObject(i+1,args[i]);
            try(ResultSet rs=ps.executeQuery()) {
                List<Map<String,Object>> rows=new ArrayList<>();
                while(rs.next()) {
                    Map<String,Object> row=new LinkedHashMap<>();
                    for(int i=1;i<=rs.getMetaData().getColumnCount();i++) row.put(rs.getMetaData().getColumnLabel(i),rs.getObject(i));
                    rows.add(row);
                }
                return rows;
            }
        }
    }
    public static final class Page {
        private final List<Map<String,Object>> rows;
        private final long total;
        private final int page,pages;
        public Page(List<Map<String,Object>> rows,long total,int page,int pages) { this.rows=rows; this.total=total; this.page=page; this.pages=pages; }
        public List<Map<String,Object>> getRows() { return rows; }
        public long getTotal() { return total; }
        public int getPage() { return page; }
        public int getPages() { return pages; }
    }
}
