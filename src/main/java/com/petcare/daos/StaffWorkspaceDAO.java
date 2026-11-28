package com.petcare.daos;

import com.petcare.utils.DBUtil;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

/** Read-only supporting data. Payment mutations remain in PaymentDAOImpl/ConfirmCounterCash. */
public class StaffWorkspaceDAO {
    public List<Map<String,Object>> skills(int staffId) throws SQLException {
        return query("SELECT s.service_id,s.name,s.category FROM dbo.StaffSkills k JOIN dbo.Services s ON s.service_id=k.service_id WHERE k.staff_id=? ORDER BY s.name",staffId);
    }
    public List<Map<String,Object>> pendingCash(Integer appointmentId) throws SQLException {
        String sql="SELECT p.payment_id,p.appointment_id,p.amount,u.full_name customer_name,t.name pet_name,a.total_amount FROM dbo.Payments p JOIN dbo.Appointments a ON a.appointment_id=p.appointment_id JOIN dbo.Users u ON u.user_id=a.customer_id JOIN dbo.Pets t ON t.pet_id=a.pet_id WHERE p.method='CASH' AND p.payment_type='CHARGE' AND p.status='PENDING' AND a.status NOT IN ('DRAFT','CANCELLED','NO_SHOW')";
        return appointmentId==null?query(sql+" ORDER BY p.payment_id DESC"):query(sql+" AND p.appointment_id=? ORDER BY p.payment_id DESC",appointmentId);
    }
    public List<Map<String,Object>> cashHistory(LocalDate day) throws SQLException {
        return query("SELECT p.payment_id,p.appointment_id,p.amount,p.paid_at,u.full_name customer_name,t.name pet_name FROM dbo.Payments p JOIN dbo.Appointments a ON a.appointment_id=p.appointment_id JOIN dbo.Users u ON u.user_id=a.customer_id JOIN dbo.Pets t ON t.pet_id=a.pet_id WHERE p.method='CASH' AND p.payment_type='CHARGE' AND p.status='PAID' AND p.paid_at>=? AND p.paid_at<? ORDER BY p.paid_at DESC,p.payment_id DESC",day,day.plusDays(1));
    }
    private List<Map<String,Object>> query(String sql,Object... args) throws SQLException {
        try(Connection c=DBUtil.getConnection();PreparedStatement s=c.prepareStatement(sql)) {
            for(int i=0;i<args.length;i++) { Object value=args[i]; if(value instanceof LocalDate date)s.setDate(i+1,java.sql.Date.valueOf(date));else s.setObject(i+1,value); }
            try(ResultSet rs=s.executeQuery()) { List<Map<String,Object>> rows=new ArrayList<>();ResultSetMetaData meta=rs.getMetaData();while(rs.next()){Map<String,Object> row=new LinkedHashMap<>();for(int i=1;i<=meta.getColumnCount();i++)row.put(meta.getColumnLabel(i),rs.getObject(i));rows.add(row);}return rows; }
        }
    }
}
