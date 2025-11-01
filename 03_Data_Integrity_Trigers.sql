
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
