# SafeHer — Women Safety and Emergency Alert System
## Integrated Java + MySQL College Project Plan

**Project type:** Java OOP + DBMS mini-project  
**Suggested title:** SafeHer: Women Safety and Emergency Alert System  
**Suggested stack:** Java 17, Maven, Java Swing, JDBC, MySQL 8  
**Project goal:** Build one desktop application that demonstrates OOP concepts in Java and database concepts in MySQL.

> **Safety note:** The first version is a college prototype. It records emergency alerts in the local database and shows them in the application. It does not automatically contact police, send SMS, or provide guaranteed real-time protection. Real SMS, email, GPS, or emergency-service integrations should be added only with suitable permissions, testing, and a clearly documented provider.

---

# 1. Project Overview

## 1.1 Problem statement
In an uncomfortable or potentially unsafe situation, a person may need a quick way to access trusted emergency contacts and record an alert. A simple system can help a user maintain emergency contacts, trigger an SOS record, view alert history, and optionally register a journey with an expected arrival time.

## 1.2 Proposed solution
SafeHer is a Java desktop application connected to a MySQL database. A registered user can:
- Register and sign in.
- Add, edit, and delete trusted emergency contacts.
- Trigger an SOS alert.
- Optionally enter a location or mark it unavailable.
- View previous alerts and their status.
- Update an alert status in the prototype.
- Register a planned journey and mark it as safely completed.
- View a simple dashboard of contacts, alerts, and journeys.

## 1.3 Minimum viable project
Build these features first:
1. User registration.
2. Emergency-contact management.
3. Create an SOS alert.
4. Store the alert in MySQL.
5. View alert history.
6. Update alert status.
7. A simple Swing interface with validation and helpful error messages.

## 1.4 Optional enhancements
Add only after the minimum viable version works:
- Safety journey tracker with an expected arrival time and manual safe check-in.
- Dashboard counts.
- Search/filter alert history.
- Map link for coordinates entered by the user.
- Email/SMS provider integration (not simulated as real delivery).
- Role-based administrator view.

---

# 2. Functional Requirements

| ID | Requirement | Acceptance criteria |
|---|---|---|
| FR-01 | Register user | Valid user details are saved to MySQL; duplicate email/phone is handled clearly. |
| FR-02 | Sign in | User can access their own dashboard using stored credentials. |
| FR-03 | Manage contacts | User can add, list, edit, and delete their trusted contacts. |
| FR-04 | Trigger SOS | Clicking SOS creates an alert record with timestamp and status. |
| FR-05 | Location details | Coordinates are optional; missing location is stored/displayed as unavailable. |
| FR-06 | Alert history | User can see their alerts, newest first. |
| FR-07 | Update status | User can update a prototype alert status, with confirmation where appropriate. |
| FR-08 | Journey (optional) | User can create a journey and manually mark it safe/completed. |
| FR-09 | Validation | Required fields and invalid phone/email formats show clear messages. |
| FR-10 | Persistence | Data remains after closing and reopening the application. |

## Non-functional requirements
- Use clear class responsibilities and readable code.
- Use JDBC `PreparedStatement` for SQL with user input.
- Store passwords as salted hashes using a reputable password-hashing library; never store plaintext passwords.
- Keep database credentials out of source control. Use environment variables or a local configuration file excluded from Git.
- Show errors to the user without exposing passwords or database secrets.
- Use transactions where a workflow requires multiple related writes.
- Do not claim an alert has been delivered unless a real delivery provider confirms it.
- Limit each signed-in user to their own records.

---

# 3. Technology and Tools

## Required
- **JDK 17 or newer** (use one JDK consistently).
- **Maven** for dependency management and builds.
- **MySQL Community Server 8.x**.
- **MySQL Workbench** (optional but helpful for viewing tables and running SQL).
- An IDE such as IntelliJ IDEA, Eclipse, or NetBeans; VS Code with Java extensions can also work.
- Git (optional, recommended for version control).

## Libraries
- MySQL Connector/J — JDBC driver.
- A password-hashing library such as jBCrypt, or an equivalent maintained library compatible with the chosen Java version.
- JUnit 5 for tests (optional but recommended).

Use the current stable compatible library versions when generating the project. Do not guess dependency versions if they can be verified from the official package repository.

---

# 4. Suggested Architecture

Use a layered design:

```text
Swing UI (screens and event handlers)
          |
          v
Service layer (validation and business rules)
          |
          v
DAO / Repository layer (SQL using JDBC)
          |
          v
MySQL database
```

Keep SQL out of Swing event handlers. UI classes should call service classes; service classes should call DAO classes.

## Suggested package structure

```text
safeher/
├── pom.xml
├── README.md
├── .gitignore
├── docs/
│   ├── PROJECT_PLAN.md
│   ├── ER_DIAGRAM.md
│   └── TEST_PLAN.md
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/safeher/
│   │   │       ├── Main.java
│   │   │       ├── config/
│   │   │       │   └── DatabaseConfig.java
│   │   │       ├── model/
│   │   │       │   ├── User.java
│   │   │       │   ├── EmergencyContact.java
│   │   │       │   ├── EmergencyAlert.java
│   │   │       │   └── Journey.java
│   │   │       ├── dao/
│   │   │       │   ├── UserDao.java
│   │   │       │   ├── EmergencyContactDao.java
│   │   │       │   ├── EmergencyAlertDao.java
│   │   │       │   └── JourneyDao.java
│   │   │       ├── service/
│   │   │       │   ├── AuthService.java
│   │   │       │   ├── ContactService.java
│   │   │       │   ├── AlertService.java
│   │   │       │   └── JourneyService.java
│   │   │       └── ui/
│   │   │           ├── LoginFrame.java
│   │   │           ├── RegisterFrame.java
│   │   │           ├── DashboardFrame.java
│   │   │           ├── ContactsPanel.java
│   │   │           ├── AlertsPanel.java
│   │   │           └── JourneysPanel.java
│   │   └── resources/
│   │       └── schema.sql
│   └── test/
│       └── java/com/safeher/
└── .env.example
```

The exact file structure can be simplified for a beginner, but keep UI, business logic, and database access separated.

---

# 5. OOP Concepts to Demonstrate

| OOP concept | How SafeHer demonstrates it |
|---|---|
| Classes and objects | `User`, `EmergencyContact`, `EmergencyAlert`, and `Journey` model real entities. |
| Encapsulation | Keep fields private and expose suitable constructors/getters/methods. |
| Abstraction | Define interfaces such as `AlertRepository` or `NotificationService` when useful. |
| Inheritance | If appropriate, create a shared base class for notification types; do not add inheritance just for appearance. |
| Polymorphism | Different notification implementations can implement a common interface. A console/demo notification must be labelled as simulated. |
| Constructors | Initialize model objects in constructors. |
| Exception handling | Handle validation, SQL errors, and connection failures clearly. |

Avoid forcing inheritance where it does not improve the design. Encapsulation, classes/objects, interfaces, and clear separation of responsibilities are enough for a solid student project.

---

# 6. Database Design

## 6.1 Tables

### `users`
- `user_id` — primary key
- `full_name`
- `email` — unique
- `phone` — unique where suitable
- `password_hash`
- `created_at`

### `emergency_contacts`
- `contact_id` — primary key
- `user_id` — foreign key to `users`
- `contact_name`
- `phone`
- `relationship_label`
- `created_at`

### `emergency_alerts`
- `alert_id` — primary key
- `user_id` — foreign key to `users`
- `alert_type` — e.g. `SOS`
- `latitude` — nullable
- `longitude` — nullable
- `location_note` — nullable
- `created_at`
- `status` — e.g. `CREATED`, `RESOLVED`, `CANCELLED`

### `journeys` (optional feature)
- `journey_id` — primary key
- `user_id` — foreign key to `users`
- `start_location`
- `destination`
- `start_time`
- `expected_arrival`
- `actual_arrival` — nullable
- `status` — e.g. `PLANNED`, `IN_PROGRESS`, `COMPLETED`, `OVERDUE`

Add indexes on foreign keys and fields commonly searched. Use foreign-key constraints. Consider `ON DELETE CASCADE` for contacts/alerts/journeys only if deleting a user is intended to permanently delete those records; otherwise prefer deactivation or restricted deletion.

## 6.2 Relationship summary
- One user has many emergency contacts.
- One user has many emergency alerts.
- One user has many journeys.
- Each contact, alert, and journey belongs to one user.

## 6.3 DBMS concepts to demonstrate
- Primary keys and foreign keys.
- `NOT NULL`, `UNIQUE`, and `CHECK` constraints where supported.
- CRUD operations.
- `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.
- Joins between users and alerts/contacts.
- Sorting and filtering.
- Normalization and avoiding repeated contact/user data.
- Prepared statements and transactions.

---

# 7. Setup and Configuration

## Step 1 — Install Java
1. Install a JDK version 17 or newer from a trusted vendor.
2. Open a terminal/Command Prompt.
3. Run:

```bash
java -version
javac -version
```

Both commands should show a compatible version. If the command is not found, configure `JAVA_HOME` and add the JDK `bin` directory to `PATH`, then reopen the terminal.

## Step 2 — Install Maven
1. Install Apache Maven, or use the Maven wrapper generated by the project.
2. Verify:

```bash
mvn -version
```

The output should show Maven and the Java version it uses.

## Step 3 — Install MySQL
1. Install MySQL Community Server 8.x.
2. Set a strong local password for the database administrator.
3. Start the MySQL service.
4. Optionally install MySQL Workbench.
5. Verify you can connect to the local server.

Do not use your database administrator account for the application's normal runtime. Create a dedicated database and limited-privilege application user.

## Step 4 — Create the database and application user
In MySQL Workbench or the MySQL command-line client, run a script similar to this:

```sql
CREATE DATABASE safeher_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER 'safeher_app'@'localhost'
  IDENTIFIED BY 'CHANGE_THIS_TO_A_STRONG_PASSWORD';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX
  ON safeher_db.* TO 'safeher_app'@'localhost';

FLUSH PRIVILEGES;
```

For normal application use, you can reduce privileges after schema setup. Never commit the real password to Git. Replace the example password before running the script.

## Step 5 — Configure the connection
Use environment variables or a local untracked configuration file. A simple environment-variable approach:

- `SAFEHER_DB_URL=jdbc:mysql://localhost:3306/safeher_db`
- `SAFEHER_DB_USER=safeher_app`
- `SAFEHER_DB_PASSWORD=your_local_password`

The application should fail with a clear, safe error if these variables are missing. Do not print the password in logs.

On Windows PowerShell, set variables for the current terminal session:

```powershell
$env:SAFEHER_DB_URL="jdbc:mysql://localhost:3306/safeher_db"
$env:SAFEHER_DB_USER="safeher_app"
$env:SAFEHER_DB_PASSWORD="your_local_password"
```

On macOS/Linux Bash:

```bash
export SAFEHER_DB_URL="jdbc:mysql://localhost:3306/safeher_db"
export SAFEHER_DB_USER="safeher_app"
export SAFEHER_DB_PASSWORD="your_local_password"
```

Use the exact variable names expected by the generated code.

## Step 6 — Create schema
The project should include `src/main/resources/schema.sql`. Run it against `safeher_db` using Workbench or the CLI. The app may optionally create tables automatically on first startup, but a separate schema script is useful for DBMS evaluation and reproducibility.

## Step 7 — Open the project
1. Open the folder containing `pom.xml` in your IDE.
2. Allow Maven to import dependencies.
3. Confirm the project uses JDK 17 or the version specified by the generated `pom.xml`.
4. Configure the database environment variables.
5. Run the `Main` class.

---

# 8. Build and Run Commands

From the project root (the folder containing `pom.xml`):

```bash
mvn clean test
mvn clean package
```

Run the packaged application using the launch method documented in the generated `README.md`. If the project is packaged as a normal JAR with dependencies managed by Maven, a direct `java -jar` command may not work unless the build config creates an executable/fat JAR. The generator must configure and document a working launch method, such as Maven Exec Plugin or a shaded executable JAR.

A typical Maven Exec Plugin launch command is:

```bash
mvn exec:java
```

This works only if the `pom.xml` configures the plugin and the correct main class. The project generator should provide a verified command.

## Run from an IDE
1. Start MySQL.
2. Ensure the schema exists.
3. Set the three `SAFEHER_DB_*` environment variables in the IDE run configuration.
4. Run `com.safeher.Main`.
5. Register a test account.
6. Add a contact.
7. Trigger a test SOS.
8. Open MySQL Workbench and confirm the rows were saved.

---

# 9. Testing Plan

Test at least the following:

| Test | Action | Expected result |
|---|---|---|
| T-01 | Register with valid details | User saved successfully. |
| T-02 | Register with duplicate email | Clear validation message; no duplicate account. |
| T-03 | Sign in with incorrect password | Access denied without exposing secret details. |
| T-04 | Add a contact | Contact appears in the list and database. |
| T-05 | Submit empty required contact fields | Validation message; no invalid row. |
| T-06 | Trigger SOS | Alert record is inserted with timestamp and `CREATED` status. |
| T-07 | View alert history | Current user's alerts appear newest first. |
| T-08 | Update alert status | Updated status persists after reload. |
| T-09 | Restart application | Previously saved records remain. |
| T-10 | Start app with database stopped | Clear connection error; app does not falsely claim success. |
| T-11 | Try to access another user's records | Access is denied by the service/DAO logic. |
| T-12 | Leave location blank | Alert still works and location is shown as unavailable. |

For a college demo, use fictional users and contacts. Do not test by sending messages to real emergency numbers.

---

# 10. Demonstration Script

A clear 3–5 minute demo:

1. Introduce the problem and the SafeHer solution.
2. Register a fictional user.
3. Add two fictional trusted contacts.
4. Trigger a test SOS alert.
5. Show the alert ID, timestamp, and status in the UI.
6. Open MySQL Workbench and run:

```sql
SELECT alert_id, user_id, alert_type, created_at, status
FROM emergency_alerts
ORDER BY created_at DESC;
```

7. Update the alert status through the application and show the persisted change.
8. Explain how Java model/service/DAO classes work with JDBC and MySQL.
9. Mention limitations honestly: the prototype records alerts; actual delivery and live GPS are not included unless explicitly implemented and tested.

---

# 11. Common Problems and Fixes

| Problem | Likely cause | What to check |
|---|---|---|
| `java` or `javac` not found | JDK missing or PATH incorrect | Reinstall/configure JDK; reopen terminal. |
| `mvn` not found | Maven missing or PATH incorrect | Use Maven wrapper if included, or install Maven. |
| `Communications link failure` | MySQL service is stopped or URL/port is wrong | Start MySQL; check host, port, and server status. |
| `Access denied for user` | Wrong username/password or grants | Verify environment variables and grants. |
| `Unknown database` | Schema/database not created | Create `safeher_db` and run schema script. |
| `No suitable driver` | MySQL Connector/J missing | Check Maven dependency and reload Maven. |
| Table does not exist | Schema script not run or wrong database selected | Run `schema.sql` against `safeher_db`. |
| App works in IDE but not as JAR | Dependencies/main class not packaged correctly | Follow README's configured launch method. |
| Password variable is null | Environment variable not set in the process running the app | Set it in the same terminal/IDE run configuration. |

---

# 12. Submission Checklist

- [ ] Java source code builds successfully.
- [ ] Maven tests pass.
- [ ] MySQL schema script is included.
- [ ] JDBC connection works.
- [ ] User registration and contact CRUD work.
- [ ] SOS records persist in MySQL.
- [ ] Alert history and status update work.
- [ ] Validation and database errors are handled.
- [ ] UML class diagram is included.
- [ ] ER diagram is included.
- [ ] SQL query screenshots are included.
- [ ] OOPS concepts are explained.
- [ ] DBMS concepts are explained.
- [ ] README includes exact setup and run steps.
- [ ] No passwords or real personal contact data are committed.
- [ ] The report clearly distinguishes simulated alerts from actual notification delivery.

---

# 13. Prompt for Codex or Claude to Generate the Project

Copy the following prompt into Codex or Claude Code from an empty project folder. If the tool can create and edit files, ask it to implement the project in the workspace rather than only describing code.

---

## Copy-and-paste prompt

You are a senior Java developer and a patient mentor helping a beginner build a complete college mini-project that combines Object-Oriented Programming (OOPS) and Database Management Systems (DBMS).

### Project
Build **SafeHer — Women Safety and Emergency Alert System**, a Java desktop application backed by MySQL.

### Goal
Create a working, beginner-friendly, runnable project. Do not only give an explanation or isolated code snippets. Create the complete project files in the workspace, including source code, SQL schema, Maven configuration, documentation, and tests.

### Required technology
- Java 17 or a compatible newer LTS version.
- Maven.
- Java Swing desktop interface.
- MySQL 8.x.
- JDBC using MySQL Connector/J.
- JUnit 5 for tests where practical.
- A reputable password-hashing library for password storage.

Use compatible current stable dependency versions. Do not invent dependency versions or APIs. Keep the implementation simple enough for a second-year computer science student to understand.

### Required features
1. User registration with name, email, phone, and password.
2. Login with password verification.
3. Add, list, edit, and delete trusted emergency contacts.
4. One-click test SOS alert creation.
5. Optional latitude, longitude, and location note fields.
6. Alert history, sorted newest first.
7. Alert status updates using statuses such as `CREATED`, `RESOLVED`, and `CANCELLED`.
8. Basic dashboard showing contact count and alert count.
9. Optional journey tracker with start location, destination, expected arrival, and a manual “I am safe” check-in.
10. Input validation and clear error messages.
11. Persistent MySQL storage.
12. Sample SQL queries and fictional seed data for demonstration, if appropriate.

### Architecture
Use a clear layered structure:
- `model` for entities.
- `dao` for JDBC database access.
- `service` for validation and business rules.
- `ui` for Swing screens.
- `config` for database configuration.

Keep SQL out of Swing event handlers. Use `PreparedStatement` for user-supplied values. Use try-with-resources for JDBC resources. Use transactions for workflows that need multiple related writes. Ensure each signed-in user can access only their own contacts, alerts, and journeys.

### OOPS requirements
Clearly demonstrate:
- Classes and objects.
- Encapsulation.
- Constructors and methods.
- Abstraction using interfaces where appropriate.
- Polymorphism through a meaningful interface implementation.
- Inheritance only when it improves the design; do not add artificial inheritance solely to claim the concept.

Include an explanation in the documentation identifying where each OOPS concept appears.

### DBMS requirements
Create a `schema.sql` file with appropriate tables, primary keys, foreign keys, constraints, and indexes. Include:
- `users`
- `emergency_contacts`
- `emergency_alerts`
- `journeys` if the journey feature is implemented.

Use normalized relational design. Include sample `SELECT`, `INSERT`, `UPDATE`, `DELETE`, and `JOIN` queries in a separate SQL demonstration file or in the documentation. Explain primary keys, foreign keys, and relationships.

### Security and safety requirements
- Never store plaintext passwords. Hash passwords with a suitable password-hashing algorithm and verify them correctly.
- Never hardcode real database credentials in source code.
- Read connection settings from environment variables:
  - `SAFEHER_DB_URL`
  - `SAFEHER_DB_USER`
  - `SAFEHER_DB_PASSWORD`
- Provide `.env.example` or a documented environment-variable template without real secrets.
- Add `.gitignore` entries for local secret files and build output.
- Do not log passwords or other secrets.
- Validate user input and handle SQL exceptions safely.
- Use fictional data in examples.
- Treat this as a prototype. The SOS action must clearly state that it records an alert in the application/database. Do not claim it sends SMS, contacts police, tracks live GPS, or guarantees safety unless those integrations are actually implemented and tested.
- Do not send test messages to real emergency services.
- If notification integration is not implemented, show a clear “recorded locally / notification not configured” status.

### UI requirements
Create a simple, clean Swing interface suitable for a college demo. Include screens or panels for:
- Login and registration.
- Dashboard.
- Emergency contacts.
- SOS alert creation.
- Alert history and status updates.
- Journey tracker if implemented.

Use clear labels, confirmation prompts for destructive actions, input validation, and useful empty states. Do not make the interface imply that a real emergency notification has been delivered.

### Project files
Create at least:
- `pom.xml`
- `README.md`
- `.gitignore`
- `src/main/resources/schema.sql`
- Java source files under `src/main/java/com/safeher/`
- Test files under `src/test/java/`
- `docs/PROJECT_PLAN.md`
- `docs/ER_DIAGRAM.md` (Mermaid ER diagram or clear text diagram)
- `docs/TEST_PLAN.md`
- `docs/SQL_DEMO.sql`

Include a UML class diagram using Mermaid in the documentation if feasible.

### Configuration and run instructions
The README must give exact, beginner-friendly steps for:
1. Installing/verifying the JDK.
2. Installing/verifying Maven or using Maven Wrapper.
3. Installing and starting MySQL.
4. Creating the database and a least-privilege application database user.
5. Setting the three environment variables on Windows PowerShell and macOS/Linux.
6. Running `schema.sql`.
7. Opening/importing the project in an IDE.
8. Running tests.
9. Running the application from the terminal and IDE.
10. Checking saved records in MySQL Workbench.
11. Troubleshooting common errors such as access denied, unknown database, connection refused, missing JDBC driver, and unset environment variables.

Configure a reliable launch method. If using `mvn exec:java`, configure the Maven Exec Plugin and main class. Alternatively, package a runnable JAR with dependencies and document the correct command. Do not provide a `java -jar` command unless the artifact is actually configured to be executable.

### Quality requirements
- Produce complete, compilable code, not pseudocode.
- Keep class and method names consistent.
- Ensure SQL table and column names match the Java DAO code exactly.
- Ensure the README commands match the actual Maven configuration.
- Include helpful comments for beginners without commenting every obvious line.
- Add tests for important validation/business rules.
- Run available build/tests in the workspace. Fix compile errors and test failures before declaring completion.
- If MySQL is not available in the environment, clearly state that live database integration could not be tested and give the exact local verification steps.
- Do not claim the project builds or tests pass unless you actually ran them.
- Do not stop after writing a plan. Implement the project files.

### Final response
When finished, provide:
1. A short overview of what was created.
2. The project folder structure.
3. Exact setup and run commands.
4. Any environment variables the user must set.
5. Test/build results and anything that could not be verified.
6. A short demo sequence for the college presentation.
7. A list of next steps for the student.

Start by checking the workspace, then create the project incrementally. Make sensible beginner-friendly decisions without asking questions unless a genuinely blocking requirement is missing.
