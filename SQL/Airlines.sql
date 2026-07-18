ALTER TABLE maindata
ADD COLUMN Flight_Date DATE;
UPDATE maindata
SET Flight_Date = STR_TO_DATE(
	CONCAT(Year,'-',`Month (#)`,'-',Day),
    '%Y-%m-%d');
SELECT Year, `Month (#)`, Day, Flight_Date
FROM maindata
LIMIT 10;
-- 1(A) Year
ALTER TABLE maindata
ADD COLUMN Year_New INT;
UPDATE maindata
SET Year_New = YEAR(Flight_Date);
SELECT Flight_Date, Year_New
FROM maindata
LIMIT 10;
-- 1(B) Month Number
ALTER TABLE maindata
ADD COLUMN MonthNo INT;
UPDATE maindata
SET MonthNo = MONTH(Flight_Date);
SELECT Flight_Date, MonthNo
FROM maindata
LIMIT 10;
-- 1(C) Month Full Name
ALTER TABLE maindata
ADD COLUMN MonthFullName VARCHAR(20);
UPDATE maindata
SET MonthFullName = MONTHNAME(Flight_Date);
SELECT Flight_Date, MonthNo, MonthFullName
FROM maindata
LIMIT 10;
-- 1(D) Quarter
ALTER TABLE maindata
ADD COLUMN Quarter VARCHAR(2);
UPDATE maindata
SET Quarter = CONCAT('Q', QUARTER(Flight_Date));
SELECT Flight_Date, Quarter
FROM maindata
LIMIT 10;
-- 1(E) Year-Month
ALTER TABLE maindata
ADD COLUMN YearMonth VARCHAR(10);
UPDATE maindata
SET YearMonth = DATE_FORMAT(Flight_Date, '%Y-%b');
SELECT Flight_Date, YearMonth
FROM maindata
LIMIT 10;
-- 1(F) Weekday Number
ALTER TABLE maindata
ADD COLUMN WeekdayNo INT;
UPDATE maindata
SET WeekdayNo = DAYOFWEEK(Flight_Date);
SELECT Flight_Date, WeekdayNo
FROM maindata
LIMIT 10;
-- 1(G) Weekday Name
ALTER TABLE maindata
ADD COLUMN WeekdayName VARCHAR(15);
UPDATE maindata
SET WeekdayName = DAYNAME(Flight_Date);
SELECT Flight_Date, WeekdayNo, WeekdayName
FROM maindata
LIMIT 10;
-- 1(H) Finacial Month
ALTER TABLE maindata
ADD COLUMN FinancialMonth INT;
UPDATE maindata
SET FinancialMonth = CASE
    WHEN MONTH(Flight_Date) >= 4 THEN MONTH(Flight_Date) - 3
    ELSE MONTH(Flight_Date) + 9
END;
SELECT Flight_Date,
       MonthNo,
       FinancialMonth
FROM maindata
LIMIT 10;
-- 1(I) Finincial Quarter
ALTER TABLE maindata
ADD COLUMN FinancialQuarter VARCHAR(2);
UPDATE maindata
SET FinancialQuarter = CASE
    WHEN FinancialMonth BETWEEN 1 AND 3 THEN 'Q1'
    WHEN FinancialMonth BETWEEN 4 AND 6 THEN 'Q2'
    WHEN FinancialMonth BETWEEN 7 AND 9 THEN 'Q3'
    ELSE 'Q4'
END;
SELECT Flight_Date,
       FinancialMonth,
       FinancialQuarter
FROM maindata
LIMIT 10;

-- 2 Find the load Factor percentage on a yearly ( Transported passengers / Available seats)
SELECT 
    Year_New AS Year,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Year_New
ORDER BY Year_New;
-- Find the load Factor percentage on a Quarterly ( Transported passengers / Available seats)
SELECT
    Quarter,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Quarter
ORDER BY Quarter;
-- Find the load Factor percentage on a Monthly ( Transported passengers / Available seats)
SELECT
    MonthFullName,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,2) AS Load_Factor_Percentage
FROM maindata
GROUP BY MonthNo, MonthFullName
ORDER BY MonthNo;
-- 3 Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)
SELECT `Carrier Name`,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,2) AS Load_Factor_Percentage
FROM maindata
GROUP BY `Carrier Name`
ORDER BY Load_Factor_Percentage DESC;

-- 4 Identify Top 10 Carrier Names based passengers preference
SELECT `Carrier Name`,
    SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `Carrier Name`
ORDER BY total_passengers DESC
LIMIT 10;

-- 5 Display top Routes ( from-to City) based on Number of Flights
SELECT
    `From - To City` AS Route,
    SUM(`# Departures Performed`) AS Number_of_Flights
FROM maindata
GROUP BY `From - To City`
ORDER BY Number_of_Flights DESC
LIMIT 10;

-- 6 Identify the how much load factor is occupied on Weekend vs Weekdays
SELECT
    CASE
        WHEN WeekdayNo IN (1, 7) 
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    SUM(`# Transported Passengers`) AS Total_Transported_Passengers,
    SUM(`# Available Seats`) AS Total_Available_Seats,
    ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,2) AS Load_Factor_Percentage
FROM maindata
GROUP BY Day_Type;

-- 8 Identify number of flights based on Distance group
SELECT
    `%Distance Group ID`as distance_group,
    SUM(`# Departures Performed`) AS Number_of_Flights
FROM maindata
GROUP BY `%Distance Group ID`
ORDER BY number_of_flights desc;