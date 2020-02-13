---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 6 - Set Operations
-- © 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The UNION Set Operation
---------------------------------------------------------------------

-- The UNION ALL Set Operation
USE TSQLFundamentals2008;

SELECT country, region, city FROM HR.Employees
UNION ALL
SELECT country, region, city FROM Sales.Customers;

-- The UNION DISTINCT Set Operation
SELECT country, region, city FROM HR.Employees
UNION
SELECT country, region, city FROM Sales.Customers;

---------------------------------------------------------------------
-- The INTERSECT
---------------------------------------------------------------------

-- The INTERSECT DISTINCT Set Operation
SELECT country, region, city FROM HR.Employees
INTERSECT
SELECT country, region, city FROM Sales.Customers;

-- The INTERSECT ALL Set Operation (Optional, Advanced)
SELECT
  ROW_NUMBER() 
    OVER(PARTITION BY country, region, city
         ORDER     BY (SELECT 0)) AS rownum,
  country, region, city
FROM HR.Employees

INTERSECT

SELECT
  ROW_NUMBER() 
    OVER(PARTITION BY country, region, city
         ORDER     BY (SELECT 0)),
  country, region, city
FROM Sales.Customers;


WITH INTERSECT_ALL
AS
(
  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)) AS rownum,
    country, region, city
  FROM HR.Employees

  INTERSECT

  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)),
    country, region, city
  FROM Sales.Customers
)
SELECT country, region, city
FROM INTERSECT_ALL;

---------------------------------------------------------------------
-- The EXCEPT Set Operation
---------------------------------------------------------------------

-- The EXCEPT DISTINCT Set Operation

-- Employees EXCEPT Customers
SELECT country, region, city FROM HR.Employees
EXCEPT
SELECT country, region, city FROM Sales.Customers;

-- Customers EXCEPT Employees
SELECT country, region, city FROM Sales.Customers
EXCEPT
SELECT country, region, city FROM HR.Employees;

-- The EXCEPT ALL Set Operation (Optional, Advanced)
WITH EXCEPT_ALL
AS
(
  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)) AS rownum,
    country, region, city
    FROM HR.Employees

  EXCEPT

  SELECT
    ROW_NUMBER() 
      OVER(PARTITION BY country, region, city
           ORDER     BY (SELECT 0)),
    country, region, city
  FROM Sales.Customers
)
SELECT country, region, city
FROM EXCEPT_ALL;

---------------------------------------------------------------------
-- Precedence
---------------------------------------------------------------------

-- INTERSECT Precedes EXCEPT
SELECT country, region, city FROM Production.Suppliers
EXCEPT
SELECT country, region, city FROM HR.Employees
INTERSECT
SELECT country, region, city FROM Sales.Customers;

-- Using Parenthesis
(SELECT country, region, city FROM Production.Suppliers
 EXCEPT
 SELECT country, region, city FROM HR.Employees)
INTERSECT
SELECT country, region, city FROM Sales.Customers;

---------------------------------------------------------------------
-- Circumventing Unsupported Logical Phases
-- (Optional, Advanced)
---------------------------------------------------------------------

-- Number of Cities per country Covered by Both Customers
-- and Employees
SELECT country, COUNT(*) AS numlocations
FROM (SELECT country, region, city FROM HR.Employees
      UNION
      SELECT country, region, city FROM Sales.Customers) AS U
GROUP BY country;

-- Two most recent orders for employees 3 and 5
SELECT empid, orderid, orderdate
FROM (SELECT TOP (2) empid, orderid, orderdate
      FROM Sales.Orders
      WHERE empid = 3
      ORDER BY orderdate DESC, orderid DESC) AS D1

UNION ALL

SELECT empid, orderid, orderdate
FROM (SELECT TOP (2) empid, orderid, orderdate
      FROM Sales.Orders
      WHERE empid = 5
      ORDER BY orderdate DESC, orderid DESC) AS D2;
