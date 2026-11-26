package com.petcare.daos;

import com.petcare.models.Combos;
import com.petcare.models.Services;
import com.petcare.utils.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ComboDAOImpl implements ComboDAO {

    private static final String BASE_JOIN_SQL =
            "SELECT c.combo_id, c.name AS combo_name, c.description AS combo_desc, c.price AS combo_price, c.is_active AS combo_active, "
            + "s.service_id, s.name AS svc_name, s.description AS svc_desc, s.category, s.duration_minutes, s.price AS svc_price, s.is_active AS svc_active "
            + "FROM dbo.Combos c "
            + "LEFT JOIN dbo.ComboServices cs ON cs.combo_id = c.combo_id "
            + "LEFT JOIN dbo.Services s ON s.service_id = cs.service_id ";

    @Override
    public List<Combos> findActiveWithServices() throws SQLException {
        String sql = BASE_JOIN_SQL + "WHERE c.is_active = 1 ORDER BY c.price, c.combo_id, s.service_id";
        Map<Integer, Combos> map = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                accumulateJdbcRow(map, rs);
            }
            return filterNonEmpty(map);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                for (String[] cols : DBUtil.queryLocalSql(sql)) {
                    accumulateLocalRow(map, cols);
                }
                return filterNonEmpty(map);
            }
            throw e;
        }
    }

    @Override
    public Combos findByIdWithServices(int comboId) throws SQLException {
        String sql = BASE_JOIN_SQL + "WHERE c.combo_id = ? ORDER BY s.service_id";
        Map<Integer, Combos> map = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comboId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    accumulateJdbcRow(map, rs);
                }
            }
            return map.get(comboId);
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = BASE_JOIN_SQL + "WHERE c.combo_id = @p0 ORDER BY s.service_id";
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(comboId))) {
                    accumulateLocalRow(map, cols);
                }
                return map.get(comboId);
            }
            throw e;
        }
    }

    private void accumulateJdbcRow(Map<Integer, Combos> map, ResultSet rs) throws SQLException {
        int comboId = rs.getInt("combo_id");
        Combos combo = map.computeIfAbsent(comboId, id -> {
            Combos c = new Combos();
            c.setComboId(id);
            return c;
        });
        if (combo.getName() == null) {
            combo.setName(rs.getString("combo_name"));
            combo.setDescription(rs.getString("combo_desc"));
            combo.setPrice(rs.getBigDecimal("combo_price"));
            combo.setActive(rs.getBoolean("combo_active"));
        }
        int serviceId = rs.getInt("service_id");
        if (!rs.wasNull()) {
            Services svc = new Services();
            svc.setServiceId(serviceId);
            svc.setName(rs.getString("svc_name"));
            svc.setDescription(rs.getString("svc_desc"));
            svc.setCategory(rs.getString("category"));
            svc.setDurationMinutes(rs.getInt("duration_minutes"));
            svc.setPrice(rs.getBigDecimal("svc_price"));
            svc.setActive(rs.getBoolean("svc_active"));
            combo.getServices().add(svc);
        }
    }

    private void accumulateLocalRow(Map<Integer, Combos> map, String[] cols) {
        int comboId = Integer.parseInt(cols[0]);
        Combos combo = map.computeIfAbsent(comboId, id -> {
            Combos c = new Combos();
            c.setComboId(id);
            c.setName(cols[1]);
            c.setDescription(cols[2]);
            c.setPrice(new BigDecimal(cols[3]));
            c.setActive("1".equals(cols[4]) || "true".equalsIgnoreCase(cols[4]));
            return c;
        });
        if (cols[5] != null && !cols[5].isEmpty()) {
            Services svc = new Services();
            svc.setServiceId(Integer.parseInt(cols[5]));
            svc.setName(cols[6]);
            svc.setDescription(cols[7]);
            svc.setCategory(cols[8]);
            svc.setDurationMinutes(Integer.parseInt(cols[9]));
            svc.setPrice(new BigDecimal(cols[10]));
            svc.setActive("1".equals(cols[11]) || "true".equalsIgnoreCase(cols[11]));
            combo.getServices().add(svc);
        }
    }

    private List<Combos> filterNonEmpty(Map<Integer, Combos> map) {
        List<Combos> result = new ArrayList<>();
        for (Combos combo : map.values()) {
            if (!combo.getServices().isEmpty()) {
                result.add(combo);
            }
        }
        return result;
    }
}
