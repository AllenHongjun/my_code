/* Chapter 9 */


/* Try it out - Creating a View with a View - Step 11 */
USE ApressFinancial
GO
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.155,'1 Aug 2008 10:10AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.2125,'1 Aug 2008 10:12AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.4175,'1 Aug 2008 10:16AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.21,'1 Aug 2008 11:22AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.17,'1 Aug 2008 14:54')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (1,2.34125,'1 Aug 2008 16:10')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (2,41.10,'1 Aug 2008 10:10AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (2,43.22,'2 Aug 2008 10:10AM')
INSERT INTO ShareDetails.SharePrices (ShareId, Price, PriceDate)
VALUES (2,45.20,'3 Aug 2008 10:10AM')

/* Try it out - Creating a View in a Query Editor pane - Step 1 */
SELECT c.AccountNumber,c.CustomerFirstName,c.CustomerOtherInitials,
tt.TransactionDescription,t.DateEntered,t.Amount,t.ReferenceDetails
FROM CustomerDetails.Customers c
JOIN TransactionDetails.Transactions t ON t.CustomerId = c.CustomerId
JOIN TransactionDetails.TransactionTypes tt ON
tt.TransactionTypeId = t.TransactionType
ORDER BY c.AccountNumber ASC, t.DateEntered DESC

/* Try it out - Creating a View in a Query Editor pane - Step 3 */
CREATE VIEW CustomerDetails.vw_CustTrans
AS
SELECT TOP 100 PERCENT
c.AccountNumber,c.CustomerFirstName,c.CustomerOtherInitials,
tt.TransactionDescription,t.DateEntered,t.Amount,t.ReferenceDetails
FROM CustomerDetails.Customers c
JOIN TransactionDetails.Transactions t ON t.CustomerId = c.CustomerId
JOIN TransactionDetails.TransactionTypes tt ON
tt.TransactionTypeId = t.TransactionType
ORDER BY c.AccountNumber ASC, t.DateEntered DESC

/* Try it out - Creating a View with SCHEMABINDING - Step 1 */
SELECT c.CustomerFirstName + ' ' + c.CustomerLastName AS CustomerName,
c.AccountNumber, fp.ProductName, cp.AmountToCollect, cp.Frequency,
cp.LastCollected
FROM CustomerDetails.Customers c
JOIN CustomerDetails.CustomerProducts cp ON cp.CustomerId = c.CustomerId
JOIN CustomerDetails.FinancialProducts fp ON
fp.ProductId = cp.FinancialProductId

/* Try it out - Creating a View with SCHEMABINDING - Step 2 */
INSERT INTO CustomerDetails.FinancialProducts (ProductId,ProductName)
VALUES (1,'Regular Savings'),
(2,'Bonds Account'),
(3,'Share Account'),
(4,'Life Insurance')
INSERT INTO CustomerDetails.CustomerProducts
(CustomerId,FinancialProductId,
AmountToCollect,Frequency,LastCollected,LastCollection,Renewable)
VALUES (1,1,200,1,'31 October 2008','31 October 2025',0),
(1,2,50,1,'24 October 2008','24 March 2009',0),
(2,4,150,3,'20 October 2008','20 October 2008',1),
(3,3,500,0,'24 October 2008','24 October 2008',0)

/* Try it out - Creating a View with SCHEMABINDING - Step 4 */
IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = N'vw_CustFinProducts'
AND TABLE_SCHEMA = N'CustomerDetails')
DROP VIEW CustomerDetails.vw_CustFinProducts
GO
CREATE VIEW CustomerDetails.vw_CustFinProducts WITH SCHEMABINDING
AS
SELECT c.CustomerFirstName + ' ' + c.CustomerLastName AS CustomerName,
c.AccountNumber, fp.ProductName, cp.AmountToCollect, cp.Frequency,
cp.LastCollected
FROM CustomerDetails.Customers c
JOIN CustomerDetails.CustomerProducts cp ON cp.CustomerId = c.CustomerId
JOIN CustomerDetails.FinancialProducts fp ON
fp.ProductId = cp.FinancialProductId


/* Try it out - Creating a View with SCHEMABINDING - Step 6 */
ALTER TABLE CustomerDetails.Customers
ALTER COLUMN CustomerFirstName nvarchar(100)

/* Try it out - xing a View - Predicate */
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET CONCAT_NULL_YIELDS_NULL ON
SET ARITHABORT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF

/* Try it out - xing a View - Step 1 */
CREATE UNIQUE CLUSTERED INDEX ix_CustFinProds
ON CustomerDetails.vw_CustFinProducts (AccountNumber,ProductName)

/* Try it out - xing a View - Step 4 */
USE [ApressFinancial]
GO
/****** Object: View [CustomerDetails].[vw_CustFinProducts]
Script Date: 08/07/2008 12:31:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP VIEW CustomerDetails.vw_CustFinProducts
GO
CREATE VIEW [CustomerDetails].[vw_CustFinProducts] WITH SCHEMABINDING
AS
SELECT c.CustomerFirstName + ' ' + c.CustomerLastName AS CustomerName,
c.AccountNumber, fp.ProductName, cp.AmountToCollect,
cp.Frequency, cp.LastCollected
FROM CustomerDetails.Customers c
JOIN CustomerDetails.CustomerProducts cp ON cp.CustomerId = c.CustomerId
JOIN CustomerDetails.FinancialProducts fp ON
fp.ProductId = cp.FinancialProductId
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF