
# 🏥 Hospital DBMS

This project is a Hospital Database Management System (DBMS) implemented using SQL. It provides a structured relational schema to manage hospital operations such as patient records, doctor assignments, room allocations, billing, diagnostics, and admissions.

📂 Project Overview

The goal of this project is to simulate a comprehensive hospital management system through a normalized SQL database. It includes various entities and their relationships to streamline data organization and retrieval.

Features
	•	Tables for Patients, Doctors, Nurses, Rooms, Admissions, Diagnostics, Medications, and more.
	•	Defined relationships between entities using foreign keys.
	•	Populated with sample data for testing and demonstration.
	•	Supports complex queries to extract meaningful insights and reports.

🧱 Database Schema

Here are the key entities in the database:
	•	Patient: Stores patient details and demographics.
	•	Doctor: Contains information about hospital doctors and specializations.
	•	Room: Manages hospital room availability and allocation.
	•	Nurse: Tracks nursing staff and assignments.
	•	Admission: Records patient admissions with assigned doctors and rooms.
	•	Diagnosis: Contains diagnosis information for each patient.
	•	Medication: Tracks prescriptions given to patients.
	•	Bill: Manages billing details based on admissions and services rendered.

The schema uses appropriate primary keys, foreign keys, and constraints to maintain data integrity.

📦 How to Use

1. Prerequisites

You need an SQL-compatible database management system like:
	•	MySQL
	•	PostgreSQL
	•	SQLite (with minor adjustments)

2. Setup Instructions
	1.	Clone this repository:

git clone https://github.com/SairamPimple/Hospital_Management_System_SQL_Project
cd hospital-dbms


	2.	Open your SQL environment and run the SQL script:

source Hospital_DBMS.sql;


	3.	Verify the schema has been created and populated:

SHOW TABLES;



3. Sample Queries

Here are some example queries you can run after setup:
	•	Get all currently admitted patients:

SELECT * FROM Admission WHERE discharge_date IS NULL;


	•	Find all patients under a specific doctor:

SELECT p.name FROM Patient p
JOIN Admission a ON p.patient_id = a.patient_id
WHERE a.doctor_id = 'D001';


	•	Generate a bill for a patient:

SELECT * FROM Bill WHERE patient_id = 'P005';



🧠 Learning Objectives

This project is perfect for:
	•	Students learning database normalization and relational design.
	•	Practicing SQL DDL/DML statements.
	•	Understanding real-world schema modeling.
	•	Demonstrating DBMS concepts in interviews or academic submissions.

