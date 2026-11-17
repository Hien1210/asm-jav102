package com.petcare.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public final class DatabaseConnectionTest {
    private DatabaseConnectionTest() { }

    public static void main(String[] args) {
        try (Connection connection = DBUtil.getConnection();
             Statement statement = connection.createStatement()) {
            statement.setQueryTimeout(5);
            try (ResultSet result = statement.executeQuery("SELECT 1")) {
                if (!result.next() || result.getInt(1) != 1) {
                    throw new SQLException("Unexpected connection test result.");
                }
            }
            System.out.println("Connected successfully to database: " + connection.getCatalog());
        } catch (SQLException e) {
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