package com.safeher.service;

import com.safeher.dao.ContactDao;
import com.safeher.model.EmergencyContact;
import java.sql.SQLException;
import java.util.List;

public class ContactService {
    private final ContactDao dao=new ContactDao();
    public List<EmergencyContact> list(long uid)throws SQLException{return dao.list(uid);}
    public void save(long uid,long id,String name,String phone,String relation)throws SQLException{dao.save(uid,new EmergencyContact(id,Validation.required(name,"Contact name"),Validation.phone(phone),relation==null?"":relation.trim()));}
    public void delete(long uid,long id)throws SQLException{dao.delete(uid,id);}
    public int count(long uid)throws SQLException{return dao.count(uid);}
}
