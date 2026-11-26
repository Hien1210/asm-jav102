package com.petcare.daos;

import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;

public class EmailVerificationDAOImpl implements EmailVerificationDAO {

    @Override
    public void createToken(int userId, String tokenHash, LocalDateTime expiresAt) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.CreateEmailVerificationToken(?, ?, ?)}")) {
                cs.setInt(1, userId);
                cs.setString(2, tokenHash);
                cs.setTimestamp(3, Timestamp.valueOf(expiresAt));
                cs.execute();
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() != 2812 && procErr.getErrorCode() != 229) {
                    throw procErr;
                }
                conn.setAutoCommit(false);
                try {
                    try (PreparedStatement del = conn.prepareStatement(
                            "DELETE FROM dbo.EmailVerificationTokens WHERE user_id = ? AND used_at IS NULL")) {
                        del.setInt(1, userId);
                        del.executeUpdate();
                    }
                    try (PreparedStatement ins = conn.prepareStatement(
                            "INSERT INTO dbo.EmailVerificationTokens(user_id, token_hash, expires_at) VALUES (?, ?, ?)")) {
                        ins.setInt(1, userId);
                        ins.setString(2, tokenHash);
                        ins.setTimestamp(3, Timestamp.valueOf(expiresAt));
                        ins.executeUpdate();
                    }
                    conn.commit();
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        }
    }

    @Override
    public Integer consumeToken(String tokenHash) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.ConsumeEmailVerificationToken(?, ?)}")) {
                cs.setString(1, tokenHash);
                cs.registerOutParameter(2, Types.INTEGER);
                cs.execute();
                int userId = cs.getInt(2);
                return cs.wasNull() ? null : userId;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() != 2812 && procErr.getErrorCode() != 229) {
                    throw procErr;
                }
                conn.setAutoCommit(false);
                try {
                    Integer userId = null;
                    try (PreparedStatement select = conn.prepareStatement(
                            "SELECT user_id FROM dbo.EmailVerificationTokens WITH (UPDLOCK, HOLDLOCK) "
                            + "WHERE token_hash = ? AND used_at IS NULL AND expires_at > SYSDATETIME()")) {
                        select.setString(1, tokenHash);
                        try (ResultSet rs = select.executeQuery()) {
                            if (rs.next()) {
                                userId = rs.getInt("user_id");
                            }
                        }
                    }
                    if (userId != null) {
                        try (PreparedStatement update = conn.prepareStatement(
                                "UPDATE dbo.EmailVerificationTokens SET used_at = SYSDATETIME() WHERE token_hash = ?")) {
                            update.setString(1, tokenHash);
                            update.executeUpdate();
                        }
                    }
                    conn.commit();
                    return userId;
                } catch (SQLException e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
                }
            }
        }
    }

    @Override
    public boolean hasPendingVerification(int userId) {
        // Fail-open: if the table/migration isn't there yet, or the DB hiccups,
        // never let this check be the reason a login fails.
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT 1 FROM dbo.EmailVerificationTokens "
                     + "WHERE user_id = ? AND used_at IS NULL AND expires_at > SYSDATETIME()")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }
}
