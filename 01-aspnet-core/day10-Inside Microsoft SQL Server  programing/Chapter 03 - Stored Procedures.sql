---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 03: Stored Procedures
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Types of Stored Procedures
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Local Stored Procedures
---------------------------------------------------------------------

-- Creation Script for GetSortedShippers
USE InsideTSQL2008;

IF OBJECT_ID('dbo.GetSortedShippers', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers;
GO
-- Stored procedure GetSortedShippers
-- Returns shippers sorted by requested sort column
CREATE PROC dbo.GetSortedShippers
  @colname AS sysname = NULL
AS

DECLARE @msg AS NVARCHAR(500);

-- Input validation
IF @colname IS NULL
BEGIN
  SET @msg = N'A value must be supplied for parameter @colname.';
  RAISERROR(@msg, 16, 1);
  RETURN;
END

IF @colname NOT IN(N'shipperid', N'companyname', N'phone')
BEGIN
  SET @msg =
    N'Valid values for @colname are: '
    + N'N''shipperid'', N''companyname'', N''phone''.';
  RAISERROR(@msg, 16, 1);
  RETURN;
END

-- Return shippers sorted by requested sort column
IF @colname = N'shipperid'
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY shipperid;
ELSE IF @colname = N'companyname'
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY companyname;
ELSE IF @colname = N'phone'
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY phone;
GO

EXEC dbo.GetSortedShippers @colname = N'companyname';
GO

DENY SELECT ON Sales.Shippers TO user1;
GRANT EXECUTE ON dbo.GetSortedShippers TO user1;

-- user1
SELECT shipperid, companyname, phone
FROM Sales.Shippers;

-- Cleanup
IF OBJECT_ID('dbo.GetSortedShippers', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers;
GO

---------------------------------------------------------------------
-- Special Stored Procedures
---------------------------------------------------------------------

-- Creating sp_Proc1
USE master;
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;
GO

CREATE PROC dbo.sp_Proc1
AS
PRINT 'master.dbo.sp_Proc1 executing in ' + DB_NAME();

-- Dynamic query
EXEC('SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = N''BASE TABLE'';');

-- Static query
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

-- Test sp_Proc1
USE InsideTSQL2008;
EXEC dbo.sp_Proc1;
GO

-- Other Special Objects
USE master;
IF OBJECT_ID('dbo.sp_Globals', 'U') IS NOT NULL
  DROP TABLE dbo.sp_Globals;

CREATE TABLE dbo.sp_Globals
(
  var_name sysname     NOT NULL PRIMARY KEY,
  val      SQL_VARIANT NULL
);
GO

-- Query sp_Globals Table
USE InsideTSQL2008;
INSERT INTO dbo.sp_Globals(var_name, val)
  VALUES('var1', 10);
  
USE AdventureWorks2008;
INSERT INTO dbo.sp_Globals(var_name, val)
  VALUES('var2', CAST(1 AS BIT));
  
USE tempdb;
SELECT var_name, val FROM dbo.sp_Globals;

-- Cleanup
USE master;
IF OBJECT_ID('dbo.sp_Globals', 'U') IS NOT NULL
  DROP TABLE dbo.sp_Globals;

---------------------------------------------------------------------
-- System Stored Procedures
---------------------------------------------------------------------

-- Marking sp_Proc1 as system object
USE master;
EXEC sp_MS_marksystemobject 'dbo.sp_Proc1';

-- Test sp_Proc1
USE InsideTSQL2008;
EXEC dbo.sp_Proc1;

USE AdventureWorks2008;
EXEC dbo.sp_Proc1;

EXEC InsideTSQL2008.dbo.sp_Proc1;
GO

-- If local version exists, local will be invoked
USE InsideTSQL2008;
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;
GO

CREATE PROC dbo.sp_Proc1
AS
PRINT 'InsideTSQL2008.dbo.sp_Proc1 executing in ' + DB_NAME();
GO

USE InsideTSQL2008;
EXEC dbo.sp_Proc1;

USE AdventureWorks2008;
EXEC dbo.sp_Proc1;
GO

-- Drop the InsideTSQL2008 version
USE InsideTSQL2008;
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;
GO

-- User objects also resolved locally if proc is marked as system object
USE master;
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;
GO

CREATE PROC dbo.sp_Proc1
AS
PRINT 'master.dbo.sp_Proc1 executing in ' + DB_NAME();
SELECT orderid FROM Sales.Orders;
GO

EXEC sp_MS_marksystemobject 'dbo.sp_Proc1';

-- Test sp_Proc1
USE InsideTSQL2008;
EXEC dbo.sp_Proc1;

USE AdventureWorks2008;
EXEC dbo.sp_Proc1;

-- Cleanup
USE master;
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;

USE InsideTSQL2008
IF OBJECT_ID('dbo.sp_Proc1', 'P') IS NOT NULL DROP PROC dbo.sp_Proc1;

---------------------------------------------------------------------
-- Other Types of Stored Procedures
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Stored Procedure's Interface
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Input Parameters
---------------------------------------------------------------------

-- Creating GetCustOrders Procedure
USE InsideTSQL2008;
IF OBJECT_ID('dbo.GetCustOrders', 'P') IS NOT NULL
  DROP PROC dbo.GetCustOrders;
GO

CREATE PROC dbo.GetCustOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231'
AS

SET NOCOUNT ON;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;
GO

-- Unnamed Arguments
EXEC dbo.GetCustOrders 1;

EXEC dbo.GetCustOrders 1, DEFAULT, '20100212';

EXEC dbo.GetCustOrders 1, '20070101', '20080101';

-- Named Arguments
EXEC dbo.GetCustOrders
  @custid   = 1,
  @fromdate = '20070101',
  @todate   = '20080101';

---------------------------------------------------------------------
-- Table-Valued Parameters
---------------------------------------------------------------------

-- Create user defined table types
USE InsideTSQL2008;

IF TYPE_ID('dbo.OrderIDs') IS NOT NULL DROP TYPE dbo.OrderIDs;

CREATE TYPE dbo.OrderIDs AS TABLE 
( 
  pos INT NOT NULL PRIMARY KEY,
  orderid INT NOT NULL UNIQUE
);
GO

-- Use table type with table variable
DECLARE @T AS dbo.OrderIDs;

INSERT INTO @T(pos, orderid)
  VALUES(1, 10248),(2, 10250),(3, 10249);

SELECT * FROM @T;
GO

-- Table-valued parameters
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders(@T AS dbo.OrderIDs READONLY)
AS

SELECT O.orderid, O.orderdate, O.custid, O.empid
FROM Sales.Orders AS O
  JOIN @T AS K
    ON O.orderid = K.orderid
ORDER BY K.pos;
GO

-- Execute procedure
DECLARE @Myorderids AS dbo.OrderIDs;

INSERT INTO @Myorderids(pos, orderid)
  VALUES(1, 10248),(2, 10250),(3, 10249);

EXEC dbo.GetOrders @T = @Myorderids;
GO

-- Executing without input uses an empty table by default
EXEC dbo.GetOrders;
GO

-- Cleanup
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
IF TYPE_ID('dbo.OrderIDs') IS NOT NULL DROP TYPE dbo.OrderIDs;

---------------------------------------------------------------------
-- Output Parameters
---------------------------------------------------------------------

-- Altering GetCustOrders Procedure
USE InsideTSQL2008;
GO

ALTER PROC dbo.GetCustOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT
AS

SET NOCOUNT ON;

DECLARE @err AS INT;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;

SELECT @numrows = @@rowcount, @err = @@error;

RETURN @err;
GO

-- Invoke GetCustOrders procedure
DECLARE @myerr AS INT, @mynumrows AS INT;

EXEC @myerr = dbo.GetCustOrders
  @custid   = 1,
  @fromdate = '20070101',
  @todate   = '20080101',
  @numrows  = @mynumrows OUTPUT;

SELECT @myerr AS err, @mynumrows AS rc;
GO

-- Send Output of GetCustOrders to a Table
IF OBJECT_ID('tempdb..#CustOrders', 'U') IS NOT NULL
  DROP TABLE #CustOrders;

CREATE TABLE #CustOrders
(
  orderid    INT      NOT NULL PRIMARY KEY,
  custid INT NOT NULL,
  empid INT      NOT NULL,
  orderdate  DATETIME NOT NULL
);
GO

DECLARE @myerr AS INT, @mynumrows AS INT;

INSERT INTO #CustOrders(orderid, custid, empid, orderdate)
  EXEC @myerr = dbo.GetCustOrders
    @custid   = 1,
    @fromdate = '20070101',
    @todate   = '20080101',
    @numrows  = @mynumrows OUTPUT;

SELECT orderid, custid, empid, orderdate
FROM #CustOrders;

SELECT @myerr AS err, @mynumrows AS rc;
GO

-- Cleanup
IF OBJECT_ID('dbo.GetCustOrders', 'P') IS NOT NULL
  DROP PROC dbo.GetCustOrders;
IF OBJECT_ID('tempdb..#CustOrders', 'U') IS NOT NULL
  DROP TABLE #CustOrders;

---------------------------------------------------------------------
-- Resolution
---------------------------------------------------------------------

-- Cleanup
USE tempdb;
IF OBJECT_ID('dbo.Proc1', 'P') IS NOT NULL DROP PROC dbo.Proc1;
IF OBJECT_ID('dbo.Proc2', 'P') IS NOT NULL DROP PROC dbo.Proc2;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

-- Create Proc1
CREATE PROC dbo.Proc1
AS

SELECT col1 FROM dbo.T1;
GO

-- Fails
EXEC dbo.Proc1;

-- Create T1
CREATE TABLE dbo.T1(col1 INT);
INSERT INTO dbo.T1(col1) VALUES(1);

-- Succeeds
EXEC dbo.Proc1;

-- Fails
CREATE PROC dbo.Proc2
AS

SELECT col2 FROM dbo.T1;
GO

-- Cleanup
USE tempdb;
IF OBJECT_ID('dbo.Proc1', 'P') IS NOT NULL DROP PROC dbo.Proc1;
IF OBJECT_ID('dbo.Proc2', 'P') IS NOT NULL DROP PROC dbo.Proc2;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

---------------------------------------------------------------------
-- Reliable Dependency Information
---------------------------------------------------------------------

-- Create objects
USE tempdb;

IF OBJECT_ID('dbo.Proc1', 'P') IS NOT NULL DROP PROC dbo.Proc1;
IF OBJECT_ID('dbo.Proc2', 'P') IS NOT NULL DROP PROC dbo.Proc2;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.V2', 'V') IS NOT NULL DROP VIEW dbo.V2;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2;
GO

CREATE PROC dbo.Proc1
AS
SELECT * FROM dbo.T1;
EXEC('SELECT * FROM dbo.T2');
GO
CREATE PROC dbo.Proc2
AS
SELECT * FROM dbo.T3;
GO
CREATE TABLE dbo.T1(col1 INT);
CREATE TABLE dbo.T2(col2 INT);
GO
CREATE VIEW dbo.V1
AS
SELECT col1 FROM dbo.T1;
GO
CREATE VIEW dbo.V2
AS
SELECT col1 FROM dbo.T1;
GO

-- Query sys.sql_expression_dependencies
SELECT
  OBJECT_SCHEMA_NAME(referencing_id) AS srcobjschema,
  OBJECT_NAME(referencing_id) AS srcobjname,
  referencing_minor_id AS srcminorid,
  referenced_schema_name AS tgtschema,
  referenced_id AS tgtobjid,
  referenced_entity_name AS tgtobjname,
  referenced_minor_id AS tgtminorid
FROM sys.sql_expression_dependencies;

-- Query sys.dm_sql_referenced_entities
SELECT
  referenced_schema_name AS objschema,
  referenced_entity_name AS objname,
  referenced_minor_name  AS minorname,
  referenced_class_desc  AS class
FROM sys.dm_sql_referenced_entities('dbo.Proc1', 'OBJECT');

-- sys.dm_sql_referencing_entities
SELECT
  referencing_schema_name AS objschema,
  referencing_entity_name AS objname,
  referencing_class_desc  AS class
FROM sys.dm_sql_referencing_entities('dbo.T1', 'OBJECT');

-- Cleanup
IF OBJECT_ID('dbo.Proc1', 'P') IS NOT NULL DROP PROC dbo.Proc1;
IF OBJECT_ID('dbo.V1', 'V') IS NOT NULL DROP VIEW dbo.V1;
IF OBJECT_ID('dbo.V2', 'V') IS NOT NULL DROP VIEW dbo.V2;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2;

---------------------------------------------------------------------
-- Compilations, Recompilations and Reuse of Execution Plans
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Reuse of Execution Plans
---------------------------------------------------------------------

-- Creating GetOrders Procedure
USE InsideTSQL2008;
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate /* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

SET STATISTICS IO ON;

-- Run first with high selectivity
EXEC dbo.GetOrders '20080506';

-- Next run with low selectivity
EXEC dbo.GetOrders '20060101';

-- Notice usecounts 2 in syscacheobjects
SELECT cacheobjtype, objtype, usecounts, sql
FROM sys.syscacheobjects
WHERE sql NOT LIKE '%sys%'
  AND sql LIKE '%33145F87-1109-4959-91D6-F1EC81F8428F%';
GO

-- CREATE WITH RECOMPILE
ALTER PROC dbo.GetOrders
  @odate AS DATETIME
WITH RECOMPILE
AS

SELECT orderid, custid, empid, orderdate /* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

-- Run first with high selectivity
EXEC dbo.GetOrders '20080506';

-- Next run with low selectivity
EXEC dbo.GetOrders '20060101';

-- Notice no plans in syscacheobjects
SELECT cacheobjtype, objtype, usecounts, sql
FROM sys.syscacheobjects
WHERE sql NOT LIKE '%sys%'
  AND sql LIKE '%33145F87-1109-4959-91D6-F1EC81F8428F%';
GO

-- RECOMPILE Query Hint
ALTER PROC dbo.GetOrders
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate /* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate
OPTION(RECOMPILE);
GO

-- Run first with high selectivity
EXEC dbo.GetOrders '20080506';

-- Next run with low selectivity
EXEC dbo.GetOrders '20060101';

-- Don't get confused by the fact that syscacheobjects
-- shows a plan with usecounts increasing
SELECT cacheobjtype, objtype, usecounts, sql
FROM sys.syscacheobjects
WHERE sql NOT LIKE '%sys%'
  AND sql LIKE '%33145F87-1109-4959-91D6-F1EC81F8428F%';

SET STATISTICS IO OFF;

---------------------------------------------------------------------
-- Recompilations
---------------------------------------------------------------------

-- Creating CustCities Procedure
IF OBJECT_ID('dbo.CustCities', 'P') IS NOT NULL
  DROP PROC dbo.CustCities;
GO

CREATE PROC dbo.CustCities
AS

SELECT custid, country, region, city, /* 97216686-F90E-4D5A-9A9E-CFD9E548AE81 */
  country + '.' + region + '.' + city AS CRC
FROM Sales.Customers
ORDER BY country, region, city;
GO

-- Run first time
EXEC dbo.CustCities;

-- Change SET option, and run second time
SET CONCAT_NULL_YIELDS_NULL OFF;

EXEC dbo.CustCities;

-- Notice two plans in syscacheobjects, and different setopts values
SELECT cacheobjtype, objtype, usecounts, setopts, sql
FROM sys.syscacheobjects
WHERE sql NOT LIKE '%sys%'
  AND sql LIKE '%97216686-F90E-4D5A-9A9E-CFD9E548AE81%';

-- Set session option back ON
SET CONCAT_NULL_YIELDS_NULL ON;
GO

-- Original procedure
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate /* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

-- Run proc first time when set option is ON
EXEC dbo.GetOrders '20080506';

-- Set session option OFF
SET CONCAT_NULL_YIELDS_NULL OFF;

-- Run proc second time when set option is OFF
EXEC dbo.GetOrders '20080506';

-- Inspect cached plans and observe that there are two plans
SELECT cacheobjtype, objtype, usecounts, setopts, sql
FROM sys.syscacheobjects
WHERE sql NOT LIKE '%sys%'
  AND sql LIKE '%33145F87-1109-4959-91D6-F1EC81F8428F%';

-- Set session option back ON
SET CONCAT_NULL_YIELDS_NULL ON;

---------------------------------------------------------------------
-- Variable Sniffing
---------------------------------------------------------------------

-- First load an order from today
INSERT INTO Sales.Orders
  (custid, empid, orderdate, requireddate, shippeddate, shipperid, freight,
   shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry)
 VALUES
  (1, 1, CURRENT_TIMESTAMP, '20100212 00:00:00.000', NULL, 1, 1,
   N'a', N'a', N'a', N'a', N'a', N'a');
GO

IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @d AS INT = 0
AS

DECLARE @odate AS DATETIME;
SET @odate = DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

-- Run GetOrders and notice Table Scan (23 logical reads)
EXEC dbo.GetOrders;
GO

-- Use inline expressions
ALTER PROC dbo.GetOrders
  @d AS INT = 0
AS

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));
GO

-- Run GetOrders and notice use of the index Figure 7-1 (4 logical reads)
EXEC dbo.GetOrders;
GO

-- Using a Stub Procedure
IF OBJECT_ID('dbo.GetOrdersQuery', 'P') IS NOT NULL
  DROP PROC dbo.GetOrdersQuery;
GO

CREATE PROC dbo.GetOrdersQuery
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

ALTER PROC dbo.GetOrders
  @d AS INT = 0
AS

DECLARE @odate AS DATETIME;
SET @odate = DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));

EXEC dbo.GetOrdersQuery @odate;
GO

EXEC dbo.GetOrders;
GO

-- Use the OPTIMIZE FOR Hint
ALTER PROC dbo.GetOrders
  @d AS INT = 0
AS

DECLARE @odate AS DATETIME;
SET @odate = DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate
OPTION(OPTIMIZE FOR(@odate = '99991231'));
GO

-- Test proc
EXEC dbo.GetOrders;
GO

-- Using the RECOMPILE query hint
ALTER PROC dbo.GetOrders
  @d AS INT = 0
AS

DECLARE @odate AS DATETIME;
SET @odate = DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate
OPTION(RECOMPILE);
GO

-- Test proc
EXEC dbo.GetOrders @d = 1;
EXEC dbo.GetOrders @d = 365;
GO

-- OPTIMIZE FOR UNKNOWN
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate
OPTION(OPTIMIZE FOR (@odate UNKNOWN));
GO

EXEC dbo.GetOrders @odate = '20080506';

---------------------------------------------------------------------
-- Plan Guides
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Object Plan Guides
---------------------------------------------------------------------
IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @d AS INT = 0
AS

DECLARE @odate AS DATETIME;
SET @odate = DATEADD(day, -@d, CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112));

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

EXEC dbo.GetOrders;
GO

-- Create a plan guide
EXEC sp_create_plan_guide
  @name = N'PG_GetOrders_Selective',
  @stmt = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= @odate;',
  @type = N'OBJECT',
  @module_or_batch = N'dbo.GetOrders',
  @hints = N'OPTION (OPTIMIZE FOR (@odate = ''99991231''))';
GO

EXEC dbo.GetOrders;
GO

-- Ensure that plan guide was used
SET SHOWPLAN_XML ON;
GO
EXEC dbo.GetOrders;
GO
SET SHOWPLAN_XML OFF;
GO

-- PlanGuideDB="InsideTSQL2008" PlanGuideName="PG_GetOrders_Selective"

-- Query plan guides
SELECT * FROM sys.plan_guides;

EXEC sp_control_plan_guide N'DROP', N'PG_GetOrders_Selective';
GO

---------------------------------------------------------------------
-- SQL Plan Guides
---------------------------------------------------------------------

SELECT empid, COUNT(*) AS cnt
FROM Sales.Orders
GROUP BY empid;

-- Create guide
EXEC sp_create_plan_guide 
  @name = N'PG_MyQuery1_MAXDOP1', 
  @stmt = N'SELECT empid, COUNT(*) AS cnt
FROM Sales.Orders
GROUP BY empid;
',
  @type = N'SQL',
  @module_or_batch = NULL, 
  @hints = N'OPTION (MAXDOP 1)';

-- Ensure that plan guide was used
SET SHOWPLAN_XML ON;
GO
SELECT empid, COUNT(*) AS cnt
FROM Sales.Orders
GROUP BY empid;
GO
SET SHOWPLAN_XML OFF;
GO

-- Query info about plan guide
SELECT * 
FROM sys.plan_guides
WHERE name = 'PG_MyQuery1_MAXDOP1';

-- Drop plan guide
EXEC sp_control_plan_guide N'DROP', N'PG_MyQuery1_MAXDOP1';
GO

---------------------------------------------------------------------
-- Template Plan Guides
---------------------------------------------------------------------

DECLARE @stmt AS NVARCHAR(MAX);
DECLARE @params AS NVARCHAR(MAX);

EXEC sp_get_query_template 
  @querytext = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= ''99991231'';',
  @templatetext  = @stmt OUTPUT, 
  @parameters  = @params OUTPUT;

SELECT @stmt AS stmt, @params AS params;
GO

-- Create template plan guide to use forced parameterization
DECLARE @stmt AS NVARCHAR(MAX);
DECLARE @params AS NVARCHAR(MAX);

EXEC sp_get_query_template 
  @querytext = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= ''99991231'';',
  @templatetext  = @stmt OUTPUT, 
  @parameters  = @params OUTPUT;

EXEC sp_create_plan_guide 
  @name = N'PG_MyQuery2_ParameterizationForced', 
  @stmt = @stmt, 
  @type = N'TEMPLATE', 
  @module_or_batch = NULL, 
  @params = @params, 
  @hints = N'OPTION(PARAMETERIZATION FORCED)';

-- Create a SQL plan guide on the query template
EXEC sp_create_plan_guide
  @name = N'PG_MyQuery2_Selective', 
  @stmt = @stmt, 
  @type = N'SQL', 
  @module_or_batch = NULL, 
  @params = @params, 
  @hints = N'OPTION(OPTIMIZE FOR (@0 = ''99991231''))';
GO

-- Ensure that plan guide was used
SET SHOWPLAN_XML ON;
GO
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20060101';
GO
SET SHOWPLAN_XML OFF;
GO

--  TemplatePlanGuideDB="InsideTSQL2008" TemplatePlanGuideName="PG_MyQuery2_ParameterizationForced" PlanGuideDB="InsideTSQL2008" PlanGuideName="PG_MyQuery2_Selective"

-- Query plan guides
SELECT * 
FROM sys.plan_guides
WHERE name IN('PG_MyQuery2_ParameterizationForced',
              'PG_MyQuery2_Selective');

-- Drop plan guides
EXEC sp_control_plan_guide N'DROP', N'PG_MyQuery2_ParameterizationForced';
EXEC sp_control_plan_guide N'DROP', N'PG_MyQuery2_Selective';

---------------------------------------------------------------------
-- Using A Fixed XML Plan
---------------------------------------------------------------------

IF OBJECT_ID('dbo.GetOrders', 'P') IS NOT NULL DROP PROC dbo.GetOrders;
GO

CREATE PROC dbo.GetOrders
  @odate AS DATETIME
AS

SELECT orderid, custid, empid, orderdate
/* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;
GO

EXEC dbo.GetOrders '99991231';
GO
DECLARE @query_plan AS NVARCHAR(MAX);
SET @query_plan = CAST(
  (SELECT query_plan
   FROM sys.dm_exec_query_stats AS QS
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) AS ST
     CROSS APPLY sys.dm_exec_query_plan(QS.plan_handle) AS QP
   WHERE 
     SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
       ((CASE statement_end_offset 
          WHEN -1 THEN DATALENGTH(ST.text)
          ELSE QS.statement_end_offset END 
              - QS.statement_start_offset)/2) + 1
            ) LIKE N'%SELECT orderid, custid, empid, orderdate
/* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;%'
     AND ST.text NOT LIKE '%sys%') AS NVARCHAR(MAX));

EXEC sp_create_plan_guide
  @name = N'PG_GetOrders_Selective',
  @stmt = N'SELECT orderid, custid, empid, orderdate
/* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;',
  @type = N'OBJECT',
  @module_or_batch = N'dbo.GetOrders',
  @hints = @query_plan;
GO

-- Check whether plan guide was used
SET SHOWPLAN_XML ON;
GO
EXEC dbo.GetOrders '20080506';
GO
SET SHOWPLAN_XML OFF;

-- Query plan guides
SELECT *
FROM sys.plan_guides
WHERE name = 'PG_GetOrders_Selective';

-- Validate plan guide
BEGIN TRAN
  DROP INDEX Sales.Orders.idx_nc_orderdate;

  SELECT plan_guide_id, msgnum, severity, state, message
  FROM sys.plan_guides
    CROSS APPLY fn_validate_plan_guide(plan_guide_id)
  WHERE name = 'PG_GetOrders_Selective';
ROLLBACK TRAN

-- Remove plan guide
EXEC sp_control_plan_guide N'DROP', N'PG_GetOrders_Selective';
GO

---------------------------------------------------------------------
-- Plan Freezing
---------------------------------------------------------------------

EXEC dbo.GetOrders '99991231';
GO
DECLARE @plan_handle AS VARBINARY(64), @offset AS INT, @rc AS INT;

SELECT @plan_handle = plan_handle, @offset = statement_start_offset
FROM sys.dm_exec_query_stats AS QS
  CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) AS ST
  CROSS APPLY sys.dm_exec_query_plan(QS.plan_handle) AS QP
WHERE 
  SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
    ((CASE statement_end_offset 
       WHEN -1 THEN DATALENGTH(ST.text)
       ELSE QS.statement_end_offset END 
           - QS.statement_start_offset)/2) + 1
         ) LIKE N'%SELECT orderid, custid, empid, orderdate
/* 33145F87-1109-4959-91D6-F1EC81F8428F */
FROM Sales.Orders
WHERE orderdate >= @odate;%'
  AND ST.text NOT LIKE '%sys%';

SET @rc = @@ROWCOUNT;

IF @rc = 1
  EXEC sp_create_plan_guide_from_handle 
      @name =  N'PG_GetOrders_Selective',
      @plan_handle = @plan_handle,
      @statement_start_offset = @offset;
ELSE
  RAISERROR(
    'Number of matching plans should be 1 but is %d. Plan guide not created.',
    16, 1, @rc);
GO

-- Check whether plan guide was used
SET SHOWPLAN_XML ON;
GO
EXEC dbo.GetOrders '20080506';
GO
SET SHOWPLAN_XML OFF;

-- Query plan guides
SELECT *
FROM sys.plan_guides
WHERE name = 'PG_GetOrders_Selective';

-- Remove plan guide
EXEC sp_control_plan_guide N'DROP', N'PG_GetOrders_Selective';

-- Cleanup
DELETE FROM Sales.Orders WHERE orderid > 11077;
DBCC CHECKIDENT('Sales.Orders', RESEED, 11077);

IF OBJECT_ID('dbo.GetOrders') IS NOT NULL
  DROP PROC dbo.GetOrders;
IF OBJECT_ID('dbo.CustCities') IS NOT NULL
  DROP PROC dbo.CustCities;
IF OBJECT_ID('dbo.GetOrdersQuery') IS NOT NULL
  DROP PROC dbo.GetOrdersQuery;
GO

---------------------------------------------------------------------
-- EXECUTE AS
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Parameterizing Sort Order
---------------------------------------------------------------------

-- Parameterizing Sort Order, Solution 1
USE InsideTSQL2008;
IF OBJECT_ID('dbo.GetSortedShippers', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers;
GO

CREATE PROC dbo.GetSortedShippers
  @colname AS sysname, @sortdir AS CHAR(1) = 'A'
AS

IF @sortdir = 'A'
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY
    CASE @colname
      WHEN N'shipperid'   THEN shipperid
      WHEN N'companyname' THEN companyname
      WHEN N'phone'       THEN phone
      ELSE CAST(NULL AS SQL_VARIANT)
    END
ELSE
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY
    CASE @colname
      WHEN N'shipperid'   THEN shipperid
      WHEN N'companyname' THEN companyname
      WHEN N'phone'       THEN phone
      ELSE CAST(NULL AS SQL_VARIANT)
    END DESC;
GO

-- Test solution 1
EXEC dbo.GetSortedShippers @colname = N'shipperid', @sortdir = N'D';
GO

-- Parameterizing Sort Order, Solution 2
ALTER PROC dbo.GetSortedShippers
  @colname AS sysname, @sortdir AS CHAR(1) = 'A'
AS

SELECT shipperid, companyname, phone
FROM Sales.Shippers
ORDER BY
  CASE WHEN @colname = N'shipperid'   AND @sortdir = 'A'
    THEN shipperid   END,
  CASE WHEN @colname = N'companyname' AND @sortdir = 'A'
    THEN companyname END,
  CASE WHEN @colname = N'phone'       AND @sortdir = 'A'
    THEN phone       END,
  CASE WHEN @colname = N'shipperid'   AND @sortdir = 'D'
    THEN shipperid   END DESC,
  CASE WHEN @colname = N'companyname' AND @sortdir = 'D'
    THEN companyname END DESC,
  CASE WHEN @colname = N'phone'       AND @sortdir = 'D'
    THEN phone       END DESC;
GO

-- Test solution 2
EXEC dbo.GetSortedShippers @colname = N'shipperid', @sortdir = N'D';
GO

-- Parameterizing Sort Order, Solution 3
ALTER PROC dbo.GetSortedShippers
  @colname AS sysname, @sortdir AS CHAR(1) = 'A'
AS

IF @colname NOT IN (N'shipperid', N'companyname', N'phone')
BEGIN
  RAISERROR('Possible SQL injection attempt.', 16, 1);
  RETURN;
END

DECLARE @sql AS NVARCHAR(500);

SET @sql = N'SELECT shipperid, companyname, phone
FROM Sales.Shippers
ORDER BY '
  + QUOTENAME(@colname)
  + CASE @sortdir WHEN 'D' THEN N' DESC' ELSE '' END
  + ';';

EXEC sp_executesql @sql;
GO

-- Test solution 3
EXEC dbo.GetSortedShippers @colname = N'shipperid', @sortdir = N'D';
GO

-- Parameterizing Sort Order, Solution 4
CREATE PROC dbo.GetSortedShippers_shipperid_A
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY shipperid;
GO
CREATE PROC dbo.GetSortedShippers_companyname_A
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY companyname;
GO
CREATE PROC dbo.GetSortedShippers_phone_A
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY phone;
GO
CREATE PROC dbo.GetSortedShippers_shipperid_D
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY shipperid   DESC;
GO
CREATE PROC dbo.GetSortedShippers_companyname_D
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY companyname DESC;
GO
CREATE PROC dbo.GetSortedShippers_phone_D
AS
  SELECT shipperid, companyname, phone
  FROM Sales.Shippers
  ORDER BY phone       DESC;
GO

ALTER PROC dbo.GetSortedShippers
  @colname AS sysname, @sortdir AS CHAR(1) = 'A'
AS

IF @colname = N'shipperid'        AND @sortdir = 'A'
  EXEC dbo.GetSortedShippers_shipperid_A;
ELSE IF @colname = N'companyname' AND @sortdir = 'A'
  EXEC dbo.GetSortedShippers_companyname_A;
ELSE IF @colname = N'phone'       AND @sortdir = 'A'
  EXEC dbo.GetSortedShippers_phone_A;
ELSE IF @colname = N'shipperid'   AND @sortdir = 'D'
  EXEC dbo.GetSortedShippers_shipperid_D;
ELSE IF @colname = N'companyname' AND @sortdir = 'D'
  EXEC dbo.GetSortedShippers_companyname_D;
ELSE IF @colname = N'phone'       AND @sortdir = 'D'
  EXEC dbo.GetSortedShippers_phone_D;
GO

-- Test
EXEC dbo.GetSortedShippers @colname = N'shipperid', @sortdir = N'D';
GO

-- Cleanup
IF OBJECT_ID('dbo.GetSortedShippers', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers;
IF OBJECT_ID('dbo.GetSortedShippers_shipperid_A', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_shipperid_A;
IF OBJECT_ID('dbo.GetSortedShippers_companyname_A', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_companyname_A;
IF OBJECT_ID('dbo.GetSortedShippers_phone_A', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_phone_A;
IF OBJECT_ID('dbo.GetSortedShippers_shipperid_D', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_shipperid_D;
IF OBJECT_ID('dbo.GetSortedShippers_companyname_D', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_companyname_D;
IF OBJECT_ID('dbo.GetSortedShippers_phone_D', 'P') IS NOT NULL
  DROP PROC dbo.GetSortedShippers_phone_D;
GO

---------------------------------------------------------------------
-- CLR Stored Procedures
---------------------------------------------------------------------

USE CLRUtilities;

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;

-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;

/*
-- Safer alternative:

-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master

CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll'

-- Create login and grant it with external access permission
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin
GO
*/

-- CLR GetEnvInfo Stored Procedure, C# Version
/*
    // GetEnvInfo Procedure
    // Returns environment info in tabular format
    [SqlProcedure]
    public static void GetEnvInfo()
    {
        // Create a record - object representation of a row
        // Include the metadata for the SQL table
        SqlDataRecord record = new SqlDataRecord(
            new SqlMetaData("EnvProperty", SqlDbType.NVarChar, 20),
            new SqlMetaData("Value", SqlDbType.NVarChar, 256));
        // Marks the beginning of the result set to be sent back to the client
        // The record parameter is used to construct the metadata
        // for the result set
        SqlContext.Pipe.SendResultsStart(record);
        // Populate some records and send them through the pipe
        record.SetSqlString(0, @"Machine Name");
        record.SetSqlString(1, Environment.MachineName);
        SqlContext.Pipe.SendResultsRow(record);
        record.SetSqlString(0, @"Processors");
        record.SetSqlString(1, Environment.ProcessorCount.ToString());
        SqlContext.Pipe.SendResultsRow(record);
        record.SetSqlString(0, @"OS Version");
        record.SetSqlString(1, Environment.OSVersion.ToString());
        SqlContext.Pipe.SendResultsRow(record);
        record.SetSqlString(0, @"CLR Version");
        record.SetSqlString(1, Environment.Version.ToString());
        SqlContext.Pipe.SendResultsRow(record);
        // End of result set
        SqlContext.Pipe.SendResultsEnd();
    }
*/

-- CLR GetEnvInfo Stored Procedure, Visual Basic Version
/*
    ' GetEnvInfo Procedure
    ' Returns environment info in tabular format
    <SqlProcedure()> _
    Public Shared Sub GetEnvInfo()
        ' Create a record - object representation of a row
        ' Include the metadata for the SQL table
        Dim record As New SqlDataRecord( _
            New SqlMetaData("EnvProperty", SqlDbType.NVarChar, 20), _
            New SqlMetaData("Value", SqlDbType.NVarChar, 256))
        ' Marks the beginning of the result set to be sent back to the client
        ' The record parameter is used to construct the metadata for
        ' the result set
        SqlContext.Pipe.SendResultsStart(record)
        '' Populate some records and send them through the pipe
        record.SetSqlString(0, "Machine Name")
        record.SetSqlString(1, Environment.MachineName)
        SqlContext.Pipe.SendResultsRow(record)
        record.SetSqlString(0, "Processors")
        record.SetSqlString(1, Environment.ProcessorCount.ToString())
        SqlContext.Pipe.SendResultsRow(record)
        record.SetSqlString(0, "OS Version")
        record.SetSqlString(1, Environment.OSVersion.ToString())
        SqlContext.Pipe.SendResultsRow(record)
        record.SetSqlString(0, "CLR Version")
        record.SetSqlString(1, Environment.Version.ToString())
        SqlContext.Pipe.SendResultsRow(record)
        ' End of result set
        SqlContext.Pipe.SendResultsEnd()
    End Sub
*/

-- Create GetEnvInfo Stored Procedure
-- C#
USE CLRUtilities;
IF OBJECT_ID('dbo.GetEnvInfo', 'PC') IS NOT NULL
  DROP PROC dbo.GetEnvInfo;
GO
CREATE PROCEDURE dbo.GetEnvInfo
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetEnvInfo;
GO

-- Visual Basic
CREATE PROCEDURE dbo.GetEnvInfo
AS EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].GetEnvInfo;
GO

-- Test dbo.GetEnvInfo procedure
EXEC dbo.GetEnvInfo;

-- CLR GetAssemblyInfo Stored Procedure, C# Version
/*
    // GetAssemblyInfo Procedure
    // Returns assembly info, uses Reflection
    [SqlProcedure]
    public static void GetAssemblyInfo(SqlString asmName)
    {
        // Retrieve the clr name of the assembly
        String clrName = null;
        // Get the context
        using (SqlConnection connection =
                 new SqlConnection("Context connection = true"))
        {
            connection.Open();
            using (SqlCommand command = new SqlCommand())
            {
                // Get the assembly and load it
                command.Connection = connection;
                command.CommandText =
                  "SELECT clr_name FROM sys.assemblies WHERE name = @asmName";
                command.Parameters.Add("@asmName", SqlDbType.NVarChar);
                command.Parameters[0].Value = asmName;
                clrName = (String)command.ExecuteScalar();
                if (clrName == null)
                {
                    throw new ArgumentException("Invalid assembly name!");
                }
                Assembly myAsm = Assembly.Load(clrName);
                // Create a record - object representation of a row
                // Include the metadata for the SQL table
                SqlDataRecord record = new SqlDataRecord(
                    new SqlMetaData("Type", SqlDbType.NVarChar, 50),
                    new SqlMetaData("Name", SqlDbType.NVarChar, 256));
                // Marks the beginning of the result set to be sent back
                // to the client
                // The record parameter is used to construct the metadata
                // for the result set
                SqlContext.Pipe.SendResultsStart(record);
                // Get all types in the assembly
                Type[] typesArr = myAsm.GetTypes();
                foreach (Type t in typesArr)
                {
                    // Type in a SQL database should be a class or
                    // a structure
                    if (t.IsClass == true)
                    {
                        record.SetSqlString(0, @"Class");
                    }
                    else
                    {
                        record.SetSqlString(0, @"Structure");
                    }
                    record.SetSqlString(1, t.FullName);
                    SqlContext.Pipe.SendResultsRow(record);
                    // Find all public static methods
                    MethodInfo[] miArr = t.GetMethods();
                    foreach (MethodInfo mi in miArr)
                    {
                        if (mi.IsPublic && mi.IsStatic)
                        {
                            record.SetSqlString(0, @"  Method");
                            record.SetSqlString(1, mi.Name);
                            SqlContext.Pipe.SendResultsRow(record);
                        }
                    }
                }
                // End of result set
                SqlContext.Pipe.SendResultsEnd();
            }
        }
    }
*/

-- CLR GetAssemblyInfo Stored Procedure, Visual Basic Version
/*
    ' GetAssemblyInfo Procedure
    ' Returns assembly info, uses Reflection
    <SqlProcedure()> _
    Public Shared Sub GetAssemblyInfo(ByVal asmName As SqlString)
        ' Retrieve the clr name of the assembly
        Dim clrName As String = Nothing
        ' Get the context
        Using connection As New SqlConnection("Context connection = true")
            connection.Open()
            Using command As New SqlCommand
                ' Get the assembly and load it
                command.Connection = connection
                command.CommandText = _
                  "SELECT clr_name FROM sys.assemblies WHERE name = @asmName"
                command.Parameters.Add("@asmName", SqlDbType.NVarChar)
                command.Parameters(0).Value = asmName
                clrName = CStr(command.ExecuteScalar())
                If (clrName = Nothing) Then
                    Throw New ArgumentException("Invalid assembly name!")
                End If
                Dim myAsm As Assembly = Assembly.Load(clrName)
                ' Create a record - object representation of a row
                ' Include the metadata for the SQL table
                Dim record As New SqlDataRecord( _
                    New SqlMetaData("Type", SqlDbType.NVarChar, 50), _
                    New SqlMetaData("Name", SqlDbType.NVarChar, 256))
                ' Marks the beginning of the result set to be sent back
                ' to the client
                ' The record parameter is used to construct the metadata
                ' for the result set
                SqlContext.Pipe.SendResultsStart(record)
                ' Get all types in the assembly
                Dim typesArr() As Type = myAsm.GetTypes()
                For Each t As Type In typesArr
                    ' Type in a SQL database should be a class or a structure
                    If (t.IsClass = True) Then
                        record.SetSqlString(0, "Class")
                    Else
                        record.SetSqlString(0, "Structure")
                    End If
                    record.SetSqlString(1, t.FullName)
                    SqlContext.Pipe.SendResultsRow(record)
                    ' Find all public static methods
                    Dim miArr() As MethodInfo = t.GetMethods
                    For Each mi As MethodInfo In miArr
                        If (mi.IsPublic And mi.IsStatic) Then
                            record.SetSqlString(0, "  Method")
                            record.SetSqlString(1, mi.Name)
                            SqlContext.Pipe.SendResultsRow(record)
                        End If
                    Next
                Next
                ' End of result set
                SqlContext.Pipe.SendResultsEnd()
            End Using
        End Using
    End Sub
*/

-- Create GetAssemblyInfo procedure
-- C#
IF OBJECT_ID('dbo.GetAssemblyInfo', 'PC') IS NOT NULL
  DROP PROC dbo.GetAssemblyInfo;
GO

CREATE PROCEDURE GetAssemblyInfo
  @asmName AS sysname
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetAssemblyInfo;
GO

-- Visual Basic
CREATE PROCEDURE GetAssemblyInfo
  @asmName AS sysname
AS EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].GetAssemblyInfo;
GO

-- Test GetAssemblyInfo procedure
EXEC GetAssemblyInfo N'CLRUtilities';

-- Cleanup
USE CLRUtilities;
IF OBJECT_ID('dbo.GetEnvInfo', 'PC') IS NOT NULL
  DROP PROC dbo.GetEnvInfo;
IF OBJECT_ID('dbo.GetAssemblyInfo', 'PC') IS NOT NULL
  DROP PROC dbo.GetAssemblyInfo;
GO
