package com.safeher.model;

import java.time.LocalDateTime;

public record EmergencyAlert(long id, String type, Double latitude, Double longitude, String locationNote, LocalDateTime createdAt, String status) {
    @Override public String toString() {
        String location = latitude == null ? "Location unavailable" : latitude + ", " + longitude;
        if (locationNote != null && !locationNote.isBlank()) location += " — " + locationNote;
        return "#" + id + " | " + createdAt + " | " + status + " | " + location;
    }
}
