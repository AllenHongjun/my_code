/* Chapter 12 */



/* Subqueries - 1 */
ALTER TABLE ShareDetails.Shares
ADD MaximumSharePrice money
DECLARE @MaxPrice money
SELECT @MaxPrice = MAX(Price)
FROM ShareDetails.SharePrices
WHERE ShareId = 1
SELECT @MaxPrice
UPDATE ShareDetails.Shares
SET MaximumSharePrice = @MaxPrice
WHERE ShareId = 1


/* Subqueries - 2 */
SELECT ShareId,MaximumSharePrice
FROM ShareDetails.Shares
UPDATE ShareDetails.Shares
SET MaximumSharePrice = (SELECT MAX(SharePrice)
FROM ShareDetails.SharePrices sp
WHERE sp.ShareId = s.ShareId)
FROM ShareDetails.Shares s
SELECT ShareId,MaximumSharePrice
FROM ShareDetails.Shares

/* Subqueries - 3 */
DECLARE @BackupSet AS INT
SELECT @BackupSet = position
FROM msdb..backupset
WHERE database_name='ApressFinancial'
AND backup_set_id=
(SELECT MAX(backup_set_id)
FROM msdb..backupset s
WHERE database_name='ApressFinancial')
IF @BackupSet IS NULL
BEGIN
RAISERROR('Verify failed. Backup information for database
''ApressFinancial'' not found.', 16, 1)
END
RESTORE VERIFYONLY
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL.10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial\ApressFinancial_backup_200808061136.bak'
WITH FILE = @BackupSet,
NOUNLOAD,
NOREWIND

/* IN 1 */
SELECT *
FROM ShareDetails.Shares
WHERE ShareId IN (1,3,5)

/* IN 2 */
SELECT *
FROM ShareDetails.Shares
WHERE ShareId IN (SELECT ShareId
FROM ShareDetails.Shares
WHERE CurrentPrice > (SELECT MIN(CurrentPrice)
FROM ShareDetails.Shares)
AND CurrentPrice < (SELECT MAX(CurrentPrice)
FROM ShareDetails.Shares))

/* IN 3 */
SELECT *
FROM ShareDetails.Shares
WHERE ShareId = 1
OR ShareId = 3
OR ShareId = 5

/* EXISTS */
SELECT *
FROM ShareDetails.Shares s
WHERE NOT EXISTS (SELECT *
FROM TransactionDetails.Transactions t
WHERE t.RelatedShareId = s.ShareId)

/* Try It Out - Using a Scalar Function with Subqueries Step 1 to 3 */
SELECT t1.TransactionId, t1.DateEntered,t1.Amount,
(SELECT MIN(DateEntered)
FROM TransactionDetails.Transactions t2
WHERE t2.CustomerId = t1.CustomerId
AND t2.DateEntered> t1.DateEntered) as 'To Date',
TransactionDetails.fn_IntCalc(10,t1.Amount,t1.DateEntered,
(SELECT MIN(DateEntered)
FROM TransactionDetails.Transactions t2
WHERE t2.CustomerId = t1.CustomerId
AND t2.DateEntered> t1.DateEntered)) AS 'Interest Earned'
FROM TransactionDetails.Transactions t1
WHERE CustomerId = 1

/* Try It Out - Table Function and CROSS APPLY - Step 1 */
CREATE FUNCTION TransactionDetails.ReturnTransactions
(@CustId bigint) RETURNS @Trans TABLE
(TransactionId bigint,
CustomerId bigint,
TransactionDescription nvarchar(30),
DateEntered datetime,
Amount money)
AS
BEGIN
INSERT INTO @Trans
SELECT TransactionId, CustomerId, TransactionDescription,
DateEntered, Amount
FROM TransactionDetails.Transactions t
JOIN TransactionDetails.TransactionTypes tt ON
tt.TransactionTypeId = t.TransactionType
WHERE CustomerId = @CustId
RETURN
END
GO

/* Try It Out - Table Function and CROSS APPLY - Step 2 */
SELECT c.CustomerFirstName, CustomerLastName,
Trans.TransactionId,TransactionDescription,
DateEntered,Amount
FROM CustomerDetails.Customers AS c
CROSS APPLY
TransactionDetails.ReturnTransactions(c.CustomerId)
AS Trans

/* Try It Out - Common Table Expressions - Example 1 */
USE AdventureWorks
GO
SELECT p.ProductSubcategoryID, s.Name,SUM(ListPrice) AS ListPrice
INTO #Temp1
FROM Production.Product p
JOIN Production.ProductSubcategory s ON s.ProductSubcategoryID =
p.ProductSubcategoryID
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID, s.Name
SELECT ProductSubcategoryID,Name,MAX(ListPrice)
FROM #Temp1
GROUP BY ProductSubcategoryID, Name
HAVING MAX(ListPrice) = (SELECT MAX(ListPrice) FROM #Temp1)
DROP TABLE #Temp1

/* Try It Out - Common Table Expressions - Example 2 */
WITH ProdList (ProductSubcategoryID,Name,ListPrice) AS
(
SELECT p.ProductSubcategoryID, s.Name,SUM(ListPrice) AS ListPrice
FROM Production.Product p
JOIN Production.ProductSubcategory s ON s.ProductSubcategoryID =
p.ProductSubcategoryID
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID, s.Name
)
SELECT ProductSubcategoryID,Name,MAX(ListPrice)
FROM ProdList
GROUP BY ProductSubcategoryID, Name
HAVING MAX(ListPrice) = (SELECT MAX(ListPrice) FROM ProdList)

/* Try It Out - Recursive CTE - Example */
USE AdventureWorks;
GO
WITH EmployeeReportingStructure
(ManagerID, EmployeeID, EmployeeLevel, Level,
ManagerContactId,ManagerTitle,ManagerFirst,ManagerLast,
EmployeeTitle,EmployeeFirst,EmployeeLast)
AS
(
-- Anchor member definition
SELECT e.ManagerID, e.EmployeeID, e.Title as EmployeeLevel,
0 AS Level,
e.ContactId as ManagerContactId,
CAST(' ' as nvarchar(8)) as ManagerTitle,
CAST(' ' as nvarchar(50)) as ManagerFirst,
CAST(' ' as nvarchar(50)) as ManagerLast,
c.Title as EmployeeTitle,c.FirstName as EmployeeFirst,
c.LastName as EmployeeLast
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact c ON c.ContactId = e.ContactId
WHERE ManagerID IS NULL
UNION ALL
-- Recursive member definition
SELECT e.ManagerID, e.EmployeeID, e.Title as EmployeeLevel, Level + 1,
e.ContactId as ManagerContactId,
m.Title as ManagerTitle,m.FirstName as ManagerFirst,
m.LastName as ManagerLast,
c.Title as EmployeeTitle,c.FirstName as EmployeeFirst,
c.LastName as EmployeeLast
FROM HumanResources.Employee AS e
INNER JOIN Person.Contact c ON c.ContactId = e.ContactId
INNER JOIN EmployeeReportingStructure AS d
ON d.EmployeeID = e.ManagerID
INNER JOIN Person.Contact m ON m.ContactId = d.ManagerContactId
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID,
ISNULL(ManagerTitle+' ','')+ManagerFirst+' '+ManagerLast as Manager,
EmployeeLevel,
ISNULL(EmployeeTitle+' ','')+EmployeeFirst+' '+EmployeeLast as Employee,
Level
FROM EmployeeReportingStructure
ORDER BY Level,EmployeeLast,EmployeeFirst
OPTION (MAXRECURSION 4)

/* Try It Out - Pivot - Example 1 */
USE AdventureWorks
GO
SELECT productID,UnitPriceDiscount,SUM(linetotal)
FROM Sales.SalesOrderDetail
WHERE productID IN (776,711,747)
GROUP BY productID,UnitPriceDiscount
ORDER BY productID,UnitPriceDiscount

/* Try It Out - Pivot - Example 2 */
SELECT pt.Discount,ISNULL([711],0.00) As Product711,
ISNULL([747],0.00) As Product747,ISNULL([776],0.00) As Product776
FROM
(SELECT sod.LineTotal, sod.ProductID, sod.UnitPriceDiscount as Discount
FROM Sales.SalesOrderDetail sod) so
PIVOT
(
SUM(so.LineTotal)
FOR so.ProductID IN ([776], [711], [747])
) AS pt
ORDER BY pt.Discount

/* Try It Out - UnPivot - Example 1 */
USE AdventureWorks
go
SELECT pt.Discount,ISNULL([711],0.00) As Product711,
ISNULL([747],0.00) As Product747,ISNULL([776],0.00) As Product776
INTO #Temp1
FROM
(SELECT sod.LineTotal, sod.ProductID, sod.UnitPriceDiscount as Discount
FROM Sales.SalesOrderDetail sod) so
PIVOT
(
SUM(so.LineTotal)
FOR so.ProductID IN ([776], [711], [747])
) AS pt
ORDER BY pt.Discount

/* Try It Out - UnPivot - Example 2 */
SELECT ProductID,Discount, DiscountAppl
FROM (SELECT Discount, product711, Product747, Product776
FROM #Temp1) up1
UNPIVOT ( DiscountAppl FOR ProductID
IN (Product711, Product747, Product776)) As upv2
WHERE DiscountAppl <> 0
ORDER BY ProductID

/* Try It Out - Ranking - Example */
WITH OrderedOrders AS
(SELECT SalesOrderID, OrderDate,
ROW_NUMBER() OVER (order by OrderDate)as RowNumber
FROM Sales.SalesOrderHeader )
SELECT *
FROM OrderedOrders
WHERE RowNumber between 50 and 60;

/* Try It Out - RowNumber - Example 1 */
USE AdventureWorks
GO
SELECT ROW_NUMBER() OVER(ORDER BY LastName) AS RowNum,
FirstName + ' ' + LastName
FROM HumanResources.vEmployee
WHERE JobTitle = 'Production Technician - WC60'
ORDER BY LastName

/* Try It Out - RowNumber - Example 2 */
USE AdventureWorks
GO
SELECT ROW_NUMBER()
OVER(PARTITION BY SUBSTRING(LastName,1,1)
ORDER BY LastName) AS RowNum, FirstName + ' ' + LastName
FROM HumanResources.vEmployee
WHERE JobTitle = 'Production Technician - WC60'
ORDER BY LastName

/* Try It Out - Ranking - Example */
USE AdventureWorks
GO
SELECT ROW_NUMBER() OVER(ORDER BY Department) AS RowNum,
RANK() OVER(ORDER BY Department) AS Ranking,
FirstName + ' ' + LastName AS Employee, Department
FROM HumanResources.vEmployeeDepartment
ORDER BY RowNum

/* Try It Out - Dense_Rank - Example */
USE AdventureWorks
GO
SELECT ROW_NUMBER() OVER(ORDER BY Department) AS RowNum,
DENSE_RANK() OVER(ORDER BY Department) AS Ranking,
CONVERT(varchar(25),FirstName + ' ' + LastName), Department
FROM HumanResources.vEmployeeDepartment
ORDER BY RowNum

/* Try It Out - NTile - Example */
USE AdventureWorks
GO
SELECT NTILE(10) OVER(ORDER BY Department) AS NTile,
FirstName + ' ' + LastName, Department
FROM HumanResources.vEmployeeDepartment

/* Try It Out - PowerShell - Step 3 */
get-help * > c:\users\rdewson\documents\powershell\powershell.txt

/* Try It Out - PowerShell - Step 4 */
get-help –detailed get-date > c:\users\rdewson\documents\powershell\get-date.txt

/* Try It Out - PowerShell - Step 5 */
get-date -DisplayHint time

/* Try It Out - PowerShell - Step 7 */
invoke-sqlcmd -query
"SELECT CustomerFirstName + ' ' + CustomerLastName
FROM CustomerDetails.Customers" -serverinstance "FAT-BELLY"

/* Try It Out - PowerShell - Step 8 */
SELECT CustomerFirstName + ' ' + CustomerLastName
FROM CustomerDetails.Customers
SELECT 'Query2'
SELECT CustomerFirstName + ' ' + CustomerLastName
FROM CustomerDetails.Customers
WHERE customerid > 1
DECLARE @return_value int,
@ClearedBalance money,
@UnclearedBalance money
EXEC @return_value = [CustomerDetails].[apf_CustBalances]
@CustId = 1,
@ClearedBalance = @ClearedBalance OUTPUT,
@UnclearedBalance = @UnclearedBalance OUTPUT
SELECT @ClearedBalance

/* Try It Out - PowerShell - Step 9 */
invoke-sqlcmd -inputfile "c:\users\rdewson\documents\powershell\
invoke-cmd-ex.sql" | out-file -filepath c:\users\rdewson\documents\
powershell\multipleoutput.txt"

/* Try It Out - PowerShell - Step 10 */
SELECT CustomerFirstName + ' ' + CustomerLastName AS 'Name'
FROM CustomerDetails.Customers
SELECT 'Query2'
SELECT CustomerFirstName + ' ' + CustomerLastName AS 'AnotherName'
FROM CustomerDetails.Customers
WHERE customerid > 1
DECLARE @return_value int,
@ClearedBalance money,
@UnclearedBalance money
EXEC @return_value = [CustomerDetails].[apf_CustBalances]
@CustId = 1,
@ClearedBalance = @ClearedBalance OUTPUT,
@UnclearedBalance = @UnclearedBalance OUTPUT
SELECT @ClearedBalance