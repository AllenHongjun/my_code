---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 13 - XML and XQuery
-- Copyright Dejan Sarka, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Introduction to XML
---------------------------------------------------------------------

SET NOCOUNT ON;
GO
USE InsideTSQL2008;
GO

-- Create XML with AUTO option, atttribute-centric
SELECT Customer.custid, Customer.companyname, 
       [Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML AUTO, ROOT('CustomersOrders');


-- XML with AUTO option, element-centric, with namespace
WITH XMLNAMESPACES('InsideTSQL2008-CustomersOrders' AS co)
SELECT [co:Customer].custid AS 'co:custid', 
       [co:Customer].companyname AS 'co:companyname', 
       [co:Order].orderid AS 'co:orderid', 
       [co:Order].orderdate AS 'co:orderdate'
FROM Sales.Customers AS [co:Customer]
  JOIN Sales.Orders AS [co:Order]
    ON [co:Customer].custid = [co:Order].custid
WHERE [co:Customer].custid <= 2
      AND [co:Order].orderid %2 = 0
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders');
GO

-- Schema
-- XML with AUTO option, element-centric, with namespace
SELECT [Customer].custid AS 'custid', 
       [Customer].companyname AS 'companyname', 
       [Order].orderid AS 'orderid', 
       [Order].orderdate AS 'orderdate'
FROM Sales.Customers AS [Customer]
  JOIN Sales.Orders AS [Order]
    ON [Customer].custid = [Order].custid
WHERE 1 = 2
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders'), 
        XMLSCHEMA('InsideTSQL2008-CustomersOrders');
GO


---------------------------------------------------------------------
-- FOR XML
---------------------------------------------------------------------

-- FOR XML RAW

-- Basic
SELECT Customer.custid, Customer.companyname, 
       [Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML RAW;

-- Enhanced
SELECT Customer.custid, Customer.companyname, 
       [Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML RAW('Customer'), ROOT('CustomersOrders');
GO

-- FOR XML AUTO

-- Element-centric, with namespace, root element
WITH XMLNAMESPACES('InsideTSQL2008-CustomersOrders' AS co)
SELECT [co:Customer].custid AS 'co:custid', 
       [co:Customer].companyname AS 'co:companyname', 
       [co:Order].orderid AS 'co:orderid', 
       [co:Order].orderdate AS 'co:orderdate'
FROM Sales.Customers AS [co:Customer]
  JOIN Sales.Orders AS [co:Order]
    ON [co:Customer].custid = [co:Order].custid
WHERE [co:Customer].custid <= 2
      AND [co:Order].orderid %2 = 0
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders');

-- AUTO with random ORDER BY
SELECT Customer.custid, Customer.companyname, 
       [Order].orderid, [Order].orderdate
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY NEWID()      
FOR XML AUTO;

-- Wrong column order
SELECT [Order].orderid, [Order].orderdate,
       Customer.custid, Customer.companyname  
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML AUTO;

-- Taking custid from Orders table
SELECT [Order].orderid, [Order].orderdate,
       [Order].custid, Customer.companyname  
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY Customer.custid, [Order].orderid
FOR XML AUTO;

-- XML schema
SELECT [Customer].custid AS 'custid', 
       [Customer].companyname AS 'companyname', 
       [Order].orderid AS 'orderid', 
       [Order].orderdate AS 'orderdate'
FROM Sales.Customers AS [Customer]
  JOIN Sales.Orders AS [Order]
    ON [Customer].custid = [Order].custid
WHERE 1 = 2
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders'), 
        XMLSCHEMA('InsideTSQL2008-CustomersOrders');
GO

-- FOR XML EXPLICIT
SELECT 1 AS Tag,
       NULL AS Parent,
       Customer.custid AS [Customer!1!custid],
       Customer.companyname AS [Customer!1!companyname],
       NULL AS [Order!2!orderid],
       NULL AS [Order!2!orderdate]
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
UNION ALL
SELECT 2 AS Tag,
       1 AS Parent,
       Customer.custid AS [Customer!1!custid],
       NULL AS [Customer!1!companyname],
       [Order].orderid AS [Order!2!orderid],
       [Order].orderdate AS [Order!2!orderdate]
FROM Sales.Customers AS Customer
  JOIN Sales.Orders AS [Order]
    ON Customer.custid = [Order].custid
WHERE Customer.custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY [Customer!1!custid],
         [Order!2!orderid]     
FOR XML EXPLICIT
GO

-- FOR XML PATH

-- Simple query
SELECT Customer.custid AS [@custid],
       Customer.companyname AS [Customer/companyname]
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH;

-- String concatenation
SELECT Customer.custid AS [data()],
       Customer.companyname AS [data()]
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH ('');

-- Customers with nested orders
SELECT Customer.custid AS [@custid],
       Customer.companyname AS [@companyname],
       (SELECT [Order].orderid AS [@orderid],
               [Order].orderdate AS [@orderdate]
        FROM Sales.Orders AS [Order]
        WHERE Customer.custid = [Order].custid
              AND [Order].orderid %2 = 0
        ORDER BY [Order].orderid
        FOR XML PATH('Order'), TYPE)
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH('Customer');
GO

---------------------------------------------------------------------
-- OPENXML
---------------------------------------------------------------------

-- Query to produce XML with attributes and elements
SELECT Customer.custid AS [@custid],
       Customer.companyname AS [companyname],
       (SELECT [Order].orderid AS [@orderid],
               [Order].orderdate AS [orderdate]
        FROM Sales.Orders AS [Order]
        WHERE Customer.custid = [Order].custid
              AND [Order].orderid %2 = 0
        ORDER BY [Order].orderid
        FOR XML PATH('Order'), TYPE)
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH('Customer'), ROOT('CustomersOrders');

-- Edge table
DECLARE @DocHandle AS INT;
DECLARE @XmlDocument AS NVARCHAR(1000);
SET @XmlDocument = N'
<CustomersOrders>
  <Customer custid="1">
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2007-10-03T00:00:00</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2007-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2006-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10926">
      <orderdate>2008-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';
-- Create an internal representation
EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument
-- Show the edge table
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer');
-- Remove the DOM
EXEC sp_xml_removedocument @DocHandle;
GO

-- Rowset description in WITH clause, different mappings
DECLARE @DocHandle AS INT;
DECLARE @XmlDocument AS NVARCHAR(1000);
SET @XmlDocument = N'
<CustomersOrders>
  <Customer custid="1">
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2007-10-03T00:00:00</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2007-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2006-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10926">
      <orderdate>2008-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';
-- Create an internal representation
EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument
-- Attribute-centric mapping
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer',1)
     WITH (custid INT,
           companyname NVARCHAR(40));
-- Element-centric mapping
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer',2)
     WITH (custid INT,
           companyname NVARCHAR(40));
-- Attribute- and element-centric mapping
-- Using undocumented flag 3
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer',3)
     WITH (custid INT,
           companyname NVARCHAR(40));
-- Attribute- and element-centric mapping
-- Combining flag 8 with flags 1 and 2
SELECT *
FROM OPENXML (@DocHandle, '/CustomersOrders/Customer',11)
     WITH (custid INT,
           companyname NVARCHAR(40));
-- Remove the DOM
EXEC sp_xml_removedocument @DocHandle;
GO


---------------------------------------------------------------------
-- XQuery
---------------------------------------------------------------------

-- Basics

-- Returning sequences
DECLARE @x AS XML;
SET @x=N'
<root>
 <a>1<c>3</c><d>4</d></a>
 <b>2</b>
</root>'
SELECT 
 @x.query('*') AS Complete_Sequence,
 @x.query('data(*)') AS Complete_Data,
 @x.query('data(root/a/c)') AS Element_c_Data;
GO        
        
-- Using namespaces
-- Query that returns XML with a namespace
WITH XMLNAMESPACES('InsideTSQL2008-CustomersOrders' AS co)
SELECT [co:Customer].custid AS 'co:custid', 
       [co:Customer].companyname AS 'co:companyname', 
       [co:Order].orderid AS 'co:orderid', 
       [co:Order].orderdate AS 'co:orderdate'
FROM Sales.Customers AS [co:Customer]
  JOIN Sales.Orders AS [co:Order]
    ON [co:Customer].custid = [co:Order].custid
WHERE [co:Customer].custid <= 2
      AND [co:Order].orderid %2 = 0
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ROOT('CustomersOrders');
-- XQuery with namespace
DECLARE @x AS XML;
SET @x='
<CustomersOrders xmlns:co="InsideTSQL2008-CustomersOrders">
  <co:Customer co:custid="1" co:companyname="Customer NRZBB">
    <co:Order co:orderid="10692" co:orderdate="2007-10-03T00:00:00" />
    <co:Order co:orderid="10702" co:orderdate="2007-10-13T00:00:00" />
    <co:Order co:orderid="10952" co:orderdate="2008-03-16T00:00:00" />
  </co:Customer>
  <co:Customer co:custid="2" co:companyname="Customer MLTDN">
    <co:Order co:orderid="10308" co:orderdate="2006-09-18T00:00:00" />
    <co:Order co:orderid="10926" co:orderdate="2008-03-04T00:00:00" />
  </co:Customer>
</CustomersOrders>';
-- Namespace in prolog of XQuery
SELECT @x.query('
(: explicit namespace :)
declare namespace co="InsideTSQL2008-CustomersOrders";
//co:Customer[1]/*') AS [Explicit namespace];
-- Default namespace for all elements in prolog of XQuery
SELECT @x.query('
(: default namespace :)
declare default element namespace "InsideTSQL2008-CustomersOrders";
//Customer[1]/*') AS [Default element namespace];
-- Namespace defined in WITH clause of T-SQL SELECT
WITH XMLNAMESPACES('InsideTSQL2008-CustomersOrders' AS co)
SELECT @x.query('
(: namespace declared in T-SQL :)
//co:Customer[1]/*') AS [Namespace in WITH clause];
GO

-- XQuery with aggregate functions
DECLARE @x AS XML;
SET @x='
<CustomersOrders>
  <Customer custid="1" companyname="Customer NRZBB">
    <Order orderid="10692" orderdate="2007-10-03T00:00:00" />
    <Order orderid="10702" orderdate="2007-10-13T00:00:00" />
    <Order orderid="10952" orderdate="2008-03-16T00:00:00" />
  </Customer>
  <Customer custid="2" companyname="Customer MLTDN">
    <Order orderid="10308" orderdate="2006-09-18T00:00:00" />
    <Order orderid="10926" orderdate="2008-03-04T00:00:00" />
  </Customer>
</CustomersOrders>';
SELECT @x.query('
for $i in //Customer
return
   <OrdersInfo>
      { $i/@companyname }
      <NumberOfOrders>
		  { count($i/Order) }
      </NumberOfOrders>
      <LastOrder>
		  { max($i/Order/@orderid) }
	  </LastOrder>
   </OrdersInfo>
');
GO

-- Navigation

-- General comparison operators
DECLARE @x AS XML = N'';				
SELECT @x.query('(1, 2, 3) = (2, 4)');	-- true
SELECT @x.query('(5, 6) < (2, 4)');		-- false
SELECT @x.query('(1, 2, 3) = 1');		-- true
SELECT @x.query('(1, 2, 3) != 1');		-- true
GO

-- Navigation examples
DECLARE @x AS XML;
SET @x = N'
<CustomersOrders>
  <Customer custid="1">
    <!-- Comment 111 -->
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2007-10-03T00:00:00</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2007-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <!-- Comment 222 -->  
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2006-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';
-- Children of CustomersOrders/Customer
-- Principal nodes only
SELECT @x.query('CustomersOrders/Customer/*')
       AS [1. Principal nodes];
-- All nodes
SELECT @x.query('CustomersOrders/Customer/node()')
       AS [2. All nodes];
-- Comment nodes only
SELECT @x.query('CustomersOrders/Customer/comment()')
       AS [3. Comment nodes];
-- Customer 2 orders
SELECT @x.query('//Customer[@custid=2]/Order')
       AS [4. Customer 2 orders];
-- All orders with orderid=10952, no matter of parents
SELECT @x.query('//../Order[@orderid=10952]')
       AS [5. Orders with orderid=10952];
-- Second Customer with at least one Order child
SELECT @x.query('(/CustomersOrders/Customer/
                  Order/parent::Customer)[2]')
       AS [6. Second Customer with at least one Order];                  
-- Conditional expressions
-- Testing sql variable
DECLARE @element NVARCHAR(20);
SET @element=N'orderdate';
SELECT @x.query('
if (sql:variable("@element")="companyname") then
 CustomersOrders/Customer/companyname
else
 CustomersOrders/Customer/Order/orderdate
')
       AS [7. Order dates];   
-- This if does not change the flow of XQuery
-- It returns company names for both customers
SELECT @x.query('
if (CustomersOrders/Customer[@custid=1]) then
 CustomersOrders/Customer/companyname
else
 CustomersOrders/Customer/Order/orderdate
')
       AS [8. Company names];             
GO

-- FLWOR
DECLARE @x AS XML;
SET @x = N'
<CustomersOrders>
  <Customer custid="1">
    <!-- Comment 111 -->
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2007-10-03T00:00:00</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2007-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <!-- Comment 222 -->  
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2006-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';
SELECT @x.query('for $i in CustomersOrders/Customer/Order
                 return $i')
       AS [1. Orders];
SELECT @x.query('for $i in CustomersOrders/Customer/Order
                 where $i/@orderid < 10900
                 return $i')
       AS [2. Filtered orders];
SELECT @x.query('for $i in CustomersOrders/Customer/Order
                 where $i/@orderid < 10900
                 order by ($i/orderdate)[1]
                 return $i')
       AS [3. Filtered and sorted orders];
SELECT @x.query('for $i in CustomersOrders/Customer/Order
                 where $i/@orderid < 10900
                 order by ($i/orderdate)[1]
                 return 
                 <Order-orderid-element>
                  <orderid>{data($i/@orderid)}</orderid>
                  {$i/orderdate}
                 </Order-orderid-element>')
       AS [4. Filtered, sorted and reformatted orders];
SELECT @x.query('for $i in CustomersOrders/Customer/Order
                 let $j := $i/orderdate
                 where $i/@orderid < 10900
                 order by ($j)[1]
                 return 
                 <Order-orderid-element>
                  <orderid>{data($i/@orderid)}</orderid>
                  {$j}
                 </Order-orderid-element>')
       AS [5. Filtered, sorted and reformatted orders with let clause];
GO

-- Join with FLWOR
-- Create XML
SELECT [Customer].custid AS 'customercustid', 
       [Customer].companyname AS 'companyname', 
       [Order].custid AS 'ordercustid',
       [Order].orderid AS 'orderid'
FROM Sales.Customers AS [Customer]
  JOIN Sales.Orders AS [Order]
    ON [Customer].custid = [Order].custid
WHERE [Customer].custid <= 2
      AND [Order].orderid %2 = 0
ORDER BY [Customer].custid, [Order].orderid
FOR XML AUTO, ROOT('CustomersOrders');
GO

DECLARE @co AS XML;
SET @co = N'
<CustomersOrders>
  <Customer customercustid="1" companyname="Customer NRZBB">
    <Order ordercustid="1" orderid="10692" />
    <Order ordercustid="1" orderid="10702" />
    <Order ordercustid="1" orderid="10952" />
  </Customer>
  <Customer customercustid="2" companyname="Customer MLTDN">
    <Order ordercustid="2" orderid="10308" />
    <Order ordercustid="2" orderid="10926" />
  </Customer>
</CustomersOrders>';
SELECT @co.query('for $i in CustomersOrders/Customer
                  for $j in $i/Order
                  where $i/@customercustid = $j/@ordercustid
                  return
                    <Order
                      customerid = "{$i/@customercustid}"
                      companyname = "{$i/@companyname}"
                      orderid = "{$j/@orderid}"
                     />')
        AS [Join Customers - Orders];
GO

---------------------------------------------------------------------
-- XML data type
---------------------------------------------------------------------

-- Visio docs in XML column
USE InsideTSQL2008;
GO
CREATE TABLE dbo.VisioDocs 
( 
  id  INT NOT NULL, 
  doc XML NOT NULL 
); 
GO 
 
INSERT INTO dbo.VisioDocs (id, doc) 
 SELECT 1, * 
 FROM OPENROWSET(BULK 'C:\InsideTSQL2008\VisioFiles\ProductER.vdx', 
   SINGLE_BLOB) AS x; 
INSERT INTO dbo.VisioDocs (id, doc) 
 SELECT 2, * 
 FROM OPENROWSET(BULK 'C:\InsideTSQL2008\VisioFiles\ProductUML.vdx', 
   SINGLE_BLOB) AS x; 
INSERT INTO dbo.VisioDocs (id, doc) 
 SELECT 3, * 
 FROM OPENROWSET(BULK 'C:\InsideTSQL2008\VisioFiles\CustomerER.vdx', 
   SINGLE_BLOB) AS x;
GO

-- Querying the VisioDocs table
SELECT id, doc
FROM dbo.VisioDocs;
GO

-- Company name - value method
SELECT id,  
  doc.value('declare namespace VI= 
    "http://schemas.microsoft.com/visio/2003/core"; 
    (/VI:VisioDocument/VI:DocumentProperties/VI:Company)[1]', 
    'NVARCHAR(50)') AS company 
FROM dbo.VisioDocs;

-- ER template - value method
SELECT id, 'ER DB Model' AS templatetype 
FROM dbo.VisioDocs 
WHERE doc.value( 
  'declare namespace VI="http://schemas.microsoft.com/visio/2003/core"; 
  (/VI:VisioDocument/VI:DocumentProperties/VI:Template)[1]', 
  'NVARCHAR(100)') LIKE N'%DBMODL_M.VST%';

-- Document settings - query method
SELECT doc.query(' 
  declare namespace VI="http://schemas.microsoft.com/visio/2003/core"; 
  for $v in /VI:VisioDocument/VI:DocumentSettings 
  return $v') AS settings 
FROM dbo.VisioDocs;

-- Document creator - query method
SELECT doc.query(' 
  declare namespace VI="http://schemas.microsoft.com/visio/2003/core"; 
  for $v in /VI:VisioDocument/VI:DocumentProperties 
  return element Person 
    { 
       attribute creatorname    
                 {$v/VI:Creator[1]/text()[1]} 
    }') 
FROM dbo.VisioDocs;
GO

-- XML indexes
ALTER TABLE dbo.VisioDocs 
  ADD CONSTRAINT PK_VisioDocs PRIMARY KEY CLUSTERED (id); 
GO
CREATE PRIMARY XML INDEX idx_xml_primary ON dbo.VisioDocs(doc); 
GO 
CREATE XML INDEX idx_xml_path ON VisioDocs(doc) 
  USING XML INDEX idx_xml_primary 
  FOR PATH;
GO

-- Testing the indexes
-- Turn actual execution plan on
-- Search for the unknown company
SELECT id, doc 
FROM dbo.VisioDocs 
WHERE doc.value( 
  'declare namespace VI="http://schemas.microsoft.com/visio/2003/core"; 
  (/VI:VisioDocument/VI:DocumentProperties/VI:Company)[1]', 
  'NVARCHAR(50)') LIKE N'Unknown%'; 
-- Drop the index
DROP INDEX idx_xml_primary ON dbo.VisioDocs; 
-- Search for the unknown company again
SELECT id, doc 
FROM dbo.VisioDocs 
WHERE doc.value( 
  'declare namespace VI="http://schemas.microsoft.com/visio/2003/core"; 
  (/VI:VisioDocument/VI:DocumentProperties/VI:Company)[1]', 
  'NVARCHAR(50)') LIKE N'Unknown%';
GO
-- Save the plan in an XML file

-- Modify method

-- Insert a subelement - 2nd company
UPDATE dbo.VisioDocs 
  SET doc.modify('declare namespace VI= 
    "http://schemas.microsoft.com/visio/2003/core"; 
    insert <VI:SecondCompany>Customer NRZBB</VI:SecondCompany> 
    after (/VI:VisioDocument/VI:DocumentProperties/VI:Company)[1]') 
WHERE id = 1; 
-- Check the new element
SELECT id, doc
FROM dbo.VisioDocs
WHERE id = 1; 
GO

-- Finding rows with 2nd company - exists method
SELECT id, doc
FROM dbo.VisioDocs
WHERE doc.exist('declare namespace VI= 
    "http://schemas.microsoft.com/visio/2003/core"; 
    /VI:VisioDocument/VI:DocumentProperties/VI:SecondCompany') = 1;
GO

-- Replace value of a subelement - 2nd company
UPDATE dbo.VisioDocs 
  SET doc.modify('declare namespace VI= 
    "http://schemas.microsoft.com/visio/2003/core"; 
    replace value of
     /VI:VisioDocument[1]/VI:DocumentProperties[1]/VI:SecondCompany[1]/text()[1]
     with "Customer MLTDN"') 
WHERE id = 1; 
-- Check the updated element
SELECT id, doc
FROM dbo.VisioDocs
WHERE id = 1; 
GO    

-- Delete a subelement - 2nd company
UPDATE dbo.VisioDocs 
  SET doc.modify('declare namespace VI= 
    "http://schemas.microsoft.com/visio/2003/core"; 
    delete
     /VI:VisioDocument/VI:DocumentProperties/VI:SecondCompany[1]') 
WHERE id = 1; 
-- Check the updated element
SELECT id, doc
FROM dbo.VisioDocs
WHERE id = 1; 
GO    

-- Shredding with the nodes method
SELECT id,
  N.c1.value('declare namespace VI= 
      "http://schemas.microsoft.com/visio/2003/core";
      (VI:Company)[1]','NVARCHAR(30)') AS Company, 
  N.c1.value('declare namespace VI= 
      "http://schemas.microsoft.com/visio/2003/core";
      (VI:Creator)[1]','NVARCHAR(30)') AS Creator      
FROM dbo.VisioDocs 
  CROSS APPLY 
    doc.nodes('declare namespace VI= 
      "http://schemas.microsoft.com/visio/2003/core"; 
      /VI:VisioDocument/VI:DocumentProperties') AS N(c1);
GO

-- Querying the execution plan
CREATE TABLE dbo.ExecutionPlans
( 
  id    INT NOT NULL, 
  eplan XML NOT NULL 
); 
GO 
INSERT INTO dbo.ExecutionPlans (id, eplan) 
 SELECT 1, * 
 FROM OPENROWSET(BULK 'C:\InsideTSQL2008\VisioFiles\VisioDocsQueries.xml', 
   SINGLE_BLOB) AS x; 
GO

-- Querying
WITH StatementCostCTE AS
(SELECT id AS BatchId, 
        N.c1.value('declare namespace EP=
         "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
          (EP:StmtSimple/@StatementId)[1]',
          'INT') AS StatementId,
        N.c1.value('declare namespace EP=
          "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
          (EP:StmtSimple/@StatementSubTreeCost)[1]',
          'DECIMAL(10,7)') AS StatementCost      
 FROM dbo.ExecutionPlans CROSS APPLY
      eplan.nodes('declare namespace EP=
        "http://schemas.microsoft.com/sqlserver/2004/07/showplan";
        /EP:ShowPlanXML/EP:BatchSequence/EP:Batch/EP:Statements') AS N(c1)),
BatchCostCTE AS
(SELECT BatchId,
        SUM(StatementCost) AS BatchCost
 FROM StatementCostCTE
 GROUP BY BatchId)
SELECT B.BatchId,
       S.StatementId,
       CAST(ROUND((S.StatementCost / B.BatchCost) * 100,5)
        AS DECIMAL(8,5))
        AS RelativeCostPercent
FROM BatchCostCTE AS B
  JOIN StatementCostCTE AS S
    ON B.BatchId = S.BatchId;
GO

-- XML as parameter
CREATE PROCEDURE dbo.GetProducts 
  @inplist XML 
AS 
SELECT P.* 
FROM Production.Products AS P
  JOIN (SELECT D1.c1.value('(./text())[1]','NVARCHAR(50)') AS nameneeded 
        FROM @inplist.nodes('/Names/NameNeeded') AS D1(c1)) AS D2 
    ON P.productname = D2.NameNeeded; 
GO

-- Test
DECLARE @inplist AS XML; 
SET @inplist= 
  (SELECT * FROM 
     (VALUES
       (N'Product HHYDP'),
       (N'Product RECZE')) AS D(NameNeeded)
  FOR XML RAW('Names'), ELEMENTS); 
EXEC dbo.GetProducts @inplist;
GO


---------------------------------------------------------------------
-- Dynamic schema
---------------------------------------------------------------------

-- Alter the Products table
ALTER TABLE Production.Products
 ADD additionalattributes XML NULL;
GO

-- Schema collection creation
-- Auxiliary tables
CREATE TABLE dbo.Beverages 
( 
  percentvitaminsRDA INT 
); 
CREATE TABLE dbo.Condiments 
( 
  shortdescription NVARCHAR(50)
); 
GO 
-- Store the Schemas in a Variable and Create the Collection 
DECLARE @mySchema NVARCHAR(MAX); 
SET @mySchema = N''; 
SET @mySchema = @mySchema + 
  (SELECT * 
   FROM Beverages 
   FOR XML AUTO, ELEMENTS, XMLSCHEMA('Beverages')); 
SET @mySchema = @mySchema + 
  (SELECT * 
   FROM Condiments 
   FOR XML AUTO, ELEMENTS, XMLSCHEMA('Condiments')); 
SELECT CAST(@myschema AS XML);
CREATE XML SCHEMA COLLECTION dbo.ProductsAdditionalAttributes AS @mySchema; 
GO 
-- Drop Tables 
DROP TABLE dbo.Beverages, dbo.Condiments;
GO

-- Retrieve information about the schema collection 
SELECT * 
FROM sys.xml_schema_collections 
WHERE name = 'ProductsAdditionalAttributes'; 
 -- Retrieve information about the namespaces in the schema collection 
SELECT N.*  
FROM sys.xml_schema_namespaces AS N 
  JOIN sys.xml_schema_collections AS C 
    ON N.xml_collection_id = C.xml_collection_id 
WHERE C.name = 'ProductsAdditionalAttributes'; 
-- Retrieve information about the components in the schema collection 
SELECT CP.*  
FROM sys.xml_schema_components AS CP 
  JOIN sys.xml_schema_collections AS C 
    ON CP.xml_collection_id = C.xml_collection_id 
WHERE C.name = 'ProductsAdditionalAttributes';
GO

-- Validate the XML column
ALTER TABLE Production.Products 
  ALTER COLUMN additionalattributes
   XML(dbo.ProductsAdditionalAttributes);
GO

-- Check the correct schema 
-- Function to retrieve the namespace
CREATE FUNCTION dbo.GetNamespace(@chkcol XML)
 RETURNS NVARCHAR(15)
AS
BEGIN
 RETURN @chkcol.value('namespace-uri((/*)[1])','NVARCHAR(15)')
END;
GO
-- Function to retrieve the category name
CREATE FUNCTION dbo.GetCategoryName(@catid INT)
 RETURNS NVARCHAR(15)
AS
BEGIN
 RETURN 
  (SELECT categoryname 
   FROM Production.Categories
   WHERE categoryid = @catid)
END;
GO
-- Add the constraint
ALTER TABLE Production.Products ADD CONSTRAINT ck_Namespace
 CHECK (dbo.GetNamespace(additionalattributes) = 
        dbo.GetCategoryName(categoryid));
GO

-- Valid data
-- Beverage
UPDATE Production.Products 
   SET additionalattributes = N'
<Beverages xmlns="Beverages"> 
  <percentvitaminsRDA>27</percentvitaminsRDA> 
</Beverages>'
WHERE productid = 1; 
-- Condiment
UPDATE Production.Products 
   SET additionalattributes = N'
<Condiments xmlns="Condiments"> 
  <shortdescription>very sweet</shortdescription> 
</Condiments>'
WHERE productid = 3; 
GO

-- Invalid data
-- String instead of int
UPDATE Production.Products 
   SET additionalattributes = N'
<Beverages xmlns="Beverages"> 
  <percentvitaminsRDA>twenty seven</percentvitaminsRDA> 
</Beverages>'
WHERE productid = 1; 
-- Wrong namespace
UPDATE Production.Products 
   SET additionalattributes = N'
<Condiments xmlns="Condiments"> 
  <shortdescription>very sweet</shortdescription> 
</Condiments>'
WHERE productid = 2; 
-- Wrong element
UPDATE Production.Products 
   SET additionalattributes = N'
<Condiments xmlns="Condiments"> 
  <unknownelement>very sweet</unknownelement> 
</Condiments>'
WHERE productid = 3; 
GO

         
---------------------------------------------------------------------
-- Clean-up code
---------------------------------------------------------------------
USE InsideTSQL2008;
GO
DROP TABLE dbo.VisioDocs;
DROP TABLE dbo.ExecutionPlans;
DROP PROCEDURE dbo.GetProducts;
ALTER TABLE Production.Products
 DROP CONSTRAINT ck_Namespace;
ALTER TABLE Production.Products
 DROP COLUMN additionalattributes;
DROP XML SCHEMA COLLECTION dbo.ProductsAdditionalAttributes;
DROP FUNCTION dbo.GetNamespace;
DROP FUNCTION dbo.GetCategoryName;
GO
SET NOCOUNT OFF;
GO
