-- Hospital Management System Database 

-- Create Database
DROP DATABASE IF EXISTS Hospital_Management_System; 
CREATE DATABASE Hospital_Management_System
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Hospital_Management_System;

-- 1. DEPARTMENT TABLE
CREATE TABLE Department (
    Dept_ID INT AUTO_INCREMENT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL UNIQUE,
    Dept_Head_ID INT NULL,
    Location VARCHAR(100),
    Phone VARCHAR(10),
    Budget DECIMAL(15,2) DEFAULT 0.00,
    Status ENUM('Active', 'Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_phone_digite_dept CHECK (Phone REGEXP '^[0-9]{10}$')
);

-- 2. Staff Table
CREATE TABLE Staff (
	Emp_ID INT  AUTO_INCREMENT PRIMARY KEY,
    Employee_Number VARCHAR(20) UNIQUE NOT NULL,
    Emp_FName VARCHAR(50) NOT NULL,
    Emp_LName VARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Gender ENUM('Male','Female','other') NOT NULL,
    Phone VARCHAR(10) NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Address TEXT NOT NULL,
    Pincode VARCHAR(6) NOT NULL,
    Date_of_Joining DATE NOT NULL,
    Date_of_Separation DATE NULL,
    Emp_Type ENUM('Doctor','Nurse','Technician','Administrator','Support') NOT NULL,
    Employee_Status ENUM('Active','Inactive','Terminated','On Leave') DEFAULT 'Active',
    Dept_ID INT NOT NULL,
    Supervisor_ID INT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Supervisor_ID) REFERENCES Staff(Emp_ID) ON DELETE SET NULL,
    
    INDEX idx_staff_name (Emp_LName, Emp_FName),
    INDEX idx_staff_type (Emp_Type),
    INDEX idx_staff_dept (Dept_ID),
    
    CONSTRAINT uq_staff_empno UNIQUE (Employee_Number), 
    CONSTRAINT chk_separation_after_joining CHECK (Date_of_Separation IS NULL OR Date_of_Separation >= Date_of_Joining),
    CONSTRAINT chk_phone_digit_staff CHECK (Phone REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_email_staff CHECK (Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_pincode_staff CHECK (Pincode REGEXP '^[0-9]{6}$')
);

ALTER TABLE Department
  ADD CONSTRAINT fk_dept_head
    FOREIGN KEY (Dept_Head_ID) REFERENCES Staff(Emp_ID) ON DELETE SET NULL;

-- 3. Patient Table
CREATE TABLE Patient (
	Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_FName VARCHAR(50) NOT NULL,
    Patient_LName VARCHAR(50) NOT NULL,
    Phone VARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Blood_Type ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Address TEXT NOT NULL,
    Pincode VARCHAR(6),
    Emergency_Contact_Name VARCHAR(100),
    Emergency_Contact_Phone VARCHAR(10),
    Admission_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Discharge_Date DATETIME NULL,
    Patient_Status ENUM('Active','Discharged','Transferred') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_patient_name (Patient_LName, Patient_FName),
    INDEX idx_patient_phone (Phone),
    INDEX idx_admission_date (Admission_Date),
    
    CONSTRAINT chk_phone_digit_patient CHECK (Phone REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_emergency_contact_phone_digit CHECK (Emergency_Contact_Phone REGEXP '^[0-9]{10}$'),
    CONSTRAINT chk_email_patient CHECK (Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_pincode_patient CHECK (Pincode REGEXP '^[0-9]{6}$'),
    CONSTRAINT chk_discharge_after_admission CHECK (Discharge_Date IS NULL OR Discharge_Date >= Admission_Date)
);

-- 4. DOCTOR TABLE
CREATE TABLE Doctor (
	Doctor_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL UNIQUE,
    License_Number VARCHAR(50) UNIQUE NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Years_of_Experience INT DEFAULT 0,
    Consultation_Fee DECIMAL(10,2) DEFAULT 0.0,
    Status ENUM('Active','On Leave','Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Emp_ID) REFERENCES Staff(Emp_ID) ON DELETE CASCADE,
    
    INDEX idx_doctor_license (License_Number),
    INDEX idx_consultation_specialization (Specialization),
    
    CONSTRAINT chk_experience CHECK (Years_of_Experience >= 0),
    CONSTRAINT chk_consultation_fee CHECK (Consultation_Fee >= 0)
);

-- 5. Nurse Table
CREATE TABLE Nurse (
	Nurse_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL UNIQUE,
    License_Number VARCHAR(50) UNIQUE NOT NULL,
    Shift_Type ENUM('Day','Night','Evening') NOT NULL,
    Ward_Assignment VARCHAR(50),
    Status ENUM('Active','On Leave','Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Emp_ID) REFERENCES Staff(Emp_ID) ON DELETE CASCADE,
    
    INDEX idx_nurse_license (License_Number),
    INDEX idx_nurse_shift (Shift_Type)
);

-- 6. Rooms Table
CREATE TABLE Room (
	Room_ID INT AUTO_INCREMENT PRIMARY KEY,
    Room_Number VARCHAR(20) UNIQUE NOT NULL,
    Room_Type ENUM('General','Private','ICU','Emergency','Surgery') NOT NULL,
    Floor_Number INT NOT NULL,
    Capacity INT DEFAULT 1,
    Current_Occupancy INT DEFAULT 0,
    Daily_Rate DECIMAL(10,2) NOT NULL,
    Status ENUM('Available','Occupied','Maintenance') DEFAULT 'Available',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_room_number (Room_Number),
    INDEX idx_room_type (Room_Type),
    INDEX idx_room_status (Status),
    
    CONSTRAINT chk_capacity CHECK (Capacity > 0),
    CONSTRAINT chk_occupancy CHECK (Current_Occupancy >= 0 AND Current_Occupancy <= Capacity),
    CONSTRAINT chk_daily_rate CHECK (Daily_Rate >= 0)
); 

-- 7. Patient room Assignment
CREATE TABLE Patient_Room_Assignment (
	Assignment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Room_ID INT NOT NULL,
    Admission_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Discharge_Date DATETIME NULL,
    Daily_Rate DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY(Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY(Room_ID) REFERENCES Room(Room_ID) ON DELETE RESTRICT,
    
    INDEX idx_patient_room (Patient_ID),
    INDEX idx_room_assignment (Room_ID),
    INDEX idx_admission_date (Admission_Date),
    
    CONSTRAINT chk_room_discharge_date CHECK (Discharge_Date IS NULL OR Discharge_Date >= Admission_Date)
);

-- 8. Appointments Table
CREATE TABLE Appointment (
	Appt_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Duration INT DEFAULT 20,
    Appointment_Type ENUM('Consultation','Follow-up','Emergency', 'Surgery') NOT NULL,
    Status ENUM('Scheduled','Confirmed','Completed','Cancelled','No Show') DEFAULT 'Scheduled',
    Reason_for_Visit TEXT,
    Consultation_Fee DECIMAL(10,2) NOT NULL,
    Scheduled_By INT NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Scheduled_By) REFERENCES Staff(Emp_ID),
    
    INDEX idx_appointment_date (Appointment_Date, Appointment_Time),
    INDEX idx_appointment_doctor (Doctor_ID),
    INDEX idx_appointment_patient (Patient_ID),
    
    UNIQUE KEY uk_doctor_datetime (Doctor_ID,Appointment_Date,Appointment_Time)
);

-- 9. Medicine
CREATE TABLE Medicine (
	Medicine_ID INT AUTO_INCREMENT PRIMARY KEY,
    Medicine_Name VARCHAR(100) NOT NULL,
    Generic_Name VARCHAR(100),
    Medicine_Type ENUM('Tablet','Capsule','Syrup','Injection','Ointment','Other') NOT NULL,
    Strength VARCHAR(50),
    Unit_Cost DECIMAL(10,2) NOT NULL,
    Current_Stock INT DEFAULT 0,
    Minimum_Stock_Level INT DEFAULT 10,
    Expiry_Date DATE,
    Status ENUM('Active','Discontinued','Out of Stock') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_medicine_name (Medicine_Name),
    INDEX idx_medicine_type (Medicine_Type),
    INDEX idx_stock_level (Current_Stock),
    
    CONSTRAINT chk_unit_cost CHECK (Unit_Cost >= 0),
    CONSTRAINT chk_stock_levels CHECK (Current_Stock >= 0 AND Minimum_Stock_Level >= 0)
);

-- 10. Prescription
CREATE TABLE Prescription (
	Prescription_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Medicine_ID INT NOT NULL,
    Prescription_Date DATE NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Frequency VARCHAR(100) NOT NULL,
    Duration_Days INT NOT NULL,
    Quantity_Prescribed INT NOT NULL,
    Quantity_Dispensed INT NOT NULL,
    Status ENUM('Active','Completed','Cancelled') DEFAULT 'Active',
    Total_Cost DECIMAL(10,2),
	Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Medicine_ID) REFERENCES Medicine(Medicine_ID) ON DELETE RESTRICT,
    
	INDEX idx_prescription_patient (Patient_ID),
    INDEX idx_prescription_doctor (Doctor_ID),
    INDEX idx_prescription_date (Prescription_Date),
    
    CONSTRAINT chk_prescription_quantity CHECK (Quantity_Prescribed>0 AND Quantity_Dispensed >= 0 AND Quantity_Dispensed <= Quantity_Prescribed),
    CONSTRAINT chk_prescription_duration CHECK (Duration_Days > 0)
); 

-- 11. LAB Tests Table
CREATE TABLE Lab_Test (
	test_ID INT AUTO_INCREMENT PRIMARY KEY,
    Test_Name VARCHAR(100) NOT NULL,
    Test_Category VARCHAR(100) NOT NULL,
    Normal_Range VARCHAR(100),
    Test_Cost DECIMAL(10,2) NOT NULL,
    Status ENUM('Active','Discontinued') DEFAULT 'Active',
    
    INDEX idx_test_name (Test_Name),
    INDEX idx_test_category (Test_Category),
    
    CONSTRAINT chk_test_cost CHECK (Test_Cost >= 0)
);

-- 12 LAB Screening Tbale
CREATE TABLE Lab_Screening (
	Lab_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Test_ID INT NOT NULL,
    Technician_ID INT NOT NULL,
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Test_Date DATETIME,
    Result_Date DATETIME,
    Test_Result VARCHAR(500),
    Status ENUM('Ordered','In Progress','Completed','Cancelled') DEFAULT 'Ordered',
    Test_Cost DECIMAL(10,2),
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Test_ID) REFERENCES Lab_Test(Test_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Technician_ID) REFERENCES Staff(Emp_ID) ON DELETE RESTRICT,
    
	INDEX idx_lab_patient (Patient_ID),
    INDEX idx_lab_doctor (Doctor_ID),
    INDEX idx_lab_order_date (Order_Date)
);

-- 13. Billing Table
CREATE TABLE Bill (
	Bill_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Bill_Date DATE NOT NULL,
    Due_Date DATE,
    Room_Charges DECIMAL(12,2) DEFAULT 0.00,
    Doctor_Charges DECIMAL(12,2) DEFAULT 0.00,
    Lab_Charges DECIMAL(12,2) DEFAULT 0.00,
    Medicine_Charges DECIMAL(12,2) DEFAULT 0.00,
    Other_Charges DECIMAL(12,2) DEFAULT 0.00,
    Tax_Rate DECIMAL(12,2) DEFAULT 0.00,
    Insurance_Coverage DECIMAL(12,2) DEFAULT 0.00,
    Amount_Paid DECIMAL(12,2) DEFAULT 0.00,
    Status ENUM('Draft','Sent','Paid','Partially Paid','Overdue') DEFAULT 'Draft',
    Created_By INT NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Created_By) REFERENCES Staff(Emp_ID),
    
    INDEX idx_bill_patient (Patient_ID),
    INDEX idx_bill_date (Bill_Date),
    INDEX idx_bill_status (Status),
    
    CONSTRAINT chk_bill_amountS CHECK (
		Room_Charges >= 0 AND Doctor_Charges >= 0 AND Lab_Charges >= 0 AND
        Medicine_Charges >= 0 AND Other_Charges >= 0 AND Amount_Paid >= 0
    ),
    CONSTRAINT chk_due_after_bill CHECK (Due_Date IS NULL OR Due_Date >= Bill_Date)
    
);

-- 14. Patient Visit
CREATE TABLE Patient_Visit (
	Visit_ID      INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID    INT NOT NULL,
    Dept_ID       INT NOT NULL,
    Visit_Date    DATETIME NOT NULL,
    Symptoms      TEXT,
    Visit_Type    ENUM('Outpatient','Inpatient','Emergency') NOT NULL,
    Created_At    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Dept_ID)    REFERENCES Department(Dept_ID) ON DELETE RESTRICT,

    INDEX idx_visit_patient (Patient_ID),
    INDEX idx_visit_dept    (Dept_ID),
    INDEX idx_visit_date    (Visit_Date)
);

-- 15. Diagonsis Tbale
CREATE TABLE Diagnosis (
    Diagnosis_Code   VARCHAR(10) PRIMARY KEY,
    Description      VARCHAR(255) NOT NULL,
    Category         VARCHAR(100)
);


-- 16. Patient_Diagonsis
CREATE TABLE Patient_Diagnosis (
    Patient_Diagnosis_ID INT AUTO_INCREMENT PRIMARY KEY,
    Visit_ID          INT NOT NULL,
    Diagnosis_Code    VARCHAR(10) NOT NULL,
    Is_Primary        BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (Visit_ID)       REFERENCES Patient_Visit(Visit_ID)      ON DELETE CASCADE,
    FOREIGN KEY (Diagnosis_Code) REFERENCES Diagnosis(Diagnosis_Code)  ON DELETE RESTRICT,
    
    INDEX idx_pd_visit       (Visit_ID),
    INDEX idx_pd_diagnosis  (Diagnosis_Code)
);

-- 17. Procedure Table
CREATE TABLE Procedure_Catalog (
    Procedure_Code   VARCHAR(10) PRIMARY KEY,
    Description      VARCHAR(255) NOT NULL,
    Category         VARCHAR(100),
    Cost             DECIMAL(12,2) NOT NULL
);

-- 18. Patient_Procedure
CREATE TABLE Patient_Procedure (
	Patient_Procedure_ID INT AUTO_INCREMENT PRIMARY KEY,
    Visit_ID INT NOT NULL,
    Procedure_Code VARCHAR(10) NOT NULL,
    Performed_By INT NOT NULL,
    Performed_Date DATETIME NOT NULL,
    Cost DECIMAL(12,2) NOT NULL,
    
	FOREIGN KEY (Visit_ID) REFERENCES Patient_Visit(Visit_ID) ON DELETE CASCADE,
    FOREIGN KEY (Procedure_Code) REFERENCES Procedure_Catalog(Procedure_Code) ON DELETE RESTRICT,
    FOREIGN KEY (Performed_By) REFERENCES Staff(Emp_ID) ON DELETE RESTRICT,
    
	INDEX idx_pp_visit        (Visit_ID),
    INDEX idx_pp_procedure    (Procedure_Code),
    INDEX idx_pp_performed_by (Performed_By)
);

-- 19. Insurance_Provider
CREATE TABLE Insurance_Provider (
    Insurance_Provider_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Contact_Info TEXT,
    Policy_Format VARCHAR(50)
);

-- 20. Patient_Insurance
CREATE TABLE Patient_Insurance (
    Patient_Insurance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID     INT NOT NULL,
    Insurance_Provider_ID    INT NOT NULL,
    Policy_Number  VARCHAR(50) NOT NULL,
    Coverage_Details TEXT,
    Effective_Date DATETIME NOT NULL,
    Expiry_Date    DATETIME,

    FOREIGN KEY (Patient_ID)  REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Insurance_Provider_ID) REFERENCES Insurance_Provider(Insurance_Provider_ID) ON DELETE RESTRICT,

    INDEX idx_pi_patient      (Patient_ID),
    INDEX idx_pi_provider     (Insurance_Provider_ID),
    
    CONSTRAINT chk_insurance_dates CHECK (Expiry_Date IS NULL OR Effective_Date <= Expiry_Date)
);

-- 21. Payment
CREATE TABLE Payment (
    Payment_ID     INT AUTO_INCREMENT PRIMARY KEY,
    Bill_ID        INT NOT NULL,
    Paid_Amount    DECIMAL(12,2) NOT NULL,
    Paid_Date      DATETIME NOT NULL,
    Method         ENUM('Cash','Card','Insurance','Online') NOT NULL,
    Reference      VARCHAR(100),

    FOREIGN KEY (Bill_ID) REFERENCES Bill(Bill_ID) ON DELETE CASCADE,

    INDEX idx_payment_bill   (Bill_ID),
    INDEX idx_payment_date   (Paid_Date)
);

-- 22. Bill_Item (line-items)
CREATE TABLE Bill_Item (
    Bill_Item_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Bill_ID        INT NOT NULL,
    Item_Type      ENUM('Room','Doctor','Lab','Medicine','Procedure','Other') NOT NULL,
    Item_ID        INT NOT NULL,
    Quantity       INT DEFAULT 1,
    Unit_Cost      DECIMAL(12,2) NOT NULL,
    Total_Cost     DECIMAL(12,2) GENERATED ALWAYS AS (Quantity * Unit_Cost) STORED,

    FOREIGN KEY (Bill_ID) REFERENCES Bill(Bill_ID) ON DELETE CASCADE,

    INDEX idx_bi_bill    (Bill_ID),
    INDEX idx_bi_type    (Item_Type)
);

-- 23. Staff_Shift_Schedule
CREATE TABLE Staff_Shift_Schedule (
    Schedule_ID   INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID        INT NOT NULL,
    Shift_Date    DATE NOT NULL,
    Shift_Type    ENUM('Day','Evening','Night') NOT NULL,
    Location      VARCHAR(100),

    FOREIGN KEY (Emp_ID)
      REFERENCES Staff(Emp_ID)
      ON DELETE CASCADE,

    UNIQUE (Emp_ID, Shift_Date, Shift_Type),
    INDEX idx_ss_emp      (Emp_ID),
    INDEX idx_ss_date     (Shift_Date)
);

-- 24. Equipment
CREATE TABLE Equipment (
    Equipment_ID      INT AUTO_INCREMENT PRIMARY KEY,
    Name              VARCHAR(100) NOT NULL,
    Model             VARCHAR(100),
    Serial_Number     VARCHAR(100) UNIQUE,
    Location          VARCHAR(100),
    Last_Maintenance  DATE,
    Next_Maintenance  DATE,
    Status            ENUM('Operational','Under Maintenance','Retired') DEFAULT 'Operational',

    INDEX idx_equipment_name  (Name),
    INDEX idx_equipment_status(Status)
);

-- ADDED: Audit_Log
CREATE TABLE Audit_Log (
    Audit_ID      INT AUTO_INCREMENT PRIMARY KEY,
    Table_Name    VARCHAR(100) NOT NULL,
    Record_ID     INT NOT NULL,
    Action        ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    Changed_By    INT,
    Changed_At    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Change_Details JSON,

    FOREIGN KEY (Changed_By) REFERENCES Staff(Emp_ID) ON DELETE SET NULL,

    INDEX idx_audit_table   (Table_Name),
    INDEX idx_audit_user    (Changed_By),
    INDEX idx_audit_time    (Changed_At)
);








