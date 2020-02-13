---------------------------------------------------------------------
-- Microsoft SQL Server 2008 T-SQL Fundamentals
-- Chapter 7 - Pivot, Unpivot and Grouping Sets
-- Exercises
-- � 2008 Itzik Ben-Gan 
---------------------------------------------------------------------

-- All exercises for this chapter will involve querying the Orders
-- table in the tempdb database that you created and populated 
-- earlier by running the code in Listing 7-1

-- 1
-- Write a query against the Orders table that returns a row for each
-- employee, a column for each order year, and the count of orders
-- for each employee and order year
-- Tables involved: tempdb database, Orders table

-- Desired output:
empid       cnt2007     cnt2008     cnt2009
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

-- 2
-- Run the following code to create and populate the EmpYearOrders table:
USE tempdb;

IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;

SELECT empid, [2007] AS cnt2007, [2008] AS cnt2008, [2009] AS cnt2009
INTO dbo.EmpYearOrders
FROM (SELECT empid, YEAR(orderdate) AS orderyear
      FROM dbo.Orders) AS D
  PIVOT(COUNT(orderyear)
        FOR orderyear IN([2007], [2008], [2009])) AS P;

SELECT * FROM dbo.EmpYearOrders;

-- Output:
empid       cnt2007     cnt2008     cnt2009
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

-- Write a query against the EmpYearOrders table that unpivots
-- the data, returning a row for each employee and order year
-- with the number of orders
-- Exclude rows where the number of orders is 0
-- (in our example, employee 3 in year 2008)

-- Desired output:
empid       orderyear   numorders
----------- ----------- -----------
1           2007        1
1           2008        1
1           2009        1
2           2007        1
2           2008        2
2           2009        1
3           2007        2
3           2009        2

-- 3
-- Write a query against the Orders table that returns the 
-- total quantities for each:
-- employee, customer, and order year
-- employee and order year
-- customer and order year
-- Include a result column in the output that uniquely identifies 
-- the grouping set with which the current row is associated
-- Tables involved: tempdb database, Orders table

-- Desired output:
groupingset empid       custid orderyear   sumqty
----------- ----------- ------ ----------- -----------
0           2           A      2007        12
0           3           A      2007        10
4           NULL        A      2007        22
0           2           A      2008        40
4           NULL        A      2008        40
0           3           A      2009        10
4           NULL        A      2009        10
0           1           B      2007        20
4           NULL        B      2007        20
0           2           B      2008        12
4           NULL        B      2008        12
0           2           B      2009        15
4           NULL        B      2009        15
0           3           C      2007        22
4           NULL        C      2007        22
0           1           C      2008        14
4           NULL        C      2008        14
0           1           C      2009        20
4           NULL        C      2009        20
0           3           D      2009        30
4           NULL        D      2009        30
2           1           NULL   2007        20
2           2           NULL   2007        12
2           3           NULL   2007        32
2           1           NULL   2008        14
2           2           NULL   2008        52
2           1           NULL   2009        20
2           2           NULL   2009        15
2           3           NULL   2009        40

(29 row(s) affected)
