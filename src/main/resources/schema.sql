CREATE TABLE IF NOT EXISTS users (
  user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(254) NOT NULL UNIQUE,
  phone VARCHAR(32) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS emergency_contacts (
  contact_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  contact_name VARCHAR(120) NOT NULL,
  phone VARCHAR(32) NOT NULL,
  relationship_label VARCHAR(60),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_contacts_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_contacts_user (user_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS emergency_alerts (
  alert_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  alert_type VARCHAR(30) NOT NULL DEFAULT 'SOS',
  latitude DECIMAL(10,7), longitude DECIMAL(10,7), location_note VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) NOT NULL DEFAULT 'CREATED',
  CONSTRAINT chk_alert_status CHECK (status IN ('CREATED','RESOLVED','CANCELLED')),
  CONSTRAINT fk_alerts_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_alert_user_created (user_id, created_at)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS journeys (
  journey_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  start_location VARCHAR(255) NOT NULL,
  destination VARCHAR(255) NOT NULL,
  start_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expected_arrival TIMESTAMP NOT NULL,
  actual_arrival TIMESTAMP NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
  CONSTRAINT chk_journey_status CHECK (status IN ('PLANNED','IN_PROGRESS','COMPLETED','OVERDUE')),
  CONSTRAINT fk_journeys_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_journeys_user_status (user_id, status)
) ENGINE=InnoDB;
