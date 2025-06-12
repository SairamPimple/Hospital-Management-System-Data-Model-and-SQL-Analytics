# Hospital Management SQL Project

## Table of Contents
1. [Project Overview](#project-overview)  
2. [Features](#features)  
3. [Tools & Technologies](#tools--technologies)  
4. [File Structure](#file-structure)  
5. [Database Schema](#database-schema)  
6. [Data Seeding](#data-seeding)  
7. [Triggers & Views](#triggers--views)  
8. [Sample Queries & Answers](#sample-queries--answers)  
9. [Setup & Usage](#setup--usage)  
10. [Contributing](#contributing)  
11. [License](#license)  

---

## Project Overview
**Hospital Management SQL Project** is a comprehensive demonstration of SQL proficiency and real-world problem solving. It models a hospital’s back-office operations—including departments, staff, patients, rooms, billing, lab tests, and more—using robust relational design and advanced SQL constructs.

## Features
- Entity relationship modeling with enforced referential integrity  
- Data validation via CHECK constraints and triggers  
- Reporting via views for common queries and dashboards  
- Sample data inserts to exercise all relationships  
- Example queries with answers to showcase analytical skills  

## Tools & Technologies
- **Database Engine:** MySQL 8.0.36  
- **GUI Tool:** MySQL Workbench  
- **SQL Dialect:** Standard SQL / MySQL-specific extensions  

## File Structure
├── Hospital_DB.sql            # 1. Table creation scripts
├── Hospital_DB_data.sql       # 2. INSERT statements to seed tables
├── triggers_and_views.sql     # 3. Triggers and CREATE VIEW definitions
└── Questions.sql              # 4. Sample query set with answers

## Database Schema
All entity tables are defined in `Hospital_DB.sql`, including:
- **Department**, **Staff**, **Patient**  
- **Doctor**, **Nurse**, **Room**, **Patient_Room_Assignment**  
- **Appointment**, **Medicine**, **Prescription**  
- **Lab_Test**, **Lab_Screening**, **Bill**, **Bill_Item**, **Payment**  
- Supporting tables: **Patient_Visit**, **Diagnosis**, **Patient_Diagnosis**, **Procedure_Catalog**, **Patient_Procedure**, **Insurance_Provider**, **Patient_Insurance**, **Staff_Shift_Schedule**, **Equipment**, **Audit_Log**

## Data Seeding
`Hospital_DB_data.sql` populates the database with realistic sample records:
- 10+ entries per core table  
- Inserts respect foreign-key dependencies  
- Demonstrates edge cases (e.g., inpatients, transfers, insurance coverage)

## Triggers & Views
Defined in `triggers_and_views.sql`:
- **Validation triggers** for dates, overlaps, capacity, payments, self-supervision  
- **Views** for common reporting: active inpatients, today’s appointments, low stock, equipment maintenance, patient summary, and more

## Sample Queries & Answers
`Questions.sql` contains 20 curated SQL challenges and their solutions, including:
- Aggregations, window-style queries, subqueries  
- Date functions, conditional logic, JOIN patterns  
- Dashboard-style summaries  

## Setup & Usage
1. Install MySQL 8.0.36 and MySQL Workbench  
2. Create a new schema:  
   ```sql
   CREATE DATABASE hospital_management;
   USE hospital_management;
  ## Run scripts in order:
mysql -u root -p hospital_management < Hospital_DB.sql  
mysql -u root -p hospital_management < Hospital_DB_data.sql  
mysql -u root -p hospital_management < triggers_and_views.sql  
