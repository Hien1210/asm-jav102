package com.petcare.utils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public final class ConfigUtil {
    private static final Properties EXTERNAL = new Properties();
    private static final Properties SETTINGS = load();

    private ConfigUtil() { }

    private static Properties load() {
        Properties settings = new Properties();
        try {
            try (InputStream input = ConfigUtil.class.getClassLoader()
                    .getResourceAsStream("application.properties")) {
                if (input != null) settings.load(input);
            }
            String external = System.getProperty("petcare.config");
            if (external != null && !external.isBlank()) {
                try (InputStream input = Files.newInputStream(Path.of(external))) {
                    EXTERNAL.load(input);
                    settings.putAll(EXTERNAL);
                }
            }
            return settings;
        } catch (IOException e) {
            throw new IllegalStateException("Cannot load database configuration.", e);
        }
    }

    public static String get(String key, String environment, String fallback) {
        // An explicitly selected external file takes precedence over inherited environment.
        if (EXTERNAL.containsKey(key)) return EXTERNAL.getProperty(key);
        String value = System.getenv(environment);
        return value != null ? value : SETTINGS.getProperty(key, fallback);
    }
}