---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 8 - Data Modification
-- Solutions
-- � 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1
-- Run the following code to create the Customers table
-- in the tempdb database
USE tempdb;

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;

CREATE TABLE dbo.Customers
(
  custid      INT          NOT NULL PRIMARY KEY,
  companyname NVARCHAR(40) NOT NULL,
  country     NVARCHAR(15) NOT NULL,
  region      NVARCHAR(15) NULL,
  city        NVARCHAR(15) NOT NULL  
);
GO

-- 1-1
-- Insert into the Customers table a row with:
-- custid:  100
-- companyname: Company ABCDE
-- country:     USA
-- region:      WA
-- city:        Redmond

-- Solution:
USE tempdb;

INSERT INTO dbo.Customers(custid, companyname, country, region, city)
  VALUES(100, N'Company ABCDE', N'USA', N'WA', N'Redmond');

-- 1-2
-- Insert into the Customers table 
-- all customers from TSQLFundamentals2008.Sales.Customers
-- who placed orders

-- Solution:
USE tempdb;

INSERT INTO dbo.Customers(custid, companyname, country, region, city)
  SELECT custid, companyname, country, region, city
  FROM TSQLFundamentals2008.Sales.Customers AS C
  WHERE EXISTS
    (SELECT * FROM TSQLFundamentals2008.Sales.Orders AS O
     WHERE O.custid = C.custid);

-- 1-3
-- Use a SELECT INTO statement to create and populate an Orders table
-- in tempdb, with orders from the Orders table in TSQLFundamentals2008 
-- that were placed in the years 2006 through 2008

-- Solution:
USE tempdb;

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;

SELECT *
INTO dbo.Orders
FROM TSQLFundamentals2008.Sales.Orders
WHERE orderdate >= '20060101'
  AND orderdate < '20090101';

-- 2
-- Delete from the Orders table in tempdb
-- orders that were placed before August 2006
-- Use the OUTPUT clause to return the orderid and orderdate
-- of the deleted orders

-- Desired output:
orderid     orderdate
----------- -----------------------
10248       2006-07-04 00:00:00.000
10249       2006-07-05 00:00:00.000
10250       2006-07-08 00:00:00.000
10251       2006-07-08 00:00:00.000
10252       2006-07-09 00:00:00.000
10253       2006-07-10 00:00:00.000
10254       2006-07-11 00:00:00.000
10255       2006-07-12 00:00:00.000
10256       2006-07-15 00:00:00.000
10257       2006-07-16 00:00:00.000
10258       2006-07-17 00:00:00.000
10259       2006-07-18 00:00:00.000
10260       2006-07-19 00:00:00.000
10261       2006-07-19 00:00:00.000
10262       2006-07-22 00:00:00.000
10263       2006-07-23 00:00:00.000
10264       2006-07-24 00:00:00.000
10265       2006-07-25 00:00:00.000
10266       2006-07-26 00:00:00.000
10267       2006-07-29 00:00:00.000
10268       2006-07-30 00:00:00.000
10269       2006-07-31 00:00:00.000

(22 row(s) affected)

-- Solution:
USE tempdb;

DELETE FROM dbo.Orders
  OUTPUT deleted.orderid, deleted.orderdate
WHERE orderdate < '20060801';

-- 3
-- Delete orders placed by customers from Brazil

-- Solution:
USE tempdb;

DELETE FROM dbo.Orders
WHERE EXISTS
  (SELECT *
   FROM dbo.Customers AS C
   WHERE Orders.custid = C.custid
     AND C.country = N'Brazil');

DELETE FROM O
FROM dbo.Orders AS O
  JOIN dbo.Customers AS C
    ON O.custid = C.custid
WHERE country = N'Brazil';

MERGE INTO dbo.Orders AS O
USING dbo.Customers AS C
  ON O.custid = C.custid
  AND country = N'Brazil'
WHEN MATCHED THEN DELETE;  

-- 4-1
-- Run the following query against Customers,
-- and notice that some rows have a NULL in the region column
SELECT * FROM dbo.Customers;

-- Output:
custid      companyname    country         region     city
----------- -------------- --------------- ---------- --------------- 
1           Customer NRZBB Germany         NULL       Berlin
2           Customer MLTDN Mexico          NULL       M�xico D.F.
3           Customer KBUDE Mexico          NULL       M�xico D.F.
4           Customer HFBZG UK              NULL       London
5           Customer HGVLZ Sweden          NULL       Lule�
6           Customer XHXJV Germany         NULL       Mannheim
7           Customer QXVLA France          NULL       Strasbourg
8           Customer QUHWH Spain           NULL       Madrid
9           Customer RTXGC France          NULL       Marseille
10          Customer EEALV Canada          BC         Tsawassen
...

(90 row(s) affected)

-- 4-2
-- Update the Customers table and change all NULL region values to '<None>'
-- Use the OUTPUT clause to show the custid, old region and new region

-- Desired output:
custid      oldregion       newregion
----------- --------------- ---------------
1           NULL            <None>
2           NULL            <None>
3           NULL            <None>
4           NULL            <None>
5           NULL            <None>
6           NULL            <None>
7           NULL            <None>
8           NULL            <None>
9           NULL            <None>
11          NULL            <None>
12          NULL            <None>
13          NULL            <None>
14          NULL            <None>
16          NULL            <None>
17          NULL            <None>
18          NULL            <None>
19          NULL            <None>
20          NULL            <None>
23          NULL            <None>
24          NULL            <None>
25          NULL            <None>
26          NULL            <None>
27          NULL            <None>
28          NULL            <None>
29          NULL            <None>
30          NULL            <None>
39          NULL            <None>
40          NULL            <None>
41          NULL            <None>
44          NULL            <None>
49          NULL            <None>
50          NULL            <None>
52          NULL            <None>
53          NULL            <None>
54          NULL            <None>
56          NULL            <None>
58          NULL            <None>
59          NULL            <None>
60          NULL            <None>
63          NULL            <None>
64          NULL            <None>
66          NULL            <None>
68          NULL            <None>
69          NULL            <None>
70          NULL            <None>
72          NULL            <None>
73          NULL            <None>
74          NULL            <None>
76          NULL            <None>
79          NULL            <None>
80          NULL            <None>
83          NULL            <None>
84          NULL            <None>
85          NULL            <None>
86          NULL            <None>
87          NULL            <None>
90          NULL            <None>
91          NULL            <None>

(58 row(s) affected)

-- Solution:
USE tempdb;

UPDATE dbo.Customers
  SET region = '<None>'
OUTPUT
  deleted.custid,
  deleted.region AS oldregion,
  inserted.region AS newregion
WHERE region IS NULL;

-- 5
-- Update all orders placed by UK customers
-- and set their shipcountry, shipregion, shipcity values
-- to the country, region, city values of the corresponding customers

-- Solutions:
USE tempdb;

UPDATE O
  SET shipcountry = C.country,
      shipregion = C.region,
      shipcity = C.city
FROM dbo.Orders AS O
  JOIN dbo.Customers AS C
    ON O.custid = C.custid
WHERE C.country = 'UK';

WITH CTE_UPD AS
(
  SELECT
    O.shipcountry AS ocountry, C.country AS ccountry,
    O.shipregion  AS oregion,  C.region  AS cregion,
    O.shipcity    AS ocity,    C.city    AS ccity
  FROM dbo.Orders AS O
    JOIN dbo.Customers AS C
      ON O.custid = C.custid
  WHERE C.country = 'UK'
)
UPDATE CTE_UPD
  SET ocountry = ccountry, oregion = cregion, ocity = ccity;

MERGE INTO dbo.Orders AS O
USING dbo.Customers AS C
   ON O.custid = C.custid
   AND C.country = 'UK'
WHEN MATCHED THEN
  UPDATE SET shipcountry = C.country,
             shipregion = C.region,
             shipcity = C.city;
