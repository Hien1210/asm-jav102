package com.petcare.daos;

import com.petcare.services.AdminModule;
import com.petcare.utils.DBUtil;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

/** Administration writes use a single connection/transaction, including combo membership. */
public class AdminCatalogDAO {
    public List<Map<String,Object>> list(AdminModule module) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            return query(c,"SELECT * FROM dbo."+module.getTable()+" ORDER BY "+module.getId()+" DESC");
        }
    }
    public Map<String,Object> find(AdminModule module, int id) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            List<Map<String,Object>> rows=query(c,"SELECT * FROM dbo."+module.getTable()+" WHERE "+module.getId()+"=?",id);
            return rows.isEmpty()?null:rows.get(0);
        }
    }
    public List<Map<String,Object>> users(String role) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            return query(c,"SELECT user_id, full_name, email FROM dbo.Users WHERE role=? ORDER BY full_name",role);
        }
    }
    public List<Integer> comboServices(int id) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            List<Integer> ids=new ArrayList<>();
            for (var row:query(c,"SELECT service_id FROM dbo.ComboServices WHERE combo_id=?",id)) ids.add((Integer)row.get("service_id"));
            return ids;
        }
    }
    public int save(AdminModule m, Integer id, Map<String,Object> values, List<Integer> services) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            c.setAutoCommit(false);
            try {
                if (m==AdminModule.SHIFTS) requireRole(c,(Integer)values.get("staff_id"),"STAFF");
                if (m==AdminModule.PETS) requireRole(c,(Integer)values.get("owner_id"),"CUSTOMER");
                if (m==AdminModule.COMBOS) {
                    if (services.isEmpty()) throw new IllegalArgumentException("Combo cần ít nhất một dịch vụ.");
                    for (int service:services) {
                        if (query(c,"SELECT service_id FROM dbo.Services WHERE service_id=? AND category<>'BOARDING' AND is_active=1",service).isEmpty())
                            throw new IllegalArgumentException("Combo chỉ nhận dịch vụ đang hoạt động, không thuộc lưu trú.");
                    }
                }
                String placeholders=java.util.stream.IntStream.range(0,values.size()+2).mapToObj(i->"?").collect(Collectors.joining(","));
                try (CallableStatement ps=c.prepareCall("{call dbo.AdminSave"+m.getTable()+"("+placeholders+")}")) {
                    if(id==null) ps.setNull(1,Types.INTEGER); else ps.setInt(1,id);
                    int index=2;
                    for(Object value:values.values()) ps.setObject(index++,value);
                    ps.registerOutParameter(index,Types.INTEGER);
                    ps.execute(); id=ps.getInt(index);
                    if(id<=0) throw new SQLException("Missing generated identifier");
                }
                if(m==AdminModule.COMBOS) {
                    try(CallableStatement ps=c.prepareCall("{call dbo.AdminSetComboServices(?,?)}")) {
                        ps.setInt(1,id);
                        ps.setString(2,services.stream().map(String::valueOf).collect(Collectors.joining(",","[","]")));
                        ps.execute();
                    }
                }
                c.commit(); return id;
            } catch (SQLException|RuntimeException e) { c.rollback(); throw e; }
        }
    }
    public void delete(AdminModule m,int id) throws SQLException {
        try (Connection c=DBUtil.getConnection()) {
            c.setAutoCommit(false);
            try {
                try(CallableStatement ps=c.prepareCall("{call dbo.AdminDelete"+m.getTable()+"(?)}")) {
                    ps.setInt(1,id); ps.execute();
                }
                c.commit();
            } catch (SQLException|RuntimeException e) { c.rollback(); throw e; }
        }
    }
    private void requireRole(Connection c,int id,String role) throws SQLException {
        if (query(c,"SELECT user_id FROM dbo.Users WHERE user_id=? AND role=? AND is_active=1",id,role).isEmpty())
            throw new IllegalArgumentException("Vui lòng chọn tài khoản đang hoạt động, đúng vai trò.");
    }
    private static void bind(PreparedStatement ps,Object...args) throws SQLException {
        for(int i=0;i<args.length;i++) ps.setObject(i+1,args[i]);
    }
    private static List<Map<String,Object>> query(Connection c,String sql,Object...args) throws SQLException {
        try (PreparedStatement ps=c.prepareStatement(sql)) {
            bind(ps,args);
            try (ResultSet rs=ps.executeQuery()) {
                List<Map<String,Object>> rows=new ArrayList<>();
                while(rs.next()) {
                    Map<String,Object> row=new LinkedHashMap<>();
                    for(int i=1;i<=rs.getMetaData().getColumnCount();i++) {
                        Object value=rs.getObject(i);
                        row.put(rs.getMetaData().getColumnLabel(i),value instanceof Boolean ? ((Boolean)value?1:0) : value);
                    }
                    rows.add(row);
                }
                return rows;
            }
        }
    }
}
