/* Chapter 6 */

/* Try it out - Using a Query Editor Template to Build an Index - Step 5 */

USE ApressFinancial
GO
CREATE INDEX IX_CustomerProducts
ON CustomerDetails.CustomerProducts
(
CustomerId
)
GO

/* Try it out - Creating an Index with Query Editor - Step 1 */
USE ApressFinancial
GO
CREATE UNIQUE CLUSTERED INDEX IX_TransactionTypes
ON TransactionDetails.TransactionTypes
(
TransactionTypeId ASC )
WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
ON [PRIMARY]
GO

/* Try it out - Creating an Index with Query Editor - Step 2 */
CREATE NONCLUSTERED INDEX IX_Transactions_TType
ON TransactionDetails.Transactions
(
TransactionType ASC)
WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
ON [PRIMARY]
GO

/* Try it out - Creating an Index with Query Editor - Step 3 */
ALTER TABLE TransactionDetails.TransactionTypes
ADD CONSTRAINT
PK_TransactionTypes PRIMARY KEY NONCLUSTERED
(
TransactionTypeId
)
WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO


/* Try it out - Dropping an Index in Query Editor - Step 1 */

USE ApressFinancial
GO
DROP INDEX IX_TransactionTypes ON TransactionDetails.TransactionTypes

/* Try it out - Dropping an Index in Query Editor - Step 2 */
CREATE UNIQUE CLUSTERED INDEX IX_TransactionTypes
ON TransactionDetails.TransactionTypes
(
TransactionTypeId ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
ON [PRIMARY]
GO

/* Try it out - Altering an Index in Query Editor - Step 1 */
USE ApressFinancial
GO
CREATE UNIQUE CLUSTERED INDEX IX_SharePrices
ON ShareDetails.SharePrices
(
ShareId ASC,
PriceDate ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
ON [PRIMARY]
GO

/* Try it out - Altering an Index in Query Editor - Step 2 */
CREATE UNIQUE CLUSTERED INDEX IX_SharePrices
ON ShareDetails.SharePrices
(
ShareId ASC,
PriceDate DESC,
Price
) WITH (STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,
DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS =
OFF, DROP_EXISTING = OFF) ON [PRIMARY]







