package com.safeher.model;

public record EmergencyContact(long id, String name, String phone, String relationship) {
    @Override public String toString() { return name + " | " + phone + (relationship == null || relationship.isBlank() ? "" : " | " + relationship); }
}
