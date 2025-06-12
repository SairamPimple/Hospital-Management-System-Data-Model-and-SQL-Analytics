# Hospital Management SQL Project

## Project Overview
**Hospital Management SQL Project** is a comprehensive demonstration of SQL proficiency and real-world problem solving. It models a hospital’s back-office operations—including departments, staff, patients, rooms, billing, lab tests, and more—using robust relational design and advanced SQL constructs.

## Table of Contents
1. [Project Overview](#project-overview)
2. [ER Diagram](#ER-Diagram)
3. [Database Schema](#database-schema)  
4. [Features](#features)  
5. [Tools & Technologies](#tools--technologies)  
6. [File Structure](#file-structure)   
8. [Setup & Usage](#setup--usage)  
9. [Contributing](#contributing)  

---

## ER Diagram
![ER Diagram]()

## Database Schema

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
├── Hospital_DB_Tables.sql            # 1. Table creation scripts
├── Hospital_DB_Data.sql       # 2. INSERT statements to seed tables
├── triggers_and_views.sql     # 3. Triggers and CREATE VIEW definitions
└── Questions.sql              # 4. Sample query set with answers


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
