package com.petcare.daos;

import com.petcare.models.Users;
import com.petcare.utils.DBUtil;
import com.petcare.utils.ValidationUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class AccountDAOImpl implements AccountDAO {

    private static final String BASE_SELECT =
            "SELECT user_id, full_name, email, phone, password_hash, role, is_active, created_at FROM dbo.Users ";

    private Users mapRow(ResultSet rs) throws SQLException {
        Timestamp createdTs = rs.getTimestamp("created_at");
        return new Users(
                rs.getInt("user_id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("password_hash"),
                rs.getString("role"),
                rs.getBoolean("is_active"),
                createdTs != null ? createdTs.toLocalDateTime() : null
        );
    }

    @Override
    public Users findById(int userId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call dbo.GetAccountById(?)}")) {
            cs.setInt(1, userId);
            try (ResultSet rs = cs.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 2812) { // Stored procedure not found fallback
                String sql = BASE_SELECT + "WHERE user_id = ?";
                try (Connection conn = DBUtil.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        return rs.next() ? mapRow(rs) : null;
                    }
                }
            }
            throw e;
        }
    }

    @Override
    public Users findByEmail(String email) throws SQLException {
        String normalized = ValidationUtil.normalizeEmail(email);
        if (normalized.isEmpty()) {
            return null;
        }
        return findByIdentifierInternal(normalized);
    }

    @Override
    public Users findByPhone(String phone) throws SQLException {
        String normalized = ValidationUtil.normalizePhone(phone);
        if (normalized.isEmpty()) {
            return null;
        }
        Users user = findByIdentifierInternal(normalized);
        if (user != null) {
            return user;
        }
        return findByIdentifierInternal(phone.trim());
    }

    @Override
    public Users findByIdentifier(String identifier) throws SQLException {
        if (identifier == null || identifier.isBlank()) {
            return null;
        }
        String trimmed = identifier.trim();
        if (trimmed.contains("@")) {
            return findByEmail(trimmed);
        }
        Users byPhone = findByPhone(trimmed);
        if (byPhone != null) {
            return byPhone;
        }
        return findByIdentifierInternal(trimmed);
    }

    private Users findByIdentifierInternal(String identifier) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call dbo.FindAccountByIdentifier(?)}")) {
            cs.setString(1, identifier);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            if (e.getErrorCode() != 2812) {
                // Fall through to SELECT query if allowed
            }
        }

        String sql = BASE_SELECT + "WHERE LOWER(email) = LOWER(?) "
                + "OR REPLACE(REPLACE(REPLACE(phone, ' ', ''), '-', ''), '.', '') = ? "
                + "OR phone = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, ValidationUtil.normalizePhone(identifier));
            ps.setString(3, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public boolean existsByEmail(String email) throws SQLException {
        return findByEmail(email) != null;
    }

    @Override
    public boolean existsByPhone(String phone) throws SQLException {
        return findByPhone(phone) != null;
    }

    @Override
    public Users create(Users user) throws SQLException {
        String role = user.getRole() != null ? user.getRole() : Users.ROLE_CUSTOMER;
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call dbo.CreateAccount(?, ?, ?, ?, ?, ?)}")) {
            cs.setString(1, user.getFullName());
            cs.setString(2, user.getEmail());
            cs.setString(3, user.getPhone());
            cs.setString(4, user.getPasswordHash());
            cs.setString(5, role);
            cs.registerOutParameter(6, Types.INTEGER);
            cs.execute();
            int generatedId = cs.getInt(6);
            if (generatedId > 0) {
                user.setUserId(generatedId);
            }
            return user;
        } catch (SQLException e) {
            if (e.getErrorCode() == 2812) { // Stored procedure not found on local DB -> fallback to INSERT
                String sql = "INSERT INTO dbo.Users (full_name, email, phone, password_hash, role, is_active) "
                        + "VALUES (?, ?, ?, ?, ?, ?)";
                try (Connection conn = DBUtil.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, user.getFullName());
                    ps.setString(2, user.getEmail());
                    ps.setString(3, user.getPhone());
                    ps.setString(4, user.getPasswordHash());
                    ps.setString(5, role);
                    ps.setBoolean(6, user.isActive());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            user.setUserId(keys.getInt(1));
                        }
                    }
                    return user;
                }
            }
            throw e;
        }
    }

    @Override
    public boolean updateRoleAndStatus(int userId, String role, boolean isActive) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call dbo.SetAccountActive(?, ?)}")) {
            cs.setInt(1, userId);
            cs.setBoolean(2, isActive);
            cs.execute();
            return true;
        } catch (SQLException e) {
            String sql = "UPDATE dbo.Users SET role = ?, is_active = ? WHERE user_id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, role);
                ps.setBoolean(2, isActive);
                ps.setInt(3, userId);
                return ps.executeUpdate() > 0;
            }
        }
    }

    @Override
    public List<Users> findAll() throws SQLException {
        List<Users> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             CallableStatement cs = conn.prepareCall("{call dbo.ListAccounts()}");
             ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            String sql = BASE_SELECT + "ORDER BY created_at DESC";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
            return list;
        }
    }
}
