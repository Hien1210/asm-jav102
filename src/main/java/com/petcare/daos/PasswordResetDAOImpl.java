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

public class PasswordResetDAOImpl implements PasswordResetDAO {

    @Override
    public void createToken(int userId, String tokenHash, LocalDateTime expiresAt) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.CreatePasswordResetToken(?, ?, ?)}")) {
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
                            "DELETE FROM dbo.PasswordResetTokens WHERE user_id = ? AND used_at IS NULL")) {
                        del.setInt(1, userId);
                        del.executeUpdate();
                    }
                    try (PreparedStatement ins = conn.prepareStatement(
                            "INSERT INTO dbo.PasswordResetTokens(user_id, token_hash, expires_at) VALUES (?, ?, ?)")) {
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
            try (CallableStatement cs = conn.prepareCall("{call dbo.ConsumePasswordResetToken(?, ?)}")) {
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
                            "SELECT user_id FROM dbo.PasswordResetTokens WITH (UPDLOCK, HOLDLOCK) "
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
                                "UPDATE dbo.PasswordResetTokens SET used_at = SYSDATETIME() WHERE token_hash = ?")) {
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
}
