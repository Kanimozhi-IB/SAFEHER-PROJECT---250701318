package com.safeher.service;

import com.safeher.dao.AlertDao;
import com.safeher.model.EmergencyAlert;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class AlertService {
    private static final Set<String> STATUSES=Set.of("CREATED","RESOLVED","CANCELLED");
    private final AlertDao dao=new AlertDao();
    public long create(long uid,String latitude,String longitude,String note)throws SQLException{
        Double lat=parse(latitude),lon=parse(longitude);Validation.coordinates(lat,lon);return dao.create(uid,lat,lon,note==null?"":note.trim());
    }
    private Double parse(String text){if(text==null||text.isBlank())return null;try{return Double.valueOf(text.trim());}catch(NumberFormatException e){throw new IllegalArgumentException("Coordinates must be numbers.");}}
    public List<EmergencyAlert> list(long uid)throws SQLException{return dao.list(uid);}
    public void updateStatus(long uid,long id,String status)throws SQLException{if(!STATUSES.contains(status))throw new IllegalArgumentException("Choose a valid alert status.");dao.updateStatus(uid,id,status);}
    public int count(long uid)throws SQLException{return dao.count(uid);}
}
