---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 05: Transactions and Concurrency
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Transactions, Described
---------------------------------------------------------------------

-- Creating and Populating Tables T1 and T2
SET NOCOUNT ON;
IF DB_ID('testdb') IS NULL CREATE DATABASE testdb;
GO
USE testdb;
GO
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2;
GO

CREATE TABLE dbo.T1
(
  keycol INT         NOT NULL PRIMARY KEY,
  col1   INT         NOT NULL,
  col2   VARCHAR(50) NOT NULL
);

INSERT INTO dbo.T1(keycol, col1, col2) VALUES
  (1, 101, 'A'),
  (2, 102, 'B'),
  (3, 103, 'C');

CREATE TABLE dbo.T2
(
  keycol INT         NOT NULL PRIMARY KEY,
  col1   INT         NOT NULL,
  col2   VARCHAR(50) NOT NULL
);

INSERT INTO dbo.T2(keycol, col1, col2) VALUES
  (1, 201, 'X'),
  (2, 202, 'Y'),
  (3, 203, 'Z');
GO

-- Transaction Example
BEGIN TRAN
  INSERT INTO dbo.T1(keycol, col1, col2) VALUES(4, 101, 'C');
  INSERT INTO dbo.T2(keycol, col1, col2) VALUES(4, 201, 'X');
COMMIT TRAN
GO

---------------------------------------------------------------------
-- Locks and Blocking
---------------------------------------------------------------------

-- Connection 1
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = 'BB' WHERE keycol = 2;
GO

-- Connection 2
SET NOCOUNT ON;
USE testdb;
GO
SELECT keycol, col1, col2 FROM dbo.T1;
GO

-- Connection 3
SET NOCOUNT ON;
USE testdb;
GO

-- Lock info
SELECT
  request_session_id            AS spid,
  resource_type                 AS restype,
  resource_database_id          AS dbid,
  resource_description          AS res,
  resource_associated_entity_id AS resid,
  request_mode                  AS mode,
  request_status                AS status
FROM sys.dm_tran_locks;

-- Connection info
SELECT * FROM sys.dm_exec_connections
WHERE session_id IN(53, 54);

-- Session info (1 session can have multiple connections)
SELECT * FROM sys.dm_exec_sessions
WHERE session_id IN(53, 54);

-- Blocking
SELECT * FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;

-- SQL text
SELECT session_id, text 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST 
WHERE session_id IN(53, 54);
GO

-- Connection 2
-- Stop, then set the LOCK_TIMEOUT, then retry
SET LOCK_TIMEOUT 5000;
SELECT keycol, col1, col2 FROM dbo.T1;
GO

-- Remove timeout
SET LOCK_TIMEOUT -1;
GO

-- Connection 1
ROLLBACK TRAN;
GO

---------------------------------------------------------------------
-- Lock Escalation
---------------------------------------------------------------------

-- Create and populate table TestEscalation
IF OBJECT_ID('dbo.TestEscalation', 'U') IS NOT NULL
  DROP TABLE dbo.TestEscalation;
GO

SELECT n AS col1, CAST('a' AS CHAR(200)) AS filler
INTO dbo.TestEscalation
FROM dbo.Nums
WHERE n <= 100000;

CREATE UNIQUE CLUSTERED INDEX idx1 ON dbo.TestEscalation(col1);
GO

-- Run transaction and observe only 1 lock reported indicating escalation
BEGIN TRAN

  DELETE FROM dbo.TestEscalation WHERE col1 <= 20000;

  SELECT COUNT(*)
  FROM sys.dm_tran_locks
  WHERE request_session_id = @@SPID;

ROLLBACK
GO

-- Disable lock escalation and run transaction again
ALTER TABLE dbo.TestEscalation SET (LOCK_ESCALATION = DISABLE);

BEGIN TRAN

  DELETE FROM dbo.TestEscalation WHERE col1 <= 20000;

  SELECT COUNT(*)
  FROM sys.dm_tran_locks
  WHERE request_session_id = @@SPID;

ROLLBACK
GO

-- Cleanup
IF OBJECT_ID('dbo.TestEscalation', 'U') IS NOT NULL
  DROP TABLE dbo.TestEscalation;
GO

---------------------------------------------------------------------
-- Isolation Levels
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Read Uncommitted
---------------------------------------------------------------------

-- First initialize the data
UPDATE dbo.T1 SET col2 = 'Version 1' WHERE keycol = 2;

-- Connection 1
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = 'Version 2' WHERE keycol = 2;
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 1
ROLLBACK TRAN
GO

---------------------------------------------------------------------
-- Read Committed
---------------------------------------------------------------------

-- Connection 1
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = 'Version 2' WHERE keycol = 2;
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 1
COMMIT TRAN
GO

-- Cleanup
UPDATE dbo.T1 SET col2 = 'Version 1' WHERE keycol = 2;
GO

---------------------------------------------------------------------
-- Repeatable Read
---------------------------------------------------------------------

-- Connection 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRAN
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
UPDATE dbo.T1 SET col2 = 'Version 2' WHERE keycol = 2;
GO

-- Connection 1
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
COMMIT TRAN
GO

-- Cleanup
UPDATE dbo.T1 SET col2 = 'Version 1' WHERE keycol = 2;
GO

---------------------------------------------------------------------
-- Serializable
---------------------------------------------------------------------
CREATE INDEX idx_col1 ON dbo.T1(col1);
GO

-- Connection 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN
  SELECT *
  FROM dbo.T1
  WHERE col1 = 102;
GO


-- Connection 2
INSERT INTO dbo.T1(keycol, col1, col2) VALUES(5, 102, 'D');
GO

-- Connection 1
  SELECT *
  FROM dbo.T1
  WHERE col1 = 102;
COMMIT TRAN;
GO

-- Cleanup
DROP INDEX dbo.T1.idx_col1;

-- In all connections issue:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

---------------------------------------------------------------------
-- New Isolation Levels
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Snapshot
---------------------------------------------------------------------

-- Allow SNAPSHOT isolation in the database
ALTER DATABASE testdb SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

-- Connection 1
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = 'Version 2' WHERE keycol = 2;
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Check row versions
SELECT * FROM sys.dm_tran_version_store;
GO

-- Connection 2
SET NOCOUNT ON;
USE testdb;
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRAN
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 1
COMMIT TRAN
SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
COMMIT TRAN
SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

---------------------------------------------------------------------
-- Conflict Detection
---------------------------------------------------------------------

-- Connection 1, Step 1
SET NOCOUNT ON;
USE testdb;
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRAN
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 1, Step 2
  UPDATE dbo.T1 SET col2 = 'Version 3' WHERE keycol = 2;
COMMIT
GO

-- Connection 1, Step 3
BEGIN TRAN
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2, Step 1
SET NOCOUNT ON;
USE testdb;
GO
UPDATE dbo.T1 SET col2 = 'Version 4' WHERE keycol = 2;
GO

-- Connection 1, Step 4
  UPDATE dbo.T1 SET col2 = 'Version 5' WHERE keycol = 2;
GO

-- Cleanup
UPDATE dbo.T1 SET col2 = 'Version 1' WHERE keycol = 2;
GO

-- Close all connections

---------------------------------------------------------------------
-- Read Committed Snapshot
---------------------------------------------------------------------

-- Turn on READ_COMMITTED_SNAPSHOT
ALTER DATABASE testdb SET READ_COMMITTED_SNAPSHOT ON;
GO

-- Connection 1
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = 'Version 2' WHERE keycol = 2;
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 2
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
GO

-- Connection 1
COMMIT TRAN
GO

-- Connection 2
  SELECT col2 FROM dbo.T1 WHERE keycol = 2;
COMMIT TRAN
GO

-- Cleanup

-- Close all connections

-- Make sure you're back in default mode
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Restore the testdb database to its default settings:
ALTER DATABASE testdb SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE testdb SET READ_COMMITTED_SNAPSHOT OFF;
GO

---------------------------------------------------------------------
-- Savepoints
---------------------------------------------------------------------

-- Seuence Table
USE tempdb;
IF OBJECT_ID('dbo.Sequence', 'U') IS NOT NULL DROP TABLE dbo.Sequence;
CREATE TABLE dbo.Sequence(val INT IDENTITY);
GO

-- Sequence Proc
IF OBJECT_ID('dbo.GetSequence', 'P') IS NOT NULL
  DROP PROC dbo.GetSequence;
GO
CREATE PROC dbo.GetSequence
  @val AS INT OUTPUT
AS
BEGIN TRAN
  SAVE TRAN S1;
  INSERT INTO dbo.Sequence DEFAULT VALUES;
  SET @val = SCOPE_IDENTITY()
  ROLLBACK TRAN S1;
COMMIT TRAN
GO

-- Get Next Sequence
DECLARE @key AS INT;
EXEC dbo.GetSequence @val = @key OUTPUT;
SELECT @key;
GO

---------------------------------------------------------------------
-- Deadlocks
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Simple Deadlock Example
---------------------------------------------------------------------

-- Connection 1
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  UPDATE dbo.T1 SET col1 = col1 + 1 WHERE keycol = 2;
GO

-- Connection 2
SET NOCOUNT ON;
USE testdb;
GO
BEGIN TRAN
  UPDATE dbo.T2 SET col1 = col1 + 1 WHERE keycol = 2;
GO

-- Connection 1
  SELECT col1 FROM dbo.T2 WHERE keycol = 2;
COMMIT TRAN
GO

-- Connection 2
  SELECT col1 FROM dbo.T1 WHERE keycol = 2;
COMMIT TRAN
GO

---------------------------------------------------------------------
-- Deadlock for missing index
---------------------------------------------------------------------

-- Connection 1
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = col2 + 'A' WHERE col1 = 101;
GO

-- Connection 2
BEGIN TRAN
  UPDATE dbo.T2 SET col2 = col2 + 'B' WHERE col1 = 203;
GO

-- Connection 1
  SELECT col2 FROM dbo.T2 WHERE col1 = 201;
COMMIT TRAN
GO

-- Connection 2
  SELECT col2 FROM dbo.T1 WHERE col1 = 103;
COMMIT TRAN
GO

-- Create an index on col1 and rerun the activities
CREATE INDEX idx_col1 ON dbo.T1(col1);
CREATE INDEX idx_col1 ON dbo.T2(col1);
GO

-- Connection 1
BEGIN TRAN
  UPDATE dbo.T1 SET col2 = col2 + 'A' WHERE col1 = 101;
GO

-- Connection 2
BEGIN TRAN
  UPDATE dbo.T2 SET col2 = col2 + 'B' WHERE col1 = 203;
GO

-- Connection 1
  SELECT col2 FROM dbo.T2 WITH (index = idx_col1) WHERE col1 = 201;
COMMIT TRAN
GO

-- Connection 2
  SELECT col2 FROM dbo.T1 WITH (index = idx_col1) WHERE col1 = 103;
COMMIT TRAN
GO

---------------------------------------------------------------------
-- Deadlock with a Single table
---------------------------------------------------------------------

-- First make sure row with keycol = 2 has col = 102
UPDATE dbo.T1 SET col1 = 102, col2 = 'B' WHERE keycol = 2;
GO

-- Connection 1
SET NOCOUNT ON;
USE testdb;

WHILE 1 = 1
  UPDATE dbo.T1 SET col1 = 203 - col1 WHERE keycol = 2;
GO

-- Connection 2
SET NOCOUNT ON;
USE testdb;

DECLARE @i AS VARCHAR(10);
WHILE 1 = 1
  SET @i = (SELECT col2 FROM dbo.T1 WITH (index = idx_col1)
            WHERE col1 = 102);
GO

-- Cleanup
USE testdb; 

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2;
GO
