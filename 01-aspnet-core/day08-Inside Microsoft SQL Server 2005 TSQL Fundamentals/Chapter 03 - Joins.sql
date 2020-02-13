---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 3 - Joins
-- � 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- CROSS Joins
---------------------------------------------------------------------

-- ANSI SQL-92
USE TSQLFundamentals2008;

SELECT C.custid, E.empid
FROM Sales.Customers AS C
  CROSS JOIN HR.Employees AS E;

-- ANSI SQL-89
SELECT C.custid, E.empid
FROM Sales.Customers AS C, HR.Employees AS E;

-- Self Cross-Join
SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1 
  CROSS JOIN HR.Employees AS E2;
GO

-- All numbers from 1 - 1000

-- Auxiliary table of digits
USE tempdb;
IF OBJECT_ID('dbo.Digits', 'U') IS NOT NULL DROP TABLE dbo.Digits;
CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

/*
Note:
Above INSERT syntax is new in Microsoft SQL Server 2008.
In earlier versions use:

INSERT INTO dbo.Digits(digit) VALUES(0);
INSERT INTO dbo.Digits(digit) VALUES(1);
INSERT INTO dbo.Digits(digit) VALUES(2);
INSERT INTO dbo.Digits(digit) VALUES(3);
INSERT INTO dbo.Digits(digit) VALUES(4);
INSERT INTO dbo.Digits(digit) VALUES(5);
INSERT INTO dbo.Digits(digit) VALUES(6);
INSERT INTO dbo.Digits(digit) VALUES(7);
INSERT INTO dbo.Digits(digit) VALUES(8);
INSERT INTO dbo.Digits(digit) VALUES(9);
*/

SELECT digit FROM dbo.Digits;
GO

-- All numbers from 1 - 1000
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

---------------------------------------------------------------------
-- INNER Joins
---------------------------------------------------------------------

-- ANSI SQL-92
USE TSQLFundamentals2008;

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  JOIN Sales.Orders AS O
    ON E.empid = O.empid;

-- ANSI SQL-89
SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O
WHERE E.empid = O.empid;
GO

-- Inner Join Safety
SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
  JOIN Sales.Orders AS O;
GO

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E, Sales.Orders AS O;
GO

---------------------------------------------------------------------
-- Further Join Examples
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Composite Joins
---------------------------------------------------------------------

-- Audit table for updates against OrderDetails
USE TSQLFundamentals2008;
IF OBJECT_ID('Sales.OrderDetailsAudit', 'U') IS NOT NULL
  DROP TABLE Sales.OrderDetailsAudit;
CREATE TABLE Sales.OrderDetailsAudit
(
  lsn        INT NOT NULL IDENTITY,
  orderid    INT NOT NULL,
  productid  INT NOT NULL,
  dt         DATETIME NOT NULL,
  loginname  sysname NOT NULL,
  columnname sysname NOT NULL,
  oldval     SQL_VARIANT,
  newval     SQL_VARIANT,
  CONSTRAINT PK_OrderDetailsAudit PRIMARY KEY(lsn),
  CONSTRAINT FK_OrderDetailsAudit_OrderDetails
    FOREIGN KEY(orderid, productid)
    REFERENCES Sales.OrderDetails(orderid, productid)
);

SELECT OD.orderid, OD.productid, OD.qty,
  ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetails AS OD
  JOIN Sales.OrderDetailsAudit AS ODA
    ON OD.orderid = ODA.orderid
    AND OD.productid = ODA.productid
WHERE ODA.columnname = N'qty';

---------------------------------------------------------------------
-- Non-Equi Joins
---------------------------------------------------------------------

-- Unique pairs of employees
SELECT
  E1.empid, E1.firstname, E1.lastname,
  E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
  JOIN HR.Employees AS E2
    ON E1.empid < E2.empid;

---------------------------------------------------------------------
-- Multi-Table Joins
---------------------------------------------------------------------

SELECT
  C.custid, C.companyname, O.orderid,
  OD.productid, OD.qty
FROM Sales.Customers AS C
  JOIN Sales.Orders AS O
    ON C.custid = O.custid
  JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

---------------------------------------------------------------------
-- Fundamentals of Outer Joins 
---------------------------------------------------------------------

-- Customers and their orders, including customers with no orders
SELECT C.custid, C.companyname, O.orderid
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid;

-- Customers with no orders
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderid IS NULL;
GO

---------------------------------------------------------------------
-- Beyond the Fundamentals of Outer Joins
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Including Missing Values
---------------------------------------------------------------------

-- Listing 3-1: Code to Create and Populate the Auxiliary Table Nums
SET NOCOUNT ON;
USE TSQLFundamentals2008;
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);

DECLARE @i AS INT = 1;
/*
Note:
The ability to declare and initialize variables in one statement
is new in Microsoft SQL Server 2008.
In earlier versions use separate DECLARE and SET statements:

DECLARE @i AS INT;
SET @i = 1;
*/
BEGIN TRAN
  WHILE @i <= 100000
  BEGIN
    INSERT INTO dbo.Nums VALUES(@i);
    SET @i = @i + 1;
  END
COMMIT TRAN
SET NOCOUNT OFF;
GO

SELECT DATEADD(day, n-1, '20060101') AS orderdate
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20060101', '20081231') + 1
ORDER BY orderdate;

SELECT DATEADD(day, Nums.n - 1, '20060101') AS orderdate,
  O.orderid, O.custid, O.empid
FROM dbo.Nums
  LEFT OUTER JOIN Sales.Orders AS O
    ON DATEADD(day, Nums.n - 1, '20060101') = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20060101', '20081231') + 1
ORDER BY orderdate;

---------------------------------------------------------------------
-- Filtering Attributes from Non-Preserved Side of Outer Join
---------------------------------------------------------------------

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
WHERE O.orderdate >= '20070101';

---------------------------------------------------------------------
-- Using Outer Joins in a Multi-Table Join
---------------------------------------------------------------------

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 1: use outer join all along
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
  LEFT OUTER JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Option 2: change join order
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
  JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid
  RIGHT OUTER JOIN Sales.Customers AS C
     ON O.custid = C.custid;

-- Option 3: use parentheses
SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
  LEFT OUTER JOIN
      (Sales.Orders AS O
         JOIN Sales.OrderDetails AS OD
           ON O.orderid = OD.orderid)
    ON C.custid = O.custid;

---------------------------------------------------------------------
-- Using the COUNT Aggregate with Outer Joins
---------------------------------------------------------------------

SELECT C.custid, COUNT(*) AS numorders
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;

SELECT C.custid, COUNT(O.orderid) AS numorders
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON C.custid = O.custid
GROUP BY C.custid;
