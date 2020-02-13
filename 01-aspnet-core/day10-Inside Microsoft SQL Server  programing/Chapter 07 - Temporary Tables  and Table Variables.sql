---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 07 - Temporary Tables and Table Variables
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Temporary Tables
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Local
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Name, Scope/Visibility
---------------------------------------------------------------------
CREATE TABLE #T1(col1 INT);
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#T1%';
DROP TABLE #T1;
GO

---------------------------------------------------------------------
-- Temporary Table Name Resolution
---------------------------------------------------------------------

-- Creation Script for proc1 and proc2; T1 and T2 with Same Schema
SET NOCOUNT ON; 
USE tempdb; 

IF OBJECT_ID('dbo.proc1', 'P') IS NOT NULL DROP PROC dbo.proc1; 
IF OBJECT_ID('dbo.proc2', 'P') IS NOT NULL DROP PROC dbo.proc2; 
GO 
 
CREATE PROC dbo.proc1 
AS 
 
CREATE TABLE #T1(col1 INT NOT NULL); 
INSERT INTO #T1 VALUES(1); 
SELECT * FROM #T1; 
 
EXEC dbo.proc2; 
GO 
 
CREATE PROC dbo.proc2 
AS 
 
CREATE TABLE #T1(col1 INT NULL); 
INSERT INTO #T1 VALUES(2); 
SELECT * FROM #T1; 
GO

-- Execute proc1
EXEC dbo.proc1;
GO

-- Alter proc2; T1 and T2 with Different Schemas
ALTER PROC dbo.proc2
AS

CREATE TABLE #T1(col1 INT NULL, col2 INT NOT NULL);
INSERT INTO #T1 VALUES(2, 2);
SELECT * FROM #T1;
GO

-- Execute proc1, fails
EXEC dbo.proc1;
GO

-- Execute proc2, succeeds
EXEC dbo.proc2;
GO

-- Execute proc1, succeeds
EXEC dbo.proc1;
GO

-- Execute proc1 after proc2 recompiles
EXEC sp_recompile 'dbo.proc2';
EXEC dbo.proc1;

-- Cleanup
IF OBJECT_ID('dbo.proc1', 'P') IS NOT NULL DROP PROC dbo.proc1; 
IF OBJECT_ID('dbo.proc2', 'P') IS NOT NULL DROP PROC dbo.proc2; 

---------------------------------------------------------------------
-- Schema Changes of Temporary Tables in Dynamic Batches
---------------------------------------------------------------------

-- Sample Code
 
-- Assume @column_defs and @insert were constructed dynamically
-- with appropriate safeguards against SQL injection
DECLARE @column_defs AS VARCHAR(1000), @insert AS VARCHAR(1000);
SET @column_defs = 'col1 INT, col2 DECIMAL(10, 2)';
SET @insert = 'INSERT INTO #T VALUES(10, 20.30)';

--	In the outer level, create temp table #T with a single dummy column
CREATE TABLE #T(dummycol INT);

--	Within a dynamic batch:
--    Alter #T adding the columns you need
--    Alter #T dropping the dummy column
--    Open another level of dynamic execution
--      Populate #T

EXEC('
ALTER TABLE #T ADD ' + @column_defs + ';
ALTER TABLE #T DROP COLUMN dummycol;
EXEC(''' + @insert + ''')');
GO

--	Back in the outer level, access #T in a new batch
SELECT * FROM #T;

-- Cleanup
DROP TABLE #T;
GO

---------------------------------------------------------------------
-- Caching of Temporary Objects
---------------------------------------------------------------------

-- Create proc TestCaching
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.TestCaching', 'P') IS NOT NULL
  DROP PROC dbo.TestCaching;
GO
CREATE PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000));

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO

-- Query temporary objects, should get no output
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';

-- Execute proc
EXEC dbo.TestCaching;

-- Query temporary objects, should get name of cached temp table
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';

-- Mark the proc for recompile
EXEC sp_recompile 'dbo.TestCaching';

-- Query temporary objects, should get no output
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';

-- DDL prevents caching
ALTER PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000));
CREATE UNIQUE INDEX idx1 ON #T1(n);

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO

-- Execute proc
EXEC dbo.TestCaching;

-- Query temporary objects, should get name of cached temp table
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';
GO

-- Use a UNIQUE constraint as part of the table definition instead of creating an index explicitly
ALTER PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000), UNIQUE(n));

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO

-- Execute proc
EXEC dbo.TestCaching;

-- Query temporary objects, should get name of cached temp table
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';
GO

-- Named constraints prevent caching
ALTER PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000), CONSTRAINT UNQ_#T1_n UNIQUE(n));

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO

-- Execute proc
EXEC dbo.TestCaching;

-- Query temporary objects, should get name of cached temp table
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';

---------------------------------------------------------------------
-- Global Temporary Tables
---------------------------------------------------------------------

-- Termination

-- Connection 1
CREATE TABLE ##T1(col1 INT);
INSERT INTO ##T1 VALUES(1);

-- Connection 2
BEGIN TRAN
  UPDATE ##T1 SET col1 = col1 + 1;

-- Close connection 1

-- Connection 2
  -- Succeeds
  SELECT * FROM ##T1;
COMMIT

-- Fails
SELECT * FROM ##T1;
GO

-- Created in startup procedure

-- Creation Script for CreateGlobals Procedure
USE master; 
IF OBJECT_ID('dbo.CreateGlobals', 'P') IS NOT NULL DROP PROC dbo.CreateGlobals 
GO 
CREATE PROC dbo.CreateGlobals 
AS 
 
CREATE TABLE ##Globals 
( 
  varname sysname NOT NULL PRIMARY KEY, 
  val     SQL_VARIANT NULL 
); 
GO 
 
EXEC dbo.sp_procoption 'dbo.CreateGlobals', 'startup', 'true';
GO

-- Restart SQL Server

-- Add a global variable
SET NOCOUNT ON;
INSERT INTO ##Globals VALUES('var1', CAST('abc' AS VARCHAR(10)));
SELECT * FROM ##Globals;

-- Cleanup
USE master;
DROP PROC dbo.CreateGlobals;
DROP TABLE ##Globals;
GO

---------------------------------------------------------------------
-- Table Variables
---------------------------------------------------------------------

-- Creating a table variable
DECLARE @T1 TABLE(col1 INT);
INSERT @T1 VALUES(1);
SELECT * FROM @T1;
GO

---------------------------------------------------------------------
-- tempdb
---------------------------------------------------------------------
SELECT TABLE_NAME
FROM tempdb.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '#%';
GO
DECLARE @T TABLE(col1 INT);

INSERT INTO @T VALUES(1);

SELECT TABLE_NAME
FROM tempdb.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '#%';
GO

---------------------------------------------------------------------
-- Statistics
---------------------------------------------------------------------

-- Table Variable Example
DECLARE @T TABLE
(
  col1 INT NOT NULL PRIMARY KEY,
  col2 INT NOT NULL,
  filler CHAR(200) NOT NULL DEFAULT('a'),
  UNIQUE(col2, col1)
);

INSERT INTO @T(col1, col2)
  SELECT n, (n - 1) % 10000 + 1 FROM dbo.Nums
  WHERE n <= 100000;

SELECT * FROM @T WHERE col1 = 1;
SELECT * FROM @T WHERE col1 <= 50000;

SELECT * FROM @T WHERE col2 = 1;
SELECT * FROM @T WHERE col2 <= 2;
SELECT * FROM @T WHERE col2 <= 5000;
GO

-- Temp Table Example
SELECT n AS col1, (n - 1) % 10000 + 1 AS col2,
  CAST('a' AS CHAR(200)) AS filler
INTO #T
FROM dbo.Nums
WHERE n <= 100000;

ALTER TABLE #T ADD PRIMARY KEY(col1);
CREATE UNIQUE INDEX idx_col2_col1 ON #T(col2, col1);
GO

SELECT * FROM #T WHERE col1 = 1;
SELECT * FROM #T WHERE col1 <= 50000;

SELECT * FROM #T WHERE col2 = 1;
SELECT * FROM #T WHERE col2 <= 2;
SELECT * FROM #T WHERE col2 <= 5000;
GO

-- Cleanup
DROP TABLE #T;
GO

---------------------------------------------------------------------
-- Minimally Logged Inserts
---------------------------------------------------------------------

-- Check amount of logging (count, size)
CHECKPOINT;
GO

DECLARE @numrecords AS INT, @size AS BIGINT;

SELECT 
  @numrecords = COUNT(*),
  @size       = COALESCE(SUM([Log Record Length]), 0)
FROM fn_dblog(NULL, NULL) AS D;

-- <operation>

SELECT 
  COUNT(*) - @numrecords AS numrecords,
  CAST((COALESCE(SUM([Log Record Length]), 0) - @size)
    / 1024. / 1024. AS NUMERIC(12, 2)) AS size_mb
FROM fn_dblog(NULL, NULL) AS D;

-- SELECT INTO with Temporary Table
USE tempdb;
CHECKPOINT;
GO

DECLARE @numrecords AS INT, @size AS BIGINT;

SELECT 
  @numrecords = COUNT(*),
  @size       = COALESCE(SUM([Log Record Length]), 0)
FROM fn_dblog(NULL, NULL) AS D;

SELECT n, CAST('a' AS CHAR(2000)) AS filler
INTO #TestLogging
FROM dbo.Nums
WHERE n <= 100000;

SELECT 
  COUNT(*) - @numrecords AS numrecords,
  CAST((COALESCE(SUM([Log Record Length]), 0) - @size)
    / 1024. / 1024. AS NUMERIC(12, 2)) AS size_mb
FROM fn_dblog(NULL, NULL) AS D;
GO

DROP TABLE #TestLogging;
GO

-- INSERT SELECT with Table Variable
USE tempdb;
CHECKPOINT;
GO

DECLARE @numrecords AS INT, @size AS BIGINT;

SELECT 
  @numrecords = COUNT(*),
  @size       = COALESCE(SUM([Log Record Length]), 0)
FROM fn_dblog(NULL, NULL) AS D;

DECLARE @TestLogging AS TABLE(n INT, filler CHAR(2000));

INSERT INTO @TestLogging(n, filler)
  SELECT n, CAST('a' AS CHAR(2000))
  FROM dbo.Nums
  WHERE n <= 100000;

SELECT 
  COUNT(*) - @numrecords AS numrecords,
  CAST((COALESCE(SUM([Log Record Length]), 0) - @size)
    / 1024. / 1024. AS NUMERIC(12, 2)) AS size_mb
FROM fn_dblog(NULL, NULL) AS D;
GO

---------------------------------------------------------------------
-- Table Expressions
---------------------------------------------------------------------

-- Return for each Employee, the Row with the Highest orderid
USE InsideTSQL2008;

WITH EmpMax AS
(
  SELECT empid, MAX(orderid) AS maxoid
  FROM Sales.Orders
  GROUP BY empid
)
SELECT O.orderid, O.empid, O.custid, O.orderdate
FROM Sales.Orders AS O
  JOIN EmpMax AS EM
    ON O.orderid = EM.maxoid;
GO

---------------------------------------------------------------------
-- Summary Exercises
---------------------------------------------------------------------

-- Listing 7-1: Code that creates realistic table sizes for summary exercises 
SET NOCOUNT ON;
USE tempdb;

IF SCHEMA_ID('Sales') IS NULL EXEC('CREATE SCHEMA Sales');
IF OBJECT_ID('Sales.Customers', 'U') IS NOT NULL DROP TABLE Sales.Customers;
IF OBJECT_ID('Sales.Orders', 'U') IS NOT NULL DROP TABLE Sales.Orders;
GO

SELECT n AS custid
INTO Sales.Customers
FROM dbo.Nums
WHERE n <= 10000;

ALTER TABLE Sales.Customers ADD PRIMARY KEY(custid);

SELECT n AS orderid,
  DATEADD(day, ABS(CHECKSUM(NEWID())) % (4*365), '20060101') AS orderdate,
  1 + ABS(CHECKSUM(NEWID())) % 10000 AS custid,
  1 + ABS(CHECKSUM(NEWID())) % 40    AS empid,
  CAST('a' AS CHAR(200)) AS filler
INTO Sales.Orders
FROM dbo.Nums
WHERE n <= 1000000;

ALTER TABLE Sales.Orders ADD PRIMARY KEY(orderid);
CREATE INDEX idx_cid_eid ON Sales.Orders(custid, empid);
GO

---------------------------------------------------------------------
-- Comparing Periods
---------------------------------------------------------------------

-- Solution with table expressions
SET STATISTICS IO ON;

WITH YearlyCounts AS
(
  SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
  FROM Sales.Orders
  GROUP BY YEAR(orderdate)
)
SELECT C.orderyear, C.numorders, C.numorders - P.numorders AS diff
FROM YearlyCounts AS C
  LEFT OUTER JOIN YearlyCounts AS P
    ON C.orderyear = P.orderyear + 1;

-- Solution with table variables
DECLARE @YearlyCounts AS TABLE
(
  orderyear INT PRIMARY KEY,
  numorders INT
);

INSERT INTO @YearlyCounts(orderyear, numorders)
  SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
  FROM Sales.Orders
  GROUP BY YEAR(orderdate);

SELECT C.orderyear, C.numorders, C.numorders - P.numorders AS diff
FROM @YearlyCounts AS C
  LEFT OUTER JOIN @YearlyCounts AS P
    ON C.orderyear = P.orderyear + 1;

---------------------------------------------------------------------
-- Recent Orders
---------------------------------------------------------------------

-- Create index to support solutions
CREATE INDEX idx_cid_od_i_eid_oid ON Sales.Orders(custid, orderdate)
  INCLUDE(empid, orderid);

-- Solutions based on table expressions
WITH CustMax AS
(
  SELECT custid, MAX(orderdate) AS mx
  FROM Sales.Orders
  GROUP BY custid
)
SELECT O.orderid, O.orderdate, O.custid, O.empid
FROM Sales.Orders AS O
  JOIN CustMax AS M
    ON O.custid = M.custid
   AND O.orderdate = M.mx;

-- Solution based on temporary tables
CREATE TABLE #CustMax
(
  custid INT      NOT NULL PRIMARY KEY,
  mx     DATETIME NOT NULL
);

INSERT INTO #CustMax(custid, mx)
  SELECT custid, MAX(orderdate) AS mx
  FROM Sales.Orders
  GROUP BY custid;

SELECT O.orderid, O.orderdate, O.custid, O.empid
FROM Sales.Orders AS O
  JOIN #CustMax AS M
    ON O.custid = M.custid
   AND O.orderdate = M.mx;

DROP TABLE #CustMax;

-- Other solutions based on table expressions

-- Solution based on CROSS APPLY, good for high density of customers
SELECT A.*
FROM Sales.Customers AS C
  CROSS APPLY (SELECT TOP (1) WITH TIES orderid, orderdate, custid, empid
               FROM Sales.Orders AS O
               WHERE O.custid = C.custid
               ORDER BY orderdate DESC) AS A;

-- Solution based on RANK, good for low density of customers
CREATE INDEX idx_cid_od_i_eid_oidD ON Sales.Orders(custid, orderdate DESC)
  INCLUDE(empid, orderid);

WITH OrderRanks AS
(
  SELECT orderid, orderdate, custid, empid,
    RANK() OVER(PARTITION BY custid ORDER BY orderdate DESC) AS rnk
  FROM Sales.Orders
)
SELECT *
FROM OrderRanks
WHERE rnk = 1;

-- Cleanup
DROP INDEX Sales.Orders.idx_cid_od_i_eid_oid;
DROP INDEX Sales.Orders.idx_cid_od_i_eid_oidD;

---------------------------------------------------------------------
-- Relational Division
---------------------------------------------------------------------
 
-- Which customers were handled by the same set of employees?

-- Solution Based on Subqueries; no Temp Table
SELECT custid,
    CASE WHEN EXISTS(SELECT * FROM Sales.Orders AS O
                     WHERE O.custid = C1.custid)
      THEN COALESCE(
        (SELECT MIN(C2.custid)
           FROM Sales.Customers AS C2
           WHERE C2.custid < C1.custid
             AND NOT EXISTS
               (SELECT * FROM Sales.Orders AS O1
                WHERE O1.custid = C1.custid
                  AND NOT EXISTS
                    (SELECT * FROM Sales.Orders AS O2
                     WHERE O2.custid = C2.custid
                       AND O2.empid = O1.empid))
             AND NOT EXISTS
               (SELECT * FROM Sales.Orders AS O2
                WHERE O2.custid = C2.custid
                  AND NOT EXISTS
                    (SELECT * FROM Sales.Orders AS O1
                     WHERE O1.custid = C1.custid
                       AND O1.empid = O2.empid))),
        custid) END AS grp
FROM Sales.Customers AS C1
ORDER BY grp, custid;
GO

-- Solution Based on Temp Tables, 8 seconds
SELECT DISTINCT custid, empid
INTO #CustsEmps
FROM Sales.Orders;

CREATE UNIQUE CLUSTERED INDEX idx_cid_eid
  ON #CustsEmps(custid, empid);
GO

WITH Agg AS
(
  SELECT custid,
    MIN(empid) AS MN,
    MAX(empid) AS MX,
    COUNT(*)   AS CN,
    SUM(empid) AS SM,
    CHECKSUM_AGG(empid) AS CS
  FROM #CustsEmps
  GROUP BY custid
),
AggJoin AS
(
  SELECT A1.custid AS cust1, A2.custid AS cust2, A1.CN
  FROM Agg AS A1
    JOIN Agg AS A2
      ON  A2.custid <= A1.custid
      AND A2.MN = A1.MN
      AND A2.MX = A1.MX
      AND A2.CN = A1.CN
      AND A2.SM = A1.SM
      AND A2.CS = A1.CS
),
CustGrp AS
(
  SELECT cust1, MIN(cust2) AS grp
  FROM AggJoin AS AJ
  WHERE CN = (SELECT COUNT(*)
              FROM #CustsEmps AS C1
                JOIN #CustsEmps AS C2
                  ON C1.custid = AJ.cust1
                  AND C2.custid = AJ.cust2
                  AND C2.empid = C1.empid)
  GROUP BY cust1
)
SELECT custid, grp
FROM Sales.Customers AS C
  LEFT OUTER JOIN CustGrp AS G
    ON C.custid = G.cust1
ORDER BY grp, custid;
GO

DROP TABLE #CustsEmps;
GO

-- Solution Based on Concatenation with XML PATH; no Temp Table, 6 seconds
WITH CustGroups AS
(
  SELECT custid,
    (SELECT CAST(empid AS VARCHAR(10)) + ';' AS [text()]
     FROM (SELECT DISTINCT empid
           FROM Sales.Orders AS O
           WHERE O.custid = C.custid) AS D
     ORDER BY empid
     FOR XML PATH('')) AS CustEmps
  FROM Sales.Customers AS C
)
SELECT custid,
  CASE WHEN CustEmps IS NULL THEN NULL
    ELSE MIN(custid) OVER(PARTITION BY CustEmps) END AS grp
FROM CustGroups
ORDER BY grp, custid;
GO
