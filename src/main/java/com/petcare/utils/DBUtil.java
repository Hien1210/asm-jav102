package com.petcare.utils;

import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBUtil {
    private DBUtil() { }

    /** Callers must close connections using try-with-resources. */
    public static Connection getConnection() throws SQLException {
        String host = ConfigUtil.get("db.host", "DB_HOST", "localhost");
        String port = ConfigUtil.get("db.port", "DB_PORT", "1433");
        String database = ConfigUtil.get("db.name", "DB_NAME", "PetCare");
        String url = ConfigUtil.get("db.url", "DB_URL", "");
        String user = ConfigUtil.get("db.username", "DB_USER",
                ConfigUtil.get("db.user", "DB_USER", ""));
        String password = ConfigUtil.get("db.password", "DB_PASSWORD", "");
        if (user.isBlank() || password.isEmpty()) {
            throw new SQLException("Set DB_USER and DB_PASSWORD or an external petcare.config file.");
        }
        Properties properties = new Properties();
        if (url.isBlank()) {
            url = "jdbc:sqlserver://";
            properties.setProperty("serverName", host);
            properties.setProperty("portNumber", port);
            properties.setProperty("databaseName", database);
            properties.setProperty("encrypt", "true");
            properties.setProperty("trustServerCertificate",
                    ConfigUtil.get("db.trustServerCertificate", "DB_TRUST_SERVER_CERTIFICATE", "false"));
        }
        properties.setProperty("user", user);
        properties.setProperty("password", password);
        properties.setProperty("loginTimeout", "15");
        properties.setProperty("socketTimeout", "15000");
        properties.setProperty("applicationName", "PetCare");
        String trustStore = ConfigUtil.get("db.trustStore", "DB_TRUST_STORE", "");
        if (!trustStore.isBlank()) {
            Path trustStorePath = Path.of(trustStore);
            Path fallbackPath = Path.of("certs", "petcare-truststore.p12");
            if (Files.isRegularFile(trustStorePath)) {
                properties.setProperty("trustStore", trustStorePath.toAbsolutePath().toString());
                properties.setProperty("trustStorePassword",
                        ConfigUtil.get("db.trustStorePassword", "DB_TRUST_STORE_PASSWORD", ""));
            } else if (Files.isRegularFile(fallbackPath)) {
                properties.setProperty("trustStore", fallbackPath.toAbsolutePath().toString());
                properties.setProperty("trustStorePassword",
                        ConfigUtil.get("db.trustStorePassword", "DB_TRUST_STORE_PASSWORD", ""));
            } else {
                properties.setProperty("trustServerCertificate", "true");
                url = url.replace("trustServerCertificate=false", "trustServerCertificate=true");
            }
        }
        // Explicit loading also works with Tomcat's web-application classloader.
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC driver is missing. Reload Maven dependencies.", e);
        }
        return DriverManager.getConnection(url, properties);
    }
}
