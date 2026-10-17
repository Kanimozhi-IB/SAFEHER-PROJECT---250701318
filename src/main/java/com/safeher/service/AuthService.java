package com.safeher.service;

import com.safeher.dao.UserDao;
import com.safeher.model.User;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {
    private final UserDao users=new UserDao();
    public User register(String name,String email,String phone,String password)throws SQLException{
        name=Validation.required(name,"Name");email=Validation.email(email);phone=Validation.phone(phone);
        if(password==null||password.length()<8)throw new IllegalArgumentException("Password must contain at least 8 characters.");
        return users.create(name,email,phone,BCrypt.hashpw(password,BCrypt.gensalt(12)));
    }
    public User login(String email,String password)throws SQLException{
        email=Validation.email(email);if(password==null||password.isEmpty())throw new IllegalArgumentException("Enter your password.");return users.authenticate(email,password);
    }
}
