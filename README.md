# SafeHer - Women Safety and Emergency Alert System

SafeHer is a Java desktop mini-project demonstrating Object-Oriented Programming (OOP) and Database Management Systems (DBMS). It uses Java Swing for the interface, JDBC for database access, and MySQL for persistent storage.

> **Prototype notice:** The SOS action writes a record to the local SafeHer database. It does not send an SMS or email, contact police or emergency services, obtain live GPS, or guarantee safety. Use fictional details when demonstrating the project.

## Features

- User registration and sign-in with BCrypt password hashing.
- Add, list, edit, and delete trusted emergency contacts.
- Record an SOS alert with optional coordinates and a location note.
- View alert history, newest first, and update status to `CREATED`, `RESOLVED`, or `CANCELLED`.
- Dashboard counts for the signed-in user's contacts and alerts.
- Database schema includes a `journeys` table for future extension. Journey screens and journey operations are not implemented in this version.
- JUnit validation tests.

## Technology

- Java 17 or newer
- Maven
- Java Swing
- MySQL 8.x
- JDBC with MySQL Connector/J
- BCrypt (`jBCrypt`)
- JUnit 5

## Project layout

```text
src/main/java/com/safeher/
  Main.java                    Swing application
  config/DatabaseConfig.java   Environment-based JDBC connection
  model/                       User, contact, and alert models
  dao/                         JDBC database operations
  service/                     Validation and application rules
src/main/resources/schema.sql  MySQL table definitions
src/test/java/                 Validation tests
docs/                          Project, ER, test, and SQL demo documentation
```

## Prerequisites

1. Install a JDK 17 or newer. Check in PowerShell:

   ```powershell
   java -version
   javac -version
   ```

2. Install Apache Maven. On Windows, download the binary archive from the [Apache Maven installation guide](https://maven.apache.org/install.html), extract it, and add its `bin` directory to your Windows `Path`. Open a new PowerShell window and check:

   ```powershell
   mvn -version
   ```

3. Install and start MySQL Community Server 8.x. MySQL Workbench is optional but useful for creating the database and viewing records.

## Database setup (MySQL Workbench)

### Create the database and application user

Connect to your local MySQL server in Workbench as an administrator. Open a query tab and run the following. Replace the example password with a strong password you choose locally; do not commit it or paste it into GitHub.

```sql
CREATE DATABASE safeher_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER 'safeher_app'@'localhost'
  IDENTIFIED BY 'replace-with-your-local-password';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX
  ON safeher_db.* TO 'safeher_app'@'localhost';

FLUSH PRIVILEGES;
```

If you already created the database and user, do not repeat `CREATE USER`. To change that user's password, run as the MySQL administrator:

```sql
ALTER USER 'safeher_app'@'localhost'
  IDENTIFIED BY 'your-new-local-password';
```

### Create the tables

1. In Workbench choose **File > Open SQL Script**.
2. Open `src/main/resources/schema.sql` from this project folder.
3. In the left **SCHEMAS** panel, refresh the list and double-click `safeher_db` so it is the active schema.
4. Click inside the schema editor, press **Ctrl+A** to select the complete script, then click the lightning bolt to execute it.
5. Verify the tables by running:

   ```sql
   USE safeher_db;
   SHOW TABLES;
   ```

   The tables are `users`, `emergency_contacts`, `emergency_alerts`, and `journeys`.

The schema uses `CREATE TABLE IF NOT EXISTS`, so it can be run again to create any missing tables without replacing existing tables.

## Configure and run on Windows PowerShell

Open PowerShell in the folder containing `pom.xml`. Set the database variables in that same window. Replace the password with the exact password configured for `safeher_app`; single quotes preserve special characters.

```powershell
$env:SAFEHER_DB_URL = 'jdbc:mysql://localhost:3306/safeher_db'
$env:SAFEHER_DB_USER = 'safeher_app'
$env:SAFEHER_DB_PASSWORD = 'your-local-password'
```

Run the automated tests, then launch the desktop application:

```powershell
mvn clean test
mvn exec:java
```

Keep this PowerShell window open while using the app. Environment variables set this way apply only to that PowerShell session. If you close it, set the variables again before launching Maven. Stop the running app by returning to PowerShell and pressing **Ctrl+C**.

On first run, Maven downloads project dependencies, so an internet connection may be needed. The configured command `mvn exec:java` runs the main class `com.safeher.Main`.

## macOS or Linux

After installing Java, Maven, and MySQL, start MySQL, create the database/user, and run `src/main/resources/schema.sql` as above. In a terminal opened at the project root, set:

```bash
export SAFEHER_DB_URL='jdbc:mysql://localhost:3306/safeher_db'
export SAFEHER_DB_USER='safeher_app'
export SAFEHER_DB_PASSWORD='your-local-password'
```

Then run:

```bash
mvn clean test
mvn exec:java
```

## Run from an IDE

1. Open the project folder containing `pom.xml` as a Maven project.
2. Configure the project JDK as Java 17 or newer.
3. Start MySQL and create the schema.
4. Add `SAFEHER_DB_URL`, `SAFEHER_DB_USER`, and `SAFEHER_DB_PASSWORD` to the IDE run configuration for `com.safeher.Main`.
5. Run `com.safeher.Main`.

Do not put a real database password into source code or commit it in an IDE run-configuration file.

## Verify saved data

In MySQL Workbench, select `safeher_db` and run:

```sql
SELECT user_id, full_name, email, created_at FROM users;
SELECT contact_id, user_id, contact_name, phone FROM emergency_contacts;
SELECT alert_id, user_id, alert_type, created_at, status FROM emergency_alerts
ORDER BY created_at DESC;
```

More sample queries are in [`docs/SQL_DEMO.sql`](docs/SQL_DEMO.sql). Never include real passwords or private contact information in screenshots or a public repository.

## Troubleshooting

- **`mvn` is not recognized:** Maven is missing from `Path`, or PowerShell was opened before the Path change. Add Maven's `bin` folder to Path and open a new terminal.
- **Access denied for `safeher_app`:** Check that the PowerShell password exactly matches MySQL. Re-enter it with single quotes. Confirm the user and grants with the MySQL administrator.
- **Unknown database:** Create `safeher_db` and verify `SAFEHER_DB_URL` uses that database name.
- **Table does not exist:** Execute the complete `schema.sql` against `safeher_db` and verify with `SHOW TABLES;`.
- **Communications link failure / connection refused:** Start MySQL and check the host and port in `SAFEHER_DB_URL` (default local port is 3306).
- **Missing environment variable:** Set all three `SAFEHER_DB_*` variables in the terminal or IDE process that launches the app.
- **Duplicate email or phone:** User email and phone are unique. Register with a new email and phone, or sign in with the existing account.
- **Maven dependency download failure:** Check internet access and run `mvn -U clean test`.

## GitHub submission

1. Create an empty repository on GitHub. If you plan to push this existing folder, do not initialize the GitHub repository with a README or license.
2. In PowerShell, change to the project folder:

   ```powershell
   cd C:\Users\Admin\Desktop\sqljava
   ```

3. Initialize Git, inspect the files, commit, and push. Replace the URL with your GitHub repository URL:

   ```powershell
   git init
   git status
   git add .
   git status
   git commit -m "Add SafeHer Java and MySQL project"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
   git push -u origin main
   ```

4. Before pushing, inspect `git status` and confirm that `.env`, passwords, and personal contact information are not staged. `.gitignore` excludes local secrets, build output, and common IDE files. If a secret was committed previously, removing it in a later commit does not erase it from Git history; rotate the credential and clean the history before making the repository public.

## Project documentation

- [Project plan](docs/PROJECT_PLAN.md)
- [ER diagram](docs/ER_DIAGRAM.md)
- [Test plan](docs/TEST_PLAN.md)
- [SQL demo queries](docs/SQL_DEMO.sql)
- [College project report](SafeHer_Project_Report.docx)

## Safety and privacy

This is a college demonstration prototype, not an emergency response service. SOS records are stored locally in the configured MySQL database only. Use fictional accounts and contact details for demos. Do not test with real emergency services.
