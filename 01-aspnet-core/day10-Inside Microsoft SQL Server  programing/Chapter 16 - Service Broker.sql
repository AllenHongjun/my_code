---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 16: Service Broker
-- Copyright Roger Wolter, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------


----------------------------------------------------------------------
----------------------------------------------------------------------
--  Sample dialog
--  End to end sample of creating a dialog and using it to exchange messages
----------------------------------------------------------------------
----------------------------------------------------------------------

---------------------------------------------------------------------
-- Listing 1
---------------------------------------------------------------------


--------------------------------------------------------------------- 
-- Create the Inventory database
--------------------------------------------------------------------- 

CREATE DATABASE Inventory; 
GO 
USE Inventory; 
GO 
  
--------------------------------------------------------------------- 
-- Create the message types we will need for the conversation 
--------------------------------------------------------------------- 
  
CREATE MESSAGE TYPE [//microsoft.com/Inventory/AddItem];  
CREATE MESSAGE TYPE [//microsoft.com/Inventory/ItemAdded]; 
  
/*------------------------------------------------------------------- 
-- Create a contract for the AddItem conversation 
-------------------------------------------------------------------*/ 
  
CREATE CONTRACT [//microsoft.com/Inventory/AddItemContract] 
  ([//microsoft.com/Inventory/AddItem] SENT BY INITIATOR, 
  [//microsoft.com/Inventory/ItemAdded] SENT BY TARGET); 
GO 
  
/*-------------------------------------------------------------------- 
-- Create the procedure to service the Inventory target queue 
-- Make it an empty procedure for now.  We will fill it in later 
--------------------------------------------------------------------*/ 
  
CREATE PROCEDURE dbo.InventoryProc  AS 
  RETURN 0; 
GO 
  
/*-------------------------------------------------------------------- 
-- Create the Inventory Queue which will be the target of  
-- the conversations.  This is created with activation on. 
--------------------------------------------------------------------*/ 
  
CREATE QUEUE dbo.InventoryQueue 
  WITH ACTIVATION ( 
     STATUS = ON, 
     PROCEDURE_NAME = dbo.InventoryProc  ,  
     MAX_QUEUE_READERS = 2, 
     EXECUTE AS SELF       
  ) ; 
  
/*-------------------------------------------------------------------- 
-- Create the Inventory Service.  Because this is the Target 
-- service, the contract must be specified  
--------------------------------------------------------------------*/ 
  
CREATE SERVICE [//microsoft.com/InventoryService] ON QUEUE dbo.InventoryQueue 
  ([//microsoft.com/Inventory/AddItemContract]); 
  
/*-------------------------------------------------------------------- 
-- Create a table to hold the inventory we're adding 
-- This isn't meant to be realistic - just a way to show that the  
-- service did something 
--------------------------------------------------------------------*/ 
  
CREATE TABLE dbo.Inventory  
( 
  PartNumber   NVARCHAR(50)     Primary Key Clustered NOT NULL, 
  Description  NVARCHAR (2000) NULL, 
  Quantity     INT NULL, 
  ReorderLevel INT NULL, 
  Location     NVARCHAR(50) NULL 
); 
GO

---------------------------------------------------------------------
-- End of Listing 1
---------------------------------------------------------------------
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Listing 2
---------------------------------------------------------------------

--------------------------------------------------------------------- 
-- Create the target procedure to handle inventory messages
--------------------------------------------------------------------- 


ALTER PROCEDURE dbo.InventoryProc   
AS 
 
Declare @message_body AS xml; 
Declare @response     AS xml; 
Declare @message_type AS sysname; 
Declare @dialog       AS uniqueidentifier ; 
Declare @hDoc         AS int; 
--  This procedure will  process event messages from  
--  the queue until the queue is empty 
WHILE (1 = 1) 
BEGIN 
  BEGIN TRANSACTION 
  -- Receive the next available message 
  WAITFOR ( 
     RECEIVE top(1) -- just handle one message at a time 
       @message_type = message_type_name,   
       @message_body = message_body,       
       @dialog       = conversation_handle     
     FROM dbo.InventoryQueue 
     ), TIMEOUT 2000   
 
  -- If we didn't get anything, break out of the loop
  IF (@@ROWCOUNT = 0) 
  BEGIN 
    ROLLBACK TRANSACTION 
    BREAK; 
  END 
  
/*-------------------------------------------------------------------- 
-- Message handling logic based on the message type received 
--------------------------------------------------------------------*/ 
  
  -- Handle End Conversation messages by ending our conversation also 
  IF (@message_type = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog') 
  BEGIN 
    PRINT 'End Dialog for dialog # ' + cast(@dialog as nvarchar(40)); 
    END CONVERSATION @dialog; 
  END 
   -- For error messages, just end the conversation.  In a real app, we 
   -- would log the error and do any required cleanup. 
  ELSE IF (@message_type = 'http://schemas.microsoft.com/SQL/ServiceBroker/Error') 
  BEGIN 
    PRINT 'Dialog ERROR dialog # ' + cast(@dialog as nvarchar(40)); 
    END CONVERSATION @dialog; 
  END 
   -- Handle an AddItem message 
  ELSE IF (@message_type = '//microsoft.com/Inventory/AddItem') 
  BEGIN 
    SET @response  = N'Item added successfully' 
    -- Parse the message body and add to the inventory 
    BEGIN TRY  
      INSERT INTO dbo.Inventory  
(PartNumber, Description, Quantity, ReorderLevel, Location) 
 
        select itm.itm. value ('(PartNumber/text())[1]', 'nvarchar(50)') 
            as PartNumber, 
          itm.itm.value('(Description/text())[1]', 'nvarchar(2000)') 
            as Description, 
          itm.itm.value('(Quantity/text())[1]', 'int')  
            as Quantity, 
          itm.itm.value('(ReorderLevel/text())[1]', 'int')  
            as ReorderLevel, 
          itm.itm.value('(Location/text())[1]', 'nvarchar(50)')  
            as Location 
         from @message_body.nodes('/Item[1]') as itm(itm); 
 
    END TRY 
    BEGIN CATCH 
      ROLLBACK TRANSACTION 
      -- Create a new transaction to send the response 
      BEGIN TRANSACTION 
        SET @response  = ERROR_MESSAGE(); 
        -- ToDo - log the error 
        -- ToDo - poison message handling 
     END CATCH; 
     -- Send a response message confirming the add was done 
     SEND ON CONVERSATION @dialog  
       MESSAGE TYPE [//microsoft.com/Inventory/ItemAdded] (@response); 
     -- We handle one message at a time so we're done with this dialog 
     END CONVERSATION @dialog; 
  END -- If message type 
  COMMIT TRANSACTION 
END -- while 
GO

---------------------------------------------------------------------
---------------------------------------------------------------------
-- End of Listing 2
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Listing 3
--------------------------------------------------------------------- 
-- Create an empty procedure for the initiator so we can use it 
-- in the activation parameters when we create the queue 
--------------------------------------------------------------------- 

 
/*------------------------------------------------------------------- 
-- Create an empty procedure for the initiator so we can use it 
-- in the activation parameters when we create the queue 
-------------------------------------------------------------------*/ 
 
CREATE PROCEDURE dbo.ManufacturingProc  AS 
  RETURN 0; 
GO 
 
/*------------------------------------------------------------------- 
-- Create the initiator queue.  Activation is configured  
-------------------------------------------------------------------*/ 
  
CREATE QUEUE dbo.ManufacturingQueue 
  WITH ACTIVATION ( 
    STATUS = ON, 
    PROCEDURE_NAME = dbo.ManufacturingProc  ,  
    MAX_QUEUE_READERS = 2, 
    EXECUTE AS SELF       
    ); 
 
/*------------------------------------------------------------------- 
-- Create the Manufacturing service.  Because it is the initiator, it 
-- doesn't require contracts. 
-------------------------------------------------------------------*/ 
  
CREATE SERVICE [//microsoft.com/ManufacturingService]  
  ON QUEUE dbo.ManufacturingQueue; 
 
/*-------------------------------------------------------------------- 
-- Create a table to hold the state for our conversation 
-- We use the conversation handle as a key instead of the  
-- conversation group ID because we just have one conversation  
-- in our group. 
--------------------------------------------------------------------*/ 
  
CREATE TABLE dbo.InventoryState   
  ( 
    PartNumber      UNIQUEIDENTIFIER  Primary Key Clustered NOT NULL, 
    Dialog          UNIQUEIDENTIFIER NULL, 
    State           NVARCHAR(50) NULL 
  ); 
GO 
 
/*------------------------------------------------------------------- 
-- Create the initiator stored procedure 
-------------------------------------------------------------------*/ 
 
CREATE PROCEDURE AddItemProc 
AS 
 
DECLARE @message_body       AS xml; 
DECLARE @Dialog             AS uniqueidentifier; 
DECLARE @partno             AS uniqueidentifier; 
 
--Set the part number to a new GUID so we can run  
--this an unlimited number of times 
SET @partno = NEWID(); 
 
-- Populate the message body  
SET @message_body = '<Item> 
   <PartNumber>' + CAST (@partno as NVARCHAR(50)) + '</PartNumber> 
   <Description>2 cm Left Threaded machine screw</Description> 
   <Quantity>5883</Quantity> 
   <ReorderLevel>1000</ReorderLevel> 
   <Location>Aisle 32, Rack 7, Bin 29</Location> 
</Item>'; 
 
BEGIN TRANSACTION 
-- Begin a dialog to the Hello World Service 
 
BEGIN DIALOG  @Dialog 
  FROM SERVICE    [//microsoft.com/ManufacturingService] 
  TO SERVICE      '//microsoft.com/InventoryService' 
  ON CONTRACT     [//microsoft.com/Inventory/AddItemContract] 
  WITH ENCRYPTION = OFF, LIFETIME = 3600; 
 
-- Send message 
SEND ON CONVERSATION @Dialog  
  MESSAGE TYPE [//microsoft.com/Inventory/AddItem] (@message_body); 
 
-- Put a row into the state table to track this conversation 
INSERT INTO dbo.InventoryState   
  VALUES (@partno, @Dialog, 'Add Item Sent'); 
COMMIT TRANSACTION 
GO

---------------------------------------------------------------------
---------------------------------------------------------------------
-- End of Listing 3
--------------------------------------------------------------------- 
---------------------------------------------------------------------
-- Listing 4
---------------------------------------------------------------------


-- Create the procedure to handle the return messages at the initiator 
-- end of the conversation
--------------------------------------------------------------------- 

ALTER PROCEDURE dbo.ManufacturingProc  
AS 
 
DECLARE @message_body AS xml; 
DECLARE @message_type AS sysname; 
DECLARE @dialog       AS uniqueidentifier ; 
 
--  This procedure will  process event messages from  
--  the queue until the queue is empty 
 
WHILE (1 = 1) 
BEGIN 
  BEGIN TRANSACTION 
 
  -- Receive the next available message 
  WAITFOR ( 
    RECEIVE top(1)  
        @message_type=message_type_name,   
        @message_body=message_body,       
        @dialog = conversation_handle     
    FROM dbo.ManufacturingQueue 
    ), TIMEOUT 2000; 
 
  -- If we didn't get anything, break out of the loop
  IF (@@ROWCOUNT = 0) 
    BEGIN 
      ROLLBACK TRANSACTION 
      BREAK; 
    END  
    IF (@message_type =  
      'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog') 
    BEGIN 
       PRINT 'End Dialog for dialog # ' + CAST(@dialog as nvarchar(40)); 
       END CONVERSATION @dialog; 
    END 
  ELSE IF (@message_type =  
    'http://schemas.microsoft.com/SQL/ServiceBroker/Error') 
  BEGIN 
    PRINT 'Dialog ERROR dialog # ' + CAST(@dialog as nvarchar(40)); 
    END CONVERSATION @dialog; 
  END 
  ELSE IF (@message_type = '//microsoft.com/Inventory/ItemAdded') 
  BEGIN  
    UPDATE dbo.InventoryState  SET State = CAST(@message_body  
       AS NVARCHAR(1000)) WHERE Dialog = @dialog; 
  END 
  COMMIT TRANSACTION 
END -- while 
GO

-------------------------------------------------------------------
--  End of Listing 4
-------------------------------------------------------------------


-------------------------------------------------------------------
-- Run the sample
-------------------------------------------------------------------


/*
-- Execute the Add Item procedure to kick off the dialog
EXEC AddItemProc
*/

----------------------------------------------------------------------
----------------------------------------------------------------------
-- End Sample dialog
----------------------------------------------------------------------
----------------------------------------------------------------------



------------------------------------------------------------------------
------------------------------------------------------------------------
--  Dialog Security
------------------------------------------------------------------------
------------------------------------------------------------------------

------------------------------------------------------------------------ 
-- These scripts set up dialog security between the initiator and target  
-- of the AddItem dialog 
------------------------------------------------------------------------ 


------------------------------------------------------------------------ 
-- Start by creating a copy of the initiator endpoint in a seperate
-- database so we can set up security between the two databases.
--
-- Create the Manufacturing database for use by security samples 
------------------------------------------------------------------------ 

CREATE DATABASE Manufacturing; 
GO 
USE Manufacturing; 
GO 
  
--------------------------------------------------------------------- 
-- Create the message types we will need for the conversation 
--------------------------------------------------------------------- 
  
CREATE MESSAGE TYPE [//microsoft.com/Inventory/AddItem];  
CREATE MESSAGE TYPE [//microsoft.com/Inventory/ItemAdded]; 
  
--------------------------------------------------------------------- 
-- Create a contract for the AddItem conversation 
--------------------------------------------------------------------- 
  
CREATE CONTRACT [//microsoft.com/Inventory/AddItemContract] 
  ([//microsoft.com/Inventory/AddItem] SENT BY INITIATOR, 
  [//microsoft.com/Inventory/ItemAdded] SENT BY TARGET); 
GO 
  

--------------------------------------------------------------------- 
-- Create an empty procedure for the initiator so we can use it 
-- in the activation parameters when we create the queue 
--------------------------------------------------------------------- 
 
CREATE PROCEDURE dbo.ManufacturingProc  AS 
  RETURN 0; 
GO 
 
--------------------------------------------------------------------- 
-- Create the initiator queue.  Activation is configured  
--------------------------------------------------------------------- 
  
CREATE QUEUE dbo.ManufacturingQueue 
  WITH ACTIVATION ( 
    STATUS = ON, 
    PROCEDURE_NAME = dbo.ManufacturingProc  ,  
    MAX_QUEUE_READERS = 2, 
    EXECUTE AS SELF       
    ); 
 
--------------------------------------------------------------------- 
-- Create the Manufacturing service.  Because it is the initiator, it 
-- doesn't require contracts. 
--------------------------------------------------------------------- 
  
CREATE SERVICE [//microsoft.com/ManufacturingService]  
  ON QUEUE dbo.ManufacturingQueue; 
 
---------------------------------------------------------------------- 
-- Create a table to hold the state for our conversation 
-- We use the conversation handle as a key instead of the  
-- conversation group ID because we just have one conversation  
-- in our group. 
---------------------------------------------------------------------- 
  
CREATE TABLE dbo.InventoryState   
  ( 
    PartNumber      UNIQUEIDENTIFIER  Primary Key Clustered NOT NULL, 
    Dialog          UNIQUEIDENTIFIER NULL, 
    State           NVARCHAR(50) NULL 
  ); 
GO 
 
--------------------------------------------------------------------- 
-- Create the initiator stored procedure 
--------------------------------------------------------------------- 
 
CREATE PROCEDURE AddItemProc 
AS 
 
DECLARE @message_body       AS xml; 
DECLARE @Dialog             AS uniqueidentifier; 
DECLARE @partno             AS uniqueidentifier; 
 
--Set the part number to a new GUID so we can run  
--this an unlimited number of times 
SET @partno = NEWID(); 
 
-- Populate the message body  
SET @message_body = '<Item> 
   <PartNumber>' + CAST (@partno as NVARCHAR(50)) + '</PartNumber> 
   <Description>2 cm Left Threaded machine screw</Description> 
   <Quantity>5883</Quantity> 
   <ReorderLevel>1000</ReorderLevel> 
   <Location>Aisle 32, Rack 7, Bin 29</Location> 
</Item>'; 
 
BEGIN TRANSACTION 
-- Begin a dialog to the Hello World Service 
 
BEGIN DIALOG  @Dialog 
  FROM SERVICE    [//microsoft.com/ManufacturingService] 
  TO SERVICE      '//microsoft.com/InventoryService' 
  ON CONTRACT     [//microsoft.com/Inventory/AddItemContract] 
  WITH ENCRYPTION = OFF, LIFETIME = 3600; 
 
-- Send message 
SEND ON CONVERSATION @Dialog  
  MESSAGE TYPE [//microsoft.com/Inventory/AddItem] (@message_body); 
 
-- Put a row into the state table to track this conversation 
INSERT INTO dbo.InventoryState   
  VALUES (@partno, @Dialog, 'Add Item Sent'); 
COMMIT TRANSACTION 
GO

ALTER PROCEDURE dbo.ManufacturingProc  
AS 
 
DECLARE @message_body AS xml; 
DECLARE @message_type AS sysname; 
DECLARE @dialog       AS uniqueidentifier ; 
 
--  This procedure will just sit in a loop processing event messages in  
--  the queue until the queue is empty 
 
WHILE (1 = 1) 
BEGIN 
  BEGIN TRANSACTION 
 
  -- Receive the next available message 
  WAITFOR ( 
    RECEIVE top(1)  
        @message_type=message_type_name,   
        @message_body=message_body,       
        @dialog = conversation_handle     
    FROM dbo.ManufacturingQueue 
    ), TIMEOUT 2000; 
 
  -- If we didn't get anything, bail out 
  IF (@@ROWCOUNT = 0) 
    BEGIN 
      ROLLBACK TRANSACTION 
      BREAK; 
    END  
    IF (@message_type =  
      'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog') 
    BEGIN 
       PRINT 'End Dialog for dialog # ' + CAST(@dialog as nvarchar(40)); 
       END CONVERSATION @dialog; 
    END 
  ELSE IF (@message_type =  
    'http://schemas.microsoft.com/SQL/ServiceBroker/Error') 
  BEGIN 
    PRINT 'Dialog ERROR dialog # ' + CAST(@dialog as nvarchar(40)); 
    END CONVERSATION @dialog; 
  END 
  ELSE IF (@message_type = '//microsoft.com/Inventory/ItemAdded') 
  BEGIN  
    UPDATE dbo.InventoryState  SET State = CAST(@message_body  
       AS NVARCHAR(1000)) WHERE Dialog = @dialog; 
  END 
  COMMIT TRANSACTION 
END -- while 
GO


----------------------------------------------------------------------
-- End Setup for Manufacturing database
----------------------------------------------------------------------


----------------------------------------------------------------------
-- Test the new database
----------------------------------------------------------------------

/*
-- Execute the Add Item procedure to kick off the dialog
EXEC AddItemProc
*/

----------------------------------------------------------------------
---  Listing 5
----------------------------------------------------------------------

-- First, turn off the trustworthy flag 
 
USE master; 
GO 
ALTER DATABASE Manufacturing SET TRUSTWORTHY OFF; 
GO 
 
/*-------------------------------------------------------------------- 
-- Set up the Target Service security  
--------------------------------------------------------------------*/ 
 
USE Inventory; 
GO 
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass.word1'; 
 
-- Create a user to represent the "Inventory" Service 
CREATE USER InventoryServiceUser WITHOUT  LOGIN; 

-- Grant control on the Inventory service to this user 
GRANT CONTROL ON SERVICE::[//microsoft.com/InventoryService]  
  TO InventoryServiceUser;   
  
-- Make the Inventory Service user the owner of the service 
ALTER AUTHORIZATION ON SERVICE::[//microsoft.com/InventoryService]   
  TO InventoryServiceUser; 
 
-- Create a Private Key Certificate associated with this user 
CREATE CERTIFICATE InventoryServiceCertPriv  
  AUTHORIZATION InventoryServiceUser  
   WITH SUBJECT = 'ForInventoryService'; 
 
-- Dump the public key certificate to a file for use on the  
-- initiating server - no private key 
BACKUP CERTIFICATE InventoryServiceCertPriv  
  TO FILE = 'C:\InventoryServiceCertPub'; -- Replace with a directory of your choice
 
/*------------------------------------------------------------------- 
-- Set up the Initiator Service security  
-------------------------------------------------------------------*/ 
 
USE Manufacturing; 
GO 
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass.word1'; 
 
-- Create a user to own the "Manufacturing" Service 
CREATE USER ManufacturingServiceUser WITHOUT LOGIN; 
 
-- Make this user the owner of the FROM service 
ALTER AUTHORIZATION ON SERVICE::[//microsoft.com/ManufacturingService]   
  TO ManufacturingServiceUser; 
 
-- Create a Private Key Certificate associated with this user 
CREATE CERTIFICATE ManufacturingServiceCertPriv  
  AUTHORIZATION ManufacturingServiceUser  
   WITH SUBJECT = 'ForManufacturingService'; 
 
-- Dump the public key certificate to a file for use on  
-- the Manufacturing server 
BACKUP CERTIFICATE ManufacturingServiceCertPriv  
  TO FILE = 'C:\ManufacturingServiceCertPub';-- Same directory as the previous script 
 
-- Create a user to represent the "Inventory" Service 
CREATE USER InventoryServiceUser WITHOUT LOGIN; 
 
-- Import the cert we got from the Inventory Service owned  
-- by the user we just created 
CREATE CERTIFICATE InventoryServiceCertPub  
  AUTHORIZATION InventoryServiceUser 
   FROM FILE = 'C:\InventoryServiceCertPub'; 
 
CREATE REMOTE SERVICE BINDING ToInventoryService 
  TO SERVICE '//microsoft.com/InventoryService' 
   WITH USER = InventoryServiceUser; 
 
/*-------------------------------------------------------------------- 
-- Finish the Target Service security setup  
--------------------------------------------------------------------*/ 
 
USE Inventory; 
GO 
 
-- Create a user to represent the "Manufacturing" Service 
CREATE USER ManufacturingServiceUser WITHOUT LOGIN; 
 
-- Import the cert we got from the Manufacturing Service owned  
-- by the user we just created 
CREATE CERTIFICATE ManufacturingServiceCertPub  
  AUTHORIZATION ManufacturingServiceUser 
   FROM FILE = 'C:\ManufacturingServiceCertPub'; 
GRANT SEND ON SERVICE::[//microsoft.com/InventoryService]  
  TO ManufacturingServiceUser ;

------------------------------------------------------------
-- End Listing 5
------------------------------------------------------------
------------------------------------------------------------





------------------------------------------------------------
-- Configuring EndPoints for transport level security
------------------------------------------------------------

------------------------------------------------------------
-- Create an endpoint for the inventory server 
-- with Windows authentication 
------------------------------------------------------------

USE master
GO 
 
CREATE ENDPOINT InventoryEndpoint STATE = STARTED 
  AS TCP ( LISTENER_PORT = 5523 ) 
   FOR SERVICE_BROKER ( AUTHENTICATION = WINDOWS ); 
CREATE LOGIN [MYDOMAIN\Service account of manufacturing service account] FROM Windows; 
 
-- Grant Manufacturing instance service account connect privileges 
GRANT CONNECT ON ENDPOINT::InventoryEndpoint  
  TO [MYDOMAIN\service account of manufacturing instance];



--------------------------------------------------------------
-- Create an endpoint for the manufacturing server 
-- with Windows authentication 
---------------------------------------------------------------
USE master 
GO 
CREATE ENDPOINT ManufacturingEndpoint STATE = STARTED 
  AS TCP ( LISTENER_PORT = 5524 ) 
   FOR SERVICE_BROKER ( AUTHENTICATION = WINDOWS ); 
 
--Create a login for remote system in this instance 
-- Change to your domain and server name! 
 
CREATE LOGIN [MYDOMAIN\Service account of inventory service account] FROM Windows; 

-- Grant Inventory instance service account connect privilege
GRANT CONNECT ON ENDPOINT::ManufacturingEndpoint  
  TO [MYDOMAIN\Service account of manufacturing instance];
 

---------------------------------------------------------------------
-- Alternative endpoint security using certificates
---------------------------------------------------------------------

-- Creating Certificates for Security

---------------------------------------------------------------------- 
-- Setup Certificate authenticated Endpoint 
-- on the Inventory server 
---------------------------------------------------------------------- 
/*-------------------------------------------------------------------- 
-- Setup Certificate authenticated Endpoint 
-- on the Inventory server 
--------------------------------------------------------------------*/ 
 
-- Create a certificate to represent the inventory 
-- server and export it to a file 
USE MASTER
 CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass.word1'; 

 
CREATE CERTIFICATE InventoryCertPriv 
  WITH SUBJECT = 'ForInventoryAuth'; 
BACKUP CERTIFICATE InventoryCertPriv  
  TO FILE = 'C:\InventoryCertPub'; 
GO 
  
-- Create a Service Broker Endpoint that uses this 
-- certificate for authentication 
 
CREATE ENDPOINT InventoryEndpoint STATE = STARTED 
  AS TCP ( LISTENER_PORT = 4423 ) 
   FOR SERVICE_BROKER ( AUTHENTICATION = CERTIFICATE InventoryCertPriv  );




---------------------------------------------------------------------- 
-- Setup Certificate authenticated Endpoint 
-- on the Manufacturing server 
---------------------------------------------------------------------- 
 
-- Create a certificate to represent the  
-- manufacturing server and export it to a file 
USE MASTER
 CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass.word1'; 
 
CREATE CERTIFICATE ManufacturingCertPriv 
  WITH SUBJECT = 'ForManufacturingAuth'; 
BACKUP CERTIFICATE ManufacturingCertPriv  
  TO FILE = 'C:\ManufacturingCertPub'; 
GO 
  
-- Create a Service Broker Endpoint that uses this 
-- certificate for authentication 
 
CREATE ENDPOINT ManufacturingEndpoint  
    STATE = STARTED 
   AS TCP ( LISTENER_PORT = 4424 ) 
  FOR SERVICE_BROKER (AUTHENTICATION =  
  CERTIFICATE ManufacturingCertPriv); 
 
-- Create a user and login to represent the  
-- inventory server on the manufacturing server 
 
CREATE LOGIN InventoryProxy  
  WITH PASSWORD = 'dj47dkri837&?>'; 
CREATE USER InventoryProxy; 
 
-- Import the certificate exported by the inventory server 
 
CREATE CERTIFICATE InventoryCertPub  
  AUTHORIZATION InventoryProxy 
   FROM FILE = 'C:\InventoryCertPub'; 
 
-- Grant connect privileges to the login that  
-- represents the inventory server 
 
GRANT CONNECT ON ENDPOINT::ManufacturingEndpoint  
  TO InventoryProxy;




---------------------------------------------------------------------- 
-- Finish the certificate-authenticated endpoint back 
-- on the Inventory server 
---------------------------------------------------------------------- 
 
/*-------------------------------------------------------------------- 
-- Finish the certificate-authenticated endpoint 
-- on the Inventory server 
--------------------------------------------------------------------*/ 
 
-- Create a user and login to represent the  
-- manufacturing server on the inventory server 
 
CREATE LOGIN ManufacturingProxy  
  WITH PASSWORD = 'dj47dkri837&?>'; 
CREATE USER ManufacturingProxy; 
 
-- Import the certificate exported by the Manufacturing server 
 
CREATE CERTIFICATE InventoryCertPub AUTHORIZATION ManufacturingProxy 
  FROM FILE = 'C:\ManufacturingCertPub'; 
 
-- Grant connect privileges to the login that  
-- represents the Manufacturing server 
 
GRANT CONNECT ON ENDPOINT::InventoryEndpoint  
  TO ManufacturingProxy;



----------------------------------------------------------------------
----------------------------------------------------------------------
-- End of sample dialog listings
----------------------------------------------------------------------

---------------------------------------------------------------------- 
-- Catalogue View for listing contracts
---------------------------------------------------------------------- 


SELECT  C.name AS Contract, M.name AS MessageType, 
  CASE 
    WHEN is_sent_by_initiator = 1 
     AND is_sent_by_target    = 1 THEN 'ANY' 
    WHEN is_sent_by_initiator = 1 THEN 'INITIATOR' 
    WHEN is_sent_by_target    = 1 THEN 'TARGET' 
  END AS SentBy 
FROM sys.service_message_types AS M 
  JOIN sys.service_contract_message_usages AS U 
    ON M.message_type_id = U.message_type_id 
  JOIN sys.service_contracts AS C 
    ON C.service_contract_id = U.service_contract_id 
ORDER BY C.name, M.name;


---------------------------------------------------------------------- 
-- List Contracts associated with each service
---------------------------------------------------------------------- 

SELECT S.name AS [Service], Q.name AS [Queue], C.name AS [Contract]  
FROM sys.services AS S  
  JOIN sys.service_queues AS Q 
    ON S.service_queue_id = Q.object_id 
  JOIN sys.service_contract_usages  AS U  
    ON S.service_id = U.service_id 
  JOIN sys.service_contracts AS C 
    ON U.service_contract_id = C.service_contract_id;


---------------------------------------------------------------------- 
-- Broker Priority Objects
---------------------------------------------------------------------- 


----------------------------------------------------------------------
-- First, create some services and contracts we can use for priority
-- objects.
-----------------------------------------------------------------------
CREATE DATABASE PriotitySample
GO
USE PriotitySample
GO
CREATE MESSAGE TYPE
    [SubmitExpense]         
    VALIDATION = WELL_FORMED_XML ;         

CREATE MESSAGE TYPE
    [ExpenseApprovedOrDenied]         
    VALIDATION = WELL_FORMED_XML ;         

CREATE MESSAGE TYPE         
    [ExpenseReimbursed]         
    VALIDATION= WELL_FORMED_XML ;         

CREATE CONTRACT          
    [ExpenseSubmission]         
    ( [SubmitExpense]         
          SENT BY INITIATOR,         
      [ExpenseApprovedOrDenied]         
          SENT BY TARGET,         
      [ExpenseReimbursed]         
          SENT BY TARGET         
    ) ;

CREATE CONTRACT          
    [ExpenseReimbusement]         
    ( [SubmitExpense]         
          SENT BY INITIATOR,         
      [ExpenseReimbursed]         
          SENT BY TARGET         
    ) ;


CREATE CONTRACT          
    [ExpenseDenied]         
    ( [SubmitExpense]         
          SENT BY INITIATOR,         
      [ExpenseApprovedOrDenied]         
          SENT BY TARGET         
    ) ;
CREATE CONTRACT          
    [ExpenseApproved]         
    ( [SubmitExpense]         
          SENT BY INITIATOR,         
      [ExpenseApprovedOrDenied]         
          SENT BY TARGET         
    ) ;
CREATE QUEUE Submit

CREATE QUEUE Process

CREATE SERVICE [ExpenseSubmit]
    ON QUEUE Submit
    ([ExpenseSubmission]) ;

CREATE SERVICE [ExpenseProcess]
    ON QUEUE Process
    ([ExpenseDenied]) ;




--------------------------------------------------------------
-- Create priority objects
--------------------------------------------------------------


-- Set the priority of a single dialog type
CREATE BROKER PRIORITY ExpenseSubmitPriority
  FOR CONVERSATION
  SET (CONTRACT_NAME = [ExpenseSubmission],
   LOCAL_SERVICE_NAME = [ExpenseSubmit],
   REMOTE_SERVICE_NAME = N'ExpenseProcess',
   PRIORITY_LEVEL = 8);

-- Set the priority for the other end of the dialog above
CREATE BROKER PRIORITY ExpenseProcessPriority
  FOR CONVERSATION
  SET (CONTRACT_NAME = [ExpenseSubmission],
   LOCAL_SERVICE_NAME = [ExpenseProcess],
   REMOTE_SERVICE_NAME = N'ExpenseSubmit',
   PRIORITY_LEVEL = 8);

-- Set the priority for all dialogs from the SpringfieldExpenses service
CREATE BROKER PRIORITY SpringfieldPriority
  FOR CONVERSATION
  SET (CONTRACT_NAME = ANY,
   LOCAL_SERVICE_NAME = ANY,
   REMOTE_SERVICE_NAME = N'SpringfieldExpense',
   PRIORITY_LEVEL = 7);


-- Set the priority for all dialogs with the specified contract
CREATE BROKER PRIORITY ExpenseProcessPriorityAll
  FOR CONVERSATION
  SET (CONTRACT_NAME = [ExpenseSubmission],
   LOCAL_SERVICE_NAME = ANY,
   REMOTE_SERVICE_NAME = ANY,
   PRIORITY_LEVEL = 8);


-- Set the priority of all dialogs to the ExpenseProcess service
CREATE BROKER PRIORITY ExpensePriority
  FOR CONVERSATION
  SET (CONTRACT_NAME = ANY,
   LOCAL_SERVICE_NAME = [ExpenseProcess],
   REMOTE_SERVICE_NAME = ANY,
   PRIORITY_LEVEL = 9);


-- Set the priority for dialogs of any type between the specified endpoints
CREATE BROKER PRIORITY ExpenseProcessAllContracts
  FOR CONVERSATION
  SET (CONTRACT_NAME = ANY,
   LOCAL_SERVICE_NAME = [ExpenseProcess],
   REMOTE_SERVICE_NAME = N'ExpenseSubmit',
   PRIORITY_LEVEL = 3);


---------------------------------------------------------------------- 
-- Troubleshooting
---------------------------------------------------------------------- 

/*  Uncomment this one before use.  Commented out so it is not run accidentally


--  Remove all Closed dialogs

declare @handle uniqueidentifier
declare conv cursor for select conversation_handle from
   sys.conversation_endpoints	where state = 'CLOSED'
open conv
fetch NEXT FROM conv into @handle
while @@FETCH_STATUS = 0
Begin
	END Conversation @handle with cleanup
	fetch NEXT FROM conv into @handle
End
close conv
deallocate conv

*/