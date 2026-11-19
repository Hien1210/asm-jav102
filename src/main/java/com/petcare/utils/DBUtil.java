package com.petcare.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

public final class DBUtil {
    private static final long TCP_CIRCUIT_BREAKER_MS = 10 * 60_000L;
    private static final String DEFAULT_LOCAL_CONN =
            "Server=localhost\\SQLEXPRESS;Database=PetCare;Integrated Security=True;TrustServerCertificate=True";
    private static final String LOCAL_PS_SCRIPT = String.join("\n",
            "[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)",
            "$ErrorActionPreference = 'Stop'",
            "$connStr = $env:PETCARE_LOCAL_CONN",
            "$sql = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:PETCARE_SQL_B64))",
            "$mode = $env:PETCARE_MODE",
            "$paramCount = [int]$env:PETCARE_PARAM_COUNT",
            "$conn = New-Object System.Data.SqlClient.SqlConnection($connStr)",
            "try {",
            "    $conn.Open()",
            "    $cmd = $conn.CreateCommand()",
            "    $cmd.CommandText = $sql",
            "    for ($i = 0; $i -lt $paramCount; $i++) {",
            "        $raw = [Environment]::GetEnvironmentVariable(\"PETCARE_P_$i\")",
            "        $sep = $raw.IndexOf(':')",
            "        $kind = $raw.Substring(0, $sep)",
            "        $valStr = $raw.Substring($sep + 1)",
            "        $p = $cmd.CreateParameter()",
            "        $p.ParameterName = \"@p$i\"",
            "        if ($kind -eq 'N') {",
            "            $p.Value = [DBNull]::Value",
            "        } elseif ($kind -eq 'I') {",
            "            $p.Value = [int]$valStr",
            "        } elseif ($kind -eq 'B') {",
            "            $p.Value = ($valStr -eq '1')",
            "        } else {",
            "            $p.Value = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($valStr))",
            "        }",
            "        [void]$cmd.Parameters.Add($p)",
            "    }",
            "    if ($mode -eq 'QUERY') {",
            "        $r = $cmd.ExecuteReader()",
            "        while ($r.Read()) {",
            "            $cols = New-Object System.Collections.Generic.List[string]",
            "            for ($c = 0; $c -lt $r.FieldCount; $c++) {",
            "                if ($r.IsDBNull($c)) {",
            "                    $cols.Add('N:')",
            "                } else {",
            "                    $v = $r.GetValue($c)",
            "                    if ($v -is [DateTime]) {",
            "                        $s = $v.ToString('yyyy-MM-ddTHH:mm:ss.fffffff')",
            "                    } elseif ($v -is [bool]) {",
            "                        $s = if ($v) { '1' } else { '0' }",
            "                    } else {",
            "                        $s = $v.ToString()",
            "                    }",
            "                    $b64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($s))",
            "                    $cols.Add(\"V:$b64\")",
            "                }",
            "            }",
            "            [Console]::Out.WriteLine('ROW:' + ($cols -join '|'))",
            "        }",
            "        $r.Close()",
            "    } elseif ($mode -eq 'SCALAR_INT') {",
            "        $res = $cmd.ExecuteScalar()",
            "        if ($null -eq $res -or $res -is [DBNull]) {",
            "            [Console]::Out.WriteLine('SCALAR:0')",
            "        } else {",
            "            [Console]::Out.WriteLine('SCALAR:' + [Convert]::ToInt32($res))",
            "        }",
            "    } else {",
            "        $affected = $cmd.ExecuteNonQuery()",
            "        [Console]::Out.WriteLine('AFFECTED:' + $affected)",
            "    }",
            "} catch {",
            "    $ex = $_.Exception",
            "    $sqlEx = $null",
            "    while ($null -ne $ex) {",
            "        if ($ex -is [System.Data.SqlClient.SqlException]) {",
            "            $sqlEx = $ex",
            "            break",
            "        }",
            "        $ex = $ex.InnerException",
            "    }",
            "    if ($null -ne $sqlEx) {",
            "        $b64Msg = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($sqlEx.Message))",
            "        [Console]::Out.WriteLine(\"SQLERR:$($sqlEx.Number):$b64Msg\")",
            "        exit 2",
            "    } else {",
            "        $b64Msg = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($_.Exception.Message))",
            "        [Console]::Out.WriteLine(\"ERR:$b64Msg\")",
            "        exit 1",
            "    }",
            "} finally {",
            "    if ($conn.State -ne 'Closed') {",
            "        $conn.Close()",
            "    }",
            "}"
    );
    private static final String ENCODED_PS_SCRIPT = Base64.getEncoder()
            .encodeToString(LOCAL_PS_SCRIPT.getBytes(StandardCharsets.UTF_16LE));

    private static volatile long lastTcpFailureMs = 0L;

    private DBUtil() { }

    /** Callers must close connections using try-with-resources. */
    public static Connection getConnection() throws SQLException {
        long failedAt = lastTcpFailureMs;
        if (failedAt > 0L && (System.currentTimeMillis() - failedAt) < TCP_CIRCUIT_BREAKER_MS) {
            throw new SQLException("Remote SQL Server TCP/IP host is unreachable (circuit breaker active).", "08S01");
        }

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
        properties.setProperty("loginTimeout", "1");
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
        try {
            Connection conn = DriverManager.getConnection(url, properties);
            lastTcpFailureMs = 0L;
            return conn;
        } catch (SQLException e) {
            if (isConnectionFailure(e)) {
                lastTcpFailureMs = System.currentTimeMillis();
            }
            throw e;
        }
    }

    public static boolean isConnectionFailure(SQLException e) {
        if (e == null) {
            return false;
        }
        String state = e.getSQLState();
        if (state != null && state.startsWith("08")) {
            return true;
        }
        String msg = e.getMessage();
        if (msg == null) {
            return false;
        }
        String lower = msg.toLowerCase(Locale.ROOT);
        return lower.contains("connect timed out")
                || lower.contains("tcp/ip connection to the host")
                || lower.contains("connection refused")
                || lower.contains("circuit breaker")
                || lower.contains("communications link failure")
                || lower.contains("sockettimeoutexception")
                || lower.contains("trustanchors");
    }

    public static String localStringParam(String value) {
        if (value == null) {
            return "N:";
        }
        return "S:" + Base64.getEncoder().encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }

    public static String localIntParam(int value) {
        return "I:" + value;
    }

    public static String localBoolParam(boolean value) {
        return value ? "B:1" : "B:0";
    }

    public static List<String[]> queryLocalSql(String sql, String... encodedParams) throws SQLException {
        return runLocalPowerShell("QUERY", sql, encodedParams).rows;
    }

    public static int executeLocalScalarInt(String sql, String... encodedParams) throws SQLException {
        return runLocalPowerShell("SCALAR_INT", sql, encodedParams).scalarOrAffected;
    }

    public static int executeLocalNonQuery(String sql, String... encodedParams) throws SQLException {
        return runLocalPowerShell("NON_QUERY", sql, encodedParams).scalarOrAffected;
    }

    private static LocalSqlResult runLocalPowerShell(String mode, String sql, String... encodedParams)
            throws SQLException {
        Path psAbsolute = Path.of("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe");
        String psExe = Files.isRegularFile(psAbsolute) ? psAbsolute.toString() : "powershell.exe";
        ProcessBuilder pb = new ProcessBuilder(
                psExe, "-NoProfile", "-NonInteractive", "-EncodedCommand", ENCODED_PS_SCRIPT);
        pb.redirectErrorStream(true);

        Map<String, String> env = pb.environment();
        env.put("PETCARE_LOCAL_CONN",
                ConfigUtil.get("db.localConnectionString", "DB_LOCAL_CONNECTION_STRING", DEFAULT_LOCAL_CONN));
        env.put("PETCARE_SQL_B64",
                Base64.getEncoder().encodeToString(sql.getBytes(StandardCharsets.UTF_8)));
        env.put("PETCARE_MODE", mode);
        env.put("PETCARE_PARAM_COUNT", String.valueOf(encodedParams != null ? encodedParams.length : 0));
        if (encodedParams != null) {
            for (int i = 0; i < encodedParams.length; i++) {
                env.put("PETCARE_P_" + i, encodedParams[i] != null ? encodedParams[i] : "N:");
            }
        }

        List<String> lines = new ArrayList<>();
        try {
            Process proc = pb.start();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(proc.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.isEmpty()) {
                        lines.add(line);
                    }
                }
            }
            boolean finished = proc.waitFor(15, TimeUnit.SECONDS);
            if (!finished) {
                proc.destroyForcibly();
                throw new SQLException("Local SQL Server Shared Memory query timed out.", "08S01");
            }
            int exitCode = proc.exitValue();
            LocalSqlResult result = new LocalSqlResult();
            for (String line : lines) {
                if (line.startsWith("ROW:")) {
                    String payload = line.substring(4);
                    String[] tokens = payload.split("\\|", -1);
                    String[] cols = new String[tokens.length];
                    for (int i = 0; i < tokens.length; i++) {
                        String tok = tokens[i];
                        if ("N:".equals(tok)) {
                            cols[i] = null;
                        } else if (tok.startsWith("V:")) {
                            byte[] decoded = Base64.getDecoder().decode(tok.substring(2));
                            cols[i] = new String(decoded, StandardCharsets.UTF_8);
                        } else {
                            cols[i] = tok;
                        }
                    }
                    result.rows.add(cols);
                } else if (line.startsWith("SCALAR:")) {
                    result.scalarOrAffected = Integer.parseInt(line.substring(7).trim());
                } else if (line.startsWith("AFFECTED:")) {
                    result.scalarOrAffected = Integer.parseInt(line.substring(9).trim());
                } else if (line.startsWith("SQLERR:")) {
                    String rest = line.substring(7);
                    int colon = rest.indexOf(':');
                    int errCode = Integer.parseInt(rest.substring(0, colon));
                    String errMsg = decodeBase64(rest.substring(colon + 1));
                    throw new SQLException(errMsg, "S0000", errCode);
                } else if (line.startsWith("ERR:")) {
                    String errMsg = decodeBase64(line.substring(4));
                    throw new SQLException("Local SQL Server fallback error: " + errMsg, "08001");
                }
            }
            if (exitCode != 0) {
                throw new SQLException("Local SQL Server fallback exited with code " + exitCode + ": "
                        + String.join("\n", lines), "08001");
            }
            return result;
        } catch (IOException e) {
            throw new SQLException("Cannot invoke local SQL Server Shared Memory bridge: " + e.getMessage(), "08001", e);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new SQLException("Interrupted while connecting to local SQL Server.", "08001", e);
        }
    }

    private static String decodeBase64(String b64) {
        return new String(Base64.getDecoder().decode(b64), StandardCharsets.UTF_8);
    }

    private static final class LocalSqlResult {
        final List<String[]> rows = new ArrayList<>();
        int scalarOrAffected = 0;
    }
}
