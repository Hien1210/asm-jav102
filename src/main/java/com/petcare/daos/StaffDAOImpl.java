package com.petcare.daos;

import com.petcare.models.StaffOption;
import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public List<StaffOption> findActiveStaffForService(int serviceId) throws SQLException {
        List<StaffOption> staff = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.ListActiveStaffForService(?)}")) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    staff.add(new StaffOption(rs.getInt("user_id"), rs.getString("full_name")));
                }
            }
        }
        return staff;
    }
}
