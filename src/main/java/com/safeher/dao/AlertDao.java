package com.safeher.dao;

import com.safeher.config.DatabaseConfig;
import com.safeher.model.EmergencyAlert;
import java.sql.*;
import java.util.*;

public class AlertDao {
    public long create(long userId, Double lat, Double lon, String note) throws SQLException {
        String sql="INSERT INTO emergency_alerts(user_id,latitude,longitude,location_note,status) VALUES(?,?,?,?,'CREATED')";
        try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){
            p.setLong(1,userId); if(lat==null){p.setNull(2,Types.DECIMAL);p.setNull(3,Types.DECIMAL);}else{p.setDouble(2,lat);p.setDouble(3,lon);}p.setString(4,note);p.executeUpdate();try(ResultSet r=p.getGeneratedKeys()){r.next();return r.getLong(1);}
        }
    }
    public List<EmergencyAlert> list(long userId) throws SQLException {
        List<EmergencyAlert> out=new ArrayList<>();
        try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement("SELECT alert_id,alert_type,latitude,longitude,location_note,created_at,status FROM emergency_alerts WHERE user_id=? ORDER BY created_at DESC")){
            p.setLong(1,userId);try(ResultSet r=p.executeQuery()){while(r.next()){double lat=r.getDouble("latitude");Double latitude=r.wasNull()?null:lat;double lon=r.getDouble("longitude");Double longitude=r.wasNull()?null:lon;Timestamp ts=r.getTimestamp("created_at");out.add(new EmergencyAlert(r.getLong("alert_id"),r.getString("alert_type"),latitude,longitude,r.getString("location_note"),ts.toLocalDateTime(),r.getString("status")));}}
        }return out;
    }
    public void updateStatus(long userId,long id,String status) throws SQLException {try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement("UPDATE emergency_alerts SET status=? WHERE alert_id=? AND user_id=?")){p.setString(1,status);p.setLong(2,id);p.setLong(3,userId);p.executeUpdate();}}
    public int count(long userId)throws SQLException{try(Connection c=DatabaseConfig.connect();PreparedStatement p=c.prepareStatement("SELECT COUNT(*) FROM emergency_alerts WHERE user_id=?")){p.setLong(1,userId);try(ResultSet r=p.executeQuery()){r.next();return r.getInt(1);}}}
}
