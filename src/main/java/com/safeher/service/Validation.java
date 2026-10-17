package com.safeher.service;

import java.util.regex.Pattern;

public final class Validation {
    private static final Pattern EMAIL=Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE=Pattern.compile("^[+0-9() .-]{7,25}$");
    private Validation() {}
    public static String email(String value){String v=value==null?"":value.trim().toLowerCase();if(!EMAIL.matcher(v).matches())throw new IllegalArgumentException("Enter a valid email address.");return v;}
    public static String phone(String value){String v=value==null?"":value.trim();if(!PHONE.matcher(v).matches())throw new IllegalArgumentException("Enter a valid phone number.");return v;}
    public static String required(String value,String label){String v=value==null?"":value.trim();if(v.isEmpty())throw new IllegalArgumentException(label+" is required.");return v;}
    public static void coordinates(Double lat,Double lon){if((lat==null)!=(lon==null))throw new IllegalArgumentException("Enter both latitude and longitude, or leave both blank.");if(lat!=null&&(lat < -90||lat>90||lon < -180||lon>180))throw new IllegalArgumentException("Coordinates are outside the valid range.");}
}
