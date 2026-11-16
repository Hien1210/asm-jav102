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
import java.time.LocalDateTime;
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

    private Users mapLocalRow(String[] cols) {
        LocalDateTime createdAt = (cols.length > 7 && cols[7] != null && !cols[7].isEmpty())
                ? LocalDateTime.parse(cols[7])
                : null;
        boolean active = "1".equals(cols[6]) || "true".equalsIgnoreCase(cols[6]);
        return new Users(
                Integer.parseInt(cols[0]),
                cols[1],
                cols[2],
                cols[3],
                cols[4],
                cols[5],
                active,
                createdAt
        );
    }

    @Override
    public Users findById(int userId) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.GetAccountById(?)}")) {
                cs.setInt(1, userId);
                try (ResultSet rs = cs.executeQuery()) {
                    return rs.next() ? mapRow(rs) : null;
                }
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = BASE_SELECT + "WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, userId);
                        try (ResultSet rs = ps.executeQuery()) {
                            return rs.next() ? mapRow(rs) : null;
                        }
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                List<String[]> rows = DBUtil.queryLocalSql(
                        "EXEC dbo.GetAccountById @user_id = @p0",
                        DBUtil.localIntParam(userId));
                return rows.isEmpty() ? null : mapLocalRow(rows.get(0));
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
        String trimmed = phone.trim();
        if (trimmed.equals(normalized)) {
            return null;
        }
        return findByIdentifierInternal(trimmed);
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
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.FindAccountByIdentifier(?)}")) {
                cs.setString(1, identifier);
                try (ResultSet rs = cs.executeQuery()) {
                    if (rs.next()) {
                        return mapRow(rs);
                    }
                }
            } catch (SQLException procErr) {
                if (DBUtil.isConnectionFailure(procErr)) {
                    throw procErr;
                }
                if (procErr.getErrorCode() != 2812 && procErr.getErrorCode() != 229) {
                    throw procErr;
                }
            }

            String sql = BASE_SELECT + "WHERE LOWER(email) = LOWER(?) "
                    + "OR REPLACE(REPLACE(REPLACE(ISNULL(phone, N''), ' ', ''), '-', ''), '.', '') = ? "
                    + "OR phone = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, identifier);
                ps.setString(2, ValidationUtil.normalizePhone(identifier));
                ps.setString(3, identifier);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next() ? mapRow(rs) : null;
                }
            } catch (SQLException selectErr) {
                // If dbo.FindAccountByIdentifier returned empty and direct SELECT is denied, treat as not found.
                if (selectErr.getErrorCode() == 229) {
                    return null;
                }
                throw selectErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                List<String[]> rows = DBUtil.queryLocalSql(
                        "EXEC dbo.FindAccountByIdentifier @identifier = @p0",
                        DBUtil.localStringParam(identifier));
                return rows.isEmpty() ? null : mapLocalRow(rows.get(0));
            }
            throw e;
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
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.CreateAccount(?, ?, ?, ?, ?, ?)}")) {
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
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "INSERT INTO dbo.Users (full_name, email, phone, password_hash, role, is_active) "
                            + "VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                int generatedId = DBUtil.executeLocalScalarInt(
                        "DECLARE @uid INT; "
                        + "EXEC dbo.CreateAccount @full_name = @p0, @email = @p1, @phone = @p2, "
                        + "@password_hash = @p3, @role = @p4, @user_id = @uid OUTPUT; "
                        + "SELECT @uid;",
                        DBUtil.localStringParam(user.getFullName()),
                        DBUtil.localStringParam(user.getEmail()),
                        DBUtil.localStringParam(user.getPhone()),
                        DBUtil.localStringParam(user.getPasswordHash()),
                        DBUtil.localStringParam(role));
                if (generatedId > 0) {
                    user.setUserId(generatedId);
                }
                return user;
            }
            throw e;
        }
    }

    @Override
    public boolean updateRoleAndStatus(int userId, String role, boolean isActive) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try {
                String sql = "UPDATE dbo.Users SET role = ?, is_active = ? WHERE user_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, role);
                    ps.setBoolean(2, isActive);
                    ps.setInt(3, userId);
                    return ps.executeUpdate() > 0;
                }
            } catch (SQLException updateErr) {
                if (updateErr.getErrorCode() == 229) {
                    try (CallableStatement cs = conn.prepareCall("{call dbo.SetAccountActive(?, ?)}")) {
                        cs.setInt(1, userId);
                        cs.setBoolean(2, isActive);
                        cs.execute();
                        return true;
                    }
                }
                throw updateErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                int affected = DBUtil.executeLocalNonQuery(
                        "UPDATE dbo.Users SET role = @p0, is_active = @p1 WHERE user_id = @p2",
                        DBUtil.localStringParam(role),
                        DBUtil.localBoolParam(isActive),
                        DBUtil.localIntParam(userId));
                return affected > 0;
            }
            throw e;
        }
    }

    @Override
    public boolean updateProfile(Users user) throws SQLException {
        String role = user.getRole() != null ? user.getRole() : Users.ROLE_CUSTOMER;
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.UpdateAccount(?, ?, ?, ?, ?)}")) {
                cs.setInt(1, user.getUserId());
                cs.setString(2, user.getFullName());
                cs.setString(3, user.getEmail());
                cs.setString(4, user.getPhone());
                cs.setString(5, role);
                cs.execute();
                return true;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "UPDATE dbo.Users SET full_name = ?, email = ?, phone = ?, role = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, user.getFullName());
                        ps.setString(2, user.getEmail());
                        ps.setString(3, user.getPhone());
                        ps.setString(4, role);
                        ps.setInt(5, user.getUserId());
                        return ps.executeUpdate() > 0;
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                int affected = DBUtil.executeLocalScalarInt(
                        "EXEC dbo.UpdateAccount @user_id = @p0, @full_name = @p1, "
                        + "@email = @p2, @phone = @p3, @role = @p4; SELECT @@ROWCOUNT;",
                        DBUtil.localIntParam(user.getUserId()),
                        DBUtil.localStringParam(user.getFullName()),
                        DBUtil.localStringParam(user.getEmail()),
                        DBUtil.localStringParam(user.getPhone()),
                        DBUtil.localStringParam(role));
                return affected > 0;
            }
            throw e;
        }
    }

    @Override
    public boolean updatePassword(int userId, String passwordHash) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.ResetAccountPassword(?, ?)}")) {
                cs.setInt(1, userId);
                cs.setString(2, passwordHash);
                cs.execute();
                return true;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "UPDATE dbo.Users SET password_hash = ? WHERE user_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, passwordHash);
                        ps.setInt(2, userId);
                        return ps.executeUpdate() > 0;
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                int affected = DBUtil.executeLocalScalarInt(
                        "EXEC dbo.ResetAccountPassword @user_id = @p0, @password_hash = @p1; SELECT @@ROWCOUNT;",
                        DBUtil.localIntParam(userId),
                        DBUtil.localStringParam(passwordHash));
                return affected > 0;
            }
            throw e;
        }
    }

    @Override
    public List<Users> findAll() throws SQLException {
        List<Users> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.ListAccounts()}");
                 ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = BASE_SELECT + "ORDER BY created_at DESC";
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            list.add(mapRow(rs));
                        }
                    }
                    return list;
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                List<String[]> rows = DBUtil.queryLocalSql("EXEC dbo.ListAccounts");
                for (String[] cols : rows) {
                    list.add(mapLocalRow(cols));
                }
                return list;
            }
            throw e;
        }
    }
}
