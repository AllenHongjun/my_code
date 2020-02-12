/* Chapter 5 */

/* Try it out - Defining a Table Through Query Editor - Step 2 */

CREATE TABLE TransactionDetails.Transactions
(TransactionId bigint IDENTITY(1,1) NOT NULL,
CustomerId bigint NOT NULL,
TransactionType int NOT NULL,
DateEntered datetime NOT NULL,
Amount numeric(18, 5) NOT NULL,
ReferenceDetails nvarchar(50) NULL,
Notes nvarchar(max) NULL,
RelatedShareId bigint NULL,
RelatedProductId bigint NOT NULL)


/* Try it out - Creating a Table Using a Template - Step 5 */

-- =========================================
-- Create table template
-- =========================================
USE ApressFinancial
GO
IF OBJECT_ID('TransactionDetails.TransactionTypes', 'U') IS NOT NULL
DROP TABLE TransactionDetails.TransactionTypes
GO
CREATE TABLE TransactionDetails.TransactionTypes(
TransactionTypeId int IDENTITY(1,1) NOT NULL,
TransactionDescription nvarchar(30) NOT NULL,
CreditType bit NOT NULL
)
GO


/* Try it out - Adding a Column  - Step 1 */
ALTER TABLE TransactionDetails.TransactionTypes
ADD AffectCashBalance bit NULL
GO

/* Try it out - Adding a Column  - Step 2 */
ALTER TABLE TransactionDetails.TransactionTypes
ALTER COLUMN AffectCashBalance bit NOT NULL
GO

/* Defining the remaining tables */
USE ApressFinancial
GO
CREATE TABLE CustomerDetails.CustomerProducts(
CustomerFinancialProductId bigint IDENTITY(1,1) NOT NULL,
CustomerId bigint NOT NULL,
FinancialProductId bigint NOT NULL,
AmountToCollect money NOT NULL,
Frequency smallint NOT NULL,
LastCollected datetime NOT NULL,
LastCollection datetime NOT NULL,
Renewable bit NOT NULL
)
ON [PRIMARY]
GO
CREATE TABLE CustomerDetails.FinancialProducts(
ProductId bigint IDENTITY(1,1) NOT NULL,
ProductName nvarchar(50) NOT NULL
) ON [PRIMARY]
GO
CREATE TABLE ShareDetails.SharePrices(
SharePriceId bigint IDENTITY(1,1) NOT NULL,
ShareId bigint NOT NULL,
Price numeric(18, 5) NOT NULL,
PriceDate datetime NOT NULL
) ON [PRIMARY]
GO
CREATE TABLE ShareDetails.Shares(
ShareId bigint IDENTITY(1,1) NOT NULL,
ShareDesc nvarchar(50) NOT NULL,
ShareTickerId nvarchar(50) NULL,
CurrentPrice numeric(18, 5) NOT NULL
) ON [PRIMARY]
GO

/* Try it out - Building a Relationship - Step 1 */
ALTER TABLE CustomerDetails.Customers
ADD CONSTRAINT
PK_Customers PRIMARY KEY NONCLUSTERED
(
CustomerId
)
WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


/* Try it out - Using SQL to Build a Relationship - Step 1 */

USE ApressFinancial
GO
ALTER TABLE TransactionDetails.Transactions
WITH NOCHECK
ADD CONSTRAINT FK_Transactions_Shares
FOREIGN KEY(RelatedShareId)
REFERENCES ShareDetails.Shares(ShareId)