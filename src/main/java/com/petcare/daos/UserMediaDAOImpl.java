package com.petcare.daos;

import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

public class UserMediaDAOImpl implements UserMediaDAO {

    private static final String SQL_SELECT =
            "SELECT avatar_url, banner_url FROM dbo.UserMedia WHERE user_id = ?";
    private static final String SQL_SELECT_LOCAL =
            "SELECT avatar_url, banner_url FROM dbo.UserMedia WHERE user_id = @p0";

    private static final String SQL_UPSERT_AVATAR_LOCAL =
            "IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = @p0) "
            + "UPDATE dbo.UserMedia SET avatar_url = @p1, updated_at = SYSDATETIME() WHERE user_id = @p0 "
            + "ELSE INSERT INTO dbo.UserMedia (user_id, avatar_url, updated_at) VALUES (@p0, @p1, SYSDATETIME())";

    private static final String SQL_UPSERT_BANNER_LOCAL =
            "IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = @p0) "
            + "UPDATE dbo.UserMedia SET banner_url = @p1, updated_at = SYSDATETIME() WHERE user_id = @p0 "
            + "ELSE INSERT INTO dbo.UserMedia (user_id, banner_url, updated_at) VALUES (@p0, @p1, SYSDATETIME())";

    private static final String SQL_UPSERT_AVATAR_JDBC =
            "IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = ?) "
            + "UPDATE dbo.UserMedia SET avatar_url = ?, updated_at = SYSDATETIME() WHERE user_id = ? "
            + "ELSE INSERT INTO dbo.UserMedia (user_id, avatar_url, updated_at) VALUES (?, ?, SYSDATETIME())";

    private static final String SQL_UPSERT_BANNER_JDBC =
            "IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = ?) "
            + "UPDATE dbo.UserMedia SET banner_url = ?, updated_at = SYSDATETIME() WHERE user_id = ? "
            + "ELSE INSERT INTO dbo.UserMedia (user_id, banner_url, updated_at) VALUES (?, ?, SYSDATETIME())";

    @Override
    public String[] findByUserId(int userId) {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall("{call dbo.GetUserMedia(?)}")) {
                cs.setInt(1, userId);
                try (ResultSet rs = cs.executeQuery()) {
                    if (rs.next()) {
                        return new String[]{normalizeBlank(rs.getString("avatar_url")),
                                normalizeBlank(rs.getString("banner_url"))};
                    }
                    return new String[]{null, null};
                }
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() != 2812 && procErr.getErrorCode() != 229) {
                    throw procErr;
                }
                try (PreparedStatement ps = conn.prepareStatement(SQL_SELECT)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new String[]{normalizeBlank(rs.getString("avatar_url")),
                                    normalizeBlank(rs.getString("banner_url"))};
                        }
                        return new String[]{null, null};
                    }
                }
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                try {
                    List<String[]> rows = DBUtil.queryLocalSql(SQL_SELECT_LOCAL, DBUtil.localIntParam(userId));
                    if (!rows.isEmpty() && rows.get(0).length >= 2) {
                        return new String[]{normalizeBlank(rows.get(0)[0]), normalizeBlank(rows.get(0)[1])};
                    }
                } catch (SQLException ignored) {
                    // Fail-open when dbo.UserMedia migration has not been applied yet.
                }
            }
            return new String[]{null, null};
        }
    }

    @Override
    public void updateAvatarUrl(int userId, String avatarUrl) throws SQLException {
        upsertField(userId, normalizeBlank(avatarUrl),
                "{call dbo.UpsertUserAvatar(?, ?)}",
                SQL_UPSERT_AVATAR_JDBC,
                SQL_UPSERT_AVATAR_LOCAL);
    }

    @Override
    public void updateBannerUrl(int userId, String bannerUrl) throws SQLException {
        upsertField(userId, normalizeBlank(bannerUrl),
                "{call dbo.UpsertUserBanner(?, ?)}",
                SQL_UPSERT_BANNER_JDBC,
                SQL_UPSERT_BANNER_LOCAL);
    }

    private void upsertField(int userId, String url, String procSql, String jdbcFallbackSql, String localSql)
            throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement cs = conn.prepareCall(procSql)) {
                cs.setInt(1, userId);
                if (url == null) {
                    cs.setNull(2, Types.NVARCHAR);
                } else {
                    cs.setString(2, url);
                }
                cs.execute();
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() != 2812 && procErr.getErrorCode() != 229) {
                    throw procErr;
                }
                try (PreparedStatement ps = conn.prepareStatement(jdbcFallbackSql)) {
                    ps.setInt(1, userId);
                    if (url == null) {
                        ps.setNull(2, Types.NVARCHAR);
                        ps.setInt(3, userId);
                        ps.setInt(4, userId);
                        ps.setNull(5, Types.NVARCHAR);
                    } else {
                        ps.setString(2, url);
                        ps.setInt(3, userId);
                        ps.setInt(4, userId);
                        ps.setString(5, url);
                    }
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(localSql, DBUtil.localIntParam(userId), DBUtil.localStringParam(url));
                return;
            }
            if (e.getErrorCode() == 208) {
                throw new SQLException(
                        "Bảng dbo.UserMedia chưa tồn tại trong cơ sở dữ liệu. Vui lòng chạy script database/petcare_user_media.sql.",
                        e.getSQLState(), e.getErrorCode(), e);
            }
            throw e;
        }
    }

    private static String normalizeBlank(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }
}
