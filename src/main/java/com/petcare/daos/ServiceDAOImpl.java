package com.petcare.daos;

import com.petcare.models.Services;
import com.petcare.utils.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAOImpl implements ServiceDAO {

    private Services mapRow(ResultSet rs) throws SQLException {
        Services service = new Services();
        service.setServiceId(rs.getInt("service_id"));
        service.setName(rs.getString("name"));
        service.setDescription(rs.getString("description"));
        service.setCategory(rs.getString("category"));
        service.setDurationMinutes(rs.getInt("duration_minutes"));
        service.setPrice(rs.getBigDecimal("price"));
        service.setActive(rs.getBoolean("is_active"));
        return service;
    }

    private Services mapLocalRow(String[] cols) {
        Services service = new Services();
        service.setServiceId(Integer.parseInt(cols[0]));
        service.setName(cols[1]);
        service.setDescription(cols[2]);
        service.setCategory(cols[3]);
        service.setDurationMinutes(Integer.parseInt(cols[4]));
        service.setPrice(new BigDecimal(cols[5]));
        service.setActive("1".equals(cols[6]) || "true".equalsIgnoreCase(cols[6]));
        return service;
    }

    @Override
    public List<Services> findActiveBookable() throws SQLException {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT service_id, name, description, category, duration_minutes, price, is_active "
                + "FROM dbo.Services WHERE is_active = 1 AND category <> 'BOARDING' ORDER BY category, name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                services.add(mapRow(rs));
            }
            return services;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                for (String[] cols : DBUtil.queryLocalSql(sql)) {
                    services.add(mapLocalRow(cols));
                }
                return services;
            }
            throw e;
        }
    }

    @Override
    public Services findById(int serviceId) throws SQLException {
        String sql = "SELECT service_id, name, description, category, duration_minutes, price, is_active "
                + "FROM dbo.Services WHERE service_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = "SELECT service_id, name, description, category, duration_minutes, price, is_active "
                        + "FROM dbo.Services WHERE service_id = @p0";
                List<String[]> rows = DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(serviceId));
                return rows.isEmpty() ? null : mapLocalRow(rows.get(0));
            }
            throw e;
        }
    }
}
