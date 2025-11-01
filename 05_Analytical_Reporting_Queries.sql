
-- 1: How many staff members are in each department?

SELECT
  d.Dept_Name,
  COUNT(s.Emp_ID) AS Staff_Count
FROM Department d
LEFT JOIN Staff s ON d.Dept_ID = s.Dept_ID
GROUP BY d.Dept_Name
ORDER BY Staff_Count DESC;

-- 2: List all patients currently admitted (not yet discharged), with their room numbers.

SELECT
  p.Patient_ID,
  CONCAT(p.Patient_FName,' ',p.Patient_LName) AS Patient_Name,
  r.Room_Number
FROM Patient_Room_Assignment pra
JOIN Patient p ON pra.Patient_ID = p.Patient_ID
JOIN Room r    ON pra.Room_ID    = r.Room_ID
WHERE pra.Discharge_Date IS NULL;

-- 3: Find the average duration (in minutes) of all appointments.

SELECT
  ROUND(AVG(Duration),1) AS Avg_Appointment_Duration
FROM Appointment;

-- 4: Show all appointments scheduled in the next 7 days.

SELECT
  Appt_ID,
  Patient_ID,
  Doctor_ID,
  Appointment_Date,
  Appointment_Time
FROM Appointment
WHERE Appointment_Date 
      BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY Appointment_Date, Appointment_Time;

-- 5: Compute each patient’s outstanding balance (total billed minus total paid).

SELECT
  p.Patient_ID,
  CONCAT(p.Patient_FName,' ',p.Patient_LName) AS Patient_Name,
  ROUND(COALESCE(SUM(
    b.Room_Charges
  + b.Doctor_Charges
  + b.Lab_Charges
  + b.Medicine_Charges
  + b.Other_Charges
  + (b.Room_Charges + b.Doctor_Charges + b.Lab_Charges + b.Medicine_Charges + b.Other_Charges) * b.Tax_Rate/100
  - COALESCE(pm.Paid_Amount,0)
  ),0),2) AS Outstanding_Balance
FROM Bill b
JOIN Patient p ON b.Patient_ID = p.Patient_ID
LEFT JOIN Payment pm ON b.Bill_ID = pm.Bill_ID
GROUP BY p.Patient_ID, p.Patient_FName, p.Patient_LName;

-- 6: List all medicines that are at or below their minimum stock level.
SELECT
  Medicine_ID,
  Medicine_Name,
  Current_Stock,
  Minimum_Stock_Level
FROM Medicine
WHERE Current_Stock <= Minimum_Stock_Level
ORDER BY Current_Stock;

-- 7: Show the most expensive procedures.
SELECT
  Procedure_Code,
  Description,
  Cost
FROM Procedure_Catalog
ORDER BY Cost DESC
LIMIT 1;

-- 8: How many lab tests have been ordered but not yet completed?

SELECT
	COUNT(*) AS Pending_Lab_Tests
FROM Lab_Screening
WHERE Status <> 'Completed';

-- 9.	Q10: For each room type, calculate the average occupancy rate (occupancy ÷ capacity).
SELECT
  Room_Type,
  ROUND(AVG(Current_Occupancy / Capacity), 2) AS Avg_Occupancy_Rate
FROM Room
GROUP BY Room_Type;

-- 10: List all staff along with their supervisor’s name (if any).
SELECT
  s.Emp_ID,
  CONCAT(s.Emp_FName,' ',s.Emp_LName)     AS Staff_Name,
  CONCAT(sup.Emp_FName,' ',sup.Emp_LName) AS Supervisor_Name
FROM Staff s
LEFT JOIN Staff sup ON s.Supervisor_ID = sup.Emp_ID
ORDER BY Staff_Name;

-- 11: Count the number of patient visits per department in the last 30 days.
SELECT
  d.Dept_Name,
  COUNT(pv.Visit_ID) AS Visit_Count
FROM Department d
LEFT JOIN Patient_Visit pv
  ON d.Dept_ID = pv.Dept_ID
 AND pv.Visit_Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY d.Dept_Name
ORDER BY Visit_Count DESC;

-- 12: Which patients have never had an appointment?
SELECT
  p.Patient_ID,
  CONCAT(p.Patient_FName,' ',p.Patient_LName) AS Patient_Name
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
WHERE a.Appt_ID IS NULL;

-- 13: Find staff members whose birthdays occur this month.
SELECT
  Emp_ID,
  CONCAT(Emp_FName,' ',Emp_LName) AS Staff_Name,
  DATE_FORMAT(Date_of_Birth,'%M %d') AS Birthday
FROM Staff
WHERE MONTH(Date_of_Birth) = MONTH(CURDATE())
ORDER BY DAY(Date_of_Birth);

-- 14: Show rooms that are currently below capacity.
SELECT
  Room_ID,
  Room_Number,
  Capacity,
  Current_Occupancy
FROM Room
WHERE Current_Occupancy < Capacity;

-- 15: List the insurance providers and how many active policies each has.
SELECT
  ip.Name AS Provider,
  COUNT(pi.Patient_ID) AS Active_Policies
FROM Insurance_Provider ip
LEFT JOIN Patient_Insurance pi
  ON ip.Insurance_Provider_ID = pi.Insurance_Provider_ID
 AND (pi.Expiry_Date IS NULL OR pi.Expiry_Date >= CURDATE())
GROUP BY ip.Name
ORDER BY Active_Policies DESC;

-- 16: Calculate total revenue (before payments) per month for the last 6 months.
SELECT
  DATE_FORMAT(Bill_Date,'%Y-%m') AS Month,
  ROUND(SUM(
    Room_Charges
  + Doctor_Charges
  + Lab_Charges
  + Medicine_Charges
  + Other_Charges
  + (Room_Charges + Doctor_Charges + Lab_Charges + Medicine_Charges + Other_Charges) * Tax_Rate/100
  ),2) AS Revenue
FROM Bill
WHERE -- Filters for the last 6 full months, ignoring the current month.
    Bill_Date >= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 6 MONTH)
    AND Bill_Date < DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY Month
ORDER BY Month;

-- 17: Which equipment is due for maintenance within the next 30 days?

SELECT
  Equipment_ID,
  Name,
  Next_Maintenance
FROM Equipment
WHERE Next_Maintenance 
      BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
  AND Status = 'Operational';

-- 18: Show the dashboard summary for each patient using your summary view.
SELECT
  Patient_ID,
  Patient_Name,
  Age,
  Patient_Status,
  Days_Admitted,
  Total_Visits,
  Outstanding_Balance,
  Insurance_Status,
  Upcoming_Appointments
FROM vw_patient_summary
ORDER BY Outstanding_Balance DESC;