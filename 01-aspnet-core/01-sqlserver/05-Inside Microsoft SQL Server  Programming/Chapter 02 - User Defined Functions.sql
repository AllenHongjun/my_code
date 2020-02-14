---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 02: User Defined Functions
-- Copyright Itzik Ben-Gan, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Some Facts about UDFs
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Scalar UDFs
---------------------------------------------------------------------

---------------------------------------------------------------------
-- T-SQL Scalar UDFs
---------------------------------------------------------------------

-- Creating the ConcatOrders function
SET NOCOUNT ON;
USE InsideTSQL2008;

IF OBJECT_ID('dbo.ConcatOrders', 'FN') IS NOT NULL
  DROP FUNCTION dbo.ConcatOrders;
GO

CREATE FUNCTION dbo.ConcatOrders
  (@custid AS INT) RETURNS VARCHAR(MAX)
AS
BEGIN
  DECLARE @orders AS VARCHAR(MAX);
  SET @orders = '';

  SELECT @orders = @orders + CAST(orderid AS VARCHAR(10)) + ';'
  FROM Sales.Orders
  WHERE custid = @custid;

  RETURN @orders;
END
GO

-- Test the ConcatOrders function
SELECT custid, dbo.ConcatOrders(custid) AS orders
FROM Sales.Customers;

-- String Concatenation using FOR XML PATH
SELECT custid,
  COALESCE(
    (SELECT CAST(orderid AS VARCHAR(10)) + ';' AS [text()]
     FROM Sales.Orders AS O
     WHERE O.custid = C.custid
     ORDER BY orderid
     FOR XML PATH(''), TYPE).value('.[1]', 'VARCHAR(MAX)'), '') AS orders
FROM Sales.Customers AS C;

-- Cleanup
IF OBJECT_ID('dbo.ConcatOrders', 'FN') IS NOT NULL
  DROP FUNCTION dbo.ConcatOrders;

---------------------------------------------------------------------
-- Performance Issues
---------------------------------------------------------------------

-- Listing 2-1: Creating and Populating Auxiliary Table of Numbers
SET NOCOUNT ON;
USE InsideTSQL2008;

IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;

CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);
DECLARE @max AS INT, @rc AS INT;
SET @max = 1000000;
SET @rc = 1;

INSERT INTO Nums VALUES(1);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.Nums SELECT n + @rc FROM dbo.Nums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.Nums 
  SELECT n + @rc FROM dbo.Nums WHERE n + @rc <= @max;
GO

-- Discard results after execution

-- Runs in less than a second
-- Plan shows Compute Scalar operator
-- Property Defined Values is [Expr1003] = Scalar Operator([Generic].[dbo].[Nums].[n]+(1))
SELECT n, n + 1 AS n_plus_one FROM dbo.Nums WHERE n <= 1000000;

-- Create AddOne function
IF OBJECT_ID('dbo.AddOne', 'FN') IS NOT NULL
  DROP FUNCTION dbo.AddOne;
GO
CREATE FUNCTION dbo.AddOne(@i AS INT) RETURNS INT
AS
BEGIN
  RETURN @i + 1;
END
GO

-- Runs for 5 seconds
-- Plan shows Compute Scalar operator
-- Property Defined Values is [Expr1003] = Scalar Operator([InsideTSQL2008].[dbo].[AddOne]([Generic].[dbo].[Nums].[n]))
SELECT n, dbo.AddOne(n) AS n_plus_one FROM dbo.Nums WHERE n <= 1000000;

-- Run a trace in Profiler with SP:Starting event; change filter to n <= 10
SELECT n, dbo.AddOne(n) AS n_plus_one FROM dbo.Nums WHERE n <= 10;

-- Use Inline Table-Valued Function
IF OBJECT_ID('dbo.AddOneInline', 'IF') IS NOT NULL
  DROP FUNCTION dbo.AddOneInline;
GO
CREATE FUNCTION dbo.AddOneInline(@n AS INT) RETURNS TABLE
AS
RETURN SELECT @n + 1 AS val;
GO

-- Runs in less than a second
-- Same plan as query without function call
SELECT n, (SELECT val FROM dbo.AddOneInline(n) AS F) AS n_plus_one
FROM dbo.Nums WHERE n <= 1000000;
GO

-- Using CROSS APPLY
SELECT Nums.n, A.val AS n_plus_one
FROM dbo.Nums CROSS APPLY dbo.AddOneInline(n) AS A
WHERE n <= 1000000;

-- Turn off Discard results after execution

-- Counting Occurrences
DECLARE @find AS NVARCHAR(40);
SET @find = N'n';

SELECT companyname,
  (LEN(companyname+'*') - LEN(REPLACE(companyname, @find, '')+'*'))
    / LEN(@find) AS cnt
FROM Sales.Customers;
GO

---------------------------------------------------------------------
-- UDFs Used in Constraints
---------------------------------------------------------------------

---------------------------------------------------------------------
-- DEFAULT Constraints
---------------------------------------------------------------------

-- Creating Table T1 and UDF T1_getkey
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  keycol INT NOT NULL CONSTRAINT PK_T1 PRIMARY KEY CHECK (keycol > 0),
  datacol VARCHAR(10) NOT NULL
);

IF OBJECT_ID('dbo.T1_getkey', 'FN') IS NOT NULL
  DROP FUNCTION dbo.T1_getkey;
GO
CREATE FUNCTION dbo.T1_getkey() RETURNS INT
AS
BEGIN
  RETURN
    CASE
      WHEN NOT EXISTS(SELECT * FROM dbo.T1 WHERE keycol = 1) THEN 1
      ELSE (SELECT MIN(keycol + 1)
            FROM dbo.T1 AS A
            WHERE NOT EXISTS
              (SELECT *
               FROM dbo.T1 AS B
               WHERE B.keycol = A.keycol + 1))
    END;
END
GO

-- Test T1_getkey function as DEFAULT constraint
ALTER TABLE dbo.T1 ADD DEFAULT(dbo.T1_getkey()) FOR keycol;

INSERT INTO dbo.T1(datacol) VALUES('a');
INSERT INTO dbo.T1(datacol) VALUES('b');
INSERT INTO dbo.T1(datacol) VALUES('c');
DELETE FROM dbo.T1 WHERE keycol = 2;
INSERT INTO dbo.T1(datacol) VALUES('d');

SELECT * FROM dbo.T1;

---------------------------------------------------------------------
-- CHECK Constraints
---------------------------------------------------------------------

---------------------------------------------------------------------
-- PRIMARY KEY and UNIQUE Constraints
---------------------------------------------------------------------

-- Attempt to add computed column with UNIQUE constraint fails
ALTER TABLE dbo.T1
  ADD col1 AS dbo.AddOne(keycol) CONSTRAINT UQ_T1_col1 UNIQUE;
GO

-- Add SCHEMABINDING to AddOne function
ALTER FUNCTION dbo.AddOne(@i AS INT) RETURNS INT
  WITH SCHEMABINDING
AS
BEGIN
  RETURN @i + 1;
END
GO

-- Add computed column with UNIQUE constraint
ALTER TABLE dbo.T1
  ADD col1 AS dbo.AddOne(keycol) CONSTRAINT UQ_T1_col1 UNIQUE;

-- Drop existing PRIMARY KEY
ALTER TABLE dbo.T1 DROP CONSTRAINT PK_T1;

-- Attempt to add computed column with PRIMARY KEY constraint fails
ALTER TABLE dbo.T1
  ADD col2 AS dbo.AddOne(keycol)
    CONSTRAINT PK_T1 PRIMARY KEY;

-- Attempt succeeds
ALTER TABLE dbo.T1
  ADD col2 AS dbo.AddOne(keycol) PERSISTED NOT NULL
    CONSTRAINT PK_T1 PRIMARY KEY;

-- Cleanup
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL
  DROP TABLE dbo.T1;
IF OBJECT_ID('dbo.T1_getkey', 'FN') IS NOT NULL
  DROP FUNCTION dbo.T1_getkey;
IF OBJECT_ID('dbo.AddOne', 'FN') IS NOT NULL
  DROP FUNCTION dbo.AddOne;
IF OBJECT_ID('dbo.AddOneInline', 'IF') IS NOT NULL
  DROP FUNCTION dbo.AddOneInline;

---------------------------------------------------------------------
-- CLR Scalar UDFs
---------------------------------------------------------------------

---------------------------------------------------------------------
-- CLR Routines
---------------------------------------------------------------------

---------------------------------------------------------------------
-- String Manipulation
---------------------------------------------------------------------

-- Matching Based on Regular Expresions

-- C#
/*
  // RegexIsMatch function
  // Validates input string against regular expression
  [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
  public static SqlBoolean RegexIsMatch(SqlString input,
    SqlString pattern)
  {
      if (input.IsNull || pattern.IsNull)
          return SqlBoolean.Null;
      else
          return (SqlBoolean)Regex.IsMatch(input.Value, pattern.Value,
            RegexOptions.CultureInvariant);
  }
*/

-- Visual Basic
/*
  ' RegexIsMatch function
  ' Validates input string against regular expression
  <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
  Public Shared Function RegexIsMatch(ByVal input As SqlString, _
    ByVal pattern As SqlString) As SqlBoolean
      If (input.IsNull Or pattern.IsNull) Then
          Return SqlBoolean.Null
      Else
          Return CType(Regex.IsMatch(input.Value, pattern.Value, _
            RegexOptions.CultureInvariant), SqlBoolean)
      End If
  End Function
*/

-- Build the solution

-- Enable CLR and create CLRUtilities database
SET NOCOUNT ON;
USE master;
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO
IF DB_ID('CLRUtilities') IS NOT NULL
  DROP DATABASE CLRUtilities;
GO
CREATE DATABASE CLRUtilities;
GO
USE CLRUtilities;

-- Create assembly 

USE CLRUtilities;

CREATE ASSEMBLY CLRUtilities
FROM 'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll'
WITH PERMISSION_SET = SAFE;
-- If no Debug folder, use instead:
-- FROM 'C:\CLRUtilities\CLRUtilities\bin\CLRUtilities.dll'

-- Create RegexIsMatch function
USE CLRUtilities;

IF OBJECT_ID('dbo.RegexIsMatch', 'FS') IS NOT NULL
  DROP FUNCTION dbo.RegexIsMatch;
GO

-- C#
CREATE FUNCTION dbo.RegexIsMatch
  (@input AS NVARCHAR(MAX), @pattern AS NVARCHAR(MAX)) 
RETURNS BIT
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexIsMatch;
GO

-- Visual Basic
CREATE FUNCTION dbo.RegexIsMatch
  (@input AS NVARCHAR(MAX), @pattern AS NVARCHAR(MAX)) 
RETURNS BIT
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].RegexIsMatch;
GO

-- Avoiding call to function on NULL input
IF OBJECT_ID('dbo.RegexIsMatch', 'FS') IS NOT NULL
  DROP FUNCTION dbo.RegexIsMatch;
GO  
CREATE FUNCTION dbo.RegexIsMatch
  (@input AS NVARCHAR(MAX), @pattern AS NVARCHAR(MAX)) 
RETURNS BIT
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexIsMatch;
GO

-- check e-mail address - RegEx = N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$'
SELECT dbo.RegexIsMatch(
  N'dejan@solidq.com',
  N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$');

SELECT dbo.RegexIsMatch(
  N'dejan#solidq.com',
  N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$');

-- Tip: Create synonym
USE MyDB;

CREATE SYNONYM dbo.RegexIsMatch FOR CLRUtilities.dbo.RegexIsMatch;

-- Use in Check constraint
-- Accept only .jpg files:
-- N'^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w ]*.*))+\.(jpg|JPG)$'
IF OBJECT_ID('dbo.TestRegex', 'U') IS NOT NULL DROP TABLE dbo.TestRegex;

CREATE TABLE dbo.TestRegex
(
  jpgfilename NVARCHAR(4000) NOT NULL
  CHECK(dbo.RegexIsMatch(jpgfilename,
    N'^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w ]*.*))+\.(jpg|JPG)$')
      = CAST(1 As BIT))
);
GO

-- Accepted
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'C:\Temp\myFile.jpg');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'\\MyShare\Temp\myFile.jpg');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'\\MyShare\myFile.jpg');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'C:\myFile.jpg');

-- Rejected
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'C:\Temp\myFile.txt');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'\\MyShare\\Temp\myFile.jpg');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'\\myFile.jpg');
INSERT INTO dbo.TestRegex(jpgfilename) VALUES(N'C:myFile.jpg');
GO

-- Replacement Based on Regular Expressions

-- Create function RemoveChars
IF OBJECT_ID('dbo.RemoveChars', 'FN') IS NOT NULL
  DROP FUNCTION dbo.RemoveChars;
GO

CREATE FUNCTION dbo.RemoveChars
  (@string AS NVARCHAR(MAX), @pattern AS NVARCHAR(MAX))
  RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @pos AS INT;
  SET @pos = PATINDEX(@pattern, @string);

  WHILE @pos > 0
  BEGIN
    SET @string = STUFF(@string, @pos, 1, N'');
    SET @pos = PATINDEX(@pattern, @string);
  END

  RETURN @string;
END
GO

SELECT custid, phone,
  dbo.RemoveChars(phone, N'%[^0-9a-zA-Z]%') AS cleanphone
FROM InsideTSQL2008.Sales.Customers;

-- RegexReplace Function

-- C#
/*
  // RegexReplace function
  // String replacement based on regular expression
  [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
  public static SqlString RegexReplace(
      SqlString input, SqlString pattern, SqlString replacement)
  {
    if (input.IsNull || pattern.IsNull || replacement.IsNull)
        return SqlString.Null;
    else
      return (SqlString)Regex.Replace(
        input.Value, pattern.Value, replacement.Value);
  }
*/

-- Visual Basic
/*
  ' RegexReplace function
  ' String replacement based on regular expression
  <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
  Public Shared Function RegexReplace( _
    ByVal input As SqlString, ByVal pattern As SqlString, _
    ByVal replacement As SqlString) As SqlString

    If (input.IsNull Or pattern.IsNull Or replacement.IsNull) Then
      Return SqlString.Null
    Else
      Return CType(Regex.Replace( _
        input.Value, pattern.Value, replacement.Value), SqlString)
    End If
  End Function
*/

-- Create RegexReplace Function
IF OBJECT_ID('dbo.RegexReplace', 'SF') IS NOT NULL
  DROP FUNCTION dbo.RegexReplace;
GO

-- C#
CREATE FUNCTION dbo.RegexReplace(
  @input       AS NVARCHAR(MAX),
  @pattern     AS NVARCHAR(MAX),
  @replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexReplace;
GO

-- Visual Basic
CREATE FUNCTION dbo.RegexReplace(
  @input       AS NVARCHAR(MAX),
  @pattern     AS NVARCHAR(MAX),
  @replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].RegexReplace;
GO

SELECT phone, dbo.RegexReplace(phone, N'[^0-9a-zA-Z]', N'') AS cleanphone
FROM InsideTSQL2008.Sales.Customers;
GO

-- Formatting Datetime Values

-- C#
/*
  // FormatDatetime function
  // Formats a DATETIME value based on a format string
  [Microsoft.SqlServer.Server.SqlFunction]
  public static SqlString FormatDatetime(SqlDateTime dt, SqlString formatstring)
  {
    if (dt.IsNull || formatstring.IsNull)
      return SqlString.Null;
    else
      return (SqlString)dt.Value.ToString(formatstring.Value);
  }
*/

-- Visual Basic
/*
  ' FormatDatetime function
  ' Formats a DATETIME value based on a format string
  <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
  Public Shared Function FormatDatetime( _
    ByVal dt As SqlDateTime, ByVal formatstring As SqlString) As SqlString

    If (dt.IsNull Or formatstring.IsNull) Then
      Return SqlString.Null
    Else
      Return CType(dt.Value.ToString(formatstring.Value), SqlString)
    End If
  End Function
*/

-- Create FormatDatetime Function
IF OBJECT_ID('dbo.FormatDatetime', 'SF') IS NOT NULL
  DROP FUNCTION dbo.FormatDatetime;
GO

-- C#
CREATE FUNCTION dbo.FormatDatetime
  (@dt AS DATETIME, @formatstring AS NVARCHAR(500)) 
RETURNS NVARCHAR(500)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.FormatDatetime;
GO

-- Visual Basic
CREATE FUNCTION dbo.FormatDatetime
  (@dt AS DATETIME, @formatstring AS NVARCHAR(500)) 
RETURNS NVARCHAR(500)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].FormatDatetime;
GO

-- Test FormatDatetime function
SELECT dbo.FormatDatetime(GETDATE(), 'MM/dd/yyyy');

-- Cleanup
IF OBJECT_ID('dbo.TestRegex','U') IS NOT NULL
  DROP TABLE dbo.TestRegex;
IF OBJECT_ID('dbo.RegexIsMatch', 'FS') IS NOT NULL
  DROP FUNCTION dbo.RegexIsMatch;
IF OBJECT_ID('dbo.RemoveChars', 'FN') IS NOT NULL
  DROP FUNCTION dbo.RemoveChars;
IF OBJECT_ID('dbo.RegexReplace', 'FS') IS NOT NULL
  DROP FUNCTION dbo.RegexReplace;
IF OBJECT_ID('dbo.FormatDatetime', 'SF') IS NOT NULL
  DROP FUNCTION dbo.FormatDatetime;
GO

---------------------------------------------------------------------
-- Explicit vs. Implicit Conversions
---------------------------------------------------------------------

-- CLR code for ImpCast and ExpCast

-- C#
/*
    // Compare implicit vs. explicit casting
    [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
    public static string ImpCast(string inpStr)
    {
        return inpStr.Substring(2, 3);
    }

    [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
    public static SqlString ExpCast(SqlString inpStr)
    {
        return (SqlString)inpStr.ToString().Substring(2, 3);
    }
*/

-- Visual Basic
/*
    ' Compare implicit vs. explicit casting
    <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
    Public Shared Function ImpCast(ByVal inpStr As String) As String
        Return inpStr.Substring(2, 3)
    End Function

    <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
    Public Shared Function ExpCast(ByVal inpStr As SqlString) As SqlString
        Return CType(inpStr.ToString().Substring(2, 3), SqlString)
    End Function
*/

-- Create functions
IF OBJECT_ID('dbo.ImpCast', 'FS') IS NOT NULL
  DROP FUNCTION dbo.ImpCast;
IF OBJECT_ID('dbo.ExpCast', 'FS') IS NOT NULL
  DROP FUNCTION dbo.ExpCast;
GO

-- C#
-- Create ImpCast function
CREATE FUNCTION dbo.ImpCast(@input AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ImpCast;
GO
-- Create ExpCast function
CREATE FUNCTION dbo.ExpCast(@input AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ExpCast;
GO

-- Visual Basic
-- Create ImpCast function
CREATE FUNCTION dbo.ImpCast(@input AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].ImpCast;
GO
-- Create ExpCast function
CREATE FUNCTION dbo.ExpCast(@input AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].ExpCast;
GO

-- Compare Performance

-- Implicit: 17 seconds
SET NOCOUNT ON;
GO
DECLARE @a AS NVARCHAR(4000);
DECLARE @i AS INT;
SET @i = 1;
WHILE @i <= 1000000
BEGIN
 SET @a = dbo.ImpCast(N'123456');
 SET @i = @i + 1;
END
GO

-- Explicit: 18 seconds
DECLARE @a AS NVARCHAR(4000);
DECLARE @i AS INT;
SET @i = 1;
WHILE @i <= 1000000
BEGIN
 SET @a = dbo.ExpCast(N'123456');
 SET @i = @i + 1;
END
GO

-- Cleanup
IF OBJECT_ID('dbo.ImpCast', 'FS') IS NOT NULL
  DROP FUNCTION dbo.ImpCast;
IF OBJECT_ID('dbo.ExpCast', 'FS') IS NOT NULL
  DROP FUNCTION dbo.ExpCast;
GO

---------------------------------------------------------------------
-- SQL Signature
---------------------------------------------------------------------

---------------------------------------------------------------------
-- T-SQL SQL Signature UDF
---------------------------------------------------------------------

-- Creation Script for the SQLSigTSQL UDF
IF OBJECT_ID('dbo.SQLSigTSQL', 'FN') IS NOT NULL
  DROP FUNCTION dbo.SQLSigTSQL;
GO

CREATE FUNCTION dbo.SQLSigTSQL 
  (@p1 NVARCHAR(MAX), @parselength INT = 4000)
RETURNS NVARCHAR(4000)

-- This function was developed at Microsoft
-- and included in this book with their permission.
--
-- This function is provided "AS IS" with no warranties,
-- and confers no rights. 
-- Use of included script samples are subject to the terms specified at
-- http://www.microsoft.com/info/cpyright.htm
-- 
-- Strips query strings
AS
BEGIN 
  DECLARE @pos AS INT;
  DECLARE @mode AS CHAR(10);
  DECLARE @maxlength AS INT;
  DECLARE @p2 AS NCHAR(4000);
  DECLARE @currchar AS CHAR(1), @nextchar AS CHAR(1);
  DECLARE @p2len AS INT;

  SET @maxlength = LEN(RTRIM(SUBSTRING(@p1,1,4000)));
  SET @maxlength = CASE WHEN @maxlength > @parselength 
                     THEN @parselength ELSE @maxlength END;
  SET @pos = 1;
  SET @p2 = '';
  SET @p2len = 0;
  SET @currchar = '';
  set @nextchar = '';
  SET @mode = 'command';

  WHILE (@pos <= @maxlength)
  BEGIN
    SET @currchar = SUBSTRING(@p1,@pos,1);
    SET @nextchar = SUBSTRING(@p1,@pos+1,1);
    IF @mode = 'command'
    BEGIN
      SET @p2 = LEFT(@p2,@p2len) + @currchar;
      SET @p2len = @p2len + 1 ;
      IF @currchar IN (',','(',' ','=','<','>','!')
        AND @nextchar BETWEEN '0' AND '9'
      BEGIN
        SET @mode = 'number';
        SET @p2 = LEFT(@p2,@p2len) + '#';
        SET @p2len = @p2len + 1;
      END 
      IF @currchar = ''''
      BEGIN
        SET @mode = 'literal';
        SET @p2 = LEFT(@p2,@p2len) + '#''';
        SET @p2len = @p2len + 2;
      END
    END
    ELSE IF @mode = 'number' AND @nextchar IN (',',')',' ','=','<','>','!')
      SET @mode= 'command';
    ELSE IF @mode = 'literal' AND @currchar = ''''
      SET @mode= 'command';

    SET @pos = @pos + 1;
  END
  RETURN @p2;
END
GO

-- Test SQLSigTSQL Function
SELECT dbo.SQLSigTSQL
  (N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);

---------------------------------------------------------------------
-- CLR SQL Signature UDF
---------------------------------------------------------------------

-- C#
/*
    // SQLSigCLR Funcion
    // Produces SQL Signature from an input query string
    [SqlFunction(IsDeterministic = true, DataAccess = DataAccessKind.None)]
    public static SqlString SQLSigCLR(SqlString inpRawString,
      SqlInt32 inpParseLength)
    {
        if (inpRawString.IsNull)
            return SqlString.Null;
        int pos = 0;
        string mode = "command";
        string RawString = inpRawString.Value;
        int maxlength = RawString.Length;
        StringBuilder p2 = new StringBuilder();
        char currchar = ' ';
        char nextchar = ' ';
        int ParseLength = RawString.Length;
        if (!inpParseLength.IsNull)
            ParseLength = inpParseLength.Value;
        if (RawString.Length > ParseLength)
        {
            maxlength = ParseLength;
        }
        while (pos < maxlength)
        {
            currchar = RawString[pos];
            if (pos < maxlength - 1)
            {
                nextchar = RawString[pos + 1];
            }
            else
            {
                nextchar = RawString[pos];
            }
            if (mode == "command")
            {
                p2.Append(currchar);
                if ((",( =<>!".IndexOf(currchar) >= 0)
                   &&
                    (nextchar >= '0' && nextchar <= '9'))
                {
                    mode = "number";
                    p2.Append('#');
                }
                if (currchar == '\'')
                {
                    mode = "literal";
                    p2.Append("#'");
                }
            }
            else if ((mode == "number")
                      &&
                       (",( =<>!".IndexOf(nextchar) >= 0))
            {
                mode = "command";
            }
            else if ((mode == "literal") && (currchar == '\''))
            {
                mode = "command";
            }
            pos++;
        }
        return p2.ToString();
    }
*/

-- Visual Basic
/*
    ' SQLSigCLR Funcion
    ' Produces SQL Signature from an input query string
    <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
    Public Shared Function SQLSigCLR(ByVal inpRawString As SqlString, _
      ByVal inpParseLength As SqlInt32) As SqlString
        If inpRawString.IsNull Then
            Return SqlString.Null
        End If
        Dim pos As Integer = 0
        Dim mode As String = "command"
        Dim RawString As String = inpRawString.Value
        Dim maxlength As Integer = RawString.Length
        Dim p2 As StringBuilder = New StringBuilder()
        Dim currchar As Char = " "c
        Dim nextchar As Char = " "c
        Dim ParseLength As Integer = RawString.Length
        If (Not inpParseLength.IsNull) Then
            ParseLength = inpParseLength.Value
        End If
        If (RawString.Length > ParseLength) Then
            maxlength = ParseLength
        End If
        While (pos < maxlength)
            currchar = RawString(pos)
            If (pos < maxlength - 1) Then
                nextchar = RawString(pos + 1)
            Else
                nextchar = RawString(pos)
            End If
            If (mode = "command") Then
                p2.Append(currchar)
                If ((",( =<>!".IndexOf(currchar) >= 0) _
                   And _
                    (nextchar >= "0"c And nextchar <= "9"c)) Then
                    mode = "number"
                    p2.Append("#")
                End If
                If (currchar = "'"c) Then
                    mode = "literal"
                    p2.Append("#")
                End If
            ElseIf ((mode = "number") And _
                    (",( =<>!".IndexOf(nextchar) >= 0)) Then
                mode = "command"
            ElseIf ((mode = "literal") And _
                    (currchar = "'"c)) Then
                mode = "command"
            End If
            pos = pos + 1
        End While
        Return p2.ToString
    End Function
*/

-- Create SQLSigCLR Function
IF OBJECT_ID('dbo.SQLSigCLR', 'FS') IS NOT NULL
  DROP FUNCTION dbo.SQLSigCLR;
GO

-- C#
CREATE FUNCTION dbo.SQLSigCLR
  (@rawstring AS NVARCHAR(MAX), @parselength AS INT) 
RETURNS NVARCHAR(MAX)
EXTERNAL NAME CLRUtilities.CLRUtilities.SQLSigCLR;
GO

-- Visual Basic
CREATE FUNCTION dbo.SQLSigCLR
  (@rawstring AS NVARCHAR(MAX), @parselength AS INT) 
RETURNS NVARCHAR(MAX)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SQLSigCLR;
GO

-- Use the SQLSigCLR function
SELECT dbo.SQLSigCLR
  (N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);
GO

---------------------------------------------------------------------
-- Compare Performance of T-SQL and CLR SQL Signature UDFs
---------------------------------------------------------------------

-- Create and populate Queries table
IF OBJECT_ID('dbo.Queries', 'U') IS NOT NULL
  DROP TABLE dbo.Queries;
GO
SELECT CAST(N'SELECT * FROM dbo.T1 WHERE col1 = '
            + CAST(n AS NVARCHAR(10))
         AS NVARCHAR(MAX)) AS query
INTO dbo.Queries
FROM dbo.Nums
WHERE n <= 100000;
GO

-- Turn on Discard Results

-- T-SQL: 64 seconds
SELECT dbo.SQLSigTSQL(query, 4000) FROM dbo.Queries;

-- CLR: both C# and Visual Basic - 2 seconds
SELECT dbo.SQLSigCLR(query, 4000) FROM dbo.Queries;
GO

-- Turn off Discard Results

-- Using RegexReplace Function - 4 seconds

SELECT
  dbo.RegexReplace(query,
    N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?#    expression coming
     )(?:([N])?('')(?:[^'']|'''')*(''))(?#      character
     )|(?:0x[\da-fA-F]*)(?#                     binary
     )|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?#     precise number
     )(?:[eE]?[\d]*)))(?#                       imprecise number
     )|(?:[~]?[-+]?(?:[\d]+))(?#                integer
     ))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?#   operators
     ))',
    N'$1$2$3#$4')
FROM dbo.Queries;
GO

-- Cleanup

IF OBJECT_ID('dbo.SQLSigTSQL', 'FN') IS NOT NULL
  DROP FUNCTION dbo.SQLSigTSQL;
IF OBJECT_ID('dbo.SQLSigCLR', 'FS') IS NOT NULL
  DROP FUNCTION dbo.SQLSigCLR;
GO

---------------------------------------------------------------------
-- Table-Valued UDFs
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Inline Table-Valued UDFs
---------------------------------------------------------------------

-- Creating CustOrders function
SET NOCOUNT ON;
USE InsideTSQL2008;

IF OBJECT_ID('dbo.CustOrders', 'IF') IS NOT NULL
  DROP FUNCTION dbo.CustOrders;
GO
CREATE FUNCTION dbo.CustOrders
  (@custid AS INT) RETURNS TABLE
AS
RETURN
  SELECT orderid, custid, empid, orderdate, requireddate,
    shippeddate, shipperid, freight, shipname, shipaddress, shipcity,
    shipregion, shippostalcode, shipcountry
  FROM Sales.Orders
  WHERE custid = @custid;
GO

-- Test Function
SELECT O.orderid, O.custid, OD.productid, OD.qty
FROM dbo.CustOrders(1) AS O
  JOIN Sales.OrderDetails AS OD
    ON O.orderid = OD.orderid;

-- Can Update Data Through Function
BEGIN TRAN
  SELECT orderid, shipperid FROM CustOrders(1) AS O;
  UPDATE dbo.CustOrders(1) SET shipperid = 2;
  SELECT orderid, shipperid FROM CustOrders(1) AS O;
ROLLBACK

-- Can Delete Data Through Function
DELETE FROM dbo.CustOrders(1) WHERE YEAR(orderdate) = 2007;

-- Don't run since it Will fail on FK violation

-- Cleanup
IF OBJECT_ID('dbo.CustOrders', 'IF') IS NOT NULL
  DROP FUNCTION dbo.CustOrders;
GO

---------------------------------------------------------------------
-- Split Array
---------------------------------------------------------------------

---------------------------------------------------------------------
-- T-SQL Split UDF
---------------------------------------------------------------------

-- Create SplitTSQL function
USE CLRUtilities;

IF OBJECT_ID('dbo.SplitTSQL', 'IF') IS NOT NULL
  DROP FUNCTION dbo.SplitTSQL; 
GO
CREATE FUNCTION dbo.SplitTSQL
  (@string NVARCHAR(MAX), @separator NCHAR(1) = N',') RETURNS TABLE
AS
RETURN
  SELECT
    (n - 1) - DATALENGTH(REPLACE(LEFT(@string, n - 1), @separator, ''))/2
      + 1 AS pos,
    SUBSTRING(@string, n, 
      CHARINDEX(@separator, @string + @separator, n) - n) AS element
  FROM dbo.Nums
  WHERE n <= DATALENGTH(@string)/2 + 1
    AND SUBSTRING(@separator + @string, n, 1) = @separator;
GO

-- Test SplitTSQL function
SELECT pos, element FROM dbo.SplitTSQL(N'a,b,c', N',') AS F;
GO

DECLARE @arr AS NVARCHAR(MAX);
SET @arr = N'10248,10249,10250';

SELECT O.orderid, O.custid, O.empid, O.orderdate
FROM dbo.SplitTSQL(@arr, N',') AS F
  JOIN InsideTSQL2008.Sales.Orders AS O
    ON CAST(F.element AS INT) = O.orderid;
GO

---------------------------------------------------------------------
-- CLR Split UDF
---------------------------------------------------------------------

-- SplitCLR function, C# version
/*
    // Struct used in SplitCLR function
    struct row_item
    {
        public string item;
        public int pos;
    }

    // SplitCLR Function
    // Splits separated list of values and returns a table
    // FillRowMethodName = "ArrSplitFillRow"
    [SqlFunction(FillRowMethodName = "ArrSplitFillRow",
     DataAccess = DataAccessKind.None,
     TableDefinition = "pos INT, element NVARCHAR(4000) ")]
    public static IEnumerable SplitCLR(SqlString inpStr,
        SqlString charSeparator)
    {
        string locStr;
        string[] splitStr;
        char[] locSeparator = new char[1];
        locSeparator[0] = (char)charSeparator.Value[0];
        if (inpStr.IsNull)
            locStr = "";
        else
            locStr = inpStr.Value;
        splitStr = locStr.Split(locSeparator,
            StringSplitOptions.RemoveEmptyEntries);
        //locStr.Split(charSeparator.ToString()[0]);
        List<row_item> SplitString = new List<row_item>();
        int i = 1;
        foreach (string s in splitStr)
        {
            row_item r = new row_item();
            r.item = s;
            r.pos = i;
            SplitString.Add(r);
            ++i;
        }
        return SplitString;
    }

    public static void ArrSplitFillRow(
      Object obj, out int pos, out string item)
    {
        pos = ((row_item)obj).pos;
        item = ((row_item)obj).item;
    }
*/

-- SplitCLR function, Visual Basic version
/*
    'Struct used in SplitCLR function
    Structure row_item
        Dim item As String
        Dim pos As Integer
    End Structure

    ' SplitCLR Function
    ' Splits separated list of values and returns a table
    ' FillRowMethodName = "ArrSplitFillRow"
    <SqlFunction(FillRowMethodName:="ArrSplitFillRow", _
       DataAccess:=DataAccessKind.None, _
       TableDefinition:="pos INT, element NVARCHAR(4000) ")> _
    Public Shared Function SplitCLR(ByVal inpStr As SqlString, _
      ByVal charSeparator As SqlString) As IEnumerable
        Dim locStr As String
        Dim splitStr() As String
        Dim locSeparator(0) As Char
        locSeparator(0) = CChar(charSeparator.Value(0))
        If (inpStr.IsNull) Then
            locStr = ""
        Else
            locStr = inpStr.Value
        End If
        splitStr = locStr.Split(locSeparator, _
          StringSplitOptions.RemoveEmptyEntries)
        Dim SplitString As New List(Of row_item)
        Dim i As Integer = 1
        For Each s As String In splitStr
            Dim r As New row_item
            r.item = s
            r.pos = i
            SplitString.Add(r)
            i = i + 1
        Next
        Return SplitString
    End Function

    Public Shared Sub ArrSplitFillRow( _
    ByVal obj As Object, <Out()> ByRef pos As Integer, _
      <Out()> ByRef item As String)
        pos = CType(obj, row_item).pos
        item = CType(obj, row_item).item
    End Sub
*/

-- Create SplitCLR function
IF OBJECT_ID('dbo.SplitCLR', 'FT') IS NOT NULL
  DROP FUNCTION dbo.SplitCLR; 
GO

-- C#
CREATE FUNCTION dbo.SplitCLR
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

-- Visual Basic
CREATE FUNCTION dbo.SplitCLR
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SplitCLR;
GO

-- Use the SplitCLR function

-- Simple usage
SELECT pos, element FROM dbo.SplitCLR(N'a,b,c', N',');
GO

-- Against a table
IF OBJECT_ID('dbo.Arrays', 'U') IS NOT NULL DROP TABLE dbo.Arrays;

CREATE TABLE dbo.Arrays
(
  arrid INT            NOT NULL IDENTITY PRIMARY KEY,
  arr   NVARCHAR(4000) NOT NULL
);
GO

INSERT INTO dbo.Arrays(arr) VALUES
  (N'20,220,25,2115,14'),
  (N'30,330,28'),
  (N'12,10,8,8,122,13,2,14,10,9'),
  (N'-4,-6,1050,-2');

-- Using CROSS APPLY
SELECT arrid, pos, element
FROM dbo.Arrays AS A
  CROSS APPLY dbo.SplitCLR(arr, N',') AS F;

---------------------------------------------------------------------
-- Compare Performance of T-SQL and CLR Split
---------------------------------------------------------------------

-- Test performance
INSERT INTO dbo.Arrays
  SELECT arr
  FROM dbo.Arrays, dbo.Nums
  WHERE n <= 100000;

-- T-SQL Version, 19 seconds
SELECT arrid,
  (n - 1) - DATALENGTH(REPLACE(LEFT(arr, n - 1), ',', ''))/2 + 1 AS pos,
  CAST(SUBSTRING(arr, n, CHARINDEX(',', arr + ',', n) - n)
       AS INT) AS element
FROM dbo.Arrays
  JOIN dbo.Nums
    ON n <= DATALENGTH(arr)/2 + 1
    AND SUBSTRING(',' + arr, n, 1) = ',';

-- CLR Version, 4 seconds
SELECT arrid, pos, element
FROM dbo.Arrays AS A
  CROSS APPLY dbo.SplitCLR(arr, N',') AS F;
GO

-- ORDER Option for CLR Table-Valued Functions

-- C#
CREATE FUNCTION dbo.SplitCLR_OrderByPos
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
ORDER(pos) -- new in SQL Server 2008
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

-- Visual Basic
CREATE FUNCTION dbo.SplitCLR_OrderByPos
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
ORDER(pos)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SplitCLR;
GO

-- Compare plans for following function calls
SELECT *
FROM dbo.SplitCLR(N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z', N',')
ORDER BY pos;

SELECT *
FROM dbo.SplitCLR_OrderByPos(N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z', N',')
ORDER BY pos;

-- Cleanup
IF OBJECT_ID('dbo.Arrays', 'U') IS NOT NULL
  DROP TABLE dbo.Arrays;
IF OBJECT_ID('dbo.SplitTSQL', 'IF') IS NOT NULL
  DROP FUNCTION dbo.SplitTSQL; 
IF OBJECT_ID('dbo.SplitCLR', 'FT') IS NOT NULL
  DROP FUNCTION dbo.SplitCLR; 
IF OBJECT_ID('dbo.SplitCLR_OrderByPos', 'FT') IS NOT NULL
  DROP FUNCTION dbo.SplitCLR_OrderByPos; 
GO

---------------------------------------------------------------------
-- Multi-Statement Table-Valued UDFs
---------------------------------------------------------------------

-- DDL & Sample Data for Employees
SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL PRIMARY KEY,
  mgrid   INT         NULL     REFERENCES dbo.Employees,
  empname VARCHAR(25) NOT NULL,
  salary  MONEY       NOT NULL
);
GO

INSERT INTO dbo.Employees(empid, mgrid, empname, salary) VALUES
  (1,  NULL, 'David',   $10000.00),
  (2,  1,    'Eitan',    $7000.00),
  (3,  1,    'Ina',      $7500.00),
  (4,  2,    'Seraph',   $5000.00),
  (5,  2,    'Jiru',     $5500.00),
  (6,  2,    'Steve',    $4500.00),
  (7,  3,    'Aaron',    $5000.00),
  (8,  5,    'Lilach',   $3500.00),
  (9,  7,    'Rita',     $3000.00),
  (10, 5,    'Sean',     $3000.00),
  (11, 7,    'Gabriel',  $3000.00),
  (12, 9,    'Emilia' ,  $2000.00),
  (13, 9,    'Michael',  $2000.00),
  (14, 9,    'Didi',     $1500.00);

CREATE UNIQUE INDEX idx_unc_mgrid_empid ON dbo.Employees(mgrid, empid);
GO

-- Creation Script for Function Subordinates
IF OBJECT_ID('dbo.Subordinates') IS NOT NULL
  DROP FUNCTION dbo.Subordinates;
GO
CREATE FUNCTION dbo.Subordinates(@mgrid AS INT) RETURNS @Subs Table
(
  empid   INT NOT NULL PRIMARY KEY NONCLUSTERED,
  mgrid   INT NULL,
  empname VARCHAR(25) NOT NULL,
  salary  MONEY       NOT NULL,
  lvl     INT NOT NULL,
  UNIQUE CLUSTERED(lvl, empid)
)
AS
BEGIN
  DECLARE @lvl AS INT;
  SET @lvl = 0;                 -- Init level counter with 0

  -- Insert root node to @Subs
  INSERT INTO @Subs(empid, mgrid, empname, salary, lvl)
    SELECT empid, mgrid, empname, salary, @lvl
    FROM dbo.Employees WHERE empid = @mgrid;

  WHILE @@rowcount > 0          -- While prev level had rows
  BEGIN
    SET @lvl = @lvl + 1;        -- Increment level counter

    -- Insert next level of subordinates to @Subs
    INSERT INTO @Subs(empid, mgrid, empname, salary, lvl)
      SELECT C.empid, C.mgrid, C.empname, C.salary, @lvl
      FROM @Subs AS P           -- P = Parent
        JOIN dbo.Employees AS C -- C = Child
          ON P.lvl = @lvl - 1   -- Filter parents from prev level
          AND C.mgrid = P.empid;
  END

  RETURN;
END
GO

-- Query Function
SELECT empid, mgrid, empname, salary, lvl
FROM dbo.Subordinates(3) AS S;
GO

-- Creation Script for Function Subordinates, Inline Version
IF OBJECT_ID('dbo.Subordinates') IS NOT NULL
  DROP FUNCTION dbo.Subordinates;
GO
CREATE FUNCTION dbo.Subordinates(@mgrid AS INT) RETURNS TABLE
AS
RETURN
  WITH Subs
  AS
  (
    -- Anchor member returns a row for the input manager
    SELECT empid, mgrid, empname, salary, 0 AS lvl 
    FROM dbo.Employees
    WHERE empid = @mgrid

    UNION ALL

    -- Recursive member returns next level of children
    SELECT C.empid, C.mgrid, C.empname, C.salary, P.lvl + 1
    FROM Subs AS P
      JOIN dbo.Employees AS C
        ON C.mgrid = P.empid
  )
  SELECT * FROM Subs;
GO

-- Query Function
SELECT empid, mgrid, empname, salary, lvl
FROM dbo.Subordinates(3) AS S;
GO

-- Cleanup
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
  DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Subordinates', 'IF') IS NOT NULL
  DROP FUNCTION dbo.Subordinates;

---------------------------------------------------------------------
-- Per-Row UDFs
---------------------------------------------------------------------

-- Non-deterministic functions run per statement not per row,
-- except NEWID
USE InsideTSQL2008;

SELECT n, RAND() AS rnd, GETDATE() AS dt, NEWID() AS guid
FROM dbo.Nums
WHERE n <= 10;
GO

-- Following fails
IF OBJECT_ID('dbo.PerRowRand', 'FN') IS NOT NULL
  DROP FUNCTION dbo.PerRowRand;
GO
CREATE FUNCTION dbo.PerRowRand() RETURNS FLOAT
AS
BEGIN
  RETURN RAND();
END
GO

-- Following succeeds
IF OBJECT_ID('dbo.VRand', 'V') IS NOT NULL
  DROP VIEW dbo.VRand;
GO
CREATE VIEW dbo.VRand AS SELECT RAND() AS r;
GO

IF OBJECT_ID('dbo.PerRowRand', 'FN') IS NOT NULL
  DROP FUNCTION dbo.PerRowRand;
GO
CREATE FUNCTION dbo.PerRowRand() RETURNS FLOAT
AS
BEGIN
  RETURN (SELECT r FROM dbo.VRand);
END
GO

-- Test Function PerRowRand function
SELECT n, dbo.PerRowRand() AS rnd
FROM dbo.Nums
WHERE n <= 10;
GO

-- Following succeeds
IF OBJECT_ID('dbo.PerRowGetdate') IS NOT NULL
  DROP FUNCTION dbo.PerRowGetdate;
GO
CREATE FUNCTION dbo.PerRowGetdate() RETURNS DATETIME
AS
BEGIN
  RETURN GETDATE();
END
GO

-- Test Function PerRowRand function
SELECT DISTINCT GETDATE() AS dt
FROM dbo.Nums
WHERE n <= 1000000;

SELECT DISTINCT dbo.PerRowGetdate() AS dt
FROM dbo.Nums
WHERE n <= 1000000;

-- Cleanup
IF OBJECT_ID('dbo.VRand', 'V') IS NOT NULL
  DROP VIEW dbo.VRand;
IF OBJECT_ID('dbo.PerRowRand', 'FN') IS NOT NULL
  DROP FUNCTION dbo.PerRowRand;
IF OBJECT_ID('dbo.PerRowGetDate', 'FN') IS NOT NULL
  DROP FUNCTION dbo.PerRowGetDate;
