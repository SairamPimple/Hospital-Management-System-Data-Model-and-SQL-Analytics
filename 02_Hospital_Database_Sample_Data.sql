-- Hospital Management System Database - Consolidated Sample Data
-- ASSUMED CURRENT DATE FOR TESTING: 2025-11-01

-- 1) DEPARTMENTS 
INSERT INTO Department (Dept_ID, Dept_Name, Location, Phone, Budget) VALUES
  (1, 'Cardiology',       'Building A', '9000000001', 500000.00),
  (2, 'Radiology',        'Building B', '9000000002', 300000.00),
  (3, 'Oncology',         'Building C', '9000000003', 400000.00),
  (4, 'Neurology',        'Building D', '9000000004', 350000.00),
  (5, 'Pediatrics',       'Building E', '9000000005', 450000.00),
  (6, 'Orthopedics',      'Building F', '9000000006', 320000.00),
  (7, 'Dermatology',      'Building G', '9000000007', 200000.00),
  (8, 'Psychiatry',       'Building H', '9000000008', 220000.00),
  (9, 'Gastroenterology', 'Building I', '9000000009', 380000.00),
  (10,'Emergency',        'Building J', '9000000010', 600000.00),
  (11,'Ophthalmology',    'Building K', '9000000011', 250000.00),
  (12,'General Surgery',  'Building L', '9000000012', 700000.00),
  (13,'Physiotherapy',    'Building M', '9000000013', 150000.00),
  (14,'Administration',   'Main Office','9000000014', 100000.00);

-- 2) STAFF 
INSERT INTO Staff (
  Emp_ID, Employee_Number, Emp_FName, Emp_LName,
  Date_of_Birth, Gender, Phone, Email, Address, Pincode,
  Date_of_Joining, Emp_Type, Employee_Status, Dept_ID, Supervisor_ID
) VALUES
  (1,'EMP001','Alice','Smith','1980-05-15','Female','9100000001','alice.smith@hosp.com','10 Main St','600001','2019-01-10','Administrator','Active',1,NULL),
  (2,'EMP002','Bob','Johnson','1975-08-20','Male','9100000002','bob.johnson@hosp.com','20 Oak St','600002','2018-07-01','Doctor','Active',1,NULL),
  (3,'EMP003','Carol','Lee','1990-03-30','Female','9100000003','carol.lee@hosp.com','30 Pine St','600003','2021-03-15','Nurse','Active',2,NULL),
  (4,'EMP004','David','Brown','1988-09-10','Male','9100000004','david.brown@hosp.com','40 Elm St','600004','2022-02-01','Technician','Active',2,1),
  (5,'EMP005','Eva','Davis','1985-12-05','Female','9100000005','eva.davis@hosp.com','50 Maple St','600005','2020-06-20','Support','Active',3,1),
  (6,'EMP006','Frank','Miller','1972-07-14','Male','9100000006','frank.miller@hosp.com','60 Cedar St','600006','2017-11-30','Doctor','Active',3,2),
  (7,'EMP007','Grace','Wilson','1993-10-22','Female','9100000007','grace.wilson@hosp.com','70 Birch St','600007','2021-08-05','Nurse','Active',4,3),
  (8,'EMP008','Henry','Moore','1982-02-17','Male','9100000008','henry.moore@hosp.com','80 Spruce St','600008','2016-04-12','Technician','Active',4,1),
  (9,'EMP009','Ivy','Taylor','1995-11-30','Female','9100000009','ivy.taylor@hosp.com','90 Walnut St','600009','2022-12-01','Doctor','Active',5,6),
  (10,'EMP010','Jack','Anderson','1987-01-25','Male','9100000010','jack.anderson@hosp.com','100 Chestnut St','600010','2019-09-15','Support','Active',5,1),
  (11,'EMP011','Laura','White','1991-04-12','Female','9100000011','laura.white@hosp.com','110 Park Ave','600011','2023-01-05','Doctor','Active',11,2),
  (12,'EMP012','Mike','Hall','1984-06-25','Male','9100000012','mike.hall@hosp.com','120 Station Rd','600012','2020-10-10','Doctor','Active',12,2),
  (13,'EMP013','Nancy','King','1998-08-01','Female','9100000013','nancy.king@hosp.com','130 Valley View','600013','2024-03-20','Nurse','Active',1,3),
  (14,'EMP014','Oliver','Scott','1979-11-17','Male','9100000014','oliver.scott@hosp.com','140 Hill St','600014','2015-05-01','Administrator','Active',14,1),
  (15,'EMP015','Pamela','Adams','1994-01-05','Female','9100000015','pamela.adams@hosp.com','150 River Rd','600015','2023-09-01','Technician','Active',2,4),
  (16,'EMP016','Quentin','Baker','1986-10-10','Male','9100000016','quentin.baker@hosp.com','160 Lake Ave','600016','2022-04-15','Support','Inactive',10,1),
  (17,'EMP017','Rachel','Carter','1997-07-28','Female','9100000017','rachel.carter@hosp.com','170 Ocean Dr','600017','2024-01-01','Nurse','On Leave',12,7),
  (18,'EMP018','Sam','Evans','1983-02-09','Male','9100000018','sam.evans@hosp.com','180 Summit Pk','600018','2017-03-01','Doctor','Active',10,NULL),
  (19,'EMP019','Tina','Harris','1996-03-29','Female','9100000019','tina.harris@hosp.com','190 Forest Ln','600019','2021-02-20','Technician','Active',9,8),
  (20,'EMP020','Victor','Jones','1990-12-05','Male','9100000020','victor.jones@hosp.com','200 Main St','600020','2020-08-01','Administrator','Active',1,14);

-- 3) PATIENTS 
INSERT INTO Patient (
  Patient_ID, Patient_FName, Patient_LName,
  Phone, Email, Blood_Type, Gender,
  Date_of_Birth, Address, Pincode,
  Emergency_Contact_Name, Emergency_Contact_Phone,
  Admission_Date, Patient_Status
) VALUES
  (1,'John','Doe','9200000001','john.doe@example.com','O+','Male','1992-11-25','101 First Ave','600011','Jane Doe','9200000011','2025-06-01 10:00:00','Active'),
  (2,'Mary','Jane','9200000002','mary.jane@example.com','A-','Female','1985-02-14','202 Second Ave','600012','Mark Jane','9200000012','2025-05-20 09:00:00','Transferred'),
  (3,'Paul','Taylor','9200000003','paul.taylor@example.com','B+','Male','1978-07-04','303 Third Ave','600013','Paula Taylor','9200000013','2025-04-10 08:30:00','Active'),
  (4,'Lisa','Brown','9200000004','lisa.brown@example.com','AB+','Female','1990-12-22','404 Fourth Ave','600014','Liam Brown','9200000014','2025-03-15 11:00:00','Discharged'),
  (5,'Kevin','White','9200000005','kevin.white@example.com','O-','Male','1983-05-30','505 Fifth Ave','600015','Karen White','9200000015','2025-06-05 10:15:00','Active'),
  (6,'Nina','Black','9200000006','nina.black@example.com','A+','Female','1996-09-10','606 Sixth Ave','600016','Neil Black','9200000016','2025-05-01 07:45:00','Active'),
  (7,'Oscar','Green','9200000007','oscar.green@example.com','B-','Male','1989-03-18','707 Seventh Ave','600017','Olga Green','9200000017','2025-02-20 12:30:00','Transferred'),
  (8,'Paula','Blue','9200000008','paula.blue@example.com','AB-','Female','1975-08-08','808 Eighth Ave','600018','Peter Blue','9200000018','2025-01-10 09:00:00','Discharged'),
  (9,'Quinn','Gray','9200000009','quinn.gray@example.com','O+','Other','2000-06-06','909 Ninth Ave','600019','Queens Gray','9200000019','2025-06-10 14:00:00','Active'),
  (10,'Rita','Pink','9200000010','rita.pink@example.com','A-','Female','1988-04-04','100 Tenth Ave','600020','Ryan Pink','9200000020','2025-05-18 06:30:00','Transferred'),
  (11,'William','Smith','9200000011','william.smith@example.com','A+','Male','1960-01-10','111 Elm St','600021','Wendy Smith','9200000021','2025-06-25 10:30:00','Active'),
  (12,'Yara','Zoe','9200000012','yara.zoe@example.com','B-','Female','2005-10-05','121 Oak St','600022','Yiannis Zoe','9200000022','2025-01-01 12:00:00','Discharged'),
  (13,'Zara','Adams','9200000013','zara.adams@example.com','O+','Female','1999-07-20','131 Pine St','600023','Zack Adams','9200000023','2025-06-28 15:00:00','Active'),
  (14,'Evan','Bell','9200000014','evan.bell@example.com','AB+','Male','1970-03-15','141 Cedar St','600024','Erica Bell','9200000024','2025-06-20 08:00:00','Active'),
  (15,'Fiona','Chen','9200000015','fiona.chen@example.com','A-','Female','1988-12-01','151 Maple St','600025','Felix Chen','9200000025','2025-05-15 11:30:00','Discharged'),
  (16,'George','Dai','9200000016','george.dai@example.com','B+','Male','1955-06-10','161 Spruce St','600026','Gina Dai','9200000026','2025-06-05 13:45:00','Active'),
  (17,'Hannah','Epps','9200000017','hannah.epps@example.com','O-','Female','2010-04-20','171 Willow Rd','600027','Harold Epps','9200000027','2025-02-14 16:00:00','Discharged'),
  (18,'Ian','Flynn','9200000018','ian.flynn@example.com','AB-','Male','1972-09-09','181 Birch St','600028','Iris Flynn','9200000028','2025-05-22 19:30:00','Discharged'),
  (19,'Jill','Gale','9200000019','jill.gale@example.com','A+','Female','1980-08-28','191 Pine Ave','600029','Jeff Gale','9200000029',NULL,'Active'), -- Outpatient, no admission date
  (20,'Kyle','Hart','9200000020','kyle.hart@example.com','O+','Male','1993-02-02','201 Oak Ln','600030','Kate Hart','9200000030',NULL,'Active'); -- Outpatient, no admission date

-- 4) DOCTORS 
INSERT INTO Doctor (Doctor_ID, Emp_ID, License_Number, Specialization, Years_of_Experience, Consultation_Fee) VALUES
  (1,2,'LIC001','Cardiology',7,1500.00), 
  (2,6,'LIC002','Oncology',8,2000.00),   
  (3,9,'LIC003','Pediatrics',3,2500.00),  
  (4,11,'LIC004','Ophthalmology',2,1200.00), 
  (5,12,'LIC005','General Surgery',5,3000.00), 
  (6,18,'LIC006','Emergency Medicine',8,1800.00);

-- 5) NURSES 
INSERT INTO Nurse (Nurse_ID, Emp_ID, License_Number, Shift_Type, Ward_Assignment) VALUES
  (1,3,'NLIC001','Day','Ward A'),
  (2,7,'NLIC002','Night','Ward B'),
  (3,13,'NLIC003','Evening','Ward C'),
  (4,17,'NLIC004','Day','Ward D');

-- 6) ROOMS
INSERT INTO Room (Room_ID, Room_Number, Room_Type, Floor_Number, Capacity, Current_Occupancy, Daily_Rate, Status) VALUES
  (1,'101A','General',1,2,1,2000.00,'Occupied'),    
  (2,'102A','Private',1,1,0,3500.00,'Available'),
  (3,'201B','ICU',2,1,1,5000.00,'Occupied'),       
  (4,'202B','Emergency',2,2,0,4500.00,'Available'),
  (5,'301C','General',3,3,0,1500.00,'Available'),
  (6,'302C','Private',3,1,1,4000.00,'Occupied'),    
  (7,'401D','ICU',4,1,1,6000.00,'Occupied'),       
  (8,'402D','Emergency',4,2,0,4500.00,'Available'),
  (9,'103A','Private',1,1,1,3500.00,'Occupied'),    
  (10,'203B','General',2,2,0,2000.00,'Maintenance');

-- 7) PATIENT ROOM ASSIGNMENTS
INSERT INTO Patient_Room_Assignment (Assignment_ID, Patient_ID, Room_ID, Admission_Date, Discharge_Date, Daily_Rate) VALUES
  (1,1,1,'2025-06-01 10:00:00', NULL, 2000.00),               
  (2,2,2,'2025-05-20 09:00:00','2025-05-25 15:00:00',3500.00), 
  (3,11,6,'2025-06-25 10:30:00', NULL, 4000.00),               
  (4,13,7,'2025-06-28 15:00:00', NULL, 6000.00),               
  (5,14,9,'2025-06-20 08:00:00', NULL, 3500.00);               

-- 8) APPOINTMENTS
INSERT INTO Appointment (
  Appt_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Duration,
  Appointment_Type, Status, Reason_for_Visit, Consultation_Fee, Scheduled_By
) VALUES
  -- Upcoming (relevant to 2025-11-01)
  (1,1,1,'2025-11-10','14:00:00',20,'Consultation','Scheduled','Chest pain follow-up',1500.00,1),
  (2,11,4,'2025-11-05','10:00:00',30,'Follow-up','Scheduled','Routine eye check',1200.00,11),
  (3,19,4,'2025-11-04','10:00:00',20,'Consultation','Scheduled','Vision problems',1200.00,14),
  (4,20,5,'2025-11-20','11:00:00',45,'Consultation','Scheduled','Surgical opinion',3000.00,14),
  -- Completed/Past
  (5,12,1,'2025-05-10','09:30:00',20,'Consultation','Completed','Fatigue',1500.00,1),
  (6,15,2,'2025-04-20','16:00:00',30,'Follow-up','Completed','X-Ray review',2000.00,1),
  (7,16,3,'2025-03-01','13:00:00',60,'Consultation','Completed','Initial assessment',2500.00,1),
  (8,18,6,'2025-05-22','20:00:00',30,'Emergency','Completed','Severe pain',1800.00,14),
  -- Cancelled/No Show (for reporting)
  (9,1,1,'2025-06-12','11:00:00',20,'Follow-up','Cancelled','Patient request',1500.00,1),
  (10,13,5,'2025-10-25','09:00:00',30,'Consultation','No Show','Pre-op discussion',3000.00,14);

-- 9) MEDICINES
INSERT INTO Medicine (
  Medicine_ID, Medicine_Name, Generic_Name, Medicine_Type,
  Strength, Unit_Cost, Current_Stock, Minimum_Stock_Level, Expiry_Date, Status
) VALUES
  (1,'Paracetamol','Acetaminophen','Tablet','500mg',10.00,100,20,'2026-12-31','Active'),
  (2,'Amoxicillin','Amoxil','Capsule','250mg',20.00,50,10,'2025-11-30','Active'),
  (3,'Lisinopril','Zestril','Tablet','10mg',5.50,5,10,'2026-05-01','Out of Stock'), 
  (4,'Aspirin','Acetylsalicylic Acid','Tablet','81mg',2.00,200,50,'2027-01-01','Active'),
  (5,'Codeine Syrup','Codeine Phosphate','Syrup','10mg/5ml',35.00,10,15,'2025-12-31','Active'); 

-- 10) LAB_TESTS
INSERT INTO Lab_Test (Test_ID, Test_Name, Test_Category, Normal_Range, Test_Cost) VALUES
  (1,'Complete Blood Count','Hematology','4.5–11.0 x10^9/L',200.00),
  (2,'Chest X-Ray','Radiology','N/A',500.00),
  (3,'Lipid Panel','Chemistry','<200 mg/dL',350.00),
  (4,'MRI Brain','Imaging','N/A',8000.00),
  (5,'Thyroid Panel','Endocrinology','N/A',450.00);

-- 11) LAB_SCREENING 
INSERT INTO Lab_Screening (
  Lab_ID, Patient_ID, Doctor_ID, Test_ID, Technician_ID, Order_Date, Test_Date, Result_Date, Test_Result, Status, Test_Cost
) VALUES
  (1,11,1,3,4,'2025-06-25 11:00:00','2025-06-26 09:00:00','2025-06-27 15:00:00','High LDL','Completed',350.00),
  (2,13,5,4,15,'2025-10-28 16:00:00',NULL,NULL,NULL,'Ordered',8000.00),   
  (3,14,5,1,4,'2025-10-29 09:00:00','2025-10-30 10:00:00',NULL,NULL,'In Progress',200.00), 
  (4, 20, 4, 3, 19, '2025-10-25 10:00:00', NULL, NULL, NULL, 'Ordered', 350.00), 
  (5, 1, 1, 5, 4, '2025-06-03 08:30:00', '2025-06-04 09:00:00', '2025-06-05 10:00:00', 'Normal range', 'Completed', 450.00),
  (6, 14, 5, 1, 15, '2025-10-20 14:00:00', '2025-10-21 15:00:00', NULL, NULL, 'In Progress', 200.00), 
  (7, 13, 5, 2, 19, '2025-10-28 10:00:00', NULL, NULL, NULL, 'Ordered', 500.00); 

-- 12) PRESCRIPTION 
INSERT INTO Prescription (
  Prescription_ID, Patient_ID, Doctor_ID, Medicine_ID, Prescription_Date,
  Dosage, Frequency, Duration_Days, Quantity_Prescribed, Quantity_Dispensed,
  Status, Total_Cost
) VALUES
  (1, 1, 1, 1, '2025-06-02', '500mg', 'Twice daily', 3, 6, 6, 'Completed', 60.00),
  (2, 11, 1, 3, '2025-06-27', '10mg', 'Once daily', 30, 30, 0, 'Active', 165.00), 
  (3, 19, 6, 4, '2025-10-28', '81mg', 'Once daily', 90, 90, 90, 'Completed', 180.00), 
  (4, 20, 4, 2, '2025-10-30', '250mg', 'Three times daily', 7, 21, 0, 'Active', 420.00), 
  (5, 11, 1, 1, '2025-11-01', '500mg', 'As needed', 10, 20, 0, 'Active', 200.00); 

-- 13) DIAGNOSIS 
INSERT INTO Diagnosis (Diagnosis_Code, Description, Category) VALUES
  ('I20','Angina Pectoris','Cardiology'),
  ('J45','Asthma','Pediatrics'),
  ('I21','Acute Myocardial Infarction','Cardiology'),
  ('J46','Status Asthmaticus','Pediatrics');

-- 14) PATIENT_VISITS
INSERT INTO Patient_Visit (Visit_ID, Patient_ID, Dept_ID, Visit_Date, Symptoms, Visit_Type) VALUES
  (1,1,1,'2025-06-01 10:00:00','Chest pain','Inpatient'),
  (2,11,1,'2025-06-25 10:30:00','Severe Chest Pain','Emergency'),
  (3,13,12,'2025-06-28 15:00:00','Abdominal Swelling','Inpatient'),
  (4,19,7,'2025-10-29 11:00:00','Skin rash and itching','Outpatient'), 
  (5,20,11,'2025-10-20 14:00:00','Blurry vision','Outpatient');

-- 15) PATIENT_DIAGNOSIS 
INSERT INTO Patient_Diagnosis (Patient_Diagnosis_ID, Visit_ID, Diagnosis_Code, Is_Primary) VALUES
  (1,1,'I20',TRUE),
  (2,2,'I21',TRUE),
  (3,4,'J45',TRUE),
  (4,3,'I20',FALSE);

-- 16) PROCEDURE_CATALOG 
INSERT INTO Procedure_Catalog (Procedure_Code, Description, Category, Cost) VALUES
  ('CATH01','Cardiac catheterization','Cardiology',50000.00),
  ('SURG02','Appendectomy','General Surgery',25000.00),
  ('SURG03','Knee Replacement','Orthopedics',60000.00);

-- 17) PATIENT_PROCEDURE 
INSERT INTO Patient_Procedure (Patient_Procedure_ID, Visit_ID, Procedure_Code, Performed_By, Performed_Date, Cost) VALUES
  (1,1,'CATH01',2,'2025-06-02 14:00:00',50000.00),
  (2,3,'SURG02',12,'2025-06-29 08:00:00',25000.00),
  (3,2,'CATH01',2,'2025-06-25 15:00:00',50000.00); 

-- 18) INSURANCE_PROVIDER (ID 1-2)
INSERT INTO Insurance_Provider (Insurance_Provider_ID, Name, Contact_Info, Policy_Format) VALUES
  (1,'HealthPlus Insurance','123 Insure Rd','Format A'),
  (2,'GlobalCare Health','456 Care Dr','Format B');

-- 19) PATIENT_INSURANCE 
INSERT INTO Patient_Insurance (
  Patient_Insurance_ID, Patient_ID, Insurance_Provider_ID, Policy_Number, Coverage_Details, Effective_Date, Expiry_Date
) VALUES
  (1,1,1,'HP123456','80% up to $10k','2025-01-01', '2026-01-01'), 
  (2,11,2,'GC98765','60% up to $50k','2024-06-01','2026-06-01'), 
  (3,19,1,'HP112233','75% standard cover','2025-01-01',NULL), 
  (4,12,2,'GC54321','20% standard cover','2020-01-01','2025-01-31'); 

-- 20) BILLS 
INSERT INTO Bill (
  Bill_ID, Patient_ID, Bill_Date, Due_Date,
  Room_Charges, Doctor_Charges, Lab_Charges, Medicine_Charges, Other_Charges,
  Tax_Rate, Insurance_Coverage, Amount_Paid, Status, Created_By
) VALUES
  (1,1,'2025-06-02','2025-06-15',4000.00,1500.00,200.00,150.00,0.00,5.00,0.00,2150.00,'Partially Paid',1),
  (2,11,'2025-06-27','2025-07-10',8000.00,1500.00,350.00,0.00,50000.00,5.00,0.00,0.00,'Sent',14),
  (3,13,'2025-06-29','2025-07-15',12000.00,3000.00,8000.00,0.00,25000.00,10.00,5000.00,0.00,'Draft',14),
  (4,12,'2025-02-01','2025-03-01',0.00,1500.00,0.00,0.00,0.00,0.00,0.00,1500.00,'Paid',14);

-- 21) PAYMENTS 
INSERT INTO Payment (Payment_ID, Bill_ID, Paid_Amount, Paid_Date, Method, Reference) VALUES
  (1,1,2150.00,'2025-06-03','Online','REF001'),
  (2,4,1500.00,'2025-02-05','Card','REF002');

-- 22) BILL_ITEMS
INSERT INTO Bill_Item (Bill_Item_ID, Bill_ID, Item_Type, Item_ID, Quantity, Unit_Cost) VALUES
  (1,1,'Room',    1,2,2000.00),
  (2,1,'Doctor',  1,1,1500.00),
  (3,1,'Lab',     1,1,200.00),
  (4,1,'Medicine',1,15,10.00),
  (5,2,'Room',6,2,4000.00),
  (6,2,'Doctor',1,1,1500.00),
  (7,2,'Lab',3,1,350.00),
  (8,2,'Procedure',1,1,50000.00),
  (9,3,'Room',7,2,6000.00),
  (10,3,'Doctor',5,1,3000.00),
  (11,3,'Lab',4,1,8000.00),
  (12,3,'Procedure',2,1,25000.00),
  (13,4,'Doctor',1,1,1500.00);

-- 23) STAFF_SHIFT_SCHEDULE
INSERT INTO Staff_Shift_Schedule (Schedule_ID, Emp_ID, Shift_Date, Shift_Type, Location) VALUES
  (1,3,'2025-06-10','Day','Ward A'),       
  (2,4,'2025-06-06','Night','Laboratory'),    
  (3,13,'2025-11-01','Evening','Ward C'),   
  (4,15,'2025-11-02','Day','Radiology Lab'),  
  (5,13,'2025-11-03','Night','Ward C'),   
  (6, 11, '2025-11-01', 'Day', 'Ward K'),  
  (7, 14, '2025-11-02', 'Day', 'Main Office'); 

-- 24) EQUIPMENT 
INSERT INTO Equipment (Equipment_ID, Name, Model, Serial_Number, Location, Last_Maintenance, Next_Maintenance, Status) VALUES
  (1,'ECG Machine','X1','SN1001','Cardiology','2025-04-01','2025-12-01','Operational'),   
  (2,'X-Ray System','Siemens A1','SN2002','Radiology','2025-01-15','2026-01-15','Operational'),  
  (3,'Surgical Robot','Da Vinci','SN3003','General Surgery','2025-06-01','2025-11-02','Operational');

-- 25) Update Dept Heads 
UPDATE Department SET Dept_Head_ID = 2  WHERE Dept_ID = 1;  -- Bob Johnson heads Cardiology
UPDATE Department SET Dept_Head_ID = 12 WHERE Dept_ID = 12; -- Mike Hall heads General Surgery
UPDATE Department SET Dept_Head_ID = 14 WHERE Dept_ID = 14; -- Oliver Scott heads Administration

-- 26) AUDIT_LOG (ID 1) (Fixes Error Code 1452 on Audit_Log)
INSERT INTO Audit_Log (Audit_ID, Table_Name, Record_ID, Action, Changed_By, Change_Details) VALUES
  (1,'Patient',1,'INSERT',1,'{"fields":["Patient_FName"],"new":["John"]}');
