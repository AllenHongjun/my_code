---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 06: Error Handling
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Error Handling without the TRY/CATCH Construct
---------------------------------------------------------------------

-- Error that doesn't terminate the batch
SELECT 1/0;
PRINT 'Still here...';
GO

-- Error that terminates the batch
SELECT 'A' + 1;
PRINT 'Still here...';
GO

SELECT * FROM NonExistingObject;
PRINT 'Still here...';
GO

-- Preserving both @@ERROR and @@ROWCOUNT
SET NOCOUNT ON;
USE InsideTSQL2008;

DECLARE @custid AS INT, @err AS INT, @rc AS INT;
SET @custid = 1;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid;

SELECT @err = @@ERROR, @rc = @@ROWCOUNT;
-- error handling code goes here 
SELECT @err AS error_number, @rc AS row_count;
GO

-- Using a Stored Procedure
IF OBJECT_ID('dbo.GetCustomerOrders', 'P') IS NOT NULL
  DROP PROC dbo.GetCustomerOrders;
GO

CREATE PROC dbo.GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231 23:59:59.997',
  @numrows  AS INT OUTPUT
AS

-- Input validation goes here

DECLARE @err AS INT;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;

SELECT @numrows = @@ROWCOUNT, @err = @@ERROR;

RETURN @err;
GO

-- Listing 6-1: Handling Errors in GetCustomerOrders Procedure
SET LOCK_TIMEOUT 5000;
DECLARE @err AS INT, @rc AS INT;

EXEC @err = dbo.GetCustomerOrders
  @custid   = 1, -- Also try with 999
  @fromdate = '20070101',
  @todate   = '20080101',
  @numrows  = @rc OUTPUT;

SELECT -- For batch-aborting errors
  @err = COALESCE(@err, @@ERROR),
  @rc  = COALESCE(@rc, @@ROWCOUNT);

SELECT @err AS error_number, @rc AS row_count;

IF @err = 0 AND @rc > 0 BEGIN
  PRINT 'Processing Successful';
  RETURN;
END

IF @err = 0 AND @rc = 0 BEGIN
  PRINT 'No rows were selected.';
  RETURN;
END

IF @err = 1222
BEGIN
  PRINT 'Handling lock time out expired error.';
  RETURN;
END

-- other errors
-- IF @err = ...

BEGIN
  PRINT 'Unhandled error detected.';
  RETURN;
END
GO

-- Try above code again when table is locked
USE InsideTSQL2008;

BEGIN TRAN
  SELECT * FROM Sales.Orders WITH (TABLOCKX);

-- run above code now, and then rollback to realease the lock
ROLLBACK TRAN
GO

---------------------------------------------------------------------
-- Error Handling with the TRY/CATCH Construct
---------------------------------------------------------------------

---------------------------------------------------------------------
-- TRY/CATCH
---------------------------------------------------------------------

-- Create the testdb Database and the Employees Table
IF DB_ID('testdb') IS NULL
  CREATE DATABASE testdb;
GO
USE testdb;
GO

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
  DROP TABLE dbo.Employees;
GO
CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL,
  empname VARCHAR(25) NOT NULL,
  mgrid   INT         NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
  CONSTRAINT CHK_Employees_empid CHECK(empid > 0),
  CONSTRAINT FK_Employees_Employees
    FOREIGN KEY(mgrid) REFERENCES Employees(empid)
);
GO

-- Run twice
BEGIN TRY
  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);
  PRINT 'INSERT succeeded.';
END TRY
BEGIN CATCH
  PRINT 'INSERT failed.';
  /* handle error here */
END CATCH
GO

---------------------------------------------------------------------
-- New Error Handling Functions
---------------------------------------------------------------------

-- Listing 6-2: New Error Handling Functions
PRINT 'Before TRY/CATCH block.';

BEGIN TRY

  PRINT '  Entering TRY block.';

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(2, 'Emp2', 1);
  -- Also try with empid = 0, 'A', NULL

  PRINT '    After INSERT.';

  PRINT '  Exiting TRY block.';

END TRY
BEGIN CATCH

  PRINT '  Entering CATCH block.';

  IF ERROR_NUMBER() = 2627
  BEGIN
    PRINT '    Handling PK violation...';
  END
  ELSE IF ERROR_NUMBER() = 547
  BEGIN
    PRINT '    Handling CHECK/FK constraint violation...';
  END
  ELSE IF ERROR_NUMBER() = 515
  BEGIN
    PRINT '    Handling NULL violation...';
  END
  ELSE IF ERROR_NUMBER() = 245
  BEGIN
    PRINT '    Handling conversion error...';
  END
  ELSE
  BEGIN
    PRINT '    Handling unknown error...';
  END

  PRINT '    Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
  PRINT '    Error Message : ' + ERROR_MESSAGE();
  PRINT '    Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
  PRINT '    Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
  PRINT '    Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
  PRINT '    Error Proc    : ' + ISNULL(ERROR_PROCEDURE(), 'Not within proc');

  PRINT '  Exiting CATCH block.';

END CATCH

PRINT 'After TRY/CATCH block.';
GO

---------------------------------------------------------------------
-- Errors in Transactions
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Using XACT_STATE
---------------------------------------------------------------------

-- Run Listing 6-3 two times, then turn XACT_ABORT ON and run again

-- Listing 6-3: Error Handling with Transaction States
BEGIN TRY

  BEGIN TRAN
    INSERT INTO dbo.Employees(empid, empname, mgrid)
      VALUES(3, 'Emp3', 1);
    /* other activity */
  COMMIT TRAN

  PRINT 'Code completed successfully.';

END TRY
BEGIN CATCH

  PRINT 'Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' found.';

  IF (XACT_STATE()) = -1
  BEGIN
	  PRINT 'Transaction is open but uncommittable.';
	  /* ...investigate data... */
	  ROLLBACK TRAN; -- can only ROLLBACK
	  /* ...handle the error... */
  END
  ELSE IF (XACT_STATE()) = 1
  BEGIN
	  PRINT 'Transaction is open and committable.';
	  /* ...handle error... */
	  COMMIT TRAN; -- or ROLLBACK
  END
  ELSE
  BEGIN
	  PRINT 'No open transaction.';
	  /* ...handle error... */
  END

END CATCH
GO

-- SET XACT_ABORT ON;
-- Run Listing 6-3
-- SET XACT_ABORT OFF;
GO

---------------------------------------------------------------------
-- Using Savepoints
---------------------------------------------------------------------

-- Listing 6-4: Creation Script for AddEmp Stored Procedure
IF OBJECT_ID('dbo.AddEmp', 'P') IS NOT NULL DROP PROC dbo.AddEmp;
GO

CREATE PROC dbo.AddEmp
  @empid AS INT, @empname AS VARCHAR(25), @mgrid AS INT
AS

-- Save tran count aside
DECLARE @tc AS INT;
SET @tc = @@TRANCOUNT;

-- If tran was already active, create a savepoint
IF @tc > 0
  SAVE TRAN S1;
-- If tran was not active, open a new one
ELSE
  BEGIN TRAN

BEGIN TRY;
  -- Modify data
  INSERT INTO dbo.Employees(empid, empname, mgrid)
     VALUES(@empid, @empname, @mgrid);
  -- If proc opened the tran, it's responsible for committing it
  IF @tc = 0
    COMMIT TRAN;

END TRY
BEGIN CATCH
    PRINT 'Error detected.';
    PRINT CASE XACT_STATE()
      WHEN 0 THEN 'No transaction is open.'
      WHEN 1 THEN 'Transaction is open and committable.'
      WHEN -1 THEN 'Transaction is open and uncommittable.'
    END;
    -- Proc opened tran
    IF @tc = 0
    BEGIN
      -- Can react differently based on tran state (XACT_STATE)
      -- In this case, say we just want to roll back
      IF XACT_STATE() <> 0
      BEGIN
        PRINT 'Rollback of tran opened by proc.';
        ROLLBACK TRAN
      END
    END
    -- Proc didn't open tran
    ELSE
    BEGIN
      IF XACT_STATE() = 1
      BEGIN
        PRINT 'Proc was invoked in an open tran.
Roll back only proc''s activity.';
        ROLLBACK TRAN S1
      END
      ELSE IF XACT_STATE() = -1
        PRINT 'Proc was invoked in an open tran, but tran is uncommittable.
Deferring error handling to caller.'
    END

    -- Raise error so that caller will determine what to do with
    -- the failure in the proc
    DECLARE
      @ErrorMessage  NVARCHAR(500),
      @ErrorSeverity INT,
      @ErrorState    INT;
    SELECT
      @ErrorMessage  = ERROR_MESSAGE()
         + QUOTENAME(N'Original error number: '
                     + CAST(ERROR_NUMBER() AS NVARCHAR(10)), N'('),
      @ErrorSeverity = ERROR_SEVERITY(),
      @ErrorState    = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
GO

-- Test proc
TRUNCATE TABLE dbo.Employees;

-- Run twice
EXEC dbo.AddEmp @empid = 1, @empname = 'Emp1', @mgrid = NULL;
GO

-- Now in a transaction
BEGIN TRAN
  EXEC AddEmp @empid = 1, @empname = 'Emp1', @mgrid = NULL;
ROLLBACK

-- Now with XACT_ABORT ON in a transaction
SET XACT_ABORT ON;

BEGIN TRAN
  EXEC AddEmp @empid = 1, @empname = 'Emp1', @mgrid = NULL;
ROLLBACK

SET XACT_ABORT OFF;
GO

---------------------------------------------------------------------
-- Deadlocks and Update Conflicts
---------------------------------------------------------------------

-- Create and Populate Tables T1 and T2
USE testdb;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
IF OBJECT_ID('dbo.T2', 'U') IS NOT NULL DROP TABLE dbo.T2; 

CREATE TABLE dbo.T1(col1 INT);
INSERT INTO dbo.T1 VALUES(1);

CREATE TABLE dbo.T2(col1 INT);
INSERT INTO dbo.T2 VALUES(1);
GO

-- Listing 6-5: Error Handling Retry Logic, Connection 1
SET NOCOUNT ON;
USE testdb;
GO

-- SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
SET LOCK_TIMEOUT 30000;

DECLARE @retry AS INT, @i AS INT, @j AS INT, @maxretries AS INT;
SELECT @retry = 1, @i = 0, @maxretries = 3;

WHILE @retry = 1 AND @i <= @maxretries
BEGIN
  SET @retry = 0;
  BEGIN TRY
    BEGIN TRAN
      SET @j = (SELECT SUM(col1) FROM dbo.T1);
      WAITFOR DELAY '00:00:05';
      UPDATE dbo.T1 SET col1 += 1;
      WAITFOR DELAY '00:00:05';
      SET @j = (SELECT SUM(col1) FROM dbo.T2);
    COMMIT TRAN
    PRINT 'Transaction completed successfully.';
  END TRY
  BEGIN CATCH
    -- Lock timeout
    IF ERROR_NUMBER() = 1222
    BEGIN
      PRINT 'Lock timeout detected.';
      IF XACT_STATE() <> 0 ROLLBACK;
    END
    -- Deadlock / Update conflict
    ELSE IF ERROR_NUMBER() IN (1205, 3960)
    BEGIN
      PRINT CASE ERROR_NUMBER()
              WHEN 1205 THEN 'Deadlock'
              WHEN 3960 THEN 'Update conflict'
            END + ' detected.';
      IF XACT_STATE() <> 0 ROLLBACK;
      SELECT @retry = 1, @i += 1;
      IF @i <= @maxretries
      BEGIN
        PRINT 'Retry #' + CAST(@i AS VARCHAR(10)) + '.';
        WAITFOR DELAY '00:00:05';
      END
    END
    ELSE
    BEGIN
      PRINT 'Unhandled error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
        + ', ' + ERROR_MESSAGE();
      IF XACT_STATE() <> 0 ROLLBACK;
    END
  END CATCH
END

IF @i > @maxretries
  PRINT 'Failed ' + CAST(@maxretries AS VARCHAR(10)) + ' retries.';
GO

-- Listing 6-6: Error Handling Retry Logic, Connection 2
SET NOCOUNT ON;
USE testdb;
GO

SET LOCK_TIMEOUT 30000;

DECLARE @retry AS INT, @i AS INT, @j AS INT, @maxretries AS INT;
SELECT @retry = 1, @i = 0, @maxretries = 3;

WHILE @retry = 1 AND @i <= @maxretries
BEGIN
  SET @retry = 0;
  BEGIN TRY
    BEGIN TRAN
      SET @j = (SELECT SUM(col1) FROM dbo.T2);
      WAITFOR DELAY '00:00:05';
      UPDATE dbo.T2 SET col1 += 1;
      WAITFOR DELAY '00:00:05';
      SET @j = (SELECT SUM(col1) FROM dbo.T1);
    COMMIT TRAN
    PRINT 'Transaction completed successfully.';
  END TRY
  BEGIN CATCH
    -- Lock timeout
    IF ERROR_NUMBER() = 1222
    BEGIN
      PRINT 'Lock timeout detected.';
      IF XACT_STATE() <> 0 ROLLBACK;
    END
    -- Deadlock / Update conflict
    ELSE IF ERROR_NUMBER() IN (1205, 3960)
    BEGIN
      PRINT CASE ERROR_NUMBER()
              WHEN 1205 THEN 'Deadlock'
              WHEN 3960 THEN 'Update conflict'
            END + ' detected.';
      IF XACT_STATE() <> 0 ROLLBACK;
      SELECT @retry = 1, @i += 1;
      IF @i <= @maxretries
      BEGIN
        PRINT 'Retry #' + CAST(@i AS VARCHAR(10)) + '.';
        WAITFOR DELAY '00:00:05';
      END
    END
    ELSE
    BEGIN
      PRINT 'Unhandled error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
        + ', ' + ERROR_MESSAGE();
      IF XACT_STATE() <> 0 ROLLBACK;
    END
  END CATCH
END

IF @i > @maxretries
  PRINT 'Failed ' + CAST(@maxretries AS VARCHAR(10)) + ' retries.';
GO

-- Error Handling Retry Logic, Connection 3
SET NOCOUNT ON;
USE testdb;
GO

SET LOCK_TIMEOUT 30000;
DECLARE @j AS INT;

BEGIN TRAN

  UPDATE dbo.T2 SET col1 += 1;
  UPDATE dbo.T2 SET col1 += 1;
  UPDATE dbo.T2 SET col1 += 1;

  WAITFOR DELAY '00:00:05';

  WHILE 1 = 1
  BEGIN
    SET @j = (SELECT SUM(col1) FROM dbo.T1);
    WAITFOR DELAY '00:00:01';
  END

ROLLBACK

-- Stop and rollback the transaction in connection 3
ROLLBACK TRAN

-- Allow snapshot isolation
ALTER DATABASE testdb SET ALLOW_SNAPSHOT_ISOLATION ON;

-- Connection 4
SET NOCOUNT ON;
USE testdb;

SET LOCK_TIMEOUT 30000;

WHILE 1 = 1
BEGIN
  UPDATE dbo.T1 SET col1 += 1;
  WAITFOR DELAY '00:00:01';
END
GO