/* Chapter 4 */

/* Try it out - Creating a Group - Step 11 */

USE [master]
GO
CREATE LOGIN [FAT-BELLY\Apress_Product_Controllers]
FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
USE [ApressFinancial]
GO
CREATE USER [FAT-BELLY\Apress_Product_Controllers]
FOR LOGIN [FAT-BELLY\Apress_Product_Controllers]
GO

/* Try it out - Programmatically Working with a Login - Step 2 */
USE [master]
GO
CREATE LOGIN [FAT-BELLY\Apress_Product_Controllers]
FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
USE [ApressFinancial]
GO
CREATE USER [FAT-BELLY\Apress_Product_Controllers]
FOR LOGIN [FAT-BELLY\Apress_Product_Controllers]
GO

/* Try it out - Programmatically Working with a Login - Step 3 */
CREATE LOGIN [FAT-BELLY\Apress_Client_Information]
FROM WINDOWS
WITH DEFAULT_DATABASE=[ApressFinancial],
DEFAULT_LANGUAGE=[us_english]
GO

/* Try it out - Creating Schemas and Adding Objects - Step 1 */
USE ApressFinancial
GO
CREATE SCHEMA TransactionDetails AUTHORIZATION dbo

/* Try it out - Creating Schemas and Adding Objects - Step 3 */
CREATE SCHEMA ShareDetails AUTHORIZATION dbo
GO
CREATE SCHEMA CustomerDetails AUTHORIZATION dbo










