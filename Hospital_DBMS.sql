-- Hospital Management System Database Schema

-- Create database
DROP DATABASE IF EXISTS hospital_management_system;
CREATE DATABASE hospital_management_system
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospital_management_system;

-- 1. DEPARTMENT TABLE
CREATE TABLE Department (
    Dept_ID INT AUTO_INCREMENT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL UNIQUE,
    Dept_Head_ID INT NULL,
    Location VARCHAR(100),
    Phone VARCHAR(15),
    Budget DECIMAL(15,2) DEFAULT 0.00,
    Status ENUM('Active', 'Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. STAFF TABLE
CREATE TABLE Staff (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Employee_Number VARCHAR(20) UNIQUE NOT NULL,
    Emp_FName VARCHAR(50) NOT NULL,
    Emp_LName VARCHAR(50) NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT NOT NULL,
    Date_Joining DATE NOT NULL,
    Date_Separation DATE NULL,
    Emp_Type ENUM('Doctor', 'Nurse', 'Technician', 'Administrator', 'Support') NOT NULL,
    Employment_Status ENUM('Active', 'Inactive', 'Terminated') DEFAULT 'Active',
    Dept_ID INT NOT NULL,
    Supervisor_ID INT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Supervisor_ID) REFERENCES Staff(Emp_ID) ON DELETE SET NULL,
    
    INDEX idx_staff_name (Emp_LName, Emp_FName),
    INDEX idx_staff_type (Emp_Type),
    INDEX idx_staff_dept (Dept_ID),
    
    CONSTRAINT chk_staff_dob CHECK (Date_of_Birth <= CURDATE()),
    CONSTRAINT chk_separation_after_joining CHECK (Date_Separation IS NULL OR Date_Separation >= Date_Joining)
);

-- Add foreign key for department head after Staff table creation
ALTER TABLE Department 
ADD CONSTRAINT fk_dept_head FOREIGN KEY (Dept_Head_ID) REFERENCES Staff(Emp_ID) ON DELETE SET NULL;

-- 3. PATIENT TABLE
CREATE TABLE Patient (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_FName VARCHAR(50) NOT NULL,
    Patient_LName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Blood_Type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Date_of_Birth DATE NOT NULL,
    Address TEXT,
    Emergency_Contact_Name VARCHAR(100),
    Emergency_Contact_Phone VARCHAR(15),
    Admission_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Discharge_Date DATETIME NULL,
    Patient_Status ENUM('Active', 'Discharged', 'Transferred') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_patient_name (Patient_LName, Patient_FName),
    INDEX idx_patient_phone (Phone),
    INDEX idx_admission_date (Admission_Date),
    
    CONSTRAINT chk_patient_dob CHECK (Date_of_Birth <= CURDATE()),
    CONSTRAINT chk_discharge_after_admission CHECK (Discharge_Date IS NULL OR Discharge_Date >= Admission_Date)
);

-- 4. DOCTOR TABLE
CREATE TABLE Doctor (
    Doctor_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL UNIQUE,
    License_Number VARCHAR(50) UNIQUE NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Years_of_Experience INT DEFAULT 0,
    Consultation_Fee DECIMAL(10,2) DEFAULT 0.00,
    Status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Emp_ID) REFERENCES Staff(Emp_ID) ON DELETE CASCADE,
    
    INDEX idx_doctor_license (License_Number),
    INDEX idx_doctor_specialization (Specialization),
    
    CONSTRAINT chk_experience CHECK (Years_of_Experience >= 0),
    CONSTRAINT chk_consultation_fee CHECK (Consultation_Fee >= 0)
);

-- 5. NURSE TABLE
CREATE TABLE Nurse (
    Nurse_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT NOT NULL UNIQUE,
    License_Number VARCHAR(50) UNIQUE NOT NULL,
    Shift_Type ENUM('Day', 'Night', 'Evening') NOT NULL,
    Ward_Assignment VARCHAR(50),
    Status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Emp_ID) REFERENCES Staff(Emp_ID) ON DELETE CASCADE,
    
    INDEX idx_nurse_license (License_Number),
    INDEX idx_nurse_shift (Shift_Type)
);

-- 6. ROOMS TABLE
CREATE TABLE Room (
    Room_ID INT AUTO_INCREMENT PRIMARY KEY,
    Room_Number VARCHAR(20) UNIQUE NOT NULL,
    Room_Type ENUM('General', 'Private', 'ICU', 'Emergency', 'Surgery') NOT NULL,
    Floor_Number INT NOT NULL,
    Capacity INT DEFAULT 1,
    Current_Occupancy INT DEFAULT 0,
    Daily_Rate DECIMAL(10,2) NOT NULL,
    Status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_room_number (Room_Number),
    INDEX idx_room_type (Room_Type),
    INDEX idx_room_status (Status),
    
    CONSTRAINT chk_capacity CHECK (Capacity > 0),
    CONSTRAINT chk_occupancy CHECK (Current_Occupancy >= 0 AND Current_Occupancy <= Capacity),
    CONSTRAINT chk_daily_rate CHECK (Daily_Rate >= 0)
);

-- 7. PATIENT ROOM ASSIGNMENT
CREATE TABLE Patient_Room_Assignment (
    Assignment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Room_ID INT NOT NULL,
    Admission_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Discharge_Date DATETIME NULL,
    Daily_Rate DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID) ON DELETE RESTRICT,
    
    INDEX idx_patient_room (Patient_ID),
    INDEX idx_room_assignment (Room_ID),
    INDEX idx_admission_date (Admission_Date),
    
    CONSTRAINT chk_room_discharge_date CHECK (Discharge_Date IS NULL OR Discharge_Date >= Admission_Date)
);

-- 8. APPOINTMENTS
CREATE TABLE Appointment (
    Appt_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Appointment_Date DATE NOT NULL,
    Appointment_Time TIME NOT NULL,
    Duration INT DEFAULT 30,
    Appointment_Type ENUM('Consultation', 'Follow-up', 'Emergency', 'Surgery') NOT NULL,
    Status ENUM('Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'No Show') DEFAULT 'Scheduled',
    Reason_for_Visit TEXT,
    Consultation_Fee DECIMAL(10,2),
    Scheduled_By INT NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Scheduled_By) REFERENCES Staff(Emp_ID),
    
    INDEX idx_appointment_date (Appointment_Date, Appointment_Time),
    INDEX idx_appointment_doctor (Doctor_ID),
    INDEX idx_appointment_patient (Patient_ID),
    
    UNIQUE KEY uk_doctor_datetime (Doctor_ID, Appointment_Date, Appointment_Time),
    CONSTRAINT chk_appointment_date CHECK (Appointment_Date >= '2024-01-01')
);

-- 9. MEDICINE
CREATE TABLE Medicine (
    Medicine_ID INT AUTO_INCREMENT PRIMARY KEY,
    Medicine_Name VARCHAR(200) NOT NULL,
    Generic_Name VARCHAR(200),
    Medicine_Type ENUM('Tablet', 'Capsule', 'Syrup', 'Injection', 'Ointment', 'Other') NOT NULL,
    Strength VARCHAR(50),
    Unit_Cost DECIMAL(10,2) NOT NULL,
    Current_Stock INT DEFAULT 0,
    Minimum_Stock_Level INT DEFAULT 10,
    Expiry_Date DATE,
    Status ENUM('Active', 'Discontinued', 'Out of Stock') DEFAULT 'Active',
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_medicine_name (Medicine_Name),
    INDEX idx_medicine_type (Medicine_Type),
    INDEX idx_stock_level (Current_Stock),
    
    CONSTRAINT chk_unit_cost CHECK (Unit_Cost >= 0),
    CONSTRAINT chk_stock_levels CHECK (Current_Stock >= 0 AND Minimum_Stock_Level >= 0)
);

-- 10. PRESCRIPTION
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
    Quantity_Dispensed INT DEFAULT 0,
    Status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active',
    Total_Cost DECIMAL(10,2),
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Medicine_ID) REFERENCES Medicine(Medicine_ID) ON DELETE RESTRICT,
    
    INDEX idx_prescription_patient (Patient_ID),
    INDEX idx_prescription_doctor (Doctor_ID),
    INDEX idx_prescription_date (Prescription_Date),
    
    CONSTRAINT chk_prescription_quantity CHECK (Quantity_Prescribed > 0 AND Quantity_Dispensed >= 0 AND Quantity_Dispensed <= Quantity_Prescribed),
    CONSTRAINT chk_prescription_duration CHECK (Duration_Days > 0)
);

-- 11. LAB TESTS
CREATE TABLE Lab_Test (
    Test_ID INT AUTO_INCREMENT PRIMARY KEY,
    Test_Name VARCHAR(200) NOT NULL,
    Test_Category VARCHAR(100) NOT NULL,
    Normal_Range VARCHAR(100),
    Test_Cost DECIMAL(10,2) NOT NULL,
    Status ENUM('Active', 'Discontinued') DEFAULT 'Active',
    
    INDEX idx_test_name (Test_Name),
    INDEX idx_test_category (Test_Category),
    
    CONSTRAINT chk_test_cost CHECK (Test_Cost >= 0)
);

-- 12. LAB SCREENING
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
    Status ENUM('Ordered', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Ordered',
    Test_Cost DECIMAL(10,2),
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Test_ID) REFERENCES Lab_Test(Test_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Technician_ID) REFERENCES Staff(Emp_ID) ON DELETE RESTRICT,
    
    INDEX idx_lab_patient (Patient_ID),
    INDEX idx_lab_doctor (Doctor_ID),
    INDEX idx_lab_order_date (Order_Date)
);

-- 13. BILLING
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
    Tax_Rate DECIMAL(5,2) DEFAULT 0.00,
    Insurance_Coverage DECIMAL(12,2) DEFAULT 0.00,
    Amount_Paid DECIMAL(12,2) DEFAULT 0.00,
    Status ENUM('Draft', 'Sent', 'Paid', 'Partially Paid', 'Overdue') DEFAULT 'Draft',
    Created_By INT NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Created_By) REFERENCES Staff(Emp_ID),
    
    INDEX idx_bill_patient (Patient_ID),
    INDEX idx_bill_date (Bill_Date),
    INDEX idx_bill_status (Status),
    
    CONSTRAINT chk_bill_amounts CHECK (
        Room_Charges >= 0 AND Doctor_Charges >= 0 AND Lab_Charges >= 0 AND 
        Medicine_Charges >= 0 AND Other_Charges >= 0 AND Amount_Paid >= 0
    )
);

-- Create Views for Common Queries
-- 1. Patient Summary View
CREATE VIEW Patient_Summary AS
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Full_Name,
    p.Phone,
    p.Email,
    p.Blood_Type,
    p.Gender,
    TIMESTAMPDIFF(YEAR, p.Date_of_Birth, CURDATE()) AS Age,
    p.Patient_Status,
    COUNT(DISTINCT a.Appt_ID) AS Total_Appointments,
    COUNT(DISTINCT pr.Prescription_ID) AS Total_Prescriptions,
    COUNT(DISTINCT ls.Lab_ID) AS Total_Lab_Tests
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
LEFT JOIN Prescription pr ON p.Patient_ID = pr.Patient_ID
LEFT JOIN Lab_Screening ls ON p.Patient_ID = ls.Patient_ID
GROUP BY p.Patient_ID;

-- 2. Doctor Schedule View
CREATE VIEW Doctor_Schedule AS
SELECT 
    d.Doctor_ID,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    d.Specialization,
    a.Appointment_Date,
    a.Appointment_Time,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    a.Appointment_Type,
    a.Status
FROM Doctor d
JOIN Staff s ON d.Emp_ID = s.Emp_ID
LEFT JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
LEFT JOIN Patient p ON a.Patient_ID = p.Patient_ID
WHERE a.Appointment_Date >= CURDATE() OR a.Appointment_Date IS NULL
ORDER BY d.Doctor_ID, a.Appointment_Date, a.Appointment_Time;

-- 3. Room Occupancy View
CREATE VIEW Room_Occupancy AS
SELECT 
    r.Room_ID,
    r.Room_Number,
    r.Room_Type,
    r.Floor_Number,
    r.Capacity,
    r.Current_Occupancy,
    r.Status AS Room_Status,
    r.Daily_Rate,
    CASE 
        WHEN r.Current_Occupancy = 0 THEN 'Available'
        WHEN r.Current_Occupancy < r.Capacity THEN 'Partially Occupied'
        ELSE 'Full'
    END AS Occupancy_Status
FROM Room r;

-- Stored Procedures
-- 1. Procedure to admit a patient
DELIMITER //
CREATE PROCEDURE AdmitPatient(
    IN p_fname VARCHAR(50),
    IN p_lname VARCHAR(50),
    IN p_phone VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_blood_type VARCHAR(5),
    IN p_gender VARCHAR(20),
    IN p_dob DATE,
    IN p_address TEXT,
    IN p_room_id INT,
    OUT p_patient_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Patient (
        Patient_FName, Patient_LName, Phone, Email, Blood_Type, Gender,
        Date_of_Birth, Address, Patient_Status
    ) VALUES (
        p_fname, p_lname, p_phone, p_email, p_blood_type, p_gender,
        p_dob, p_address, 'Active'
    );
    
    SET p_patient_id = LAST_INSERT_ID();
    
    IF p_room_id IS NOT NULL THEN
        INSERT INTO Patient_Room_Assignment (Patient_ID, Room_ID, Daily_Rate)
        SELECT p_patient_id, p_room_id, Daily_Rate 
        FROM Room 
        WHERE Room_ID = p_room_id AND Status = 'Available';
        
        UPDATE Room 
        SET Status = 'Occupied', Current_Occupancy = Current_Occupancy + 1
        WHERE Room_ID = p_room_id;
    END IF;
    
    COMMIT;
END //
DELIMITER ;

-- 2. Function to calculate patient age
DELIMITER //
CREATE FUNCTION GetPatientAge(p_patient_id INT) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE patient_age INT;
    
    SELECT TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE()) INTO patient_age
    FROM Patient 
    WHERE Patient_ID = p_patient_id;
    
    RETURN COALESCE(patient_age, 0);
END //
DELIMITER ;

-- Create Triggers for Business Logic
-- 1. Trigger to validate appointment dates
DELIMITER //
CREATE TRIGGER tr_appointment_date_validation
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF NEW.Appointment_Date < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot schedule appointments in the past';
    END IF;
END //
DELIMITER ;

-- 2. Trigger to update room occupancy when patient is assigned
DELIMITER //
CREATE TRIGGER tr_patient_room_assignment_after_insert
AFTER INSERT ON Patient_Room_Assignment
FOR EACH ROW
BEGIN
    UPDATE Room 
    SET Current_Occupancy = Current_Occupancy + 1,
        Status = 'Occupied'
    WHERE Room_ID = NEW.Room_ID;
END //
DELIMITER ;

-- Sample Data Insertion
-- Insert Departments
INSERT INTO Department (Dept_Name, Location, Phone, Budget) VALUES
('Cardiology', 'Building A, Floor 2', '555-0101', 500000.00),
('Emergency', 'Building A, Floor 1', '555-0102', 750000.00),
('Pediatrics', 'Building B, Floor 3', '555-0103', 400000.00),
('Surgery', 'Building A, Floor 4', '555-0104', 800000.00),
('Laboratory', 'Building C, Floor 1', '555-0105', 300000.00);

-- Insert Staff
INSERT INTO Staff (Employee_Number, Emp_FName, Emp_LName, Date_of_Birth, Gender, Phone, Email, Address, Date_Joining, Emp_Type, Dept_ID) VALUES
('EMP001', 'Dr. John', 'Smith', '1980-05-15', 'Male', '555-1001', 'john.smith@hospital.com', '123 Medical Ave', '2020-01-15', 'Doctor', 1),
('EMP002', 'Dr. Sarah', 'Johnson', '1985-03-22', 'Female', '555-1002', 'sarah.johnson@hospital.com', '456 Health St', '2021-03-10', 'Doctor', 2),
('EMP003', 'Alice', 'Brown', '1990-07-18', 'Female', '555-1003', 'alice.brown@hospital.com', '789 Care Blvd', '2022-06-01', 'Nurse', 1),
('EMP004', 'Bob', 'Wilson', '1988-11-30', 'Male', '555-1004', 'bob.wilson@hospital.com', '321 Wellness Dr', '2021-09-15', 'Technician', 5);

-- Insert Doctors
INSERT INTO Doctor (Emp_ID, License_Number, Specialization, Years_of_Experience, Consultation_Fee) VALUES
(1, 'DOC12345', 'Cardiology', 15, 200.00),
(2, 'DOC12346', 'Emergency Medicine', 10, 150.00);

-- Insert Nurses
INSERT INTO Nurse (Emp_ID, License_Number, Shift_Type, Ward_Assignment) VALUES
(3, 'NUR12345', 'Day', 'Cardiology Ward');

-- Insert Rooms
INSERT INTO Room (Room_Number, Room_Type, Floor_Number, Capacity, Daily_Rate) VALUES
('101', 'General', 1, 2, 100.00),
('102', 'Private', 1, 1, 200.00),
('201', 'ICU', 2, 1, 500.00),
('202', 'Surgery', 2, 1, 300.00);

-- Insert Lab Tests
INSERT INTO Lab_Test (Test_Name, Test_Category, Normal_Range, Test_Cost) VALUES
('Complete Blood Count', 'Hematology', 'WBC: 4.5-11.0 x10³/µL', 50.00),
('Lipid Panel', 'Chemistry', 'Total Cholesterol: <200 mg/dL', 75.00),
('X-Ray Chest', 'Radiology', 'Normal lung fields', 100.00);

-- Insert Medicines
INSERT INTO Medicine (Medicine_Name, Generic_Name, Medicine_Type, Strength, Unit_Cost, Current_Stock) VALUES
('Aspirin', 'Acetylsalicylic Acid', 'Tablet', '100mg', 0.50, 1000),
('Amoxicillin', 'Amoxicillin', 'Capsule', '500mg', 2.00, 500),
('Paracetamol', 'Acetaminophen', 'Tablet', '500mg', 0.25, 2000);