package com.safeher.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConfig {
    private DatabaseConfig() {}

    public static Connection connect() throws SQLException {
        String url = required("SAFEHER_DB_URL");
        String user = required("SAFEHER_DB_USER");
        String password = required("SAFEHER_DB_PASSWORD");
        return DriverManager.getConnection(url, user, password);
    }

    private static String required(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) throw new IllegalStateException("Missing required environment variable: " + name);
        return value;
    }
}
