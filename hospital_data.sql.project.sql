CREATE TABLE hospital_data (
    hospital_name      VARCHAR(100),
    location           VARCHAR(100),
    department         VARCHAR(100),
    doctors_count      INT,
    patients_count     INT,
    admission_date     DATE,
    discharge_date     DATE,
    medical_expenses   DECIMAL(12,2)
);

SELECT * FROM hospital_data;

--1. Total Number of Patients

SELECT SUM("patients_count")
AS total_patients
FROM hospital_data;

--2. Average Number of Doctors per Hospital

SELECT "hospital_name", 
AVG("doctors_count")
AS avg_doctors
FROM hospital_data
GROUP BY "hospital_name";

--3. Top 3 Departments with the highest Number of Patients

SELECT "department", SUM("patients_count")
AS total_patients
FROM hospital_data
GROUP BY "department"
ORDER BY total_patients DESC
FETCH FIRST 3 ROWS ONLY;

--4. Hospital With the Meximum Medical Expenses

SELECT "hospital_name", SUM("medical_expenses")
AS total_expenses
FROM hospital_data
GROUP BY "hospital_name"
ORDER BY total_expenses DESC
FETCH FIRST 1 ROW ONLY;

--5. Daily Average Medical Expenses

SELECT "hospital_name", "admission_date", AVG("medical_expenses")
AS avg_daily_expenses
FROM hospital_data
GROUP BY "hospital_name", "admission_date"
ORDER BY "hospital_name", "admission_date";

--6. Longest Hospital Stay

SELECT "hospital_name", "department", "admission_date", "discharge_date",
("discharge_date" - "admission_date")
AS stay_days
FROM hospital_data
ORDER BY stay_days DESC
FETCH FIRST 1 ROW ONLY;

--7. Total Patients Treated Per City

SELECT "location", SUM("patients_count")
AS total_Patients
FROM hospital_data
GROUP BY "location";

--8. Average Length of Stay Per Department

SELECT "department", AVG("discharge_date" - "admission_date")
AS avg_stay_days
FROM hospital_data
GROUP BY "department";

--9. Identify the Depertment with the Lowest Number of Patients

SELECT "department", SUM("patients_count")
AS total_patients
FROM hospital_data
GROUP BY "department"
ORDER BY total_patients ASC
FETCH FIRST 1 ROW ONLY;

--10. Monthly Medical Expenses Report

SELECT EXTRACT(YEAR FROM "admission_date") AS YEAR,
       EXTRACT(MONTH FROM "admission_date") AS MONTH,
	   SUM("medical_expenses")
	   AS total_monthly_expenses
	   FROM hospital_data
	   GROUP BY EXTRACT(YEAR FROM "admission_date"),
       EXTRACT(MONTH FROM "admission_date")
	   ORDER BY YEAR, MONTH;