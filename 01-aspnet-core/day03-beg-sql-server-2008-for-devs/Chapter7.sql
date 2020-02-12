/* Chapter 7 */

/* Try it out - Taking a Database Offline - Step 1 */
USE master
GO
ALTER DATABASE ApressFinancial
SET OFFLINE


/* Try it out - Taking a Database Offline - Step 2 */
USE master
go
ALTER DATABASE ApressFinancial
SET ONLINE

/* Try it out - Backing Up the Database Using T-SQL for a Full and Differential Backup - Step 2 */
BACKUP DATABASE ApressFinancial
TO DISK = 'C:\Program Files\Microsoft SQL
Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial.bak'
WITH NAME = 'ApressFinancial-Full Database Backup',
SKIP,
NOUNLOAD,
STATS = 10

/* Try it out - Backing Up the Database Using T-SQL for a Full and Differential Backup - Step 6 */

BACKUP DATABASE [ApressFinancial] TO DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\
Backup\ApressFinancial.bak'
WITH DIFFERENTIAL ,
DESCRIPTION = 'This is a differential backup',
RETAINDAYS = 60, NOFORMAT, NOINIT,
MEDIANAME = N'ApressBackup',
NAME = N'ApressFinancial-Differential Database Backup',
NOSKIP, NOREWIND, NOUNLOAD, STATS = 10, CHECKSUM
GO

/* Try it out - Backing Up the Database Using T-SQL for a Full and Differential Backup - Step 7 */
declare @backupSetId as int
select @backupSetId = position
from msdb..backupset
where database_name=N'ApressFinancial'
and backup_set_id=
(select max(backup_set_id)
from msdb..backupset
where database_name=N'ApressFinancial' )
if @backupSetId is null
begin
raiserror(N'Verify failed. Backup information for database ''ApressFinancial''
not found.', 16, 1)
end
RESTORE VERIFYONLY FROM
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER
\MSSQL\Backup\ApressFinancial.bak'
WITH FILE = @backupSetId,
NOUNLOAD,
NOREWIND


/* Try it out - Backing Up the Transaction Log Using T-SQL - Step 1 */

BACKUP LOG ApressFinancial
TO DISK = 'C:\Program Files\Microsoft SQL
Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial.bak'
WITH NOFORMAT, NOINIT,
NAME = N'ApressFinancial-Transaction Log Backup',
SKIP, NOREWIND, NOUNLOAD,
STATS = 10


/* Try it out - Restoring a Database - Step 1 */

USE ApressFinancial
GO
ALTER TABLE ShareDetails.Shares
ADD DummyColumn varchar(30)


/* Try it out - Restoring Using T-SQL - Step 1 */
USE ApressFinancial
GO
ALTER TABLE ShareDetails.Shares
ADD DummyColumn varchar(30)


/* Try it out - Restoring Using T-SQL - Step 2 */
USE Master
GO
RESTORE DATABASE [ApressFinancial]
FROM DISK = 'C:\Program Files\Microsoft SQL
Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial.bak' WITH FILE = 2,
NORECOVERY, NOUNLOAD, REPLACE, STATS = 10
GO

/* Try it out - Restoring Using T-SQL - Step 3 */
RESTORE DATABASE [ApressFinancial]
FROM DISK = 'C:\Program Files\Microsoft SQL
Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial.bak' WITH FILE = 4,
NORECOVERY, NOUNLOAD, REPLACE, STATS = 10
GO


/* Try it out - Restoring Using T-SQL - Step 4 */
RESTORE LOG [ApressFinancial]
FROM DISK = 'C:\Program Files\Microsoft SQL
Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\
ApressFinancial.bak' WITH FILE = 5,
NOUNLOAD, STATS = 10


/* Try it out - Detaching and Reattaching a Database - Step 1 */
USE master
GO
sp_detach_db 'ApressFinancial'

/* Try it out - Detaching and Reattaching a Database - Step 4 */
ALTER DATABASE ApressFinancial
SET SINGLE_USER WITH ROLLBACK IMMEDIATE

/* Try it out - Detaching and Reattaching a Database - Step 5 */
ALTER DATABASE ApressFinancial
SET MULTI_USER


/* Try it out - Detaching and Reattaching a Database - Step 6 */

CREATE DATABASE ApressFinancial
ON (FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\
Data\ApressFinancial.MDF')
FOR ATTACH

/* Try it out - Creating a Database Maintenance Plan - Step 1 */
sp_configure 'show advanced options', 1
GO
RECONFIGURE;
GO
sp_configure 'Agent XPs', 1
GO
RECONFIGURE
GO