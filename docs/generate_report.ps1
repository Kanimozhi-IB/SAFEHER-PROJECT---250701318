$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression

$script:body = [System.Text.StringBuilder]::new()
function Escape-Xml([string]$Value) {
    if ($null -eq $Value) { return '' }
    return [System.Security.SecurityElement]::Escape($Value)
}
function Add-Paragraph([string]$Text, [string]$Style = 'Normal', [switch]$Code) {
    $escaped = Escape-Xml $Text
    if ($Code) {
        [void]$script:body.Append('<w:p><w:pPr><w:pStyle w:val="Code"/></w:pPr><w:r><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="16"/></w:rPr><w:t xml:space="preserve">' + $escaped + '</w:t></w:r></w:p>')
    } else {
        [void]$script:body.Append('<w:p><w:pPr><w:pStyle w:val="' + $Style + '"/></w:pPr><w:r><w:t xml:space="preserve">' + $escaped + '</w:t></w:r></w:p>')
    }
}
function Add-PageBreak {
    [void]$script:body.Append('<w:p><w:r><w:br w:type="page"/></w:r></w:p>')
}
function Add-CodeBlock([string]$Text) {
    foreach ($line in ($Text -split "`r?`n")) { Add-Paragraph $line -Code }
}

$root = Split-Path -Parent $PSScriptRoot
$output = Join-Path $root 'SafeHer_Project_Report.docx'

Add-Paragraph 'SAFEHER' 'Title'
Add-Paragraph 'Women Safety and Emergency Alert System' 'Subtitle'
Add-Paragraph 'College Mini-Project Report' 'Subtitle'
Add-Paragraph ''
Add-Paragraph 'Submitted by: __________________________________________'
Add-Paragraph 'Register / Roll number: __________________________________'
Add-Paragraph 'Department and college: _________________________________'
Add-Paragraph 'Project guide: ___________________________________________'
Add-Paragraph 'Academic year: __________________________________________'
Add-Paragraph ''
Add-Paragraph 'Technology: Java 17+, Swing, JDBC, MySQL 8, Maven'
Add-Paragraph 'Project type: Object-Oriented Programming and Database Management Systems'
Add-PageBreak

Add-Paragraph 'Abstract' 'Heading1'
Add-Paragraph 'SafeHer is a desktop prototype that lets a registered user maintain trusted emergency contacts, create a local SOS alert record, and review or update alert history. It is implemented in Java with a Swing interface and stores persistent data in MySQL through JDBC. Passwords are stored as BCrypt hashes. The prototype does not send SMS or email, contact authorities, obtain live GPS, or guarantee personal safety.'
Add-Paragraph 'Contents' 'Heading1'
@('1. Introduction','2. Objectives and scope','3. Requirements','4. Technology and architecture','5. Database design','6. Implementation and OOP concepts','7. Setup and execution','8. Testing and observed output','9. Limitations and future work','10. Conclusion','Appendix A. Complete source code','Appendix B. SQL demonstration') | ForEach-Object { Add-Paragraph $_ }

Add-Paragraph '1. Introduction' 'Heading1'
Add-Paragraph 'People may want quick access to trusted contacts and a way to record an alert or planned response. SafeHer provides an educational desktop workflow for storing contact information and recording test alerts. All records are scoped to the signed-in user.'
Add-Paragraph 'Problem statement' 'Heading2'
Add-Paragraph 'A user needs a simple place to maintain trusted contacts and create a time-stamped record during a safety concern. The project demonstrates how a Java application can validate input and persist relational data.'
Add-Paragraph 'Proposed solution' 'Heading2'
Add-Paragraph 'SafeHer combines account registration and sign-in, contact CRUD, local SOS recording with optional location fields, alert history, and status updates. The app explicitly labels alerts as local records.'

Add-Paragraph '2. Objectives and scope' 'Heading1'
@('• Demonstrate Java classes, encapsulation, service abstractions, and JDBC persistence.','• Register and authenticate users with salted BCrypt password hashes.','• Add, list, edit, and delete trusted contacts.','• Record an SOS alert with optional coordinates and location note.','• Show the current user’s alert history newest first and update status.','• Demonstrate MySQL tables, primary/foreign keys, constraints, indexes, and SQL CRUD operations.') | ForEach-Object { Add-Paragraph $_ }
Add-Paragraph 'Journey table structure is included in the database schema as an extension point. A journey user interface and journey CRUD workflow are not implemented in this version.'

Add-Paragraph '3. Requirements' 'Heading1'
Add-Paragraph 'Functional requirements' 'Heading2'
@('• Account registration with name, unique email, unique phone, and password.','• Sign-in using email and password verification.','• Trusted emergency contact management.','• Test SOS alert creation, optional location, history, and status updates.','• Dashboard counts for the signed-in user’s contacts and alerts.') | ForEach-Object { Add-Paragraph $_ }
Add-Paragraph 'Non-functional requirements' 'Heading2'
@('• Use PreparedStatement for SQL input and try-with-resources for JDBC resources.','• Store database configuration in SAFEHER_DB_URL, SAFEHER_DB_USER, SAFEHER_DB_PASSWORD environment variables.','• Keep each user’s records isolated using user_id conditions in DAO operations.','• Show a clear message that alerts are recorded locally and not delivered.') | ForEach-Object { Add-Paragraph $_ }

Add-Paragraph '4. Technology and architecture' 'Heading1'
Add-Paragraph 'Java 17 or newer provides the application language and Swing UI. Maven manages dependencies and build commands. MySQL stores relational records. JDBC Connector/J connects Java to MySQL. jBCrypt hashes and verifies passwords. JUnit 5 covers validation rules.'
Add-Paragraph 'Layered architecture' 'Heading2'
Add-CodeBlock @'
Swing UI (Main.java)
        ↓
Service layer (validation and business rules)
        ↓
DAO layer (JDBC and PreparedStatement)
        ↓
MySQL database (schema.sql)
'@
Add-Paragraph 'Package responsibilities' 'Heading2'
@('• config: database connection from environment variables.','• model: User, EmergencyContact, and EmergencyAlert records.','• dao: SQL operations for accounts, contacts, and alerts.','• service: validation, BCrypt authentication, and status rules.','• ui: Swing login, registration, contacts, SOS, and history screens.') | ForEach-Object { Add-Paragraph $_ }

Add-Paragraph '5. Database design' 'Heading1'
Add-Paragraph 'The schema defines four InnoDB tables. users stores account details and password hashes. emergency_contacts, emergency_alerts, and journeys each reference users through user_id. Foreign keys cascade when a user row is deleted. Unique constraints protect user email and phone. Status checks restrict alert and journey values.'
Add-Paragraph 'Relationships' 'Heading2'
@('• One user has many emergency contacts.','• One user has many emergency alerts.','• One user may have many journeys (schema only in this implementation).') | ForEach-Object { Add-Paragraph $_ }
Add-Paragraph 'The full executable DDL appears in Appendix A. Additional SELECT, INSERT, UPDATE, DELETE, and JOIN examples appear in Appendix B.'

Add-Paragraph '6. Implementation and OOP concepts' 'Heading1'
Add-Paragraph 'Encapsulation and objects' 'Heading2'
Add-Paragraph 'User, EmergencyContact, and EmergencyAlert are domain model records. DAOs and services hold their collaborators privately and expose operations through methods.'
Add-Paragraph 'Abstraction and polymorphism' 'Heading2'
Add-Paragraph 'Service classes separate validation and business rules from Swing components. The UI’s SqlAction functional interface provides a common operation shape for persistence actions, invoked through lambdas.'
Add-Paragraph 'Inheritance' 'Heading2'
Add-Paragraph 'The design does not add artificial inheritance. Swing screens use the standard JPanel/JFrame inheritance required by the UI toolkit.'
Add-Paragraph 'Security' 'Heading2'
Add-Paragraph 'Passwords are hashed using BCrypt with a generated salt. SQL uses prepared statements. Database credentials are read from environment variables and are not included in the source appendix. Never place a real password in the submission.'

Add-Paragraph '7. Setup and execution' 'Heading1'
Add-Paragraph 'Prerequisites: JDK 17 or newer, Maven, and a running MySQL 8 server.'
Add-Paragraph 'Create database and application user in MySQL Workbench as an administrator:'
Add-CodeBlock @'
CREATE DATABASE safeher_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'safeher_app'@'localhost' IDENTIFIED BY 'replace-with-a-local-password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX
  ON safeher_db.* TO 'safeher_app'@'localhost';
'@
Add-Paragraph 'Open src/main/resources/schema.sql in Workbench, select safeher_db, and execute the complete script. Set environment variables in the same PowerShell window used to launch Maven:'
Add-CodeBlock @'
$env:SAFEHER_DB_URL = 'jdbc:mysql://localhost:3306/safeher_db'
$env:SAFEHER_DB_USER = 'safeher_app'
$env:SAFEHER_DB_PASSWORD = 'your-local-password'
mvn test
mvn exec:java
'@
Add-Paragraph 'The app can also be opened from an IDE as com.safeher.Main after configuring the same environment variables.'

Add-Paragraph '8. Testing and observed output' 'Heading1'
Add-Paragraph 'Automated validation tests cover email normalization/format, phone validation, coordinate pairing, and coordinate ranges. The manual test plan covers registration, duplicate account handling, login, contact CRUD, SOS persistence, status updates, user isolation, and database outage handling.'
Add-Paragraph 'Observed application output' 'Heading2'
Add-Paragraph 'The user-provided application run showed the dashboard after sign-in, with one contact and one alert. The alert appeared with status CREATED and location unavailable. This confirms the UI displayed a persisted alert record in the demonstrated run.'
Add-CodeBlock @'
SafeHer | Safety companion prototype
Welcome, [registered user]
Contacts: 1    Alerts: 1
#1 | 2026-10-17T22:43:56 | CREATED | Location unavailable
'@
Add-Paragraph 'The record above is transcribed from the user-provided screenshot. It is a local test alert, not proof of a delivered emergency notification. Build/test output was not captured in this report.'

Add-Paragraph '9. Limitations and future work' 'Heading1'
@('• The SOS button only inserts a database record.','• No SMS, email, police, or emergency-service integration is implemented.','• Location is manually entered; the application does not use live GPS.','• Journey table exists but journey screens and business workflows remain future work.','• Production use would require security review, privacy controls, backup strategy, and carefully tested external integrations.') | ForEach-Object { Add-Paragraph $_ }

Add-Paragraph '10. Conclusion' 'Heading1'
Add-Paragraph 'SafeHer demonstrates a layered Java desktop application connected to a relational MySQL database. It applies object-oriented modeling, validation, password hashing, prepared statements, constraints, and user-scoped CRUD operations. The prototype’s limits are presented clearly: it records data locally and does not provide real emergency dispatch.'
Add-Paragraph 'References' 'Heading1'
@('• Apache Maven Project. Maven documentation: https://maven.apache.org/guides/','• Oracle. Java documentation: https://docs.oracle.com/en/java/','• MySQL. MySQL 8.0 Reference Manual: https://dev.mysql.com/doc/refman/8.0/en/','• jBCrypt dependency: org.mindrot:jbcrypt (version listed in pom.xml).') | ForEach-Object { Add-Paragraph $_ }

$sourceFiles = @(
    'pom.xml', '.gitignore', '.env.example',
    'src/main/resources/schema.sql',
    'src/main/java/com/safeher/Main.java',
    'src/main/java/com/safeher/config/DatabaseConfig.java',
    'src/main/java/com/safeher/model/User.java',
    'src/main/java/com/safeher/model/EmergencyContact.java',
    'src/main/java/com/safeher/model/EmergencyAlert.java',
    'src/main/java/com/safeher/dao/UserDao.java',
    'src/main/java/com/safeher/dao/ContactDao.java',
    'src/main/java/com/safeher/dao/AlertDao.java',
    'src/main/java/com/safeher/service/Validation.java',
    'src/main/java/com/safeher/service/AuthService.java',
    'src/main/java/com/safeher/service/ContactService.java',
    'src/main/java/com/safeher/service/AlertService.java',
    'src/test/java/com/safeher/ValidationTest.java',
    'docs/SQL_DEMO.sql'
)
Add-PageBreak
Add-Paragraph 'Appendix A. Complete source code' 'Heading1'
Add-Paragraph 'The following listings are copied from the project workspace. Database passwords and local credentials are intentionally excluded.'
foreach ($relative in $sourceFiles) {
    $path = Join-Path $root $relative
    if (Test-Path -LiteralPath $path) {
        Add-PageBreak
        Add-Paragraph $relative 'Heading2'
        Add-CodeBlock (Get-Content -Raw -LiteralPath $path)
    }
}

Add-PageBreak
Add-Paragraph 'Appendix B. SQL demonstration' 'Heading1'
Add-CodeBlock (Get-Content -Raw -LiteralPath (Join-Path $root 'docs/SQL_DEMO.sql'))

$document = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' + $script:body.ToString() + '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134"/></w:sectPr></w:body></w:document>'
$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:rPr><w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/><w:sz w:val="22"/></w:rPr><w:pPr><w:spacing w:after="140" w:line="276" w:lineRule="auto"/></w:pPr></w:style>
<w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/><w:basedOn w:val="Normal"/><w:pPr><w:jc w:val="center"/><w:spacing w:before="2400" w:after="400"/></w:pPr><w:rPr><w:b/><w:color w:val="17365D"/><w:sz w:val="48"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Subtitle"><w:name w:val="Subtitle"/><w:basedOn w:val="Normal"/><w:pPr><w:jc w:val="center"/></w:pPr><w:rPr><w:color w:val="365F91"/><w:sz w:val="28"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Heading1"><w:name w:val="heading 1"/><w:basedOn w:val="Normal"/><w:pPr><w:outlineLvl w:val="0"/><w:keepNext/><w:spacing w:before="300" w:after="160"/></w:pPr><w:rPr><w:b/><w:color w:val="17365D"/><w:sz w:val="32"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Heading2"><w:name w:val="heading 2"/><w:basedOn w:val="Normal"/><w:pPr><w:outlineLvl w:val="1"/><w:keepNext/><w:spacing w:before="200" w:after="100"/></w:pPr><w:rPr><w:b/><w:color w:val="365F91"/><w:sz w:val="26"/></w:rPr></w:style>
<w:style w:type="paragraph" w:styleId="Code"><w:name w:val="Code"/><w:basedOn w:val="Normal"/><w:pPr><w:spacing w:after="0" w:line="210"/></w:pPr><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="16"/></w:rPr></w:style>
</w:styles>
'@
$contentTypes = '<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/><Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/></Types>'
$relationships = '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'
$docRelationships = '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>'

if (Test-Path -LiteralPath $output) { Remove-Item -LiteralPath $output }
$stream = [System.IO.File]::Open($output, [System.IO.FileMode]::CreateNew)
$archive = [System.IO.Compression.ZipArchive]::new($stream, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    $entries = @{
        '[Content_Types].xml' = $contentTypes
        '_rels/.rels' = $relationships
        'word/document.xml' = $document
        'word/styles.xml' = $styles
        'word/_rels/document.xml.rels' = $docRelationships
    }
    foreach ($name in $entries.Keys) {
        $entry = $archive.CreateEntry($name)
        $writer = [System.IO.StreamWriter]::new($entry.Open(), [System.Text.UTF8Encoding]::new($false))
        $writer.Write($entries[$name])
        $writer.Dispose()
    }
} finally {
    $archive.Dispose()
    $stream.Dispose()
}
Write-Output "Created $output"
