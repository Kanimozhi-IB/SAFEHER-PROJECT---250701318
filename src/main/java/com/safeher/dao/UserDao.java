package com.safeher.dao;

import com.safeher.config.DatabaseConfig;
import com.safeher.model.User;
import java.sql.*;

public class UserDao {
    public User create(String name, String email, String phone, String hash) throws SQLException {
        String sql = "INSERT INTO users(full_name,email,phone,password_hash) VALUES(?,?,?,?)";
        try (Connection c = DatabaseConfig.connect(); PreparedStatement p = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1,name); p.setString(2,email); p.setString(3,phone); p.setString(4,hash); p.executeUpdate();
            try (ResultSet k=p.getGeneratedKeys()) { k.next(); return new User(k.getLong(1),name,email,phone); }
        }
    }
    public User authenticate(String email, String password) throws SQLException {
        try (Connection c=DatabaseConfig.connect(); PreparedStatement p=c.prepareStatement("SELECT user_id,full_name,email,phone,password_hash FROM users WHERE email=?")) {
            p.setString(1,email);
            try (ResultSet r=p.executeQuery()) {
                if (!r.next() || !org.mindrot.jbcrypt.BCrypt.checkpw(password,r.getString("password_hash"))) return null;
                return new User(r.getLong("user_id"),r.getString("full_name"),r.getString("email"),r.getString("phone"));
            }
        }
    }
}
