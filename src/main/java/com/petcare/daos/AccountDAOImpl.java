package com.petcare.daos;

import com.petcare.models.Users;
import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class AccountDAOImpl implements AccountDAO {

    private Users mapRow(ResultSet rs, boolean includePasswordHash) throws SQLException {
        Users user = new Users();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        if (includePasswordHash) {
            user.setPasswordHash(rs.getString("password_hash"));
        }
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    @Override
    public List<Users> findAll() throws SQLException {
        List<Users> accounts = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.ListAccounts}");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                accounts.add(mapRow(rs, false));
            }
        }
        return accounts;
    }

    @Override
    public Users findById(int userId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.GetAccountById(?)}")) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs, false) : null;
            }
        }
    }

    @Override
    public Users findByIdentifierWithPasswordHash(String identifier) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.FindAccountByIdentifier(?)}")) {
            stmt.setString(1, identifier);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs, true) : null;
            }
        }
    }

    @Override
    public int create(Users account) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.CreateAccount(?,?,?,?,?,?)}")) {
            stmt.setString(1, account.getFullName());
            stmt.setString(2, account.getEmail());
            stmt.setString(3, account.getPhone());
            stmt.setString(4, account.getPasswordHash());
            stmt.setString(5, account.getRole());
            stmt.registerOutParameter(6, Types.INTEGER);
            stmt.execute();
            return stmt.getInt(6);
        }
    }

    @Override
    public void update(Users account) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.UpdateAccount(?,?,?,?,?)}")) {
            stmt.setInt(1, account.getUserId());
            stmt.setString(2, account.getFullName());
            stmt.setString(3, account.getEmail());
            stmt.setString(4, account.getPhone());
            stmt.setString(5, account.getRole());
            stmt.execute();
        }
    }

    @Override
    public void setActive(int userId, boolean active) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.SetAccountActive(?,?)}")) {
            stmt.setInt(1, userId);
            stmt.setBoolean(2, active);
            stmt.execute();
        }
    }

    @Override
    public void resetPassword(int userId, String passwordHash) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.ResetAccountPassword(?,?)}")) {
            stmt.setInt(1, userId);
            stmt.setString(2, passwordHash);
            stmt.execute();
        }
    }
}
