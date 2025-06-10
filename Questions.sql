-- ====================================
-- HOSPITAL MANAGEMENT SYSTEM - ADVANCED SQL QUERIES
-- Demonstrating SQL Mastery with Complex Scenarios
-- ====================================

-- 1. BASIC QUERIES - Data Retrieval and Filtering
-- ====================================

-- Q1: Find all active doctors with their specializations and years of experience
SELECT 
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    d.Specialization,
    d.Years_of_Experience,
    d.Consultation_Fee,
    dep.Dept_Name
FROM Doctor d
JOIN Staff s ON d.Emp_ID = s.Emp_ID
JOIN Department dep ON s.Dept_ID = dep.Dept_ID
WHERE d.Status = 'Active' AND s.Employment_Status = 'Active'
ORDER BY d.Years_of_Experience DESC;

-- Q2: List all patients with their emergency contacts who are currently admitted
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    p.Phone,
    p.Blood_Type,
    p.Emergency_Contact_Name,
    p.Emergency_Contact_Phone,
    r.Room_Number,
    r.Room_Type
FROM Patient p
JOIN Patient_Room_Assignment pra ON p.Patient_ID = pra.Patient_ID
JOIN Room r ON pra.Room_ID = r.Room_ID
WHERE p.Patient_Status = 'Active' 
  AND pra.Discharge_Date IS NULL
ORDER BY r.Room_Number;

-- ====================================
-- 2. AGGREGATE FUNCTIONS AND GROUP BY
-- ====================================

-- Q3: Calculate department-wise statistics
SELECT 
    d.Dept_Name,
    COUNT(s.Emp_ID) as Total_Staff,
    COUNT(CASE WHEN s.Emp_Type = 'Doctor' THEN 1 END) as Total_Doctors,
    COUNT(CASE WHEN s.Emp_Type = 'Nurse' THEN 1 END) as Total_Nurses,
    d.Budget,
    ROUND(d.Budget / NULLIF(COUNT(s.Emp_ID), 0), 2) as Budget_Per_Employee
FROM Department d
LEFT JOIN Staff s ON d.Dept_ID = s.Dept_ID 
WHERE s.Employment_Status = 'Active' OR s.Employment_Status IS NULL
GROUP BY d.Dept_ID, d.Dept_Name, d.Budget
ORDER BY Total_Staff DESC;

-- Q4: Monthly appointment statistics with revenue analysis
SELECT 
    YEAR(a.Appointment_Date) as Year,
    MONTH(a.Appointment_Date) as Month,
    MONTHNAME(a.Appointment_Date) as Month_Name,
    COUNT(*) as Total_Appointments,
    COUNT(CASE WHEN a.Status = 'Completed' THEN 1 END) as Completed_Appointments,
    COUNT(CASE WHEN a.Status = 'Cancelled' THEN 1 END) as Cancelled_Appointments,
    ROUND(COUNT(CASE WHEN a.Status = 'Completed' THEN 1 END) * 100.0 / COUNT(*), 2) as Completion_Rate,
    SUM(CASE WHEN a.Status = 'Completed' THEN a.Consultation_Fee ELSE 0 END) as Revenue_Generated
FROM Appointment a
WHERE a.Appointment_Date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY YEAR(a.Appointment_Date), MONTH(a.Appointment_Date)
ORDER BY Year DESC, Month DESC;

-- ====================================
-- 3. WINDOW FUNCTIONS AND ANALYTICS
-- ====================================

-- Q5: Rank doctors by consultation fees within their specializations
SELECT 
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    d.Specialization,
    d.Consultation_Fee,
    RANK() OVER (PARTITION BY d.Specialization ORDER BY d.Consultation_Fee DESC) as Fee_Rank,
    ROW_NUMBER() OVER (ORDER BY d.Consultation_Fee DESC) as Overall_Rank,
    ROUND(AVG(d.Consultation_Fee) OVER (PARTITION BY d.Specialization), 2) as Avg_Specialty_Fee
FROM Doctor d
JOIN Staff s ON d.Emp_ID = s.Emp_ID
WHERE d.Status = 'Active'
ORDER BY d.Specialization, Fee_Rank;

-- Q6: Patient visit frequency analysis with running totals
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    COUNT(a.Appt_ID) as Total_Visits,
    MAX(a.Appointment_Date) as Last_Visit,
    MIN(a.Appointment_Date) as First_Visit,
    DATEDIFF(MAX(a.Appointment_Date), MIN(a.Appointment_Date)) as Days_Between_First_Last,
    SUM(COUNT(a.Appt_ID)) OVER (ORDER BY COUNT(a.Appt_ID) DESC) as Running_Total_Visits,
    NTILE(4) OVER (ORDER BY COUNT(a.Appt_ID)) as Visit_Quartile
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
GROUP BY p.Patient_ID, p.Patient_FName, p.Patient_LName
HAVING COUNT(a.Appt_ID) > 0
ORDER BY Total_Visits DESC;

-- ====================================
-- 4. COMPLEX JOINS AND SUBQUERIES
-- ====================================

-- Q7: Find doctors who have treated patients from all blood types
SELECT 
    d.Doctor_ID,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    d.Specialization,
    COUNT(DISTINCT p.Blood_Type) as Blood_Types_Treated,
    GROUP_CONCAT(DISTINCT p.Blood_Type ORDER BY p.Blood_Type) as Blood_Types_List
FROM Doctor d
JOIN Staff s ON d.Emp_ID = s.Emp_ID
JOIN Appointment a ON d.Doctor_ID = a.Doctor_ID
JOIN Patient p ON a.Patient_ID = p.Patient_ID
WHERE a.Status = 'Completed'
GROUP BY d.Doctor_ID, s.Emp_FName, s.Emp_LName, d.Specialization
HAVING COUNT(DISTINCT p.Blood_Type) = (
    SELECT COUNT(DISTINCT Blood_Type) FROM Patient
)
ORDER BY Doctor_Name;

-- Q8: Complex patient billing analysis with multiple conditions
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    COUNT(DISTINCT a.Appt_ID) as Total_Appointments,
    COUNT(DISTINCT pr.Prescription_ID) as Total_Prescriptions,
    COUNT(DISTINCT ls.Lab_ID) as Total_Lab_Tests,
    COALESCE(SUM(b.Room_Charges + b.Doctor_Charges + b.Lab_Charges + b.Medicine_Charges), 0) as Total_Charges,
    COALESCE(SUM(b.Amount_Paid), 0) as Total_Paid,
    COALESCE(SUM(b.Room_Charges + b.Doctor_Charges + b.Lab_Charges + b.Medicine_Charges) - SUM(b.Amount_Paid), 0) as Outstanding_Balance,
    CASE 
        WHEN SUM(b.Amount_Paid) >= SUM(b.Room_Charges + b.Doctor_Charges + b.Lab_Charges + b.Medicine_Charges) THEN 'Paid'
        WHEN SUM(b.Amount_Paid) > 0 THEN 'Partially Paid'
        ELSE 'Unpaid'
    END as Payment_Status
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
LEFT JOIN Prescription pr ON p.Patient_ID = pr.Patient_ID
LEFT JOIN Lab_Screening ls ON p.Patient_ID = ls.Patient_ID
LEFT JOIN Bill b ON p.Patient_ID = b.Patient_ID
GROUP BY p.Patient_ID, p.Patient_FName, p.Patient_LName
HAVING Total_Charges > 0
ORDER BY Outstanding_Balance DESC;

-- ====================================
-- 5. CORRELATED SUBQUERIES AND EXISTS
-- ====================================

-- Q9: Find patients who have been prescribed the most expensive medicines
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    m.Medicine_Name,
    m.Unit_Cost,
    pr.Quantity_Prescribed,
    (m.Unit_Cost * pr.Quantity_Prescribed) as Total_Medicine_Cost
FROM Patient p
JOIN Prescription pr ON p.Patient_ID = pr.Patient_ID
JOIN Medicine m ON pr.Medicine_ID = m.Medicine_ID
WHERE m.Unit_Cost = (
    SELECT MAX(m2.Unit_Cost)
    FROM Prescription pr2
    JOIN Medicine m2 ON pr2.Medicine_ID = m2.Medicine_ID
    WHERE pr2.Patient_ID = p.Patient_ID
)
ORDER BY Total_Medicine_Cost DESC;

-- Q10: Doctors who have no appointments in the next 30 days
SELECT 
    d.Doctor_ID,
    CONCAT(s.Emp_FName, ' ', s.Emp_LName) AS Doctor_Name,
    d.Specialization,
    d.Status
FROM Doctor d
JOIN Staff s ON d.Emp_ID = s.Emp_ID
WHERE d.Status = 'Active'
  AND NOT EXISTS (
    SELECT 1 
    FROM Appointment a 
    WHERE a.Doctor_ID = d.Doctor_ID 
      AND a.Appointment_Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
      AND a.Status NOT IN ('Cancelled', 'No Show')
  )
ORDER BY d.Specialization, Doctor_Name;

-- ====================================
-- 6. ADVANCED DATE/TIME FUNCTIONS
-- ====================================

-- Q11: Analyze appointment patterns by day of week and hour
SELECT 
    DAYNAME(a.Appointment_Date) as Day_of_Week,
    HOUR(a.Appointment_Time) as Hour_of_Day,
    COUNT(*) as Total_Appointments,
    COUNT(CASE WHEN a.Status = 'Completed' THEN 1 END) as Completed_Appointments,
    ROUND(AVG(a.Duration), 2) as Avg_Duration_Minutes,
    SUM(a.Consultation_Fee) as Total_Revenue
FROM Appointment a
WHERE a.Appointment_Date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY DAYNAME(a.Appointment_Date), HOUR(a.Appointment_Time), DAYOFWEEK(a.Appointment_Date)
ORDER BY DAYOFWEEK(a.Appointment_Date), Hour_of_Day;

-- Q12: Patient age distribution analysis
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE()) < 18 THEN 'Pediatric (0-17)'
        WHEN TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE()) BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE()) BETWEEN 36 AND 55 THEN 'Middle Age (36-55)'
        WHEN TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE()) BETWEEN 56 AND 70 THEN 'Senior (56-70)'
        ELSE 'Elderly (70+)'
    END as Age_Group,
    COUNT(*) as Patient_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Patient), 2) as Percentage,
    AVG(TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE())) as Avg_Age
FROM Patient
GROUP BY Age_Group
ORDER BY Avg_Age;

-- ====================================
-- 7. CONDITIONAL LOGIC AND CASE STATEMENTS
-- ====================================

-- Q13: Room utilization efficiency report
SELECT 
    r.Room_Number,
    r.Room_Type,
    r.Capacity,
    r.Current_Occupancy,
    r.Daily_Rate,
    CASE 
        WHEN r.Current_Occupancy = 0 THEN 'Available'
        WHEN r.Current_Occupancy = r.Capacity THEN 'Full'
        ELSE 'Partially Occupied'
    END as Occupancy_Status,
    ROUND((r.Current_Occupancy * 100.0 / r.Capacity), 2) as Occupancy_Percentage,
    CASE 
        WHEN r.Current_Occupancy = 0 THEN 0
        ELSE r.Daily_Rate * r.Current_Occupancy
    END as Daily_Revenue,
    CASE 
        WHEN r.Status = 'Maintenance' THEN 'Under Maintenance'
        WHEN r.Current_Occupancy = 0 THEN 'Ready for Admission'
        WHEN r.Current_Occupancy < r.Capacity THEN 'Partially Available'
        ELSE 'Full - No Availability'
    END as Availability_Status
FROM Room r
ORDER BY r.Room_Type, r.Room_Number;

-- ====================================
-- 8. PIVOT-LIKE OPERATIONS AND ADVANCED AGGREGATIONS
-- ====================================

-- Q14: Medicine inventory analysis with stock alerts
SELECT 
    m.Medicine_Name,
    m.Medicine_Type,
    m.Current_Stock,
    m.Minimum_Stock_Level,
    m.Unit_Cost,
    CASE 
        WHEN m.Current_Stock <= m.Minimum_Stock_Level THEN 'REORDER NOW'
        WHEN m.Current_Stock <= (m.Minimum_Stock_Level * 1.5) THEN 'LOW STOCK'
        ELSE 'ADEQUATE'
    END as Stock_Status,
    (m.Current_Stock - m.Minimum_Stock_Level) as Stock_Buffer,
    (m.Current_Stock * m.Unit_Cost) as Inventory_Value,
    COALESCE(prescription_stats.Total_Prescribed, 0) as Total_Ever_Prescribed,
    COALESCE(prescription_stats.Avg_Monthly_Usage, 0) as Avg_Monthly_Usage
FROM Medicine m
LEFT JOIN (
    SELECT 
        Medicine_ID,
        SUM(Quantity_Prescribed) as Total_Prescribed,
        ROUND(SUM(Quantity_Prescribed) / 12, 2) as Avg_Monthly_Usage
    FROM Prescription 
    WHERE Prescription_Date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    GROUP BY Medicine_ID
) prescription_stats ON m.Medicine_ID = prescription_stats.Medicine_ID
ORDER BY 
    CASE Stock_Status 
        WHEN 'REORDER NOW' THEN 1 
        WHEN 'LOW STOCK' THEN 2 
        ELSE 3 
    END,
    Inventory_Value DESC;

-- ====================================
-- 9. RECURSIVE QUERIES AND HIERARCHICAL DATA
-- ====================================

-- Q15: Staff hierarchy and supervision chain
WITH RECURSIVE StaffHierarchy AS (
    -- Base case: Top level managers (no supervisor)
    SELECT 
        Emp_ID,
        CONCAT(Emp_FName, ' ', Emp_LName) as Employee_Name,
        Emp_Type,
        Supervisor_ID,
        0 as Level,
        CAST(CONCAT(Emp_FName, ' ', Emp_LName) AS CHAR(1000)) as Hierarchy_Path
    FROM Staff 
    WHERE Supervisor_ID IS NULL AND Employment_Status = 'Active'
    
    UNION ALL
    
    -- Recursive case: Employees with supervisors
    SELECT 
        s.Emp_ID,
        CONCAT(s.Emp_FName, ' ', s.Emp_LName) as Employee_Name,
        s.Emp_Type,
        s.Supervisor_ID,
        sh.Level + 1,
        CONCAT(sh.Hierarchy_Path, ' -> ', s.Emp_FName, ' ', s.Emp_LName)
    FROM Staff s
    INNER JOIN StaffHierarchy sh ON s.Supervisor_ID = sh.Emp_ID
    WHERE s.Employment_Status = 'Active' AND sh.Level < 5
)
SELECT 
    Level,
    Employee_Name,
    Emp_Type,
    Hierarchy_Path,
    (SELECT COUNT(*) FROM Staff s2 WHERE s2.Supervisor_ID = sh.Emp_ID) as Direct_Reports
FROM StaffHierarchy sh
ORDER BY Level, Employee_Name;

-- ====================================
-- 10. PERFORMANCE OPTIMIZATION QUERIES
-- ====================================

-- Q16: Identify frequently accessed patient records (for caching strategy)
SELECT 
    p.Patient_ID,
    CONCAT(p.Patient_FName, ' ', p.Patient_LName) AS Patient_Name,
    COUNT(DISTINCT a.Appt_ID) + 
    COUNT(DISTINCT pr.Prescription_ID) + 
    COUNT(DISTINCT ls.Lab_ID) as Total_Interactions,
    COUNT(DISTINCT a.Appt_ID) as Appointment_Count,
    COUNT(DISTINCT pr.Prescription_ID) as Prescription_Count,
    COUNT(DISTINCT ls.Lab_ID) as Lab_Test_Count,
    MAX(GREATEST(
        COALESCE(a.Updated_At, '1900-01-01'),
        COALESCE(pr.Updated_At, '1900-01-01'),
        COALESCE(ls.Order_Date, '1900-01-01')
    )) as Last_Activity_Date,
    DATEDIFF(CURDATE(), MAX(GREATEST(
        COALESCE(a.Updated_At, '1900-01-01'),
        COALESCE(pr.Updated_At, '1900-01-01'),
        COALESCE(ls.Order_Date, '1900-01-01')
    ))) as Days_Since_Last_Activity
FROM Patient p
LEFT JOIN Appointment a ON p.Patient_ID = a.Patient_ID
LEFT JOIN Prescription pr ON p.Patient_ID = pr.Patient_ID
LEFT JOIN Lab_Screening ls ON p.Patient_ID = ls.Patient_ID
GROUP BY p.Patient_ID, p.Patient_FName, p.Patient_LName
HAVING Total_Interactions > 0
ORDER BY Total_Interactions DESC, Days_Since_Last_Activity ASC
LIMIT 20;

-- Q17: Comprehensive hospital performance dashboard query
SELECT 
    'Hospital Performance Dashboard' as Report_Title,
    CURDATE() as Report_Date,
    
    -- Patient Statistics
    (SELECT COUNT(*) FROM Patient WHERE Patient_Status = 'Active') as Active_Patients,
    (SELECT COUNT(*) FROM Patient WHERE Admission_Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as New_Patients_30Days,
    
    -- Staff Statistics  
    (SELECT COUNT(*) FROM Staff WHERE Employment_Status = 'Active') as Active_Staff,
    (SELECT COUNT(*) FROM Doctor WHERE Status = 'Active') as Active_Doctors,
    (SELECT COUNT(*) FROM Nurse WHERE Status = 'Active') as Active_Nurses,
    
    -- Appointment Statistics
    (SELECT COUNT(*) FROM Appointment WHERE Appointment_Date = CURDATE()) as Todays_Appointments,
    (SELECT COUNT(*) FROM Appointment WHERE Appointment_Date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND Status = 'Completed') as Completed_Appointments_7Days,
    
    -- Room Statistics
    (SELECT COUNT(*) FROM Room WHERE Status = 'Available') as Available_Rooms,
    (SELECT COUNT(*) FROM Room WHERE Status = 'Occupied') as Occupied_Rooms,
    (SELECT ROUND(SUM(Current_Occupancy) * 100.0 / SUM(Capacity), 2) FROM Room) as Overall_Occupancy_Rate,
    
    -- Financial Statistics
    (SELECT COALESCE(SUM(Room_Charges + Doctor_Charges + Lab_Charges + Medicine_Charges), 0) 
     FROM Bill WHERE Bill_Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as Revenue_30Days,
    (SELECT COALESCE(SUM(Amount_Paid), 0) 
     FROM Bill WHERE Bill_Date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as Collections_30Days,
    
    -- Inventory Alerts
    (SELECT COUNT(*) FROM Medicine WHERE Current_Stock <= Minimum_Stock_Level) as Low_Stock_Medicines,
    (SELECT COUNT(*) FROM Medicine WHERE Expiry_Date <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)) as Medicines_Expiring_90Days;