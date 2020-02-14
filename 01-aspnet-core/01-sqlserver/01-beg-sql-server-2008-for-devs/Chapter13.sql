/* Chapter 13 */



/* Try It Out - TCreating a Trigger in Query Editor - Steps 1 and 2 */
USE ApressFinancial
GO
CREATE TRIGGER TransactionDetails.trgInsTransactions
ON TransactionDetails.Transactions
AFTER INSERT
AS
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance +
(SELECT CASE WHEN CreditType = 0
THEN i.Amount * -1
ELSE i.Amount
END
FROM INSERTED i
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = i.TransactionType
WHERE AffectCashBalance = 1)
FROM CustomerDetails.Customers c
JOIN INSERTED i ON i.CustomerId = c.CustomerId

/* Try It Out - TCreating a Trigger in Query Editor - Step 3 */
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1
INSERT INTO TransactionDetails.Transactions (CustomerId,TransactionType,
Amount,RelatedProductId, DateEntered)
VALUES (1,2,200,1,GETDATE())
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1

/* Try It Out - TCreating a Trigger in Query Editor - Step 5 */
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1
INSERT INTO TransactionDetails.Transactions (CustomerId,TransactionType,
Amount,RelatedProductId, DateEntered)
VALUES (1,3,200,1,GETDATE())
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1

/* Try It Out - TCreating a Trigger in Query Editor - Step 7 */
SELECT *
FROM TransactionDetails.Transactions
WHERE CustomerId=1

/* Try It Out - TCreating a Trigger in Query Editor - Step 8 */
ALTER TRIGGER TransactionDetails.trgInsTransactions
ON TransactionDetails.Transactions
AFTER INSERT
AS
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance +
ISNULL((SELECT CASE WHEN CreditType = 0
THEN i.Amount * -1
ELSE i.Amount
END
FROM INSERTED i
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = i.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN INSERTED i ON i.CustomerId = c.CustomerId

/* Try It Out - TCreating a Trigger in Query Editor - Step 9 */
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1
INSERT INTO TransactionDetails.Transactions (CustomerId,TransactionType,
Amount,RelatedProductId, DateEntered)
VALUES (1,3,200,1,GETDATE())
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE customerId=1

/* Try It Out - UPDATE() - Steps 1 to 3 */
ALTER TRIGGER TransactionDetails.trgInsTransactions
ON TransactionDetails.Transactions
AFTER INSERT,UPDATE
AS
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance -
ISNULL((SELECT CASE WHEN CreditType = 0
THEN d.Amount * -1
ELSE d.Amount
END
FROM DELETED d
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = d.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN DELETED d ON d.CustomerId = c.CustomerId
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance +
ISNULL((SELECT CASE WHEN CreditType = 0
THEN i.Amount * -1
ELSE i.Amount
END
FROM INSERTED i
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = i.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN INSERTED i ON i.CustomerId = c.CustomerId

/* Try It Out - UPDATE() - Step 4 */
SELECT *
FROM TransactionDetails.Transactions
WHERE CustomerId = 1
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1
UPDATE TransactionDetails.Transactions
SET Amount = 100
WHERE TransactionId = 5
SELECT *
FROM TransactionDetails.Transactions
WHERE CustomerId = 1
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1

/* Try It Out - UPDATE() - Step 7 */
ALTER TRIGGER TransactionDetails.trgInsTransactions
ON TransactionDetails.Transactions
AFTER INSERT,UPDATE
AS
IF UPDATE(Amount) OR Update(TransactionType)
BEGIN
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance -
ISNULL((SELECT CASE WHEN CreditType = 0
THEN d.Amount * -1
ELSE d.Amount
END
FROM DELETED d
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = d.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN DELETED d ON d.CustomerId = c.CustomerId
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance +
ISNULL((SELECT CASE WHEN CreditType = 0
THEN i.Amount * -1
ELSE i.Amount
END
FROM INSERTED i
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = i.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN INSERTED i ON i.CustomerId = c.CustomerId
RAISERROR ('We have completed an update',10,1)
END
ELSE
RAISERROR ('Updates have been skipped',10,1)


/* Try It Out - UPDATE() - Step 8 */
SELECT *
FROM TransactionDetails.Transactions
WHERE TransactionId=5
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1
UPDATE TransactionDetails.Transactions
SET DateEntered = DATEADD(dd,-1,DateEntered)
WHERE TransactionId = 5
SELECT *
FROM TransactionDetails.Transactions
WHERE TransactionId=5
SELECT ClearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1


/* Try It Out - COLUMNS_UPDATED() - Step 1 */
ALTER TRIGGER TransactionDetails.trgInsTransactions
ON TransactionDetails.Transactions
AFTER UPDATE,INSERT
AS
IF (SUBSTRING(COLUMNS_UPDATED(),1,1) = power(2,(3-1))
OR SUBSTRING(COLUMNS_UPDATED(),1,1) = power(2,(5-1)))
BEGIN
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance -
ISNULL((SELECT CASE WHEN CreditType = 0
THEN d.Amount * -1
ELSE d.Amount
END
FROM DELETED d
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = d.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN DELETED d ON d.CustomerId = c.CustomerId
UPDATE CustomerDetails.Customers
SET ClearedBalance = ClearedBalance +
ISNULL((SELECT CASE WHEN CreditType = 0
THEN i.Amount * -1
ELSE i.Amount
END
FROM INSERTED i
JOIN TransactionDetails.TransactionTypes tt
ON tt.TransactionTypeId = i.TransactionType
WHERE AffectCashBalance = 1),0)
FROM CustomerDetails.Customers c
JOIN INSERTED i ON i.CustomerId = c.CustomerId
RAISERROR ('We have completed an update ',10,1)
END
ELSE
RAISERROR ('Updates have been skipped',10,1)

/* Try It Out - DDL Trigger - Step 1 */
CREATE TRIGGER trgSprocs
ON DATABASE
FOR CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE
AS
IF DATEPART(hh,GETDATE()) > 9 AND DATEPART(hh,GETDATE()) < 17
BEGIN
DECLARE @Message nvarchar(max)
SELECT @Message =
'Completing work during core hours. Trying to release - '
+ EVENTDATA().value
('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
RAISERROR (@Message, 16, 1)
ROLLBACK
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SQL Server Database Mail Profile',
@recipients = 'robin@fat-belly.com',
@body = 'A stored procedure change',
@subject = 'A stored procedure change has been initiated and rolled back
during core hours'
END

/* Try It Out - DDL Trigger - Step 2 */
CREATE PROCEDURE Test1
AS
SELECT 'Hello all'

/* Try It Out - DDL Trigger - Step 4 */
DROP TRIGGER trgSprocs ON DATABASE

/* Try It Out - DDL Trigger - Step 5 */
CREATE TRIGGER trgDBDump
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
SELECT EVENTDATA()

/* Try It Out - DDL Trigger - Step 6 */
CREATE PROCEDURE Test1
AS
SELECT 'Hello all'
