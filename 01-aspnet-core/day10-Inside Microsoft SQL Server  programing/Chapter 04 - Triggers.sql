---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 04: Triggers
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Triggers
---------------------------------------------------------------------

---------------------------------------------------------------------
-- AFTER Triggers
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The inserted and deleted Special Tables
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Identifying the Number of affected Rows
---------------------------------------------------------------------

-- Create table T1
SET NOCOUNT ON; 
USE tempdb; 
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 

CREATE TABLE dbo.T1 
( 
  keycol  INT         NOT NULL PRIMARY KEY, 
  datacol VARCHAR(10) NOT NULL 
);
GO

-- Creation Script for trg_T1_i Trigger
CREATE TRIGGER trg_T1_i ON T1 FOR INSERT
AS

DECLARE @rc AS INT = 
  (SELECT COUNT(*) FROM (SELECT TOP (2) * FROM inserted) AS D);

IF @rc = 0 RETURN;

DECLARE @keycol AS INT, @datacol AS VARCHAR(10);

IF @rc = 1 -- single row
BEGIN
  SELECT @keycol = keycol, @datacol = datacol FROM inserted;

  PRINT 'Handling keycol: '
    + CAST(@keycol AS VARCHAR(10))
    + ', datacol: ' + @datacol;
END
ELSE -- multi row
BEGIN
  
  DECLARE @C AS CURSOR;

  SET @C = CURSOR FAST_FORWARD FOR
    SELECT keycol, datacol FROM inserted;

  OPEN @C;
  
  FETCH NEXT FROM @C INTO @keycol, @datacol;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    PRINT 'Handling keycol: '
      + CAST(@keycol AS VARCHAR(10))
      + ', datacol: ' + @datacol;

    FETCH NEXT FROM @C INTO @keycol, @datacol;
  END

END
GO

-- Test trg_T1_i trigger

-- 0 Rows
INSERT INTO dbo.T1 SELECT 1, 'A' WHERE 1 = 0;
GO

-- 1 Row
INSERT INTO dbo.T1 SELECT 1, 'A';

-- Multi Rows
INSERT INTO dbo.T1 VALUES
  (2, 'B'), (3, 'C'), (4, 'D');
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Identifying the Type of Trigger
---------------------------------------------------------------------

-- Create table T1
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 

CREATE TABLE dbo.T1 
( 
  keycol  INT         NOT NULL PRIMARY KEY, 
  datacol VARCHAR(10) NOT NULL 
);
GO

-- Creation Script for trg_T1_iud Trigger
CREATE TRIGGER trg_T1_iud ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS

DECLARE @i AS INT = 
  (SELECT COUNT(*) FROM (SELECT TOP (1) * FROM inserted) AS I);
DECLARE @d AS INT = 
  (SELECT COUNT(*) FROM (SELECT TOP (1) * FROM deleted) AS D);

IF @i = 1 AND @d = 1
  PRINT 'UPDATE of at least one row identified';
ELSE IF @i = 1 AND @d = 0
  PRINT 'INSERT of at least one row identified';
ELSE IF @i = 0 AND @d = 1
  PRINT 'DELETE of at least one row identified';
ELSE
  PRINT 'No rows affected';
GO

-- Test trg_T1_iud trigger

-- 0 Rows
INSERT INTO T1 SELECT 1, 'A' WHERE 1 = 0;

-- INSERT
INSERT INTO T1 SELECT 1, 'A';

-- UPDATE
UPDATE T1 SET datacol = 'AA' WHERE keycol = 1;

-- DELETE
DELETE FROM T1 WHERE keycol = 1;
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Not firing Triggers for Specific Statements
---------------------------------------------------------------------

-- Create table T1
USE tempdb; 
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
CREATE TABLE dbo.T1(col1 INT);
GO

-- Create trg_T1_i trigger using temp table
CREATE TRIGGER trg_T1_i ON dbo.T1 FOR INSERT
AS

IF OBJECT_ID('tempdb..#do_not_fire_trg_T1_i') IS NOT NULL RETURN;

PRINT 'trg_T1_i in action...';
GO

-- Test trg_T1_i

-- No Signal
INSERT INTO dbo.T1 VALUES(1);
GO

-- Setting signal
CREATE TABLE #do_not_fire_trg_T1_i(col1 INT);
INSERT INTO T1 VALUES(2);
-- Clearing signal
DROP TABLE #do_not_fire_trg_T1_i;
GO

-- Using Session Context

-- Generate GUID (only once)
SELECT CAST(NEWID() AS BINARY(16));
GO

-- Stored procedure that sets the signal
IF OBJECT_ID('dbo.TrgSignal_Set', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Set;
GO
CREATE PROC dbo.TrgSignal_Set
  @guid AS BINARY(16),
  @pos  AS INT
AS

DECLARE @ci AS VARBINARY(128);
SET @ci = 
  ISNULL(SUBSTRING(CONTEXT_INFO(), 1, @pos-1),
         CAST(REPLICATE(0x00, @pos-1) AS VARBINARY(128)))
  + @guid +
  ISNULL(SUBSTRING(CONTEXT_INFO(), @pos+16, 128-16-@pos+1), 0x);
SET CONTEXT_INFO @ci;
GO

-- Stored procedure that clears the signal
IF OBJECT_ID('dbo.TrgSignal_Clear', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Clear;
GO
CREATE PROC dbo.TrgSignal_Clear
  @pos  AS INT
AS

DECLARE @ci AS VARBINARY(128);
SET @ci = 
  ISNULL(SUBSTRING(CONTEXT_INFO(), 1, @pos-1),
         CAST(REPLICATE(0x00, @pos-1) AS VARBINARY(128)))
  + CAST(REPLICATE(0x00, 16) AS VARBINARY(128)) +
  ISNULL(SUBSTRING(CONTEXT_INFO(), @pos+16, 128-16-@pos+1), 0x);
SET CONTEXT_INFO @ci;
GO

-- Stored procedure that looks for the signal
IF OBJECT_ID('dbo.TrgSignal_Get', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Get;
GO
CREATE PROC dbo.TrgSignal_Get
  @guid AS BINARY(16) OUTPUT,
  @pos  AS INT
AS

SET @guid = SUBSTRING(CONTEXT_INFO(), @pos, 16);
GO

-- Alter trg_T1_i trigger using session context
ALTER TRIGGER trg_T1_i ON dbo.T1 FOR INSERT
AS

DECLARE @signal AS BINARY(16);
EXEC dbo.TrgSignal_Get
  @guid = @signal OUTPUT,
  @pos  = 1; 
IF @signal = 0x7EDBCEC5E165E749BF1261A655F52C48 RETURN;

PRINT 'trg_T1_i in action...';
GO

-- No Signal
INSERT INTO dbo.T1 VALUES(1);
GO

-- Set Signal
EXEC dbo.TrgSignal_Set
  @guid = 0x7EDBCEC5E165E749BF1261A655F52C48,
  @pos = 1;

-- Issue INSERT
INSERT INTO T1 VALUES(2);

-- Clear Signal
EXEC dbo.TrgSignal_Clear @pos = 1;

-- No signal
INSERT INTO T1 VALUES(3);
GO

-- Cleanup
USE tempdb;
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL
  DROP TABLE dbo.T1;

USE master;
IF OBJECT_ID('dbo.TrgSignal_Set', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Set;
IF OBJECT_ID('dbo.TrgSignal_Clear', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Clear;
IF OBJECT_ID('dbo.TrgSignal_Get', 'P') IS NOT NULL
  DROP PROC dbo.TrgSignal_Get;
GO

---------------------------------------------------------------------
-- Nesting and Recursion
---------------------------------------------------------------------

-- Allow trigger recursion
ALTER DATABASE HR SET RECURSIVE_TRIGGERS ON;
GO

-- Create trigger trg_Employees_d
CREATE TRIGGER trg_Employees_d ON dbo.Employees FOR DELETE
AS

IF NOT EXISTS(SELECT * FROM deleted) RETURN; -- recursion termination check

DELETE E
FROM dbo.Employees AS E
  JOIN deleted AS M
    ON E.mgrid = M.empid;
GO

---------------------------------------------------------------------
-- UPDATE and COLUMNS_UPDATED
---------------------------------------------------------------------

-- Create the Table T1 with 100 Columns
USE tempdb; 
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
GO 
 
DECLARE @cmd AS NVARCHAR(4000), @i AS INT; 
 
SET @cmd = 
  N'CREATE TABLE dbo.T1(keycol INT NOT NULL IDENTITY PRIMARY KEY'; 
 
SET @i = 1; 
WHILE @i <= 100 
BEGIN 
  SET @cmd = 
    @cmd + N',col' + CAST(@i AS nvarchar(10)) + 
    N' INT NOT NULL DEFAULT 0'; 
  SET @i = @i + 1; 
END 
 
SET @cmd = @cmd + N');' 
 
EXEC sp_executesql @cmd; 
 
INSERT INTO dbo.T1 DEFAULT VALUES; 
 
SELECT * FROM T1;
GO

-- Trigger That Identifies Which Columns Were Updated
CREATE TRIGGER trg_T1_u_identify_updated_columns ON dbo.T1 FOR UPDATE 
AS 
SET NOCOUNT ON; 

DECLARE @parent_object_id AS INT = 
  (SELECT parent_object_id
   FROM sys.objects
   WHERE object_id = @@PROCID);

WITH UpdatedColumns(column_id) AS
(
  SELECT n
  FROM dbo.Nums
  WHERE n <=
    -- retrieve maximum column ID in trigger's parent table
    (SELECT MAX(column_id) 
     FROM sys.columns
     WHERE object_id = @parent_object_id)
    -- bit corresponding to nth column is turned on
    AND (SUBSTRING(COLUMNS_UPDATED(),(n - 1) / 8 + 1, 1)) 
         & POWER(2, (n - 1) % 8) > 0
)
SELECT C.name AS updated_column
FROM sys.columns AS C
  JOIN UpdatedColumns AS U
    ON C.column_id = U.column_id
WHERE object_id = @parent_object_id
ORDER BY U.column_id; 
GO

-- Test trg_T1_u_identify_updated_columns trigger
UPDATE dbo.T1
  SET col4 = 2, col8 = 2, col90 = 2, col6 = 2
WHERE keycol = 1;
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Auditing Example
---------------------------------------------------------------------

-- Creation Script for the T1 Table and Audit Table
SET NOCOUNT ON; 
USE tempdb; 

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
IF OBJECT_ID('dbo.T1Audit', 'U') IS NOT NULL DROP TABLE dbo.T1Audit; 

CREATE TABLE dbo.T1 
( 
  keycol INT NOT NULL PRIMARY KEY, 
  intcol INT NULL, 
  varcharcol VARCHAR(10) NULL 
); 

CREATE TABLE dbo.T1Audit 
( 
  lsn     INT         NOT NULL IDENTITY PRIMARY KEY, -- log serial number 
  keycol  INT         NOT NULL, 
  colname sysname     NOT NULL, 
  oldval  SQL_VARIANT NULL, 
  newval  SQL_VARIANT NULL 
);
GO

-- Creation Script for the trg_T1_U_Audit Trigger
CREATE TRIGGER trg_T1_u_audit ON dbo.T1 FOR UPDATE
AS

-- If 0 affected rows, do nothing
IF NOT EXISTS(SELECT * FROM inserted) RETURN;

INSERT INTO dbo.T1Audit(keycol, colname, oldval, newval)
  SELECT *
  FROM (SELECT I.keycol, colname,
          CASE colname
            WHEN N'intcol' THEN CAST(D.intcol AS SQL_VARIANT)
            WHEN N'varcharcol' THEN CAST(D.varcharcol AS SQL_VARIANT)
          END AS oldval,
          CASE colname
            WHEN N'intcol' THEN CAST(I.intcol AS SQL_VARIANT)
            WHEN N'varcharcol' THEN CAST(I.varcharcol AS SQL_VARIANT)
          END AS newval
        FROM inserted AS I
          JOIN deleted AS D
            ON I.keycol = D.keycol
          CROSS JOIN
            (SELECT N'intcol' AS colname
             UNION ALL SELECT N'varcharcol') AS C) AS D
  WHERE oldval <> newval
     OR oldval IS NULL AND newval IS NOT NULL
     OR oldval IS NOT NULL AND newval IS NULL;
GO

-- Load data to T1
INSERT INTO dbo.T1(keycol, intcol, varcharcol) VALUES
  (1, 10, 'A'), (2, 20, 'B'), (3, 30, 'C');

-- Update data in T1
UPDATE dbo.T1
  SET varcharcol = varcharcol + 'X',
      intcol = 40 - intcol
WHERE keycol < 3;

-- Query T1 and the audit Table
SELECT * FROM dbo.T1;
SELECT * FROM dbo.T1Audit;
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
IF OBJECT_ID('dbo.T1Audit', 'U') IS NOT NULL DROP TABLE dbo.T1Audit;
GO

---------------------------------------------------------------------
-- INSTEAD OF Triggers
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Per-Row Triggers
---------------------------------------------------------------------

-- Create table T1
USE tempdb; 
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 

CREATE TABLE dbo.T1 
( 
  keycol  INT NOT NULL PRIMARY KEY, 
  datacol INT NOT NULL 
);
GO

-- Create trigger trg_T1_i
CREATE TRIGGER trg_T1_i ON T1 AFTER INSERT
AS

DECLARE @msg AS VARCHAR(100);
SET @msg = 'Key: '
  + CAST((SELECT keycol FROM inserted) AS VARCHAR(10)) + ' inserted.';
PRINT @msg;
GO

-- Test trigger trg_T1_i
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, 10);
GO

-- Error on attempt to insert multiple rows
INSERT INTO dbo.T1(keycol, datacol) VALUES
  (2, 20), (3, 30), (4, 40);
GO

-- Creation Script for the trg_T1_ioi_perrow Trigger
CREATE TRIGGER trg_T1_ioi_perrow ON dbo.T1 INSTEAD OF INSERT
AS

DECLARE @rc AS INT = 
  (SELECT COUNT(*) FROM (SELECT TOP (2) * FROM inserted) AS D);

IF @rc = 0 RETURN;

IF @rc = 1
  INSERT INTO dbo.T1 SELECT * FROM inserted;
ELSE
BEGIN
  DECLARE @keycol AS INT, @datacol AS INT;
  DECLARE @Cinserted CURSOR;

  SET @Cinserted = CURSOR FAST_FORWARD FOR
    SELECT keycol, datacol FROM inserted;

  OPEN @Cinserted;

  FETCH NEXT FROM @Cinserted INTO @keycol, @datacol;
  WHILE @@fetch_status = 0
  BEGIN
    INSERT INTO dbo.T1(keycol, datacol) VALUES(@keycol, @datacol);
    FETCH NEXT FROM @Cinserted INTO @keycol, @datacol;
  END
END
GO

-- Test trigger trg_T1_ioi_perrow
INSERT INTO dbo.T1(keycol, datacol) VALUES(5, 50);

INSERT INTO dbo.T1(keycol, datacol) VALUES
  (6, 60), (7, 70), (8, 80);
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO

---------------------------------------------------------------------
-- Used with Views
---------------------------------------------------------------------

-- Creation Script for OrderDetails Table and VOrderTotals View
USE tempdb;
IF OBJECT_ID('dbo.OrderTotals', 'V') IS NOT NULL
  DROP VIEW dbo.OrderTotals;
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
  DROP TABLE dbo.OrderDetails;
GO

CREATE TABLE dbo.OrderDetails
(
  oid  INT NOT NULL,
  pid INT NOT NULL,
  qty INT NOT NULL,
  PRIMARY KEY(oid, pid)
);

INSERT INTO dbo.OrderDetails(oid, pid, qty) VALUES
  (10248, 1, 10),
  (10248, 2, 20),
  (10248, 3, 30),
  (10249, 1,  5),
  (10249, 2, 10),
  (10249, 3, 15),
  (10250, 1, 20),
  (10250, 2, 20),
  (10250, 3, 20);
GO

CREATE VIEW dbo.OrderTotals
AS

SELECT oid, SUM(qty) AS totalqty
FROM dbo.OrderDetails
GROUP BY oid;
GO

-- Creation Script for trg_VOrderTotals_iou Trigger
CREATE TRIGGER trg_OrderTotals_iou ON dbo.OrderTotals INSTEAD OF UPDATE
AS

IF NOT EXISTS(SELECT * FROM inserted) RETURN;

IF UPDATE(oid)
BEGIN
  RAISERROR('Updates to the OrderID column are not allowed.', 16, 1);
  ROLLBACK TRAN;
  RETURN;
END;

WITH UPD_CTE AS
(
  SELECT qty, ROUND(1.*OD.qty / D.totalqty * I.totalqty, 0) AS newqty
  FROM dbo.OrderDetails AS OD
    JOIN inserted AS I
      ON OD.oid = I.oid
    JOIN deleted AS D
      ON I.oid = D.oid
)
UPDATE UPD_CTE
  SET qty = newqty;
GO

-- Test trg_VOrderTotals_iou trigger
SELECT oid, pid, qty FROM dbo.OrderDetails;
SELECT oid, totalqty FROM dbo.OrderTotals;

UPDATE dbo.OrderTotals
  SET totalqty *= 2;

SELECT oid, pid, qty FROM dbo.OrderDetails;
SELECT oid, totalqty FROM dbo.OrderTotals;
GO

-- Cleanup
IF OBJECT_ID('dbo.OrderTotals', 'V') IS NOT NULL
  DROP VIEW dbo.OrderTotals;
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
  DROP TABLE dbo.OrderDetails;
GO

---------------------------------------------------------------------
-- Automatic Handling of Sequences
---------------------------------------------------------------------

-- Create Table T1
SET NOCOUNT ON; 
USE tempdb; 

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
CREATE TABLE dbo.T1 
( 
  keycol  INT NOT NULL PRIMARY KEY, 
  datacol VARCHAR(10) NOT NULL 
);
GO

-- Create sequence
IF OBJECT_ID('dbo.Sequence', 'U') IS NOT NULL
  DROP TABLE dbo.Sequence;
GO
CREATE TABLE dbo.Sequence(val INT NOT NULL);
INSERT INTO dbo.Sequence VALUES(0);
GO

-- Trigger generating keys
CREATE TRIGGER trg_T1_ioi_assign_key ON dbo.T1 INSTEAD OF INSERT
AS

DECLARE
  @rc  AS INT = (SELECT COUNT(*) FROM inserted),
  @key AS INT;

IF @rc = 0 RETURN; -- if 0 affected rows, exit

-- Update sequence
UPDATE dbo.Sequence SET @key = val, val = val + @rc;

INSERT INTO dbo.T1(keycol, datacol)
  SELECT @key + ROW_NUMBER() OVER(ORDER BY (SELECT 0)), datacol
  FROM inserted;
GO

-- Test trigger
INSERT INTO dbo.T1(datacol)
  VALUES('G'),('U'),('I'),('N'),('N'),('E'),('S'),('S');

SELECT keycol, datacol FROM dbo.T1;
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
IF OBJECT_ID('dbo.Sequence', 'U') IS NOT NULL DROP TABLE dbo.Sequence;
GO

---------------------------------------------------------------------
-- DDL Triggers
---------------------------------------------------------------------

-- Evntdata() Function

---------------------------------------------------------------------
-- Database Level Triggers
---------------------------------------------------------------------

-- Create testdb database
USE master; 
IF DB_ID('testdb') IS NULL CREATE DATABASE testdb;
GO
USE testdb;
GO

-- Creation Script for trg_create_table_with_pk Trigger
IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_create_table_with_pk')
  DROP TRIGGER trg_create_table_with_pk  ON DATABASE;
GO
CREATE TRIGGER trg_create_table_with_pk ON DATABASE FOR CREATE_TABLE
AS

DECLARE @eventdata AS XML, @objectname AS NVARCHAR(257),
  @msg AS NVARCHAR(500);

SET @eventdata = EVENTDATA();
SET @objectname = 
  + QUOTENAME(@eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'))
  + N'.' + 
  QUOTENAME(@eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'));

IF COALESCE(
     OBJECTPROPERTY(OBJECT_ID(@objectname), 'TableHasPrimaryKey'),
     0) = 0
BEGIN
  SET @msg = N'Table ' + @objectname + ' does not contain a primary key.'
    + CHAR(10) + N'Table creation rolled back.';
  RAISERROR(@msg, 16, 1);
  ROLLBACK;
  RETURN;
END
GO

-- Test trigger trg_create_table_with_pk
IF OBJECT_ID('dbo.T', 'U') IS NOT NULL DROP TABLE dbo.T;
GO
CREATE TABLE dbo.T(col1 INT NOT NULL);
GO
CREATE TABLE dbo.T(col1 INT NOT NULL PRIMARY KEY);
GO

-- Creation Script for AuditDDLEvents Table and trg_audit_ddl_events Trigger
IF OBJECT_ID('dbo.AuditDDLEvents', 'U') IS NOT NULL
  DROP TABLE dbo.AuditDDLEvents;
GO
CREATE TABLE dbo.AuditDDLEvents
(
  lsn              INT      NOT NULL IDENTITY,
  posttime         DATETIME NOT NULL,
  eventtype        sysname  NOT NULL,
  loginname        sysname  NOT NULL,
  schemaname       sysname  NOT NULL,
  objectname       sysname  NOT NULL,
  targetobjectname sysname  NULL,
  eventdata        XML      NOT NULL,
  CONSTRAINT PK_AuditDDLEvents PRIMARY KEY(lsn)
);
GO

IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_audit_ddl_events')
  DROP TRIGGER trg_audit_ddl_events  ON DATABASE;
GO
CREATE TRIGGER trg_audit_ddl_events ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS

DECLARE @eventdata AS XML;
SET @eventdata = EVENTDATA();

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
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT NOT NULL PRIMARY KEY);
ALTER TABLE dbo.T1 ADD col2 INT NULL;
ALTER TABLE dbo.T1 ALTER COLUMN col2 INT NOT NULL;
CREATE NONCLUSTERED INDEX idx1 ON dbo.T1(col2);
GO

SELECT * FROM dbo.AuditDDLEvents;
GO

-- Who changed T1 in the last 24 hours and how?
SELECT posttime, eventtype, loginname, 
  eventdata.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
  AS tsqlcommand 
FROM dbo.AuditDDLEvents 
WHERE schemaname = N'dbo' AND N'T1' IN(objectname, targetobjectname) 
  AND posttime > CURRENT_TIMESTAMP - 1 
ORDER BY posttime;
GO

-- Rename event
IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_rename')
  DROP TRIGGER trg_audit_ddl_events  ON DATABASE;
GO
CREATE TRIGGER trg_rename ON DATABASE FOR RENAME
AS

DECLARE @eventdata AS XML = EVENTDATA();

DECLARE
  @SchemaName       AS SYSNAME =
    @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
  @TargetObjectName AS SYSNAME =
    @eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
  @ObjectName       AS SYSNAME =
    @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
  @NewObjectName    AS SYSNAME =
    @eventdata.value('(/EVENT_INSTANCE/NewObjectName)[1]', 'sysname');

DECLARE @msg AS NVARCHAR(1000) = N'RENAME event occurred.
SchemaName      : ' + @SchemaName + N'
TargetObjectName: ' + @TargetObjectName + N'
ObjectName      : ' + @ObjectName + N'
NewObjectName   : ' + @NewObjectName;

PRINT @msg;
GO

-- test

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1(col1 INT PRIMARY KEY);
EXEC sp_rename 'dbo.T1.col1', 'col2', 'COLUMN';
GO

-- Cleanup
USE testdb;

IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_create_table_with_pk')
  DROP TRIGGER trg_create_table_with_pk  ON DATABASE;

IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_audit_ddl_events')
  DROP TRIGGER trg_audit_ddl_events  ON DATABASE;

IF EXISTS(SELECT * FROM sys.triggers
          WHERE parent_class = 0 AND name = 'trg_rename')
  DROP TRIGGER trg_rename  ON DATABASE;

IF OBJECT_ID('dbo.AuditDDLEvents', 'U') IS NOT NULL
  DROP TABLE dbo.AuditDDLEvents;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

IF OBJECT_ID('dbo.T', 'U') IS NOT NULL DROP TABLE dbo.T;
GO

---------------------------------------------------------------------
-- Server Level Triggers
---------------------------------------------------------------------

-- Creation Script for AuditDDLLogins Table and trg_audit_ddl_logins Trigger
USE master;

IF OBJECT_ID('dbo.AuditDDLLogins', 'U') IS NOT NULL
  DROP TABLE dbo.AuditDDLLogins;

CREATE TABLE dbo.AuditDDLLogins
(
  lsn              INT      NOT NULL IDENTITY,
  posttime         DATETIME NOT NULL,
  eventtype        sysname  NOT NULL,
  loginname        sysname  NOT NULL,
  objectname       sysname  NOT NULL,
  logintype        sysname  NOT NULL,
  eventdata        XML      NOT NULL,
  CONSTRAINT PK_AuditDDLLogins PRIMARY KEY(lsn)
);
GO

IF EXISTS(SELECT * FROM sys.server_triggers
          WHERE name = 'trg_audit_ddl_logins')
  DROP TRIGGER trg_audit_ddl_logins ON ALL SERVER;
GO
CREATE TRIGGER trg_audit_ddl_logins ON ALL SERVER
  FOR DDL_LOGIN_EVENTS
AS
DECLARE @eventdata AS XML = EVENTDATA();

INSERT INTO master.dbo.AuditDDLLogins(
  posttime, eventtype, loginname,
  objectname, logintype, eventdata)
  VALUES(
    @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]',   'VARCHAR(23)'),
    @eventdata.value('(/EVENT_INSTANCE/EventType)[1]',  'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/LoginName)[1]',  'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/LoginType)[1]',  'sysname'),
    @eventdata);
GO

-- Test trigger audit_ddl_logins
CREATE LOGIN login1 WITH PASSWORD = '6BAAA5FA-A8D4-469D-9713-3FFC6745513F';
ALTER LOGIN login1 WITH PASSWORD = 'E8A0D5A6-D7B7-4710-B06E-80558E08C8E0';
DROP LOGIN login1;
GO

SELECT * FROM master.dbo.AuditDDLLogins;
GO

-- Cleanup
IF EXISTS(SELECT * FROM sys.server_triggers
          WHERE name = 'trg_audit_ddl_logins')
  DROP TRIGGER trg_audit_ddl_logins ON ALL SERVER;

IF OBJECT_ID('dbo.AuditDDLLogins', 'U') IS NOT NULL
  DROP TABLE dbo.AuditDDLLogins;
GO

---------------------------------------------------------------------
-- Logon Triggers
---------------------------------------------------------------------

-- Create login called user1
USE master;

CREATE LOGIN user1
  WITH PASSWORD = '9500A9BA-E173-4A27-BA4A-B36DCD925877',
       CHECK_EXPIRATION = ON;

GRANT VIEW SERVER STATE TO user1;
GO

-- Create logon trigger that rejects the session if:
-- the login is user1
-- and the login already has an open session
-- and the time is peak time (>= 11:45, < 14:16)
-- and the new session is nonpooled
CREATE TRIGGER trg_logon_con_limit ON ALL SERVER 
  WITH EXECUTE AS 'user1'
  FOR LOGON
AS
BEGIN
IF ORIGINAL_LOGIN()= 'user1'
    AND (SELECT COUNT(*)
         FROM sys.dm_exec_sessions
         WHERE is_user_process = 1
           AND original_login_name = 'user1') > 1
    AND CAST(SYSDATETIME() AS TIME) >= '11:45'
    AND CAST(SYSDATETIME() AS TIME) <  '14:16'
    AND EVENTDATA().value('(/EVENT_INSTANCE/IsPooled)[1]', 'INT') = 0
  ROLLBACK;
END;
GO

-- Cleanup
DROP TRIGGER trg_logon_con_limit ON ALL SERVER;
DROP LOGIN user1;
GO

---------------------------------------------------------------------
-- CLR Triggers
---------------------------------------------------------------------

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
USE CLRUtilities;
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative

USE master;
CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
*/

-- C#
/*
-- C# Code for trg_GenericDMLAudit Trigger
  // Generic trigger for auditing DML statements
  // trigger will write first 200 characters from all columns
  // in an XML format to App Event Log
  [SqlTrigger(Name = @"trg_GenericDMLAudit", Target = "T1",
     Event = "FOR INSERT, UPDATE, DELETE")]
  public static void trg_GenericDMLAudit()
  {
    // Get the trigger context to get info about the action type
    SqlTriggerContext triggContext = SqlContext.TriggerContext;
    // Prepare the command and pipe objects
    SqlCommand command;
    SqlPipe pipe = SqlContext.Pipe;

    // Check type of action
    switch (triggContext.TriggerAction)
    {
      case TriggerAction.Insert:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type, cast it
          // to nvarchar and select only a substring from it
          // Info from Inserted
          command = new SqlCommand(
            @"SELECT 'New data: '
                + REPLACE(
                    SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200
              FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE)
                AS a(InsertedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          // Note: if the following line would use
          // Environment.MachineName instead of "." to refer to
          // the local machine event log, the assembly would need
          // the UNSAFE permission set
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      case TriggerAction.Update:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type,
          // cast it to nvarchar and select only a substring from it
          // Info from Deleted
          command = new SqlCommand(
            @"SELECT 'Old data: '
                + REPLACE(
                    SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 
              FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE)
                AS a(DeletedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Info from Inserted
          command.CommandText =
            @"SELECT ' // New data: '
                + REPLACE(
                    SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 
              FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE)
                AS a(InsertedContents);";
          msg = msg + (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      case TriggerAction.Delete:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type,
          // cast it to nvarchar and select only a substring from it
          // Info from Deleted
          command = new SqlCommand(
            @"SELECT 'Old data: '
                + REPLACE(
                    SUBSTRING(CAST(a. DeletedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 
              FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE)
                   AS a(DeletedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      default:
        // Just to be sure - this part should never fire
        pipe.Send(@"Nothing happened");
        break;
    }
  }
*/

-- Visual Basic
/*
-- Visual Basic Code for trg_GenericDMLAudit Trigger
  ' Generic trigger for auditing DML statements
  ' trigger will write first 200 characters from all columns 
  ' in an XML format to App Event Log
  <SqlTrigger(Name:="trg_GenericDMLAudit", Target:="T1", _
    Event:="FOR INSERT, UPDATE, DELETE")> _
  Public Shared Sub trg_GenericDMLAudit()
    ' Get the trigger context to get info about the action type
    Dim triggContext As SqlTriggerContext = SqlContext.TriggerContext
    ' Prepare the command and pipe objects
    Dim command As SqlCommand
    Dim pipe As SqlPipe = SqlContext.Pipe

    ' Check type of action
    Select Case triggContext.TriggerAction
      Case TriggerAction.Insert
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Inserted
          command = New SqlCommand( _
            "SELECT 'New data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 " & _
            "FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE) " & _
            "AS a(InsertedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          ' Note: if the following line would use
          ' Environment.MachineName instead of "." to refer to
          ' the local machine event log, the assembly would need
          ' the UNSAFE permission set
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case TriggerAction.Update
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Deleted
          command = New SqlCommand( _
            "SELECT 'Old data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 " & _
            "FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE) " & _
            "AS a(DeletedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Info from Inserted
          command.CommandText = _
            "SELECT ' // New data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 " & _
            "FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE) " & _
            "AS a(InsertedContents);"
          msg = msg + CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case TriggerAction.Delete
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Deleted
          command = New SqlCommand( _
            "SELECT 'Old data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 " & _
            "FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE) " & _
            "AS a(DeletedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case Else
        ' Just to be sure - this part should never fire
        pipe.Send("Nothing happened")
    End Select
  End Sub
*/

-- Create table T1
USE ClrUtilities; 

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 

CREATE TABLE dbo.T1 
( 
  keycol  INT         NOT NULL PRIMARY KEY, 
  datacol VARCHAR(10) NOT NULL 
);
GO

-- C#
CREATE TRIGGER trg_T1_iud_GenericDMLAudit
 ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
EXTERNAL NAME CLRUtilities.CLRUtilities.trg_GenericDMLAudit;
GO

-- Visual Basic
CREATE TRIGGER trg_T1_iud_GenericDMLAudit
 ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].trg_GenericDMLAudit;
GO

-- Test trigger
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, N'A');
UPDATE dbo.T1 SET datacol = N'B' WHERE keycol = 1;
DELETE FROM dbo.T1 WHERE keycol = 1;
GO

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
GO
