---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 10 - Programmable Objects
-- © 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------

-- Declare a variable and initialize it with a value
DECLARE @i AS INT;
SET @i = 10;
GO

-- Declare and initialize a variable in the same statement
DECLARE @i AS INT = 10;
GO

-- Store the result of a subquery in a variable
USE TSQLFundamentals2008;

DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE empid = 3);

SELECT @empname AS empname;
GO

-- Using the SET command to assign one variable at a time
DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SET @firstname = (SELECT firstname
                  FROM HR.Employees
                  WHERE empid = 3);
SET @lastname = (SELECT lastname
                  FROM HR.Employees
                  WHERE empid = 3);

SELECT @firstname AS firstname, @lastname AS lastname;
GO

-- Using the SELECT command to assign multiple variables in the same statement
DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SELECT
  @firstname = firstname,
  @lastname  = lastname
FROM HR.Employees
WHERE empid = 3;

SELECT @firstname AS firstname, @lastname AS lastname;
GO

-- SELECT doesn't fail when multiple rows qualify
DECLARE @empname AS NVARCHAR(61);

SELECT @empname = firstname + N' ' + lastname
FROM HR.Employees
WHERE mgrid = 2;

SELECT @empname AS empname;
GO

-- SET fails when multiple rows qualify
DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE mgrid = 2);

SELECT @empname AS empname;
GO

---------------------------------------------------------------------
-- Batches
---------------------------------------------------------------------

-- A Batch as a Unit of Parsing

-- Valid batch
PRINT 'First batch';
USE TSQLFundamentals2008;
GO
-- Invalid batch
PRINT 'Second batch';
SELECT custid FROM Sales.Customers;
SELECT orderid FOM Sales.Orders;
GO
-- Valid batch
PRINT 'Third batch';
SELECT empid FROM HR.Employees;
GO

-- Batches and Variables

DECLARE @i AS INT;
SET @i = 10;
-- Succeeds
PRINT @i;
GO

-- Fails
PRINT @i;
GO

-- Statements That Cannot Be Combined in the same Batch

IF OBJECT_ID('Sales.MyView', 'V') IS NOT NULL DROP VIEW Sales.MyView;

CREATE VIEW Sales.MyView
AS

SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY YEAR(orderdate);
GO

-- A Batch as a Unit of Resolution

-- Create T1 with one column
USE tempdb;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT);
GO

-- Following fails
ALTER TABLE dbo.T1 ADD col2 INT;
SELECT col1, col2 FROM dbo.T1;
GO

-- Following succeeds
ALTER TABLE dbo.T1 ADD col2 INT;
GO
SELECT col1, col2 FROM dbo.T1;
GO

-- The GO n Option

-- Create T1 with identity column
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT IDENTITY);
GO

-- Suppress insert messages
SET NOCOUNT ON;
GO

-- Execute batch 100 times
INSERT INTO dbo.T1 DEFAULT VALUES;
GO 100

---------------------------------------------------------------------
-- Flow Elements
---------------------------------------------------------------------

-- The IF ... ELSE Flow Element
IF YEAR(CURRENT_TIMESTAMP) <> YEAR(DATEADD(day, 1, CURRENT_TIMESTAMP))
  PRINT 'Today is the last day of the year.'
ELSE
  PRINT 'Today is not the last day of the year.'
GO

-- IF ELSE IF
IF YEAR(CURRENT_TIMESTAMP) <> YEAR(DATEADD(day, 1, CURRENT_TIMESTAMP))
  PRINT 'Today is the last day of the year.'
ELSE
  IF MONTH(CURRENT_TIMESTAMP) <> MONTH(DATEADD(day, 1, CURRENT_TIMESTAMP))
    PRINT 'Today is the last day of the month but not the last day of the year.'
  ELSE 
    PRINT 'Today is not the last day of the month.';
GO

-- Statement Block
IF DAY(CURRENT_TIMESTAMP) = 1
BEGIN
  PRINT 'Today is the first day of the month.';
  PRINT 'Starting a full database backup.';
  BACKUP DATABASE TSQLFundamentals2008
    TO DISK = 'C:\Temp\TSQLFundamentals2008_Full.BAK' WITH INIT;
  PRINT 'Finished full database backup.';
END
ELSE
BEGIN
  PRINT 'Today is not the first day of the month.'
  PRINT 'Starting a differential database backup.';
  BACKUP DATABASE TSQLFundamentals2008
    TO DISK = 'C:\Temp\TSQLFundamentals2008_Diff.BAK' WITH INIT;
  PRINT 'Finished differential database backup.';
END
GO

-- The WHILE Flow Element
DECLARE @i AS INT;
SET @i = 1;
WHILE @i <= 10
BEGIN
  PRINT @i;
  SET @i = @i + 1;
END;
GO

-- BREAK
DECLARE @i AS INT;
SET @i = 1
WHILE @i <= 10
BEGIN
  IF @i = 6 BREAK;
  PRINT @i;
  SET @i = @i + 1;
END;
GO

-- CONTINUE
DECLARE @i AS INT;
SET @i = 0
WHILE @i < 10
BEGIN
  SET @i = @i + 1;
  IF @i = 6 CONTINUE;
  PRINT @i;
END;
GO

-- An Example of Using IF and WHILE
SET NOCOUNT ON;
USE tempdb;
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);
GO

DECLARE @i AS INT;
SET @i = 1;
WHILE @i <= 1000
BEGIN
  INSERT INTO dbo.Nums(n) VALUES(@i);
  SET @i = @i + 1;
END
GO

---------------------------------------------------------------------
-- Cursors
---------------------------------------------------------------------

-- Example: Running Aggregations
SET NOCOUNT ON;
USE TSQLFundamentals2008;

DECLARE @Result TABLE
(
  custid     INT,
  ordermonth DATETIME,
  qty        INT, 
  runqty     INT,
  PRIMARY KEY(custid, ordermonth)
);

DECLARE
  @custid     AS INT,
  @prvcustid  AS INT,
  @ordermonth DATETIME,
  @qty        AS INT,
  @runqty     AS INT;

DECLARE C CURSOR FAST_FORWARD /* read only, forward only */ FOR
  SELECT custid, ordermonth, qty
  FROM Sales.CustOrders
  ORDER BY custid, ordermonth;

OPEN C

FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;

SELECT @prvcustid = @custid, @runqty = 0;

WHILE @@FETCH_STATUS = 0
BEGIN
  IF @custid <> @prvcustid
    SELECT @prvcustid = @custid, @runqty = 0;

  SET @runqty = @runqty + @qty;

  INSERT INTO @Result VALUES(@custid, @ordermonth, @qty, @runqty);
  
  FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;
END

CLOSE C;

DEALLOCATE C;

SELECT 
  custid,
  CONVERT(VARCHAR(7), ordermonth, 121) AS ordermonth,
  qty,
  runqty
FROM @Result
ORDER BY custid, ordermonth;
GO

---------------------------------------------------------------------
-- Temporary Tables
---------------------------------------------------------------------

-- Local Temporary Tables

USE TSQLFundamentals2008;

IF OBJECT_ID('tempdb.dbo.#MyOrderTotalsByYear') IS NOT NULL
  DROP TABLE dbo.#MyOrderTotalsByYear;
GO

SELECT
  YEAR(O.orderdate) AS orderyear,
  SUM(OD.qty) AS qty
INTO dbo.#MyOrderTotalsByYear
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM dbo.#MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN dbo.#MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
GO

-- Try accessing the table from another session
SELECT orderyear, qty FROM dbo.#MyOrderTotalsByYear;

-- Global Temporary Tables
CREATE TABLE dbo.##Globals
(
  id  sysname     NOT NULL PRIMARY KEY,
  val SQL_VARIANT NOT NULL
);

-- Run from any session
INSERT INTO dbo.##Globals(id, val) VALUES(N'i', CAST(10 AS INT));

-- Run from any session
SELECT val FROM dbo.##Globals WHERE id = N'i';

-- Run from any session
DROP TABLE dbo.##Globals;
GO

-- Table Variables
DECLARE @MyOrderTotalsByYear TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM @MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN @MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
GO

-- Table Types
USE TSQLFundamentals2008;

IF TYPE_ID('dbo.OrderTotalsByYear') IS NOT NULL
  DROP TYPE dbo.OrderTotalsByYear;

CREATE TYPE dbo.OrderTotalsByYear AS TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);
GO

-- Use table type
DECLARE @MyOrderTotalsByYear AS dbo.OrderTotalsByYear;

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT orderyear, qty FROM @MyOrderTotalsByYear;
GO

---------------------------------------------------------------------
-- Dynamic SQL
---------------------------------------------------------------------

-- The EXEC Command

-- Simple example of EXEC
DECLARE @sql AS VARCHAR(100);
SET @sql = 'PRINT ''This message was printed by a dynamic SQL batch.'';';
EXEC(@sql);
GO

-- Using EXEC to returned space used of tables in database
USE TSQLFundamentals2008;

DECLARE
  @sql AS NVARCHAR(300),
  @schemaname AS sysname,
  @tablename  AS sysname;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT TABLE_SCHEMA, TABLE_NAME
  FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_TYPE = 'BASE TABLE';

OPEN C

FETCH NEXT FROM C INTO @schemaname, @tablename;

WHILE @@fetch_status = 0
BEGIN
  SET @sql =
    N'EXEC sp_spaceused N'''
    + QUOTENAME(@schemaname) + N'.'
    + QUOTENAME(@tablename) + N''';';

  EXEC(@sql);

  FETCH NEXT FROM C INTO @schemaname, @tablename;
END

CLOSE C;

DEALLOCATE C;
GO

-- The sp_executesql Stored Procedure

-- Simple example using sp_executesql
DECLARE @sql AS NVARCHAR(100);

SET @sql = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderid = @orderid;';

EXEC sp_executesql
  @stmt = @sql,
  @params = N'@orderid AS INT',
  @orderid = 10248;
GO

-- Using sp_executesql to returned count of rows of tables in database

DECLARE @Counts TABLE
(
  schemaname sysname NOT NULL,
  tablename sysname NOT NULL,
  numrows INT NOT NULL,
  PRIMARY KEY(schemaname, tablename)
);

DECLARE
  @sql AS NVARCHAR(350),
  @schemaname AS sysname,
  @tablename  AS sysname,
  @numrows    AS INT;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT TABLE_SCHEMA, TABLE_NAME
  FROM INFORMATION_SCHEMA.TABLES;

OPEN C

FETCH NEXT FROM C INTO @schemaname, @tablename;

WHILE @@fetch_status = 0
BEGIN
  SET @sql =
    N'SET @n = (SELECT COUNT(*) FROM '
    + QUOTENAME(@schemaname) + N'.'
    + QUOTENAME(@tablename) + N');';

  EXEC sp_executesql
    @stmt = @sql,
    @params = N'@n AS INT OUTPUT',
    @n = @numrows OUTPUT;

  INSERT INTO @Counts(schemaname, tablename, numrows)
    VALUES(@schemaname, @tablename, @numrows);

  FETCH NEXT FROM C INTO @schemaname, @tablename;
END

CLOSE C;

DEALLOCATE C;

SELECT schemaname, tablename, numrows
FROM @Counts;
GO

-- Using PIVOT with Dynamic SQL (Advanced, Optional)

-- Static PIVOT
SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
      FROM Sales.Orders) AS D
  PIVOT(SUM(freight) FOR orderyear IN([2006],[2007],[2008])) AS P;

-- Dynamic PIVOT
DECLARE
  @sql       AS NVARCHAR(1000),
  @orderyear AS INT,
  @first     AS INT;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT DISTINCT(YEAR(orderdate)) AS orderyear
  FROM Sales.Orders
  ORDER BY orderyear;

SET @first = 1;

SET @sql = N'SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
      FROM Sales.Orders) AS D
  PIVOT(SUM(freight) FOR orderyear IN(';

OPEN C

FETCH NEXT FROM C INTO @orderyear;

WHILE @@fetch_status = 0
BEGIN
  IF @first = 0
    SET @sql = @sql + N','
  ELSE
    SET @first = 0;

  SET @sql = @sql + QUOTENAME(@orderyear);

  FETCH NEXT FROM C INTO @orderyear;
END

CLOSE C;

DEALLOCATE C;

SET @sql = @sql + N')) AS P;';

EXEC sp_executesql @stmt = @sql;
GO

---------------------------------------------------------------------
-- Routines
---------------------------------------------------------------------

---------------------------------------------------------------------
-- User Defined Functions
---------------------------------------------------------------------

USE TSQLFundamentals2008;
IF OBJECT_ID('dbo.fn_age') IS NOT NULL DROP FUNCTION dbo.fn_age;
GO

CREATE FUNCTION dbo.fn_age
(
  @birthdate AS DATETIME,
  @eventdate AS DATETIME
)
RETURNS INT
AS
BEGIN
  RETURN
    DATEDIFF(year, @birthdate, @eventdate)
    - CASE WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
              < 100 * MONTH(@birthdate) + DAY(@birthdate)
           THEN 1 ELSE 0
      END
END
GO

-- Test function
SELECT
  empid, firstname, lastname, birthdate,
  dbo.fn_age(birthdate, CURRENT_TIMESTAMP) AS age
FROM HR.Employees;

---------------------------------------------------------------------
-- Stored Procedures
---------------------------------------------------------------------

-- Using a Stored Procedure
USE TSQLFundamentals2008;
IF OBJECT_ID('Sales.usp_GetCustomerOrders', 'P') IS NOT NULL
  DROP PROC Sales.usp_GetCustomerOrders;
GO

CREATE PROC Sales.usp_GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT
AS
SET NOCOUNT ON;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;

SET @numrows = @@rowcount;
GO

DECLARE @rc AS INT;

EXEC Sales.usp_GetCustomerOrders
  @custid   = 1, -- Also try with 100
  @fromdate = '20070101',
  @todate   = '20080101',
  @numrows  = @rc OUTPUT;

SELECT @rc AS numrows;
GO

---------------------------------------------------------------------
-- Triggers
---------------------------------------------------------------------

-- Example for a DML audit trigger
USE tempdb;

IF OBJECT_ID('dbo.T1_Audit', 'U') IS NOT NULL DROP TABLE dbo.T1_Audit;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);

CREATE TABLE dbo.T1_Audit
(
  audit_lsn  INT         NOT NULL IDENTITY PRIMARY KEY,
  dt         DATETIME    NOT NULL DEFAULT(CURRENT_TIMESTAMP),
  login_name sysname     NOT NULL DEFAULT(SUSER_SNAME()),
  keycol     INT         NOT NULL,
  datacol    VARCHAR(10) NOT NULL
);
GO

CREATE TRIGGER trg_T1_insert_audit ON dbo.T1 AFTER INSERT
AS
SET NOCOUNT ON;

INSERT INTO dbo.T1_Audit(keycol, datacol)
  SELECT keycol, datacol FROM inserted;
GO

INSERT INTO dbo.T1(keycol, datacol) VALUES(10, 'a');
INSERT INTO dbo.T1(keycol, datacol) VALUES(30, 'x');
INSERT INTO dbo.T1(keycol, datacol) VALUES(20, 'g');

SELECT audit_lsn, dt, login_name, keycol, datacol
FROM dbo.T1_Audit;
GO

-- Example for a DDL audit trigger
USE master;
IF DB_ID('testdb') IS NOT NULL DROP DATABASE testdb;
CREATE DATABASE testdb;
GO
USE testdb;
GO

-- Creation Script for AuditDDLEvents Table and trg_audit_ddl_events Trigger
IF OBJECT_ID('dbo.AuditDDLEvents', 'U') IS NOT NULL
  DROP TABLE dbo.AuditDDLEvents;

CREATE TABLE dbo.AuditDDLEvents
(
  audit_lsn        INT      NOT NULL IDENTITY,
  posttime         DATETIME NOT NULL,
  eventtype        sysname  NOT NULL,
  loginname        sysname  NOT NULL,
  schemaname       sysname  NOT NULL,
  objectname       sysname  NOT NULL,
  targetobjectname sysname  NULL,
  eventdata        XML      NOT NULL,
  CONSTRAINT PK_AuditDDLEvents PRIMARY KEY(audit_lsn)
);
GO

CREATE TRIGGER trg_audit_ddl_events
  ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
SET NOCOUNT ON;

DECLARE @eventdata AS XML;
SET @eventdata = eventdata();

INSERT INTO dbo.AuditDDLEvents(
  posttime, eventtype, loginname, schemaname, 
  objectname, targetobjectname, eventdata)
  VALUES(
    @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]',         'VARCHAR(23)'),
    @eventdata.value('(/EVENT_INSTANCE/EventType)[1]',        'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/LoginName)[1]',        'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]',       'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]',       'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
    @eventdata);
GO

-- Test trigger trg_audit_ddl_events
CREATE TABLE dbo.T1(col1 INT NOT NULL PRIMARY KEY);
ALTER TABLE dbo.T1 ADD col2 INT NULL;
ALTER TABLE dbo.T1 ALTER COLUMN col2 INT NOT NULL;
CREATE NONCLUSTERED INDEX idx1 ON dbo.T1(col2);
GO

SELECT * FROM dbo.AuditDDLEvents;
GO

-- Cleanup
USE master;
IF DB_ID('testdb') IS NOT NULL DROP DATABASE testdb;
GO

---------------------------------------------------------------------
-- Error Handling
---------------------------------------------------------------------

-- Simple example
BEGIN TRY
  PRINT 10/2;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH
GO

BEGIN TRY
  PRINT 10/0;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH
GO

-- Script to create Employees table in tempdb
USE tempdb;
IF OBJECT_ID('dbo.Employees') IS NOT NULL DROP TABLE dbo.Employees;
CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL,
  empname VARCHAR(25) NOT NULL,
  mgrid   INT         NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
  CONSTRAINT CHK_Employees_empid CHECK(empid > 0),
  CONSTRAINT FK_Employees_Employees
    FOREIGN KEY(mgrid) REFERENCES dbo.Employees(empid)
);
GO

-- Detailed Example
BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);
  -- Also try with empid = 0, 'A', NULL

END TRY
BEGIN CATCH

  IF ERROR_NUMBER() = 2627
  BEGIN
    PRINT 'Handling PK violation...';
  END
  ELSE IF ERROR_NUMBER() = 547
  BEGIN
    PRINT 'Handling CHECK/FK constraint violation...';
  END
  ELSE IF ERROR_NUMBER() = 515
  BEGIN
    PRINT 'Handling NULL violation...';
  END
  ELSE IF ERROR_NUMBER() = 245
  BEGIN
    PRINT 'Handling conversion error...';
  END
  ELSE
  BEGIN
    PRINT 'Handling unknown error...';
  END

  PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
  PRINT 'Error Message : ' + ERROR_MESSAGE();
  PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
  PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
  PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
  PRINT 'Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
 
END CATCH
GO

-- Encapsulating Reusable Code
IF OBJECT_ID('dbo.usp_err_messages', 'P') IS NOT NULL
  DROP PROC dbo.usp_err_messages;
GO

CREATE PROC dbo.usp_err_messages
AS
SET NOCOUNT ON;

IF ERROR_NUMBER() = 2627
BEGIN
  PRINT 'Handling PK violation...';
END
ELSE IF ERROR_NUMBER() = 547
BEGIN
  PRINT 'Handling CHECK/FK constraint violation...';
END
ELSE IF ERROR_NUMBER() = 515
BEGIN
  PRINT 'Handling NULL violation...';
END
ELSE IF ERROR_NUMBER() = 245
BEGIN
  PRINT 'Handling conversion error...';
END
ELSE
BEGIN
  PRINT 'Handling unknown error...';
END

PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'Error Message : ' + ERROR_MESSAGE();
PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
PRINT 'Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
GO

-- Calling Proc in CATCH Block
BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);

END TRY
BEGIN CATCH

  EXEC dbo.usp_err_messages;
  
END CATCH
