📘 Emergency Room Management System (ERMS) — Database Engineering Project

This project is a full end-to-end database solution for managing an Emergency Room’s operational data. It was developed using classical database engineering methodology and implemented in MySQL 8.0+.
The system spans schema design, data cleaning, normalization, view creation, and stored-procedure logic, forming a complete backend for an ER information system.

🚀 Phase II — Relational Schema Design & Data Integration

Phase II focused on transforming the EER model into a functional, normalized relational database and preparing real-world messy data for production use.

✔ Relational Schema Construction

Translated the instructor-provided EERD into a full relational schema with precise:

Primary keys

Composite and foreign keys

Relationship mappings (1:N, M:N, ISA hierarchies)

Justified ON UPDATE and ON DELETE behaviors for each FK using scenario-driven logic.

Ensured referential integrity, domain constraints, and normalization up to BCNF where applicable.

✔ Database Creation (CREATE TABLE Statements)

Built a complete set of MySQL tables with:

Data type constraints

NOT NULL, UNIQUE, and CHECK constraints

Foreign key cascades / restricts

Clear separation between core entities (Patient, Staff, Doctor, Nurse) and relationship tables (Appointment, Med_Order, etc.)

✔ Data Cleaning & Ingestion

The initial ER data was provided in two inconsistent formats:

A text-based description (semi-structured, inconsistent naming)

A spreadsheet containing non-normalized records

Key cleaning and integration steps included:

Restructuring non-normalized spreadsheet rows into proper relational tuples

Standardizing categorical fields and resolving ID/foreign key mismatches

Converting timestamps, numeric values, and boolean indicators to the correct MySQL formats

Inserting clean, validated data through hand-written INSERT statements

Verifying referential integrity to ensure the full schema loaded with no errors

✔ Unhandled Constraint Documentation

Identified system-level constraints not enforceable through SQL declarations (e.g., cardinality rules, logical business constraints) and documented them for later enforcement in application logic or stored procedures.

⚙️ Phase III — Views & Stored Procedure Logic

Phase III implemented the full "operational layer" of the ERMS through carefully designed SQL views and stored procedures.

✔ View Development (Hospital Staff Perspectives)

Implemented 5 views that present filtered, role-specific insights into the ER database, such as:

Current staffing status

Doctor–patient assignments

Upcoming appointments

Medication order summaries

Room or equipment usage

These views help different hospital roles retrieve information without needing raw table access.

✔ Stored Procedure Implementation (Core Application Logic)

Developed 15 stored procedures that enable system operators to safely query and update ER data, including:

Scheduling or cancelling appointments

Assigning or removing staff from patients

Managing medication orders

Filtering records using optional / nullable inputs

Handling edge cases (e.g., missing IDs, invalid dates)

All procedures were built using the required:

Naming conventions

Input parameter types

Output formats

Error-safe logic aligned with the scenario rules

✔ Validation & Testing

Procedures were tested with numerous cases, including NULL parameters and boundary conditions.

Verified correctness using both the provided autograder and manual SQL test scripts.

Ensured all views and procedures run without errors on a clean MySQL Workbench installation.

🛠️ Tech Stack

MySQL 8.0+

SQL (DDL + DML + Stored Procedures)

EER → Relational Schema Methodology

Data Cleaning & Normalization

Integrity-Conscious Database Design

📄 Project Highlights

Built a production-quality relational schema from an EER diagram.

Loaded and normalized messy real-world ER data into a clean relational structure.

Implemented a full suite of views and stored procedures used to operate the ER system.

Ensured data integrity, correctness, and robustness across hundreds of test cases.
