USE AdventureWorks2008

SELECT   sc.AccountNumber,
         soh.SalesOrderID,
         soh.OrderDate,
         sod.ProductID,
         pp.Name,
         sod.OrderQty,
         sod.UnitPrice,
         sod.UnitPriceDiscount * sod.UnitPrice * sod.OrderQty AS TotalDiscount,
         sod.LineTotal
FROM     Sales.Customer AS sc
INNER JOIN   Sales.SalesOrderHeader AS soh
      ON sc.CustomerID = soh.CustomerID
INNER JOIN   Sales.SalesOrderDetail AS sod
      ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS pp
      ON sod.ProductID = pp.ProductID
WHERE CAST(soh.OrderDate AS Date) = 
      CAST(DATEADD(day,-1,GETDATE()) AS Date)


USE AdventureWorks2008
update Sales.SalesOrderHeader
set OrderDate=CAST(DATEADD(DAY,-1,GETDATE()) as Date),
DueDate=CAST(DATEADD(DAY,11,GETDATE()) as Date),
shipDate=CAST(DATEADD(DAY,6,GETDATE()) as Date)
where SalesOrderID<43663

