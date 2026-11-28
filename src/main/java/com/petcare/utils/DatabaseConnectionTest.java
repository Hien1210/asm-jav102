package com.petcare.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public final class DatabaseConnectionTest {
    private DatabaseConnectionTest() { }

    public static void main(String[] args) {
        try (Connection connection = DBUtil.getConnection();
             Statement statement = connection.createStatement()) {
            statement.setQueryTimeout(5);
            try (ResultSet result = statement.executeQuery("SELECT CONVERT(NVARCHAR(128),SERVERPROPERTY('ServerName')), DB_NAME(), COUNT(*) FROM dbo.Users")) {
                if (!result.next()) {
                    throw new SQLException("Unexpected connection test result.");
                }
                System.out.println("Connected via JDBC | server = " + result.getString(1)
                        + " | database = " + result.getString(2)
                        + " | dbo.Users count = " + result.getInt(3));
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                try {
                    List<String[]> rows = DBUtil.queryLocalSql("SELECT CONVERT(NVARCHAR(128),SERVERPROPERTY('ServerName')), DB_NAME(), COUNT(*) FROM dbo.Users");
                    if (!rows.isEmpty() && rows.get(0).length >= 3) {
                        System.out.println("Connected via LOCAL FALLBACK | server = "
                                + rows.get(0)[0] + " | database = " + rows.get(0)[1]
                                + " | dbo.Users count = " + rows.get(0)[2]);
                        return;
                    }
                } catch (SQLException localErr) {
                    System.err.println("Local fallback connection failed. SQLState=" + localErr.getSQLState()
                            + "; errorCode=" + localErr.getErrorCode() + "; msg=" + localErr.getMessage());
                }
            }
            System.err.println("Connection failed. SQLState=" + e.getSQLState()
                    + "; errorCode=" + e.getErrorCode());
            // Avoid printing credentials or connection properties.
            for (Throwable cause = e; cause != null; cause = cause.getCause()) {
                System.err.println("Cause type: " + cause.getClass().getSimpleName());
            }
            System.exit(1);
        }
    }
}
