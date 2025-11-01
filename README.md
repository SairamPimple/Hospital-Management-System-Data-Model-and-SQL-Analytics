# Hospital Management System: Data Model and SQL Analytics

## Description
This project focuses on designing and implementing a robust relational database management system (RDBMS) for a hypothetical hospital management scenario. The core objective was to create a normalized database schema that accurately represents complex hospital entities (e.g., Patients, Doctors, Appointments, Billing, Departments, etc.) and demonstrate advanced SQL proficiency for data extraction and analysis.

This project establishes a robust Relational Database Management System (RDBMS) designed to support the analytical and operational needs of a modern hospital. It serves as a comprehensive demonstration of advanced SQL skills, including data modeling, integrity enforcement (Constraints & Triggers), and sophisticated business intelligence querying (Views & Complex Joins).

The primary objective was not to build front-end software, but to create a highly optimized and reliable data source capable of powering critical business functions such as billing, resource scheduling, inventory management, and patient outcome analysis.

## Table of Contents
1. [Description](#Description)
2. [ER Diagram](#ER-Diagram)
3. [Key Features and Skills Demonstrated](#Key-Features-and-Skills-Demonstrated)  
4. [Tools & Technologies](#tools--technologies)  
6. [Setup & Usage](#setup--usage)  
7. [Contributing](#contributing)  

3. [Database Schema](#database-schema)  
---


## Key Features and Skills Demonstrated

This project showcases a comprehensive skill set across data modeling, advanced querying, and ensuring data integrity, making the complex Hospital Management System data actionable for analysis.

1. Advanced SQL & Analytical Reporting

- Complex View Generation: Created 11 analytical SQL views (e.g., vw_patient_summary) that aggregate data across up to 10 tables, providing a single, ready-to-use reporting layer for complex metrics like patient demographics, admission status, outstanding balances, and next appointments.

- Operational Querying: Developed 20 diverse analytical queries (Questions.sql) to solve real-world business problems, including:

  - Financial Analysis: Calculating Outstanding Patient Balances (Q5) and Total Monthly Revenue (Q17).

  - Resource Management: Analyzing Room Occupancy Rates (Q10) and tracking Equipment Maintenance Schedules (Q19).

  - Staffing & Demand: Counting Staff by Department (Q1) and Patient Visits in the Last 30 Days (Q12).

- Advanced SQL Techniques: Demonstrated expertise in complex Multi-Table Joins, Date/Time Functions (DATEDIFF, DATE_SUB, TIMESTAMP), Conditional Aggregation (COALESCE, IF), and GROUP BY/HAVING clauses for filtered reporting.

2. Database Design & Data Integrity

- Schema Development: Designed and implemented a robust Relational Database Management System (RDBMS) with 25 tables (Staff, Patient, Appointments, Billing, etc.), enforcing Third Normal Form (3NF) principles.

- Data Constraints: Maintained strong data quality using explicit constraints, including Primary/Foreign Keys, CHECK constraints (e.g., phone format, date validation), and Unique Indexes for optimized lookup performance.

- Automated Data Integrity (Triggers): Implemented 8 custom triggers to automatically enforce critical business logic, such as:

  - Appointment Conflict Prevention (trg_no_appt_overlap) to ensure doctors cannot be double-booked.

  - Room Management: Automatically incrementing/decrementing Current_Occupancy when a patient is admitted or discharged.

  - Financial Guardrails: Preventing over-payment on a bill (trg_payment_amount_check).

3. Data Context & Tools

- Data Modeling: Conceptualized and documented the entire system using an Entity-Relationship (ER) Diagram to clearly visualize table relationships and dependencies.

- Domain Expertise: Modeled complex healthcare entities like Prescription, Patient_Diagnosis, Patient_Procedure, and Audit_Log, proving the ability to handle complex, real-world data structures.

- Tools: Proficient in [Insert Specific SQL Dialect, e.g., MySQL/PostgreSQL] for database construction and management.



| Features                       | Business Relevance                            | Analytical Rigor |
| :----------------              | :------:                                      | ----: |
| Complex Schema                 | Models real-world entities (Patients, Staff, Doctors, Bills, Insurance) ensuring business rules are translated accurately into data structures.                                                                 | 23.99 |
| Data Integrity (Triggers)      |   True                                        | 23.99 |
| Business Views (11 Views)      |  False                                         | 19.99 |
| Advanced Queries (18 Examples) |  False                                         | 42.99 |



Key Features Demonstrated:

| Feature | Business Relevance | Analytical Rigor |
| Complex Schema | Models real-world entities (Patients, Staff, Doctors, Bills, Insurance) ensuring business rules are translated accurately into data structures. | Utilizes 24 distinct tables with appropriate Primary Keys, Foreign Keys, and Indexing strategies for efficient data retrieval. |
| Data Integrity (Triggers) | Ensures data quality and transactional reliability, preventing business-critical errors like scheduling conflicts or data corruption. | Implements 7 Triggers to enforce rules such as preventing overlapping doctor appointments, validating staff/patient dates of birth, and maintaining real-time room occupancy counts. |
| Business Views (11 Views) | Creates pre-aggregated and simplified data layers for easy consumption by reporting tools and decision-makers (e.g., Finance, Operations). | Generates complex, multi-join views like vw_patient_summary and vw_patient_balance to calculate metrics (e.g., outstanding balances, days admitted) derived from multiple tables. |
| Advanced Queries (18 Examples) | Enables data-driven decision-making by addressing high-priority operational and financial reporting requirements from leadership. | Exhibits mastery of complex SQL patterns, including multi-table joins, advanced date and time calculations (DATE_ADD, DATEDIFF), conditional logic (COALESCE), and financial aggregation to derive key performance indicators (KPIs). |






## ER Diagram
![ER Diagram](https://github.com/SairamPimple/Hospital_Management_System_SQL_Project/blob/main/ER%20Diagram.png)

<details>

<summary> Database Schema </summary>


- **Department** (`Dept_ID` PK)  
  - Dept_Name, Dept_Head_ID → Staff.Emp_ID, Location, Phone, Budget, Status, timestamps  

- **Staff** (`Emp_ID` PK)  
  - Employee_Number, Emp_FName, Emp_LName, Date_of_Birth, Gender, Phone, Email, Address, Pin_code, Date_of_Joining, Date_of_Separation, Emp_Type, Employee_Status, Dept_ID → Department.Dept_ID, Supervisor_ID → Staff.Emp_ID, timestamps  

- **Patient** (`Patient_ID` PK)  
  - Patient_FName, Patient_LName, Phone, Email, Blood_Type, Gender, Date_of_Birth, Address, Pincode, Emergency_Contact_Name, Emergency_Contact_Phone, Admission_Date, Discharge_Date, Patient_Status, timestamps  

- **Doctor** (`Doctor_ID` PK)  
  - Emp_ID → Staff.Emp_ID, License_Number, Specialization, Years_of_Experience, Consultation_Fee, Status, timestamps  

- **Nurse** (`Nurse_ID` PK)  
  - Emp_ID → Staff.Emp_ID, License_Number, Shift_Type, Ward_Assignment, Status, timestamps  

- **Room** (`Room_ID` PK)  
  - Room_Number, Room_Type, Floor_Number, Capacity, Current_Occupancy, Daily_Rate, Status, timestamps  

- **Patient_Room_Assignment** (`Assignment_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Room_ID → Room.Room_ID, Admission_Date, Discharge_Date, Daily_Rate  

- **Appointment** (`Appt_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Doctor_ID → Doctor.Doctor_ID, Appointment_Date, Appointment_Time, Duration, Appointment_Type, Status, Reason_for_Visit, Consultation_Fee, Scheduled_By → Staff.Emp_ID, timestamps  

- **Medicine** (`Medicine_ID` PK)  
  - Medicine_Name, Generic_Name, Medicine_Type, Strength, Unit_Cost, Current_Stock, Minimum_Stock_Level, Expiry_Date, Status, timestamps  

- **Prescription** (`Prescription_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Doctor_ID → Doctor.Doctor_ID, Medicine_ID → Medicine.Medicine_ID, Prescription_Date, Dosage, Frequency, Duration_Days, Quantity_Prescribed, Quantity_Dispensed, Total_Cost, Status, timestamps  

- **Lab_Test** (`Test_ID` PK)  
  - Test_Name, Test_Cost, Test_Category, Normal_Range, Status  

- **Lab_Screening** (`Lab_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Doctor_ID → Doctor.Doctor_ID, Test_ID → Lab_Test.Test_ID, Technician_ID → Staff.Emp_ID, Order_Date, Test_Date, Result_Date, Test_Result, Status, Test_Cost  

- **Bill** (`Bill_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Bill_Date, Due_Date, Room_Charges, Doctor_Charges, Lab_Charges, Medicine_Charges, Other_Charges, Tax_Rate, Insurance_Coverage, Amount_Paid, Status, Created_By → Staff.Emp_ID, timestamps  

- **Bill_Item** (`Bill_Item_ID` PK)  
  - Bill_ID → Bill.Bill_ID, Item_Type, Item_ID, Quantity, Unit_Cost  

- **Payment** (`Payment_ID` PK)  
  - Bill_ID → Bill.Bill_ID, Paid_Amount, Paid_Date, Method, Reference  

- **Patient_Visit** (`Visit_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Dept_ID → Department.Dept_ID, Visit_Date, Symptoms, Visit_Type  

- **Diagnosis** (`Diagnosis_Code` PK)  
  - Description, Category  

- **Patient_Diagnosis** (`PD_ID` PK)  
  - Visit_ID → Patient_Visit.Visit_ID, Diagnosis_Code → Diagnosis.Diagnosis_Code, Is_Primary  

- **Procedure_Catalog** (`Procedure_Code` PK)  
  - Description, Category, Cost  

- **Patient_Procedure** (`PP_ID` PK)  
  - Visit_ID → Patient_Visit.Visit_ID, Procedure_Code → Procedure_Catalog.Procedure_Code, Performed_By → Staff.Emp_ID, Performed_Date, Cost  

- **Insurance_Provider** (`Provider_ID` PK)  
  - Name, Contact_Info, Policy_Format  

- **Patient_Insurance** (`PI_ID` PK)  
  - Patient_ID → Patient.Patient_ID, Provider_ID → Insurance_Provider.Provider_ID, Policy_Number, Coverage_Details, Effective_Date, Expiry_Date  

- **Staff_Shift_Schedule** (`Schedule_ID` PK)  
  - Emp_ID → Staff.Emp_ID, Shift_Date, Shift_Type, Location  

- **Equipment** (`Equipment_ID` PK)  
  - Name, Model, Serial_Number, Location, Last_Maintenance, Next_Maintenance, Status  

- **Audit_Log** (`Audit_ID` PK)  
  - Table_Name, Record_ID, Action, Changed_By → Staff.Emp_ID, Change_Details, timestamps
  

</details>
  

## Tools & Technologies
- **Database Engine:** MySQL 8.0.36  
- **GUI Tool:** MySQL Workbench  
- **SQL Dialect:** Standard SQL / MySQL-specific extensions  


## Setup & Usage
1. Install MySQL 8.0.36 and MySQL Workbench  
2. Create a new schema:  
   ```sql
   DROP DATABASE IF EXISTS Hospital_Management_System; 
   CREATE DATABASE Hospital_Management_System
   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE Hospital_Management_System;
  ## Run scripts in order:
mysql -u root -p hospital_management < Hospital_DB.sql  
mysql -u root -p hospital_management < Hospital_DB_data.sql  
mysql -u root -p hospital_management < triggers_and_views.sql  
