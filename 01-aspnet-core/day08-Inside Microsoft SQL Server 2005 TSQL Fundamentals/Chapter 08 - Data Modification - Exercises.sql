---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 8 - Data Modification
-- Exercises
-- © 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

-- Unless explicitly mentioned otherwise, the database assumed 
-- in the exercise is tempdb

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

-- 1-1
-- Insert into the Customers table a row with:
-- custid:  100
-- companyname: Company ABCDE
-- country:     USA
-- region:      WA
-- city:        Redmond

-- 1-2
-- Insert into the Customers table 
-- all customers from TSQLFundamentals2008.Sales.Customers
-- who placed orders

-- 1-3
-- Use a SELECT INTO statement to create and populate an Orders table
-- in tempdb, with orders from the Orders table in TSQLFundamentals2008 
-- that were placed in the years 2006 through 2008

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

-- 3
-- Delete orders placed by customers from Brazil

-- 4-1
-- Run the following query against Customers,
-- and notice that some rows have a NULL in the region column
SELECT * FROM dbo.Customers;

-- Output:
custid      companyname    country         region     city
----------- -------------- --------------- ---------- --------------- 
1           Customer NRZBB Germany         NULL       Berlin
2           Customer MLTDN Mexico          NULL       México D.F.
3           Customer KBUDE Mexico          NULL       México D.F.
4           Customer HFBZG UK              NULL       London
5           Customer HGVLZ Sweden          NULL       Luleå
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

-- 5
-- Update all orders placed by UK customers
-- and set their shipcountry, shipregion, shipcity values
-- to the country, region, city values of the corresponding customers
