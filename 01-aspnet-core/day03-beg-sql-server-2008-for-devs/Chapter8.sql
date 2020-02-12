/* Chapter 8 */

/* Try it out - Query Editor Scripting - Step 5 */
SET QUOTED_IDENTIFIER OFF
GO
INSERT INTO [ApressFinancial].[ShareDetails].[Shares]
([ShareDesc]
,[ShareTickerId]
,[CurrentPrice])
VALUES
("ACME'S HOMEBAKE COOKIES INC",
'AHCI',
2.34125)


/* Try it out - NULL Values and SQL Server Management Studio Compared to T-SQL - Step 7 */
USE ApressFinancial
GO
INSERT INTO CustomerDetails.Customers (CustomerTitleId) VALUES ('Mr')

/* Try it out - NULL Values and SQL Server Management Studio Compared to T-SQL - Step 9 */
USE ApressFinancial
GO
INSERT INTO CustomerDetails.Customers (CustomerTitleId) VALUES (1)

/* Try it out - NULL Values and SQL Server Management Studio Compared to T-SQL - Step 11 */
INSERT INTO CustomerDetails.Customers
(CustomerTitleId,CustomerLastName,CustomerFirstName,
CustomerOtherInitials,AddressId,AccountNumber,AccountType,
ClearedBalance,UnclearedBalance)
VALUES (3,'Mason','Jack',NULL,145,53431993,1,437.97,-10.56)


/* DBCC CHECKIDENT */
DELETE FROM CustomerDetails.Customers
DBCC CHECKIDENT('CustomerDetails.Customers',RESEED,0)
INSERT INTO CustomerDetails.Customers
(CustomerTitleId,CustomerFirstName,CustomerOtherInitials,
CustomerLastName,AddressId,AccountNumber,AccountType,
ClearedBalance,UnclearedBalance)
VALUES (1,'Robin',NULL,'Dewson',1333, 18176111,1,200.00,2.00)
INSERT INTO CustomerDetails.Customers
(CustomerTitleId,CustomerLastName,CustomerFirstName,
CustomerOtherInitials,AddressId,AccountNumber,AccountType,
ClearedBalance,UnclearedBalance)
VALUES (3,'Mason','Jack',NULL,145,53431993,1,437.97,-10.56)


/* Try it out - Altering a Table for a Default Value in Query Editor - Step 1 */

USE ApressFinancial
GO
ALTER TABLE CustomerDetails.CustomerProducts
ADD CONSTRAINT PK_CustomerProducts
PRIMARY KEY CLUSTERED
(CustomerFinancialProductId) ON [PRIMARY]
GO

/* Try it out - Altering a Table for a Default Value in Query Editor - Step 2 */
ALTER TABLE CustomerDetails.CustomerProducts
WITH NOCHECK
ADD CONSTRAINT CK_CustProds_AmtCheck
CHECK ((AmountToCollect > 0))
GO

/* Try it out - Altering a Table for a Default Value in Query Editor - Step 3 */
ALTER TABLE CustomerDetails.CustomerProducts WITH NOCHECK
ADD CONSTRAINT DF_CustProd_Renewable
DEFAULT (0)
FOR Renewable

/* Try it out - Altering a Table for a Default Value in Query Editor - Step 11 */

INSERT INTO CustomerDetails.CustomerProducts
(CustomerId,FinancialProductId,AmountToCollect,Frequency,
LastCollected,LastCollection,Renewable)
VALUES (1,1,-100,0,'24 Aug 2005','24 Aug 2008',0)

/* Try it out - Altering a Table for a Default Value in Query Editor - Step 13 */
INSERT INTO CustomerDetails.CustomerProducts
(CustomerId,FinancialProductId,AmountToCollect,Frequency,
LastCollected,LastCollection)
VALUES (1,1,100,0,'24 Aug 2008','23 Aug 2008')


/* Try it out - Insert Several Records At Once - Step 1 */

INSERT INTO CustomerDetails.Customers
(CustomerTitleId,CustomerFirstName,CustomerOtherInitials,
CustomerLastName,AddressId,AccountNumber,AccountType,
ClearedBalance,UnclearedBalance)
VALUES (3,'Bernie','I','McGee',314,65368765,1,6653.11,0.00),
(2,'Julie','A','Dewson',2134,81625422,1,53.32,-12.21),
(1,'Kirsty',NULL,'Hull',4312,96565334,1,1266.00,10.32)


/* Try it out - The First Set of Searches - Step 1 */
Select * From CustomerDetails.Customers

/* Try it out - The First Set of Searches - Step 3 */
SELECT CustomerFirstName,CustomerLastName,ClearedBalance
FROM CustomerDetails.Customers

/* Try it out - The First Set of Searches - Step 5 */
SELECT CustomerFirstName As 'First Name',
CustomerLastName AS 'Surname',
ClearedBalance Balance
FROM CustomerDetails.Customers

/* Try it out - Putting the Results in Text and a File - Step 2 */
SELECT CustomerFirstName As 'First Name',
CustomerLastName AS 'Surname',
ClearedBalance Balance
FROM CustomerDetails.Customers


/* Try it out - The WHERE Statement - Step 1 */
INSERT INTO ShareDetails.Shares
(ShareDesc, ShareTickerId,CurrentPrice)
VALUES ('FAT-BELLY.COM','FBC',45.20),
('NetRadio Inc','NRI',29.79),
('Texas Oil Industries','TOI',0.455),
('London Bridge Club','LBC',1.46)

/* Try it out - The WHERE Statement - Step 2 */
SELECT ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE ShareDesc = 'FAT-BELLY.COM'

/* Try it out - The WHERE Statement - Step 5 */
SELECT ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE ShareDesc > 'FAT-BELLY.COM'
AND ShareDesc < 'TEXAS OIL INDUSTRIES'

/* Try it out - The WHERE Statement - Step 7 */
SELECT ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE ShareDesc <> 'FAT-BELLY.COM'
SELECT ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE NOT ShareDesc = 'FAT-BELLY.COM'

/* Try it out - SET ROWCOUNT - Step 1 */
SET ROWCOUNT 3
SELECT * FROM ShareDetails.Shares
SET ROWCOUNT 0
SELECT * FROM ShareDetails.Shares

/* Try it out - TOP n - Step 1 */
SELECT TOP 3 * FROM ShareDetails.Shares
SET ROWCOUNT 3
SELECT TOP 2 * FROM ShareDetails.Shares
SET ROWCOUNT 2
SELECT TOP 3 * FROM ShareDetails.Shares
SET ROWCOUNT 0

/* Try it out - String Functions - Step 1 */
SELECT CustomerFirstName + ' ' + CustomerLastName AS 'Name',
ClearedBalance Balance
FROM CustomerDetails.Customers

/* Try it out - String Functions - Step 3 */
SELECT LEFT(CustomerFirstName + ' ' + CustomerLastName,50) AS 'Name',
ClearedBalance Balance
FROM CustomerDetails.Customers

/* Try it out - String Functions - Step 5 */
SELECT RTRIM(CustomerFirstName + ' ' + CustomerLastName) AS 'Name',
ClearedBalance Balance
FROM CustomerDetail.Customers

/* Try it out - Altering the Order - Step 1 */
SELECT LEFT(CustomerFirstName + ' ' + CustomerLastName,50) AS 'Name',
ClearedBalance Balance
FROM CustomerDetails.Customers
ORDER BY Balance

/* Try it out - Altering the Order - Step 3 */
SELECT LEFT(CustomerFirstName + ' ' + CustomerLastName,50) AS 'Name',
ClearedBalance Balance
FROM CustomerDetails.Customers

/* Try it out - The LIKE Operator - Step 1 */
SELECT CustomerFirstName + ' ' + CustomerLastName
FROM CustomerDetails.Customers
WHERE CustomerLastName LIKE '%Gee'
ORDER BY Balance DESC

/* Try it out - The LIKE Operator - Step 3 */
SELECT CustomerFirstName + ' ' + CustomerLastName AS [Name]
FROM CustomerDetails.Customers
WHERE CustomerFirstName + ' ' + CustomerLastName LIKE '%n%'

/* Try it out - The LIKE Operator - Step 5 */
SELECT CustomerFirstName + ' ' + CustomerLastName AS [Name]
FROM CustomerDetails.Customers
WHERE [Name] LIKE '%n%'

/* Try it out - SELECT INTO - Step 1 */
SELECT CustomerFirstName + ' ' + CustomerLastName AS [Name],
ClearedBalance,UnclearedBalance
INTO CustTemp
FROM CustomerDetails.Customers

/* Try it out - Updating a Row of Data - Step 1 */
USE ApressFinancial
GO
UPDATE CustomerDetails.Customers
SET CustomerLastName = 'Brodie'
WHERE CustomerId = 1

/* Try it out - Updating a Row of Data - Step 3 */
SELECT * FROM CustomerDetails.Customers
WHERE CustomerId = 1

/* Try it out - Updating a Row of Data - Step 5 */
DECLARE @ValueToUpdate VARCHAR(30)
SET @ValueToUpdate = 'McGlynn'
UPDATE CustomerDetails.Customers
SET CustomerLastName = @ValueToUpdate,
ClearedBalance = ClearedBalance + UnclearedBalance ,
UnclearedBalance = 0
WHERE CustomerLastName = 'Brodie'

/* Try it out - Updating a Row of Data - Step 7 */
SELECT CustomerFirstName, CustomerLastName,
ClearedBalance, UnclearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1

/* Try it out - Updating a Row of Data - Step 8 */
DECLARE @WrongDataType VARCHAR(20)
SET @WrongDataType = '4311.22'
UPDATE CustomerDetails.Customers
SET ClearedBalance = @WrongDataType
WHERE CustomerId = 1

/* Try it out - Updating a Row of Data - Step 10 */
SELECT CustomerFirstName, CustomerLastName,
ClearedBalance, UnclearedBalance
FROM CustomerDetails.Customers
WHERE CustomerId = 1

/* Try it out - Updating a Row of Data - Step 11 */
DECLARE @WrongDataType VARCHAR(20)
SET @WrongDataType = '2.0'
UPDATE CustomerDetails.Customers
SET AddressId = @WrongDataType
WHERE CustomerId = 1

/* Try it out - Using a Transaction - Step 1 */
SELECT 'Before',ShareId,ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE ShareId = 3
BEGIN TRAN ShareUpd
UPDATE ShareDetails.Shares
SET CurrentPrice = CurrentPrice * 1.1
WHERE ShareId = 3
COMMIT TRAN
SELECT 'After',ShareId,ShareDesc,CurrentPrice
FROM ShareDetails.Shares
WHERE ShareId = 3

/* Try it out - Using a Transaction - Step 3 */
SELECT 'Before',ShareId,ShareDesc,CurrentPrice
FROM ShareDetails.Shares
-- WHERE ShareId = 3
BEGIN TRAN ShareUpd
UPDATE ShareDetails.Shares
SET CurrentPrice = CurrentPrice * 1.1
-- WHERE ShareId = 3
SELECT 'Within the transaction',ShareId,ShareDesc,CurrentPrice
FROM ShareDetails.Shares
ROLLBACK TRAN
SELECT 'After',ShareId,ShareDesc,CurrentPrice
FROM ShareDetails.Shares
-- WHERE ShareId = 3

/* Nested Tramsactopms */
BEGIN TRAN ShareUpd
SELECT '1st TranCount',@@TRANCOUNT
BEGIN TRAN ShareUpd2
SELECT '2nd TranCount',@@TRANCOUNT
COMMIT TRAN ShareUpd2
SELECT '3rd TranCount',@@TRANCOUNT
COMMIT TRAN -- It is at this point that data modifications will be committed
SELECT 'Last TranCount',@@TRANCOUNT

/* Try it out - Deleting Records - Step 1 */
BEGIN TRAN
SELECT * FROM CustTemp
DELETE CustTemp
SELECT * FROM CustTemp
ROLLBACK TRAN
SELECT * FROM CustTemp

/* Try it out - Deleting Records - Step 3 */
BEGIN TRAN
SELECT * FROM CustTemp
DELETE TOP (3) CustTemp
SELECT * FROM CustTemp
ROLLBACK TRAN
SELECT * FROM CustTemp