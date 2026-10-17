package com.safeher.dao;

import com.safeher.config.DatabaseConfig;
import com.safeher.model.EmergencyContact;
import java.sql.*;
import java.util.*;

public class ContactDao {
    public List<EmergencyContact> list(long userId) throws SQLException {
        List<EmergencyContact> out=new ArrayList<>();
        try(Connection c=DatabaseConfig.connect(); PreparedStatement p=c.prepareStatement("SELECT contact_id,contact_name,phone,relationship_label FROM emergency_contacts WHERE user_id=? ORDER BY contact_name")) {
            p.setLong(1,userId); try(ResultSet r=p.executeQuery()){ while(r.next()) out.add(new EmergencyContact(r.getLong(1),r.getString(2),r.getString(3),r.getString(4))); }
        } return out;
    }
    public void save(long userId, EmergencyContact x) throws SQLException {
        String sql=x.id()==0 ? "INSERT INTO emergency_contacts(user_id,contact_name,phone,relationship_label) VALUES(?,?,?,?)" : "UPDATE emergency_contacts SET contact_name=?,phone=?,relationship_label=? WHERE contact_id=? AND user_id=?";
        try(Connection c=DatabaseConfig.connect(); PreparedStatement p=c.prepareStatement(sql)) {
            if(x.id()==0){p.setLong(1,userId);p.setString(2,x.name());p.setString(3,x.phone());p.setString(4,x.relationship());}
            else {p.setString(1,x.name());p.setString(2,x.phone());p.setString(3,x.relationship());p.setLong(4,x.id());p.setLong(5,userId);} p.executeUpdate();
        }
    }
    public void delete(long userId,long id) throws SQLException { try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement("DELETE FROM emergency_contacts WHERE contact_id=? AND user_id=?")){p.setLong(1,id);p.setLong(2,userId);p.executeUpdate();} }
    public int count(long userId) throws SQLException { try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement("SELECT COUNT(*) FROM emergency_contacts WHERE user_id=?")){p.setLong(1,userId);try(ResultSet r=p.executeQuery()){r.next();return r.getInt(1);}} }
}
