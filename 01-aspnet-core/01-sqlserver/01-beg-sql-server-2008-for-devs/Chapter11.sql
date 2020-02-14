/* Chapter 11 */


/* Try it out - Joining Two Tables - Step 1 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - Joining Two Tables - Step 3 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId
AND sp.Price = s.CurrentPrice

/* Try it out - Joining Two Tables - Step 5 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
LEFT OUTER JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - Joining Two Tables - Step 7 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
LEFT OUTER JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId
WHERE sp.Price IS NULL

/* Try it out - Joining Two Tables - Step 9 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.SharePrices sp
RIGHT OUTER JOIN ShareDetails.Shares s ON sp.ShareId = s.ShareId

/* Try it out - Joining Two Tables - Step 11 */
INSERT INTO ShareDetails.SharePrices
(ShareId, Price, PriceDate)
VALUES (99999,12.34,'1 Aug 2008 10:10AM')
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.SharePrices sp
FULL OUTER JOIN ShareDetails.Shares s ON sp.ShareId = s.ShareId

/* Try it out - Joining Two Tables - Step 13 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.SharePrices sp
CROSS JOIN ShareDetails.Shares s

/* Try it out - Declaring and Working with Variables - Step 1 */
DECLARE @MyDate datetime=GETDATE(), @CurrPriceInCents money
SELECT @CurrPriceInCents = CurrentPrice * 100
FROM ShareDetails.Shares
WHERE ShareId = 2
SELECT @MyDate,@CurrPriceInCents

/* Try it out - Declaring and Working with Variables - Step 3 */
DECLARE @MyDate datetime= GETDATE(), @CurrPriceInCents money
SELECT @CurrPriceInCents = CurrentPrice * 100
FROM ShareDetails.Shares
WHERE ShareId = 2
GO
SELECT @MyDate,@CurrPriceInCents

/* Try it out - Declaring and Working with Variables - Step 5 */
DECLARE @MyDate datetime= GETDATE(), @CurrPriceInCents money
SELECT @CurrPriceInCents = CurrentPrice * 100
FROM ShareDetails.Shares
-- WHERE ShareId = 2
--GO
SELECT @MyDate,@CurrPriceInCents


/* Try it out - Temporary Tables - Step 1 */
CREATE TABLE #SharesTmp
(ShareDesc varchar(50),
Price numeric(18,5),
PriceDate datetime)

/* Try it out - Temporary Tables - Step 2 */
INSERT INTO #SharesTmp
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - Temporary Tables - Step 3 and 5*/
SELECT * FROM #SharesTmp

/* Try it out - Temporary Tables - Step 7 */
DROP TABLE #SharesTmp

/* Try it out - Temporary Tables - Step 8 */
CREATE TABLE ##SharesTmp
(ShareDesc varchar(50),
Price numeric(18,5),
PriceDate datetime)
INSERT INTO ##SharesTmp
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId
SELECT * FROM ##SharesTmp

/* Try it out - Temporary Tables - Step 10 */
SELECT * FROM ##SharesTmp


/* Try it out - Counting Rows - Step 1 */
SELECT COUNT(*) AS 'Number of Rows'
FROM ShareDetails.Shares

/* Try it out - Counting Rows - Step 3 */
SELECT COUNT(*) AS 'Number of Rows'
FROM ShareDetails.Shares
WHERE CurrentPrice > 10


/* Try it out - Summing Values - Step 1 */
SELECT SUM(Amount) AS 'Amount Deposited'
FROM TransactionDetails.Transactions
WHERE CustomerId = 1
AND TransactionType = 1

/* Try it out - Max and Min - Step 1 */
SELECT MAX(Price) MaxPrice,MIN(Price) MinPrice
FROM ShareDetails.SharePrices

/* Try it out - AVG - Step 1 */
SELECT AVG(Price) AvgPrice
FROM ShareDetails.SharePrices
WHERE ShareId = 1

/* Try it out - GROUP BY - Step 1 */
SELECT ShareId, MIN(Price) MinPrice, Max(Price) MaxPrice
FROM ShareDetails.SharePrices
WHERE ShareId < 9999
GROUP BY ShareId

/* Try it out - GROUP BY - Step 3 */
SELECT sp.ShareId, s.ShareDesc,MIN(Price) MinPrice, Max(Price) MaxPrice
FROM ShareDetails.SharePrices sp
LEFT JOIN ShareDetails.Shares s ON s.ShareId = sp.ShareId
WHERE sp.ShareId < 9999
GROUP BY ALL sp.ShareId, s.ShareDesc

/* Try it out - HAVING - Step 1 */
SELECT sp.ShareId, s.ShareDesc,MIN(Price) MinPrice, Max(Price) MaxPrice
FROM ShareDetails.SharePrices sp
LEFT JOIN ShareDetails.Shares s ON s.ShareId = sp.ShareId
WHERE sp.ShareId < 9999
GROUP BY ALL sp.ShareId, s.ShareDesc
HAVING MIN(Price) > 10

/* Try it out - DISTINCT VALUES - Step 1 */
SELECT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - DISTINCT VALUES - Step 2 */
SELECT DISTINCT s.ShareDesc,sp.Price,sp.PriceDate
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - DISTINCT VALUES - Step 3 */
SELECT DISTINCT s.ShareDesc
FROM ShareDetails.Shares s
JOIN ShareDetails.SharePrices sp ON sp.ShareId = s.ShareId

/* Try it out - DATEADD - Step 1 */
DECLARE @OldTime datetime
SET @OldTime = '24 March 2008 3:00 PM'
SELECT DATEADD(hh,4,@OldTime)

/* Try it out - DATEADD - Step 2 */
DECLARE @OldTime datetime
SET @OldTime = '24 March 2008 3:00 PM'
SELECT DATEADD(hh,-6,@OldTime)

/* Try it out - DATEDIFF - Step 1 */
DECLARE @FirstTime datetime, @SecondTime datetime
SET @FirstTime = '24 March 2008 3:00 PM'
SET @SecondTime = '24 March 2008 3:33PM'
SELECT DATEDIFF(ms,@FirstTime,@SecondTime)

/* Try it out - DATENAME - Step 1 */
DECLARE @StatementDate datetime
SET @StatementDate = '24 March 2008 3:00 PM'
SELECT DATENAME(dw,@StatementDate)

/* Try it out - DATEPART - Step 1 */
DECLARE @WhatsTheDay datetime
SET @WhatsTheDay = '24 March 2008 3:00 PM'
SELECT DATEPART(dd, @WhatsTheDay)

/* Try it out - DATEPART - Step 2 */
DECLARE @WhatsTheDay datetime
SET @WhatsTheDay = '24 March 2008 3:00 PM'
SELECT DATENAME(dw, @WhatsTheDay) + ', ' +
CAST(DATEPART(dd,@WhatsTheDay) AS varchar(2)) + ' ' +
DATENAME(mm,@WhatsTheDay) + ' ' +
CAST(DATEPART(yyyy,@WhatsTheDay) AS char(4))

/* Try it out - ASCII - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = ASCII('Robin ')

/* Try it out - CHAR - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = ASCII('Robin ')
SELECT CHAR(@StringTest)
SELECT @StringTest

/* Try it out - CHAR - Step 3 */
DECLARE @StringTest int
SET @StringTest = ASCII('Robin ')
SELECT CHAR(@StringTest)

/* Try it out - LEFT - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = 'Robin '
SELECT LEFT(@StringTest,3)

/* Try it out - LOWER - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = 'Robin '
SELECT LOWER(LEFT(@StringTest,3))

/* Try it out - LTRIM - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = ' Robin'
SELECT 'Start-'+LTRIM(@StringTest),'Start-'+@StringTest

/* Try it out - RIGHT - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = ' Robin'
SELECT RIGHT(@StringTest,3)

/* Try it out - RTRIM - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = 'Robin'
SELECT @StringTest+'-End',RTRIM(@StringTest)+'-End'

/* Try it out - STR - Step 1 */
SELECT 'A'+82

/* Try it out - STR - Step 3 */
SELECT 'A'+STR(82)

/* Try it out - STR - Step 5 */
SELECT 'A'+LTRIM(STR(82))

/* Try it out - SUBSTR - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = 'Robin '
SELECT SUBSTRING(@StringTest,3,LEN(@StringTest))

/* Try it out - UPPER - Step 1 */
DECLARE @StringTest char(10)
SET @StringTest = 'Robin '
SELECT UPPER(@StringTest)

/* Try it out - CASE - Step 1 */
SET QUOTED_IDENTIFIER OFF
SELECT CustomerId,
CASE WHEN CreditType = 0 THEN "Debits" ELSE "Credits" END
AS TranType,SUM(Amount)
FROM TransactionDetails.Transactions t
JOIN TransactionDetails.TransactionTypes tt ON
tt.TransActionTypeId = t.TransactionType
WHERE t.DateEntered BETWEEN '1 Aug 2008' AND '31 Aug 2008'
GROUP BY CustomerId,CreditType

/* Try it out - CAST/CONVERT - Step 1 */
DECLARE @Cast int
SET @Cast = 1234
SELECT CAST(@Cast as char(10)) + '-End'

/* Try it out - CAST/CONVERT - Step 3 */
DECLARE @Convert int
SET @Convert = 5678
SELECT CONVERT(char(10),@Convert) + '-End'

/* Try it out - ISDATE - Step 1 */
DECLARE @IsDate char(15)
SET @IsDate = '31 Sep 2008'
SELECT ISDATE(@IsDate)

/* Try it out - ISDATE - Step 3 */
DECLARE @IsDate char(15)
SET @IsDate = '30 Sep 2008'
SELECT ISDATE(@IsDate)

/* Try it out - ISNULL - Step 1 */
DECLARE @IsNull char(10)
SET @IsNull = NULL
SELECT ISNULL(@IsNull,GETDATE())

/* Try it out - ISNUMERIC - Step 1 */
DECLARE @IsNum char(10)
SET @IsNum = 'Robin '
SELECT ISNUMERIC(@IsNum)

/* Try it out - ISNUMERIC - Step 2 */
DECLARE @IsNum char(10)
SET @IsNum = '1234 '
SELECT ISNUMERIC(@IsNum)

/* Try it out - RAISERROR - Step 1 */
sp_addmessage @msgnum=50001,@severity=1,
@msgtext='Customer is overdrawn'

/* Try it out - RAISERROR - Step 2 */
RAISERROR (50001,1,1)

/* Try it out - RAISERROR - Step 4 */
sp_addmessage @msgnum =50001,@severity=1,
@msgtext='Customer is overdrawn. CustomerId= %010u',@replace='replace'

/* Try it out - RAISERROR - Step 5 */
RAISERROR (50001,1,1,243)

/* Try it out - @@ERROR - Step 1 */
SELECT 100/0
SELECT @@ERROR
SELECT @@ERROR

/* Try it out - @@ERROR - Step 4 */
RAISERROR (50001,1,1,243)
SELECT @@ERROR

/* Try it out - @@ERROR - Step 6 */
RAISERROR (50001,11,1,243)
SELECT @@ERROR

/* Try it out - TRY. . .CATCH - Step 1 */
DECLARE @Probs int
BEGIN TRY
SELECT 'This will work'
SELECT @Probs='Not Right'
SELECT 10+5,
'This will also work, however the error means it will not run'
END TRY
BEGIN CATCH
SELECT 'An error has occurred at line ' +
LTRIM(STR(ERROR_LINE())) +
' with error ' + LTRIM(STR(ERROR_NUMBER())) + ' ' + ERROR_MESSAGE()
END CATCH

/* Try it out - TRY. . .CATCH - Step 3 */
DECLARE @Probs int
BEGIN TRY
SELECT 'This will work'
BEGIN TRY
SELECT @Probs='Not Right'
SELECT 10+5,
'This will also work, however the error means it will not run'
END TRY
BEGIN CATCH
SELECT 'The second catch block'
END CATCH
SELECT 'And then this will now work'
END TRY
BEGIN CATCH
SELECT 'An error has occurred at line ' +
LTRIM(STR(ERROR_LINE())) +
' with error ' + LTRIM(STR(ERROR_NUMBER())) + ' ' + ERROR_MESSAGE()
END CATCH

/* Try it out - TRY. . .CATCH - Step 5 */
DECLARE @Probs int
BEGIN TRY
SELECT 'This will work'
BEGIN TRY
SELECT * FROM #Temp
END TRY
BEGIN CATCH
SELECT 'The second catch block'
END CATCH
SELECT 'And then this will now work'
END TRY
BEGIN CATCH
SELECT 'An error has occurred at line ' +
LTRIM(STR(ERROR_LINE())) +
' with error ' + LTRIM(STR(ERROR_NUMBER())) + ' ' + ERROR_MESSAGE()
END CATCH

/* Try it out - TRY. . .CATCH - Step 7 */
DECLARE @Probs int
SELECT 'This will work'
BEGIN TRY
SELECT @Probs='Not Right'
SELECT 10+5,
'This will also work, however the error means it will not run'
END TRY
BEGIN CATCH
DECLARE @ErrMsg NVARCHAR(4000)
DECLARE @ErrSeverity INT
DECLARE @ErrState INT
SELECT 'Blimey! An error'
SELECT
@ErrMsg = ERROR_MESSAGE(),
@ErrSeverity = ERROR_SEVERITY(),
@ErrState = ERROR_STATE();
RAISERROR (@ErrMsg,@ErrSeverity,@ErrState)
END CATCH