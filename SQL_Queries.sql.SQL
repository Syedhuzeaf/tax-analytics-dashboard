-- ================================================
-- 1. Create and Use Database
-- ================================================

CREATE DATABASE tax_dashboard;
USE tax_dashboard;

-- ================================================
-- 2. Table Structure: invoice_data
-- ================================================

CREATE TABLE invoice_data (
  Invoice_ID INT,
  Date DATE,
  Party_Name VARCHAR(100),
  Party_Type VARCHAR(20),
  State VARCHAR(50),
  Quantity INT,
  Item_Description VARCHAR(255),
  Rate_Per_Unit DECIMAL(10,2),
  Total_Amount DECIMAL(10,2),
  GST_Applicable BOOLEAN,
  GST_Percentage DECIMAL(5,2),
  GST_Amount DECIMAL(10,2),
  TDS_Applicable BOOLEAN,
  TDS_Percentage DECIMAL(5,2),
  TDS_Amount DECIMAL(10,2),
  Payment_Mode VARCHAR(50),
  GSTIN VARCHAR(20),
  GST_Type VARCHAR(20),
  TDS_Sections VARCHAR(10),
  PAN VARCHAR(20),
  Audit_Flag VARCHAR(20)
);

-- ================================================
-- 3. Preview and Understand the Table
-- ================================================

-- View first 10 rows
SELECT * FROM invoice_data LIMIT 10;

-- Get structure of table
DESCRIBE invoice_data;

-- ================================================
-- 4. Monthly Revenue Analysis
-- ================================================

SELECT 
  Month,
  Year,
  ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM (
  SELECT 
    MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS Month,
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS Year,
    CAST(Total_Amount AS DECIMAL(10,2)) AS Total_Amount
  FROM invoice_data
) AS sub
GROUP BY Year, Month
ORDER BY Year, Month;

-- ================================================
-- 5. GST Collected by State
-- ================================================

SELECT 
  State,
  ROUND(SUM(CAST(GST_Amount AS DECIMAL(10,2))), 2) AS Total_GST
FROM invoice_data
GROUP BY State
ORDER BY Total_GST DESC;

-- ================================================
-- 6. TDS Deducted by Section
-- ================================================

SELECT 
  TDS_Sections,
  ROUND(SUM(CAST(TDS_Amount AS DECIMAL(10,2))), 2) AS Total_TDS
FROM invoice_data
WHERE TDS_Applicable = 'TRUE'
GROUP BY TDS_Sections
ORDER BY Total_TDS DESC;

-- ================================================
-- 7. Top 5 Parties by Revenue
-- ================================================

SELECT 
  Party_Name,
  ROUND(SUM(CAST(Total_Amount AS DECIMAL(10,2))), 2) AS Revenue
FROM invoice_data
GROUP BY Party_Name
ORDER BY Revenue DESC
LIMIT 5;

-- ================================================
-- 8. Customer vs Vendor Split (Transaction Count & Revenue)
-- ================================================

SELECT 
  Party_Type,
  COUNT(*) AS Total_Transactions,
  ROUND(SUM(CAST(Total_Amount AS DECIMAL(10,2))), 2) AS Total_Revenue
FROM invoice_data
GROUP BY Party_Type;

-- ================================================
-- 9. Audit Risk Summary
-- ================================================

SELECT 
  Audit_Flag,
  COUNT(*) AS Number_of_Entries,
  ROUND(SUM(CAST(Total_Amount AS DECIMAL(10,2))), 2) AS Total_Value
FROM invoice_data
GROUP BY Audit_Flag;
                   