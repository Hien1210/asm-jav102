package com.petcare.daos;

import com.petcare.models.BusinessHours;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class BusinessHoursDAOImpl implements BusinessHoursDAO {

    @Override
    public List<BusinessHours> findAll() throws SQLException {
        List<BusinessHours> list = new ArrayList<>();
        String sql = "SELECT day_of_week, open_time, close_time, is_closed FROM dbo.BusinessHours ORDER BY day_of_week";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BusinessHours bh = new BusinessHours();
                bh.setDayOfWeek(rs.getInt("day_of_week"));
                Time open = rs.getTime("open_time");
                Time close = rs.getTime("close_time");
                bh.setOpenTime(open != null ? open.toLocalTime() : null);
                bh.setCloseTime(close != null ? close.toLocalTime() : null);
                bh.setClosed(rs.getBoolean("is_closed"));
                list.add(bh);
            }
            return list;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                for (String[] cols : DBUtil.queryLocalSql(sql)) {
                    BusinessHours bh = new BusinessHours();
                    bh.setDayOfWeek(Integer.parseInt(cols[0]));
                    bh.setOpenTime(DateUtil.parseLocalTime(cols[1]));
                    bh.setCloseTime(DateUtil.parseLocalTime(cols[2]));
                    bh.setClosed("1".equals(cols[3]) || "true".equalsIgnoreCase(cols[3]));
                    list.add(bh);
                }
                return list;
            }
            throw e;
        }
    }
}
