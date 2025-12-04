📌 Emergency Room Management System (ERMS) — CS 4400 Project

This project implements a full relational database system for a hospital Emergency Room, following classical database design methodology.
Across Phase II and Phase III, I built both the physical database schema and the operational SQL logic that powers the system.

Phase II — Database Schema & Data Integration

Converted the provided EER diagram into a complete relational schema, defining all primary keys, foreign keys, and constraints.

Implemented full CREATE TABLE statements with data types, integrity rules, and justified ON UPDATE / ON DELETE behaviors.

Cleaned and normalized messy input data from multiple sources (text + spreadsheets) and wrote INSERT statements to load structured tables.

Documented all unhandled constraints not enforceable through SQL alone.

Phase III — Views & Stored Procedures

Developed all required views to provide role-specific perspectives for hospital staff.

Implemented 15 stored procedures enabling controlled querying and updating of the ER database, handling NULL/optional parameters and all scenario rules.

Ensured full compatibility with the Phase II schema and validated correctness through extensive testing and autograder cases.
