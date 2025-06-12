
-- Trigers --
DELIMITER $$

-- a) Staff date‐of‐birth cannot be in the future
CREATE TRIGGER trg_check_staff_dob
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
  IF NEW.Date_of_Birth > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Date of birth cannot be in the future.';
  END IF;
END$$

CREATE TRIGGER trg_check_staff_dob_update
BEFORE UPDATE ON Staff
FOR EACH ROW
BEGIN
  IF NEW.Date_of_Birth > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Updated date of birth cannot be in the future.';
  END IF;
END$$


-- b) Patient date‐of‐birth cannot be in the future
CREATE TRIGGER trg_check_patient_dob
BEFORE INSERT ON Patient
FOR EACH ROW
BEGIN
  IF NEW.Date_of_Birth > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Date of birth cannot be in the future.';
  END IF;
END$$

CREATE TRIGGER trg_check_patient_dob_update
BEFORE UPDATE ON Patient
FOR EACH ROW
BEGIN
  IF NEW.Date_of_Birth > CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Updated date of birth cannot be in the future.';
  END IF;
END$$


-- c) Appointment date checks (use future dates in test data)
CREATE TRIGGER trg_appointment_date_check
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
  IF NEW.Appointment_Date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Appointment date cannot be in the past.';
  END IF;
END$$

CREATE TRIGGER trg_appointment_date_update_check
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
  IF NEW.Appointment_Date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Updated appointment date cannot be in the past.';
  END IF;
END$$


-- d) Prevent overlapping appointments
CREATE TRIGGER trg_no_appt_overlap
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
  DECLARE clash_count INT;
  DECLARE new_start   DATETIME;
  DECLARE new_end     DATETIME;

  SET new_start = TIMESTAMP(NEW.Appointment_Date, NEW.Appointment_Time);
  SET new_end   = new_start + INTERVAL NEW.Duration MINUTE;

  SELECT COUNT(*) INTO clash_count
    FROM Appointment
   WHERE Doctor_ID = NEW.Doctor_ID
     AND TIMESTAMP(Appointment_Date,Appointment_Time) < new_end
     AND TIMESTAMP(Appointment_Date,Appointment_Time) + INTERVAL Duration MINUTE > new_start;

  IF clash_count > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Appointment overlaps an existing one for this doctor.';
  END IF;
END$$

CREATE TRIGGER trg_no_appt_overlap_upd
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
  DECLARE clash_count INT;
  DECLARE new_start   DATETIME;
  DECLARE new_end     DATETIME;

  SET new_start = TIMESTAMP(NEW.Appointment_Date, NEW.Appointment_Time);
  SET new_end   = new_start + INTERVAL NEW.Duration MINUTE;

  SELECT COUNT(*) INTO clash_count
    FROM Appointment
   WHERE Doctor_ID = NEW.Doctor_ID
     AND Appt_ID <> OLD.Appt_ID
     AND TIMESTAMP(Appointment_Date,Appointment_Time) < new_end
     AND TIMESTAMP(Appointment_Date,Appointment_Time) + INTERVAL Duration MINUTE > new_start;

  IF clash_count > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Updated appointment would overlap an existing one.';
  END IF;
END$$


-- e) Maintain Room.Current_Occupancy
CREATE TRIGGER trg_room_occupancy_inc
AFTER INSERT ON Patient_Room_Assignment
FOR EACH ROW
BEGIN
  UPDATE Room
     SET Current_Occupancy = Current_Occupancy + 1
   WHERE Room_ID = NEW.Room_ID;

  IF (SELECT Current_Occupancy FROM Room WHERE Room_ID = NEW.Room_ID) > 
     (SELECT Capacity          FROM Room WHERE Room_ID = NEW.Room_ID) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Room capacity exceeded.';
  END IF;
END$$

CREATE TRIGGER trg_room_occupancy_dec
AFTER UPDATE ON Patient_Room_Assignment
FOR EACH ROW
BEGIN
  IF OLD.Discharge_Date IS NULL AND NEW.Discharge_Date IS NOT NULL THEN
    UPDATE Room
       SET Current_Occupancy = Current_Occupancy - 1
     WHERE Room_ID = NEW.Room_ID;
  END IF;
END$$


-- f) Prevent over‐payment
CREATE TRIGGER trg_payment_amount_check
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
  DECLARE bill_total DECIMAL(12,2);

  SELECT
    Room_Charges + Doctor_Charges + Lab_Charges + Medicine_Charges + Other_Charges
    + ((Room_Charges + Doctor_Charges + Lab_Charges + Medicine_Charges + Other_Charges) * Tax_Rate / 100)
    - Insurance_Coverage
  INTO bill_total
    FROM Bill
   WHERE Bill_ID = NEW.Bill_ID;

  IF NEW.Paid_Amount > bill_total THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Paid_Amount exceeds bill total.';
  END IF;
END$$


-- g) No self‐supervision
CREATE TRIGGER trg_staff_no_self_supervisor_ins
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
  IF NEW.Supervisor_ID IS NOT NULL AND NEW.Supervisor_ID = NEW.Emp_ID THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Supervisor_ID cannot be same as Emp_ID.';
  END IF;
END$$

CREATE TRIGGER trg_staff_no_self_supervisor_upd
BEFORE UPDATE ON Staff
FOR EACH ROW
BEGIN
  IF NEW.Supervisor_ID IS NOT NULL AND NEW.Supervisor_ID = NEW.Emp_ID THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Supervisor_ID cannot be same as Emp_ID.';
  END IF;
END$$

DELIMITER ;



-- Create Views for Common Queries
-- 1. Current Inpatients: patients still admitted, with room and length of stay
CREATE OR REPLACE VIEW vw_active_inpatient AS
SELECT 
	p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    pra.Room_ID,
    r.Room_Number,
    r.Room_Type,
    pra.Admission_Date,
    DATEDIFF(NOW(), pra.Admission_Date) + 1 AS Days_Admitted
FROM Patient_Room_Assignment pra
JOIN Patient p ON pra.Patient_ID = p.Patient_ID
JOIN Room r ON pra.Room_ID = r.Room_ID
WHERE pra.Discharge_Date IS NULL;

-- 2. Todays Appointments: all appointement sheduled for current date
CREATE OR REPLACE VIEW vw_today_appointments AS
SELECT 
	a.Appt_ID,
    a.Appointment_Time,
	CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName)         AS Doctor_Name,
    a.Status,
    a.Appointment_Type
FROM Appointment a
JOIN Patient p ON a.Patient_ID = p.Patient_ID
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID
JOIN Staff s ON d.Emp_ID = s.Emp_ID
WHERE a.Appointment_Date = CURRENT_DATE 
ORDER BY a.Appointment_Time;


-- 3. Doctor Schedule (next 7 days): counts of appts per doctor
CREATE OR REPLACE VIEW vw_doctor_schedule AS
SELECT
    d.Doctor_ID,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    COUNT(a.Appt_ID) AS Upcoming_Appointments
FROM Doctor d
JOIN Staff s    ON d.Emp_ID         = s.Emp_ID
LEFT JOIN Appointment a
  ON d.Doctor_ID = a.Doctor_ID
 AND a.Appointment_Date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY d.Doctor_ID, s.Emp_FName, s.Emp_LName;


-- 4. Outstanding Patient Balances: total billed minus total paid
CREATE OR REPLACE VIEW vw_patient_balance AS
SELECT
    b.Bill_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    b.Bill_Date,
    (COALESCE(b.Room_Charges,0)
     + COALESCE(b.Doctor_Charges,0)
     + COALESCE(b.Lab_Charges,0)
     + COALESCE(b.Medicine_Charges,0)
     + COALESCE(b.Other_Charges,0)
     + COALESCE(b.Tax_Rate * (
         b.Room_Charges + b.Doctor_Charges + b.Lab_Charges + b.Medicine_Charges + b.Other_Charges
       ) / 100, 0)
     - COALESCE(SUM(pmt.Paid_Amount),0)
    ) AS Balance_Due
FROM Bill b
JOIN Patient p ON b.Patient_ID = p.Patient_ID
LEFT JOIN Payment pmt ON b.Bill_ID = pmt.Bill_ID
GROUP BY b.Bill_ID, p.Patient_FName, p.Patient_LName, b.Bill_Date;


-- 5. Low-Stock Medicines: stock at or below minimum threshold
CREATE OR REPLACE VIEW vw_low_stock_medicines AS
SELECT
    Medicine_ID,
    Medicine_Name,
    Current_Stock,
    Minimum_Stock_Level,
    Expiry_Date
FROM Medicine
WHERE Current_Stock <= Minimum_Stock_Level;


-- 6. Pending Lab Tests: all tests not yet completed
CREATE OR REPLACE VIEW vw_pending_lab_tests AS
SELECT
    ls.Lab_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    lt.Test_Name,
    ls.Order_Date,
    ls.Status
FROM Lab_Screening ls
JOIN Patient p  ON ls.Patient_ID = p.Patient_ID
JOIN Lab_Test lt ON ls.Test_ID    = lt.Test_ID
WHERE ls.Status <> 'Completed'
ORDER BY ls.Order_Date;


-- 7. Equipment Due for Maintenance: maintenance due today or overdue
CREATE OR REPLACE VIEW vw_equipment_maintenance_due AS
SELECT
    Equipment_ID,
    Name,
    Model,
    Location,
    Last_Maintenance,
    Next_Maintenance,
    Status
FROM Equipment
WHERE Next_Maintenance <= CURRENT_DATE
  AND Status = 'Operational';


-- 8. Department Patient Counts: # of active patients by department (via visits)
CREATE OR REPLACE VIEW vw_department_patient_count AS
SELECT
    dept.Dept_ID,
    dept.Dept_Name,
    COUNT(DISTINCT pv.Patient_ID) AS Active_Patient_Count
FROM Department dept
LEFT JOIN Patient_Visit pv
  ON dept.Dept_ID = pv.Dept_ID
 AND pv.Visit_Date BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND CURRENT_DATE
GROUP BY dept.Dept_ID, dept.Dept_Name;

-- 9. Staff On Duty Today: nurses and technicians with scheduled shifts today
CREATE OR REPLACE VIEW vw_staff_on_duty AS
SELECT
    s.Emp_ID,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Staff_Name,
    sh.Shift_Type,
    sh.Location
FROM Staff_Shift_Schedule sh
JOIN Staff s ON sh.Emp_ID = s.Emp_ID
WHERE sh.Shift_Date = CURRENT_DATE;


-- 10. Patients with Active Insurance
CREATE OR REPLACE VIEW vw_insurance_active AS
SELECT
    pi.PI_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    ip.Name               AS Provider,
    pi.Policy_Number,
    pi.Effective_Date,
    pi.Expiry_Date
FROM Patient_Insurance pi
JOIN Patient p             ON pi.Patient_ID    = p.Patient_ID
JOIN Insurance_Provider ip ON pi.Provider_ID   = ip.Provider_ID
WHERE pi.Expiry_Date IS NULL OR pi.Expiry_Date >= CURRENT_DATE;

-- 11. Patient Summary
CREATE OR REPLACE VIEW vw_patient_summary AS
SELECT
  p.Patient_ID,
  CONCAT(p.Patient_FName,' ',p.Patient_LName) AS Patient_Name,
  TIMESTAMPDIFF(YEAR,p.Date_of_Birth,CURDATE()) AS Age,
  p.Gender, p.Phone, p.Email, p.Patient_Status,

  pra.Room_ID,
  r.Room_Number,
  pra.Admission_Date   AS Current_Admission_Date,
  pra.Discharge_Date   AS Current_Discharge_Date,
  IF(pra.Discharge_Date IS NULL,
     DATEDIFF(NOW(), pra.Admission_Date)+1,
     NULL
  ) AS Days_Admitted,

  COALESCE(v.visit_count,0)      AS Total_Visits,
  v.last_visit_date             AS Last_Visit_Date,

  -- inline balance
  COALESCE(bal.total_balance,0)  AS Outstanding_Balance,

  CASE WHEN ins.active_count>0 THEN 'Active' ELSE 'None' END AS Insurance_Status,
  ins.next_expiry                        AS Next_Insurance_Expiry,

  COALESCE(app.upcoming_count,0) AS Upcoming_Appointments,
  app.next_appointment_date     AS Next_Appointment_Date

FROM Patient p

LEFT JOIN Patient_Room_Assignment pra
  ON p.Patient_ID = pra.Patient_ID
 AND pra.Discharge_Date IS NULL
LEFT JOIN Room r ON pra.Room_ID = r.Room_ID

LEFT JOIN (
  SELECT Patient_ID,
         COUNT(*)      AS visit_count,
         MAX(Visit_Date) AS last_visit_date
  FROM Patient_Visit
  GROUP BY Patient_ID
) v ON p.Patient_ID = v.Patient_ID

LEFT JOIN (
  SELECT
    b.Patient_ID,
    SUM(
      COALESCE(b.Room_Charges,0)
    + COALESCE(b.Doctor_Charges,0)
    + COALESCE(b.Lab_Charges,0)
    + COALESCE(b.Medicine_Charges,0)
    + COALESCE(b.Other_Charges,0)
    + (COALESCE(b.Room_Charges,0)
       + COALESCE(b.Doctor_Charges,0)
       + COALESCE(b.Lab_Charges,0)
       + COALESCE(b.Medicine_Charges,0)
       + COALESCE(b.Other_Charges,0)
      ) * b.Tax_Rate/100
    - COALESCE(pmt.Paid_Amount,0)
    ) AS total_balance
  FROM Bill b
  LEFT JOIN Payment pmt ON b.Bill_ID = pmt.Bill_ID
  GROUP BY b.Patient_ID
) bal ON p.Patient_ID = bal.Patient_ID

LEFT JOIN (
  SELECT Patient_ID,
         COUNT(*)      AS active_count,
         MAX(Expiry_Date) AS next_expiry
  FROM Patient_Insurance
  WHERE Expiry_Date IS NULL OR Expiry_Date >= CURDATE()
  GROUP BY Patient_ID
) ins ON p.Patient_ID = ins.Patient_ID

LEFT JOIN (
  SELECT Patient_ID,
         COUNT(*)      AS upcoming_count,
         MIN(Appointment_Date) AS next_appointment_date
  FROM Appointment
  WHERE Appointment_Date >= CURDATE()
  GROUP BY Patient_ID
) app ON p.Patient_ID = app.Patient_ID
;