# SafeHer project plan

SafeHer is a Java Swing and MySQL educational prototype for maintaining trusted contacts, locally recording SOS alerts, and reviewing alert history. It does not send notifications or access live location.

## Components
- `model`: immutable user, contact, and alert records.
- `dao`: JDBC persistence using prepared statements and user-scoped queries.
- `service`: validation, password hashing, and business rules.
- `ui`: Swing login/registration, dashboard, contact CRUD, alert creation/history/status.
- `config`: environment-based MySQL connection configuration.

## OOP concepts
Encapsulation is reflected in immutable Java records and private service state. Models represent domain objects; constructors enforce their fields. Service classes abstract validation/business logic from the UI. JDBC DAOs separate persistence. `SqlAction` is a functional interface consumed polymorphically by UI actions. Inheritance is not forced.

## Limits
The app stores an alert record in MySQL. It does not send SMS/email, contact authorities, or track GPS. Journeys are represented in the schema for future work; journey screens are not part of this implementation.
