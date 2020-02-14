---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 01 - Views
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Views Described
---------------------------------------------------------------------

-- Creating CustsWithOrders View
SET NOCOUNT ON;
USE InsideTSQL2008;

IF OBJECT_ID('Sales.CustsWithOrders', 'V') IS NOT NULL
  DROP VIEW Sales.CustsWithOrders;
GO

CREATE VIEW Sales.CustsWithOrders
AS

SELECT custid, companyname, contactname, contacttitle,
  address, city, region, postalcode, country, phone, fax
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT * FROM Sales.Orders AS O
   WHERE O.custid = C.custid);
GO

-- No Error
IF EXISTS(SELECT 1/0) PRINT 'no error';
GO

---------------------------------------------------------------------
-- ORDER BY in a View
---------------------------------------------------------------------

-- ORDER BY in a View is not Allowed
ALTER VIEW Sales.CustsWithOrders
AS

SELECT country, custid, companyname, contactname, contacttitle,
  address, city, region, postalcode, phone, fax
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT * FROM Sales.Orders AS O
   WHERE O.custid = C.custid)
ORDER BY country;
GO

-- Instead, use ORDER BY in Outer Query
SELECT country, custid, companyname
FROM Sales.CustsWithOrders
ORDER BY country;
GO

-- Do not rely on TOP
ALTER VIEW Sales.CustsWithOrders
AS

SELECT TOP (100) PERCENT
  country, custid, companyname, contactname, contacttitle,
  address, city, region, postalcode, phone, fax
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT * FROM Sales.Orders AS O
   WHERE O.custid = C.custid)
ORDER BY country;
GO

-- Query CustsWithOrders
SELECT country, custid, companyname
FROM Sales.CustsWithOrders;
GO

-- Cleanup
IF OBJECT_ID('Sales.CustsWithOrders', 'V') IS NOT NULL
  DROP VIEW Sales.CustsWithOrders;
GO

---------------------------------------------------------------------
-- Refreshing Views
---------------------------------------------------------------------

-- Create T1 and V1
USE tempdb;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1(col1 INT, col2 INT);
INSERT INTO dbo.T1(col1, col2) VALUES(1, 2);
GO

CREATE VIEW dbo.V1
AS

SELECT * FROM dbo.T1;
GO

-- Query V1, Notice 2 Columns
SELECT * FROM dbo.V1;
GO

-- Add Column to T1
ALTER TABLE dbo.T1 ADD col3 INT;

-- Query V1, Notice Still 2 Columns
SELECT * FROM dbo.V1;

-- Refresh View Metadata
EXEC sp_refreshview 'dbo.V1';

-- Query V1, Notice 3 Columns
SELECT * FROM dbo.V1;

-- Refreshing all views in database
SELECT
  N'EXEC sp_refreshview '
    + QUOTENAME(SCHEMA_NAME(schema_id) + N'.' + QUOTENAME(name), '''')
    + ';' AS cmd
FROM sys.views
WHERE OBJECTPROPERTY(object_id, 'IsSchemaBound') = 0;

-- Cleanup
USE tempdb;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Modular Approach
---------------------------------------------------------------------

-- Grouping Consecutive Months with the Same Trend

-- Creating and Populating the Sales Table
SET NOCOUNT ON;
USE tempdb;
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;
GO

CREATE TABLE dbo.Sales
(
  mnth DATE NOT NULL PRIMARY KEY, 
/* Note: The DATE type is new in SQL Server 2008.
   In earlier versions use DATETIME. */
  qty  INT  NOT NULL
);

INSERT INTO dbo.Sales(mnth, qty) VALUES
/* Note: Table Value Constructor (enhanced VALUES clause) is new 
   in SQL Server 2008. In earlier versions use a separate 
   INSERT VALUES statement for each row. */
  ('20071201', 100),
  ('20080101', 110),
  ('20080201', 120),
  ('20080301', 130),
  ('20080401', 140),
  ('20080501', 140),
  ('20080601', 130),
  ('20080701', 120),
  ('20080801', 110),
  ('20080901', 100),
  ('20081001', 110),
  ('20081101', 100),
  ('20081201', 120),
  ('20090101', 130),
  ('20090201', 140),
  ('20090301', 100),
  ('20090401', 100),
  ('20090501', 100),
  ('20090601', 110),
  ('20090701', 120),
  ('20090801', 110),
  ('20090901', 120),
  ('20091001', 130),
  ('20091101', 140),
  ('20091201', 100);
GO

-- Identify ranges of months with the same trend
-- (up, same, down, unknown)

-- Solution using views

-- Calculate the sign of the difference between
-- the current qty and the previous month's
IF OBJECT_ID('dbo.SalesTrendSgn', 'V') IS NOT NULL DROP VIEW dbo.SalesTrendSgn;
GO
CREATE VIEW dbo.SalesTrendSgn
AS

SELECT mnth, qty,
  SIGN((S1.qty -
         (SELECT TOP (1) qty
          FROM dbo.Sales AS S2
          WHERE S2.mnth < S1.mnth
          ORDER BY S2.mnth DESC))) AS sgn
FROM dbo.Sales AS S1;
GO

SELECT * FROM dbo.SalesTrendSgn;

-- Calculate a grouping factor
IF OBJECT_ID('dbo.SalesGrp', 'V') IS NOT NULL DROP VIEW dbo.SalesGrp;
GO
CREATE VIEW dbo.SalesGrp
AS

SELECT mnth, sgn,
  (SELECT MIN(mnth) FROM dbo.SalesTrendSgn AS V2
   WHERE V2.sgn <> V1.sgn
     AND V2.mnth > V1.mnth) AS grp
FROM dbo.SalesTrendSgn AS V1;
GO

SELECT * FROM dbo.SalesGrp;

-- Group ranges and return their trends
IF OBJECT_ID('dbo.SalesTrends', 'V') IS NOT NULL
  DROP VIEW dbo.SalesTrends;
GO
CREATE VIEW dbo.SalesTrends
AS

SELECT 
  CONVERT(VARCHAR(6), MIN(mnth), 112) AS start_range,
  CONVERT(VARCHAR(6), MAX(mnth), 112) AS end_range,
  CASE sgn
    WHEN -1 THEN 'down'
    WHEN  0 THEN 'same'
    WHEN  1 THEN 'up'
    ELSE         'unknown'
  END AS trend
FROM dbo.SalesGrp
GROUP BY sgn, grp;
GO

-- Query SalesTrends
SELECT start_range, end_range, trend
FROM dbo.SalesTrends
ORDER BY start_range;
GO

-- Solution using CTEs

-- Calculate row numbers based on the order of m
IF OBJECT_ID('dbo.SalesRN', 'V') IS NOT NULL
  DROP VIEW dbo.SalesRN;
GO
CREATE VIEW dbo.SalesRN
AS

SELECT mnth, qty, ROW_NUMBER() OVER(ORDER BY mnth) AS rn
FROM dbo.Sales;
GO

SELECT * FROM dbo.SalesRN;

-- Calculate the sign of the difference between
-- the current qty and the previous month's
IF OBJECT_ID('dbo.SalesTrendSgn', 'V') IS NOT NULL
  DROP VIEW dbo.SalesTrendSgn;
GO
CREATE VIEW dbo.SalesTrendSgn
AS

SELECT Cur.mnth, Cur.qty, SIGN(Cur.qty - Prv.qty) AS sgn
FROM dbo.SalesRN AS Cur
  LEFT OUTER JOIN dbo.SalesRN AS Prv
    ON Cur.rn = Prv.rn + 1;
GO

-- Calculate a grouping factor
IF OBJECT_ID('dbo.SalesGrp', 'V') IS NOT NULL
  DROP VIEW dbo.SalesGrp;
GO
CREATE VIEW dbo.SalesGrp
AS

SELECT mnth, sgn,
  DATEADD(month,
    -1 * ROW_NUMBER() OVER(PARTITION BY sgn ORDER BY mnth),
    mnth) AS grp
FROM dbo.SalesTrendSgn;
GO

-- Group ranges and return their trends
IF OBJECT_ID('dbo.SalesTrends', 'V') IS NOT NULL
  DROP VIEW dbo.SalesTrends;
GO
CREATE VIEW dbo.SalesTrends
AS

SELECT 
  CONVERT(VARCHAR(6), MIN(mnth), 112) AS start_range,
  CONVERT(VARCHAR(6), MAX(mnth), 112) AS end_range,
  CASE sgn
    WHEN -1 THEN 'down'
    WHEN  0 THEN 'same'
    WHEN  1 THEN 'up'
    ELSE         'unknown'
  END AS trend
FROM dbo.SalesGrp
GROUP BY sgn, grp;
GO

-- Query SalesTrends
SELECT start_range, end_range, trend
FROM dbo.SalesTrends
ORDER BY start_range;
GO

-- Implementing SalesTrends with a view and CTE
ALTER VIEW dbo.SalesTrends
AS

WITH SalesRN AS
(
  SELECT mnth, qty, ROW_NUMBER() OVER(ORDER BY mnth) AS rn
  FROM dbo.Sales
),
SalesTrendSgn AS
(
  SELECT Cur.mnth, Cur.qty, SIGN(Cur.qty - Prv.qty) AS sgn
  FROM SalesRN AS Cur
    LEFT OUTER JOIN SalesRN AS Prv
      ON Cur.rn = Prv.rn + 1
),
SalesGrp AS
(
  SELECT mnth, sgn,
    DATEADD(month,
      -1 * ROW_NUMBER() OVER(PARTITION BY sgn ORDER BY mnth),
      mnth) AS grp
  FROM SalesTrendSgn
)
SELECT 
  CONVERT(VARCHAR(6), MIN(mnth), 112) AS start_range,
  CONVERT(VARCHAR(6), MAX(mnth), 112) AS end_range,
  CASE sgn
    WHEN -1 THEN 'down'
    WHEN  0 THEN 'same'
    WHEN  1 THEN 'up'
    ELSE         'unknown'
  END AS trend
FROM SalesGrp
GROUP BY sgn, grp;
GO

-- Query SalesTrends
SELECT start_range, end_range, trend
FROM dbo.SalesTrends
ORDER BY start_range;
GO

-- Cleanup
IF OBJECT_ID('dbo.SalesTrends', 'V') IS NOT NULL DROP VIEW dbo.SalesTrends;
IF OBJECT_ID('dbo.SalesGrp', 'V') IS NOT NULL DROP VIEW dbo.SalesGrp;
IF OBJECT_ID('dbo.SalesTrendSgn', 'V') IS NOT NULL DROP VIEW dbo.SalesTrendSgn;
IF OBJECT_ID('dbo.SalesRN', 'V') IS NOT NULL DROP VIEW dbo.SalesRN;
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;
GO

---------------------------------------------------------------------
-- Updating Views
---------------------------------------------------------------------

-- Creating UserData, CurrentUserData and Setting Permissions
USE tempdb;
IF OBJECT_ID('dbo.CurrentUserData', 'V') IS NOT NULL
  DROP VIEW dbo.CurrentUserData;
IF OBJECT_ID('dbo.UserData', 'T') IS NOT NULL
  DROP TABLE dbo.UserData;
GO
CREATE TABLE dbo.UserData
(
  keycol    INT         NOT NULL IDENTITY PRIMARY KEY,
  loginname sysname     NOT NULL DEFAULT (SUSER_SNAME()),
  datacol   VARCHAR(20) NOT NULL,
  /* ... other columns ... */
);
GO
CREATE VIEW dbo.CurrentUserData
AS

SELECT keycol, datacol
FROM dbo.UserData
WHERE loginname = SUSER_SNAME();
GO

DENY SELECT, INSERT, UPDATE, DELETE ON dbo.UserData TO public;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CurrentUserData TO public;
GO

-- Updating 1 Side of 1-M Relationship

-- Creating Sales.Customers, Orders and CustOrders
SET NOCOUNT ON;
USE tempdb;
IF OBJECT_ID('dbo.CustOrders', 'V') IS NOT NULL DROP VIEW dbo.CustOrders;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
  cid   INT         NOT NULL PRIMARY KEY,
  cname VARCHAR(25) NOT NULL,
  /* other columns */
)
INSERT INTO dbo.Customers(cid, cname) VALUES
  (1, 'Cust 1'),
  (2, 'Cust 2');

CREATE TABLE dbo.Orders
(
  oid INT NOT NULL PRIMARY KEY,
  cid INT NOT NULL REFERENCES dbo.Customers,
  /* other columns */
)
INSERT INTO dbo.Orders(oid, cid) VALUES
  (1001, 1),
  (1002, 1),
  (1003, 1),
  (2001, 2),
  (2002, 2),
  (2003, 2);
GO

CREATE VIEW dbo.CustOrders
AS

SELECT C.cid, C.cname, O.oid
FROM dbo.Customers AS C
  JOIN dbo.Orders AS O
    ON O.cid = C.cid;
GO

-- Query CustOrders
SELECT cid, cname, oid FROM dbo.CustOrders;

-- Update CustOrders
UPDATE dbo.CustOrders
  SET cname = 'Cust 42'
WHERE oid = 1001;

-- Query CustOrders
SELECT cid, cname, oid FROM dbo.CustOrders;

-- Cleanup
USE tempdb;
IF OBJECT_ID('dbo.CurrentUserData', 'V') IS NOT NULL
  DROP VIEW dbo.CurrentUserData;
IF OBJECT_ID('dbo.UserData', 'U') IS NOT NULL
  DROP TABLE dbo.UserData;
IF OBJECT_ID('dbo.CustOrders', 'V') IS NOT NULL
  DROP VIEW dbo.CustOrders;
IF OBJECT_ID('Sales.Orders', 'U') IS NOT NULL
  DROP TABLE Sales.Orders;
IF OBJECT_ID('Sales.Customers', 'U') IS NOT NULL
  DROP TABLE Sales.Customers;
GO

---------------------------------------------------------------------
-- View Options
---------------------------------------------------------------------

---------------------------------------------------------------------
-- ENCRYPTION, SCHEMABINDING 
---------------------------------------------------------------------

USE InsideTSQL2008;
IF OBJECT_ID('Sales.CustsWithOrders') IS NOT NULL
  DROP VIEW Sales.CustsWithOrders;
GO

CREATE VIEW Sales.CustsWithOrders WITH ENCRYPTION, SCHEMABINDING
AS

SELECT custid, companyname, contactname, contacttitle, 
  address, city, region, postalcode, country, phone, fax 
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT 1 FROM Sales.Orders AS O
   WHERE O.custid = C.custid);
GO

-- Try to get the view's text
EXEC sp_helptext 'Sales.CustsWithOrders';
SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.CustsWithOrders'));
GO

-- Try a schema change
ALTER TABLE Sales.Customers DROP COLUMN address;
GO

-- Check which object references the object/column of interest
SELECT referencing_schema_name, referencing_entity_name
FROM sys.dm_sql_referencing_entities('Sales.Customers', 'OBJECT');

SELECT
  OBJECT_SCHEMA_NAME(referencing_id) AS referencing_schema_name,
  OBJECT_NAME(referencing_id) AS referencing_entity_name
FROM sys.sql_expression_dependencies
WHERE referenced_schema_name = N'Sales'
  AND referenced_entity_name = N'Customers'
  AND COL_NAME(referenced_id, referenced_minor_id) = N'address';

---------------------------------------------------------------------
-- CHECK OPTION
---------------------------------------------------------------------

-- Notice that you can insert a row through the view
INSERT INTO Sales.CustsWithOrders(
         companyname, contactname, contacttitle, address, city, region,
         postalcode, country, phone, fax)
  VALUES(N'Customer ABCDE', N'ABCDE', N'ABCDE', N'ABCDE', N'ABCDE', 
         N'ABCDE', N'ABCDE', N'ABCDE', N'ABCDE', N'ABCDE');

-- But when you query the view, you won't see it
SELECT custid, companyname
FROM Sales.CustsWithOrders
WHERE companyname = N'Customer ABCDE';

-- You can see it in the table, though
SELECT custid, companyname
FROM Sales.Customers
WHERE companyname = N'Customer ABCDE';
GO

-- Add CHECK OPTION to the View
ALTER VIEW Sales.CustsWithOrders WITH ENCRYPTION, SCHEMABINDING
AS

SELECT custid, companyname, contactname, contacttitle, 
  address, city, region, postalcode, country, phone, fax 
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT 1 FROM Sales.Orders AS O
   WHERE O.custid = C.custid)
WITH CHECK OPTION;
GO

-- Notice that you can't insert a row through the view
INSERT INTO Sales.CustsWithOrders(
         companyname, contactname, contacttitle, address, city, region,
         postalcode, country, phone, fax)
  VALUES(N'Customer FGHIJ', N'FGHIJ', N'FGHIJ', N'FGHIJ', N'FGHIJ', 
         N'FGHIJ', N'FGHIJ', N'FGHIJ', N'FGHIJ', N'FGHIJ');

-- Cleanup
DELETE FROM Sales.Customers
WHERE custid > 91;

DBCC CHECKIDENT('Sales.Customers', RESEED, 91);

---------------------------------------------------------------------
-- VIEW_METADATA
---------------------------------------------------------------------

-- VIEW_METADATA
ALTER VIEW Sales.CustsWithOrders
  WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS

SELECT custid, companyname, contactname, contacttitle, 
  address, city, region, postalcode, country, phone, fax 
FROM Sales.Customers AS C
WHERE EXISTS
  (SELECT 1 FROM Sales.Orders AS O
   WHERE O.custid = C.custid)
WITH CHECK OPTION;
GO

-- Cleanup
IF OBJECT_ID('Sales.CustsWithOrders', 'V') IS NOT NULL
  DROP VIEW Sales.CustsWithOrders;
GO

---------------------------------------------------------------------
-- Indexed Views
---------------------------------------------------------------------

-- Indexed View Example
USE InsideTSQL2008;
IF OBJECT_ID('dbo.EmpOrders', 'V') IS NOT NULL DROP VIEW dbo.EmpOrders;
IF OBJECT_ID('dbo.EmpOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpOrders;
GO

CREATE VIEW dbo.EmpOrders WITH SCHEMABINDING
AS

SELECT O.empid, SUM(OD.qty) AS totalqty, COUNT_BIG(*) AS cnt
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY O.empid;
GO

CREATE UNIQUE CLUSTERED INDEX idx_uc_empid ON dbo.EmpOrders(empid);

-- Query EmpOrders
SET STATISTICS IO ON;
SELECT empid, totalqty, cnt FROM dbo.EmpOrders;

-- Query Base Tables
SELECT O.empid, SUM(OD.qty) AS totalqty, AVG(OD.qty) AS avgqty, COUNT_BIG(*) AS cnt
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY O.empid;

SET STATISTICS IO OFF;

-- Enforcing UNIQUE with Multiple NULLs

-- Creating Table T1 and View V1
USE tempdb;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

CREATE TABLE dbo.T1
(
  keycol  INT         NULL,
  datacol VARCHAR(10) NOT NULL
);
GO

CREATE VIEW dbo.V1 WITH SCHEMABINDING
AS

SELECT keycol FROM dbo.T1 WHERE keycol IS NOT NULL;
GO

CREATE UNIQUE CLUSTERED INDEX idx_uc_keycol ON dbo.V1(keycol);

-- Test Inserts
INSERT INTO dbo.T1(keycol, datacol) VALUES(1,    'a');
INSERT INTO dbo.T1(keycol, datacol) VALUES(1,    'b'); -- fails
INSERT INTO dbo.T1(keycol, datacol) VALUES(NULL, 'c');
INSERT INTO dbo.T1(keycol, datacol) VALUES(NULL, 'd');

-- Query T1
SELECT keycol, datacol FROM dbo.T1;

-- Drop view
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;

-- Create filtered index
CREATE UNIQUE INDEX idx_keycol_notnull ON dbo.T1(keycol)
  WHERE keycol IS NOT NULL;

-- Insert more rows
INSERT INTO dbo.T1(keycol, datacol) VALUES(NULL, 'e');
INSERT INTO dbo.T1(keycol, datacol) VALUES(NULL, 'f');
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, 'g');

-- Query T1
SELECT keycol, datacol FROM dbo.T1;

-- CLeanup
USE InsideTSQL2008;
IF OBJECT_ID('dbo.EmpOrders', 'V') IS NOT NULL DROP VIEW dbo.EmpOrders;

USE tempdb;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
