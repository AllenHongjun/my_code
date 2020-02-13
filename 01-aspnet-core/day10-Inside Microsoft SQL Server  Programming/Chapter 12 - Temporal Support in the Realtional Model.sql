---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 12 - Temporal Support in the Relational Model
-- Copyright Dejan Sarka, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Auxiliary date numbers table
---------------------------------------------------------------------

SET NOCOUNT ON;
USE InsideTSQL2008;

IF OBJECT_ID('dbo.DateNums', 'U') IS NOT NULL DROP TABLE dbo.DateNums;
CREATE TABLE dbo.DateNums
 (n INT NOT NULL PRIMARY KEY,
  d DATE NOT NULL);

DECLARE @max AS INT, @rc AS INT, @d AS DATE;
SET @max = 10000;
SET @rc = 1;
SET @d = '20090101'     -- Initial date

INSERT INTO dbo.DateNums VALUES(1, @d);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.DateNums 
  SELECT n + @rc, DATEADD(day,n + @rc - 1, @d) FROM dbo.DateNums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.DateNums
  SELECT n + @rc, DATEADD(day,n + @rc - 1, @d) 
  FROM dbo.DateNums 
  WHERE n + @rc <= @max;
GO

-- Check data
SELECT * FROM dbo.DateNums
GO


---------------------------------------------------------------------
-- Semitemporal problems
---------------------------------------------------------------------

-- Create table Production.Suppliers_Since
IF OBJECT_ID('Production.Suppliers_Since', 'U') IS NOT NULL
   DROP TABLE Production.Suppliers_Since;
CREATE TABLE Production.Suppliers_Since
(
  supplierid   INT          NOT NULL,
  companyname  NVARCHAR(40) NOT NULL,
  since        INT          NOT NULL
  CONSTRAINT PK_Suppliers_Since PRIMARY KEY(supplierid)
);
GO
-- Create table Production.SuppliersProducts_Since
IF OBJECT_ID('Production.SuppliersProducts_Since', 'U') IS NOT NULL
   DROP TABLE Production.SuppliersProducts_Since;
CREATE TABLE Production.SuppliersProducts_Since
(
  supplierid   INT          NOT NULL,
  productid    INT          NOT NULL,
  since        INT          NOT NULL
  CONSTRAINT PK_SuppliersProducts_Since
   PRIMARY KEY(supplierid, productid)
);
GO

-- Foreign keys
ALTER TABLE Production.Suppliers_Since
 ADD CONSTRAINT DateNums_Suppliers_Since_FK1
     FOREIGN KEY (since)
     REFERENCES dbo.DateNums (n);
ALTER TABLE Production.SuppliersProducts_Since
 ADD CONSTRAINT Suppliers_SuppliersProducts_Since_FK1
     FOREIGN KEY (supplierid)
     REFERENCES Production.Suppliers_Since (supplierid);
ALTER TABLE Production.SuppliersProducts_Since
 ADD CONSTRAINT Products_SuppliersProducts_Since_FK1
     FOREIGN KEY (productid)
     REFERENCES Production.Products (productid);
ALTER TABLE Production.SuppliersProducts_Since
 ADD CONSTRAINT DateNums_SuppliersProducts_Since_FK1
     FOREIGN KEY (since)
     REFERENCES dbo.DateNums (n);
GO
     
-- Additional constraint: a supplier can supply products
-- only after the supplier has a contract
-- First trigger prevents invalid inserts to the SuppliersProducts_Since table
IF OBJECT_ID (N'Production.SuppliersProducts_Since_TR1', 'TR') IS NOT NULL
   DROP TRIGGER Production.SuppliersProducts_Since_TR1;
GO
CREATE TRIGGER Production.SuppliersProducts_Since_TR1
 ON Production.SuppliersProducts_Since
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
         INNER JOIN Production.Suppliers_Since AS s
          ON i.supplierid = s.supplierid
             AND i.since < s.since
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
   only after they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO
-- Second trigger prevents invalid updates to the Suppliers_Since table
IF OBJECT_ID (N'Production.Suppliers_Since_TR1', 'TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_Since_TR1;
GO
CREATE TRIGGER Production.Suppliers_Since_TR1
 ON Production.Suppliers_Since
AFTER UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM Production.SuppliersProducts_Since AS sp
         INNER JOIN Production.Suppliers_Since AS s
          ON sp.supplierid = s.supplierid
             AND sp.since < s.since
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
   only after they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO


-- Test the constraints
-- Suppliers_Since valid data
INSERT INTO Production.Suppliers_Since
 (supplierid, companyname, since)
VALUES
 (1, N'Supplier SWRXU', 10),
 (2, N'Supplier VHQZD', 15),
 (3, N'Supplier STUAZ', 17);
GO
-- Check data
SELECT *
  FROM Production.Suppliers_Since;
GO
  
-- SuppliersProducts_Since
INSERT INTO Production.SuppliersProducts_Since
 (supplierid, productid, since)
VALUES
 (1, 20, 10),
 (1, 21, 12),
 (2, 22, 15),
 (3, 21, 23);
GO
-- Check data
SELECT *
  FROM Production.SuppliersProducts_Since;
GO

-- Invalid data
-- Since too early - not a valid time point
INSERT INTO Production.Suppliers_Since
 (supplierId, companyname, since)
VALUES
 (4, N'Supplier MXMMM', 0);
GO
-- A product supplied before supplier had a contract
INSERT INTO Production.SuppliersProducts_Since
 (supplierid, productid, since)
VALUES
 (1, 22, 9);
 GO
-- Updating since column for a supplier to try to make it
-- later than since of the product supplied by the supplier
UPDATE Production.Suppliers_Since
   SET since = 24
 WHERE supplierid = 3;  
GO
  
-- Querying semitemporal table
SELECT s.supplierId, s.companyname, s.since,
       d.d AS datesince
FROM Production.Suppliers_Since AS s
 INNER JOIN dbo.DateNums AS d
  ON s.since = d.n;
GO


---------------------------------------------------------------------
-- Full temporal support with intervalCID
---------------------------------------------------------------------

---------------------------------------------------------------------
-- C# version of IntervalCID
---------------------------------------------------------------------

/*
using System;
using System.Data;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using System.Globalization;
using Microsoft.SqlServer.Server;

[Serializable]
[SqlUserDefinedType(Format.Native,
                    IsByteOrdered = true,
                    ValidationMethodName = "ValidateIntervalCID")]
public struct IntervalCID : INullable
{
    //Regular expression used to parse values of the form (intBegin,intEnd)
    private static readonly Regex _parser
        = new Regex(@"\A\(\s*(?<intBegin>\-?\d+?)\s*:\s*(?<intEnd>\-?\d+?)\s*\)\Z",
                    RegexOptions.Compiled | RegexOptions.ExplicitCapture);

    // Beginning and end points of interval
    private Int32 _begin;
    private Int32 _end;

    // Internal member to show whether the value is null
    private bool _isnull;

    // Null value returned equal for all instances
    private const string NULL = "<<null interval>>";
    private static readonly IntervalCID NULL_INSTANCE
       = new IntervalCID(true);

    // Constructor for a known value
    public IntervalCID(Int32 begin, Int32 end)
    {
        this._begin = begin;
        this._end = end;
        this._isnull = false;
    }

    // Constructor for an unknown value
    private IntervalCID(bool isnull)
    {
        this._isnull = isnull;
        this._begin = this._end = 0;
    }

    // Default string representation
    public override string ToString()
    {
        return this._isnull ? NULL : ("("
            + this._begin.ToString(CultureInfo.InvariantCulture) + ":"
            + this._end.ToString(CultureInfo.InvariantCulture)
            + ")");
    }

    // Null handling
    public bool IsNull
    {
        get
        {
            return this._isnull;
        }
    }

    public static IntervalCID Null
    {
        get
        {
            return NULL_INSTANCE;
        }
    }

    // Parsing input using regular expression
    public static IntervalCID Parse(SqlString sqlString)
    {
        string value = sqlString.ToString();

        if (sqlString.IsNull || value == NULL)
            return new IntervalCID(true);

        // Check whether the input value matches the regex pattern
        Match m = _parser.Match(value);

        // If the input’s format is incorrect, throw an exception
        if (!m.Success)
            throw new ArgumentException(
                "Invalid format an interval. "
                + "Format is (intBegin:intEnd).");

        // If everything is OK, parse the value; 
        // we will get two Int32 type values
        IntervalCID it = new IntervalCID(Int32.Parse(m.Groups[1].Value,
            CultureInfo.InvariantCulture), Int32.Parse(m.Groups[2].Value,
            CultureInfo.InvariantCulture));
        if (!it.ValidateIntervalCID())
            throw new ArgumentException("Invalid beginning and end values.");

        return it;
    }

    // Beginning and end separately
    public Int32 BeginInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._begin;
        }
        set
        {
            Int32 temp = _begin;
            _begin = value;
            if (!ValidateIntervalCID())
            {
                _begin = temp;
                throw new ArgumentException("Invalid beginning value.");
            }

        }
    }

    public Int32 EndInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._end;
        }
        set
        {
            Int32 temp = _end;
            _end = value;
            if (!ValidateIntervalCID())
            {
                _end = temp;
                throw new ArgumentException("Invalid end value.");
            }

        }
    }

    // Validation method
    private bool ValidateIntervalCID()
    {
        if (_end >= _begin)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Allen's operators

    public bool Equals(IntervalCID target)
    {
        return ((this._begin == target._begin) & (this._end == target._end));
    }

    public bool Before(IntervalCID target)
    {
        return (this._end < target._begin);
    }

    public bool After(IntervalCID target)
    {
        return (this._begin > target._end);
    }

    public bool Includes(IntervalCID target)
    {
        return ((this._begin <= target._begin) & (this._end >= target._end));
    }

    public bool ProperlyIncludes(IntervalCID target)
    {
        return ((this.Includes(target)) & (!this.Equals(target)));
    }

    public bool Meets(IntervalCID target)
    {
        return ((this._end + 1 == target._begin) | (this._begin == target._end + 1));
    }

    public bool Overlaps(IntervalCID target)
    {
        return ((this._begin <= target._end) & (target._begin <= this._end));
    }

    public bool Merges(IntervalCID target)
    {
        return (this.Meets(target) | this.Overlaps(target));
    }

    public bool Begins(IntervalCID target)
    {
        return ((this._begin == target._begin) & (this._end <= target._end));
    }

    public bool Ends(IntervalCID target)
    {
        return ((this._begin >= target._begin) & (this._end == target._end));
    }

    public IntervalCID Union(IntervalCID target)
    {
        if (this.Merges(target))
            return new IntervalCID(System.Math.Min(this.BeginInt, target.BeginInt),
                                   System.Math.Max(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Intersect(IntervalCID target)
    {
        if (this.Overlaps(target))
            return new IntervalCID(System.Math.Max(this.BeginInt, target.BeginInt),
                                   System.Math.Min(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Minus(IntervalCID target)
    {
        if ((this.BeginInt < target.BeginInt) & (this.EndInt <= target.EndInt))
            return new IntervalCID(this.BeginInt, System.Math.Min(target.BeginInt - 1, this.EndInt));
        else
            if ((this.BeginInt >= target.BeginInt) & (this.EndInt > target.EndInt))
                return new IntervalCID(System.Math.Max(target.EndInt + 1, this.BeginInt), this.EndInt);
            else
                return new IntervalCID(true);
    }

}
*/

---------------------------------------------------------------------
-- Visual Basic version of IntervalCID
---------------------------------------------------------------------

/*
Imports System
Imports System.Data
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server
Imports System.Text.RegularExpressions
Imports System.Globalization

<Serializable()> _
<SqlUserDefinedType(Format.Native, IsByteOrdered:=True, _
                    ValidationMethodName:="ValidateIntervalCID")> _
Public Structure IntervalCID
    Implements INullable

    Private Shared ReadOnly parser As New Regex("\A\(\s*(?<intBegin>\-?\d+?)\s*:\s*(?<intEnd>\-?\d+?)\s*\)\Z", _
                                                RegexOptions.Compiled Or RegexOptions.ExplicitCapture)
    Private beginValue As Integer
    Private endValue As Integer
    Private isNullValue As Boolean
    Private Const nullValue As String = "<<null interval>>"
    Private Shared ReadOnly NULL_INSTANCE As New IntervalCID(True)

    Public Sub New(ByVal _begin As Integer, ByVal _end As Integer)
        Me.beginValue = _begin
        Me.endValue = _end
        Me.isNullValue = False
    End Sub

    Private Sub New(ByVal isnull As Boolean)
        Me.isNullValue = isnull
        Me.beginValue = 0
        Me.endValue = 0
    End Sub

    Public Overrides Function ToString() As <SqlFacet(maxSize:=700)> String
        If Me.isNullValue = True Then
            Return nullValue
        Else
            Return "(" & Me.beginValue.ToString(CultureInfo.InvariantCulture) & _
                   ":" & Me.endValue.ToString(CultureInfo.InvariantCulture) & ")"
        End If
    End Function


    Public ReadOnly Property IsNull() As Boolean Implements INullable.IsNull
        Get
            Return Me.isNullValue
        End Get
    End Property

    Public Shared ReadOnly Property Null() As IntervalCID
        Get
            Return NULL_INSTANCE
        End Get
    End Property

    Public Shared Function Parse(ByVal sqlString As SqlString) As IntervalCID
        Dim value As String = SqlString.ToString()

        If sqlString.IsNull Or value = nullValue Then
            Return New IntervalCID(True)
        End If

        Dim m As Match = parser.Match(value)

        If Not m.Success Then
            Throw New ArgumentException( _
                "Invalid format for an interval. " + _
                "Format is (intBegin:intEnd).")
        End If

        Dim it As IntervalCID
        it = New IntervalCID(Integer.Parse(m.Groups(1).Value, CultureInfo.InvariantCulture), _
                             Integer.Parse(m.Groups(2).Value, CultureInfo.InvariantCulture))

        If Not it.ValidateIntervalCID() Then
            Throw New ArgumentException( _
                "Invalid beginning and end values.")
        Else
            Return it
        End If

    End Function

    Public Property BeginInt() As Integer
        <SqlMethod(IsDeterministic:=True, IsPrecise:=True)> _
        Get
            Return Me.beginValue
        End Get
        Set(ByVal Value As Integer)
            Dim temp As Integer
            temp = beginValue
            Me.beginValue = Value
            If Not ValidateIntervalCID() Then
                beginValue = temp
                Throw New ArgumentException("Invalid beginning value.")
            End If
        End Set
    End Property

    Public Property EndInt() As Integer
        <SqlMethod(IsDeterministic:=True, IsPrecise:=True)> _
        Get
            Return Me.endValue
        End Get
        Set(ByVal Value As Integer)
            Dim temp As Integer
            temp = endValue
            Me.endValue = Value
            If Not ValidateIntervalCID() Then
                endValue = temp
                Throw New ArgumentException("Invalid end value.")
            End If
        End Set
    End Property

    Private Function ValidateIntervalCID() As Boolean
        If endValue >= beginValue Then
            Return True
        Else
            Return False
        End If
    End Function

    Public Shadows Function Equals(ByVal target As IntervalCID) As Boolean
        Return ((Me.beginValue = target.beginValue) And (Me.endValue = target.endValue))
    End Function

    Public Function Before(ByVal target As IntervalCID) As Boolean
        Return (Me.endValue < target.beginValue)
    End Function

    Public Function After(ByVal target As IntervalCID) As Boolean
        Return (Me.beginValue > target.endValue)
    End Function

    Public Function Includes(ByVal target As IntervalCID) As Boolean
        Return ((Me.beginValue <= target.beginValue) And (Me.endValue >= target.endValue))
    End Function

    Public Function ProperlyIncludes(ByVal target As IntervalCID) As Boolean
        Return ((Me.Includes(target)) And (Not Me.Equals(target)))
    End Function

    Public Function Meets(ByVal target As IntervalCID) As Boolean
        Return ((Me.endValue + 1 = target.beginValue) Or (Me.beginValue = target.endValue + 1))
    End Function

    Public Function Overlaps(ByVal target As IntervalCID) As Boolean
        Return ((Me.beginValue <= target.endValue) And (target.beginValue <= Me.endValue))
    End Function

    Public Function Merges(ByVal target As IntervalCID) As Boolean
        Return (Me.Meets(target) Or Me.Overlaps(target))
    End Function

    Public Function Begins(ByVal target As IntervalCID) As Boolean
        Return ((Me.beginValue = target.beginValue) And (Me.endValue <= target.endValue))
    End Function

    Public Function Ends(ByVal target As IntervalCID) As Boolean
        Return ((Me.beginValue >= target.beginValue) And (Me.endValue = target.endValue))
    End Function

    Public Function Union(ByVal target As IntervalCID) As IntervalCID
        If Me.Merges(target) Then
            Return New IntervalCID(System.Math.Min(Me.BeginInt, target.BeginInt), _
                                   System.Math.Max(Me.EndInt, target.EndInt))
        Else
            Return New IntervalCID(True)
        End If
    End Function

    Public Function Intersect(ByVal target As IntervalCID) As IntervalCID
        If Me.Overlaps(target) Then
            Return New IntervalCID(System.Math.Max(Me.BeginInt, target.BeginInt), _
                                   System.Math.Min(Me.EndInt, target.EndInt))
        Else
            Return New IntervalCID(True)
        End If
    End Function

    Public Function Minus(ByVal target As IntervalCID) As IntervalCID
        If ((Me.BeginInt < target.BeginInt) And (Me.EndInt <= target.EndInt)) Then
            Return New IntervalCID(Me.BeginInt, System.Math.Min(target.BeginInt - 1, Me.EndInt))
        ElseIf ((Me.BeginInt >= target.BeginInt) And (Me.EndInt > target.EndInt)) Then
            Return New IntervalCID(System.Math.Max(target.EndInt + 1, Me.BeginInt), Me.EndInt)
        Else
            Return New IntervalCID(True)
        End If
    End Function

End Structure
*/

-- Testing IntervalCID

-- Enable CLR
USE master; 
EXEC sp_configure 'clr enabled', 1; 
RECONFIGURE; 
GO 
USE InsideTSQL2008;
GO

-- Deploy assembly
CREATE ASSEMBLY IntervalCIDCS 
FROM 'C:\InsideTSQL2008\IntervalCID\IntervalCIDCS\bin\Debug\IntervalCIDCS.dll' 
WITH PERMISSION_SET = SAFE;
GO

-- Type
CREATE TYPE dbo.IntervalCID 
EXTERNAL NAME IntervalCIDCS.IntervalCID;
GO

-- Testing presentation and Boolean operators
DECLARE @i1 IntervalCID, @i2 IntervalCID, @i3 IntervalCID;
PRINT 'Testing presentation';
SET @i1 = N'(1:5)';
SELECT @i1 AS i1Bin, CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
PRINT 'Testing Equals operator';
SET @i2 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Equals(@i2) AS [Equals];
PRINT 'Testing Before and After operators';       
SET @i2 = N'(7:10)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Before(@i2) AS [Before], @i1.After(@i2) AS [After];
PRINT 'Testing Includes and Properly Includes operators';        
SET @i2 = N'(3:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Includes(@i2) AS [i1 Includes i2], 
       @i1.ProperlyIncludes(@i2) AS [i1 Properly Includes i2];
SET @i3 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i3.ToString() AS CHAR(8)) AS i3,
       @i1.Includes(@i3) AS [i1 Includes i3], 
       @i1.ProperlyIncludes(@i3) AS [i1 Properly Includes i3];       
PRINT 'Testing Meets operator'; 
SET @i2 = N'(6:6)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Meets(@i2) AS [Meets];
PRINT 'Testing Overlaps operator';   
SET @i2 = N'(3:6)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Overlaps(@i2) AS [Overlaps];
PRINT 'Testing Begins and Ends operators';   
SET @i2 = N'(1:7)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Begins(@i2) AS [Begins], @i1.Ends(@i2) AS [Ends];
PRINT 'Testing NULLs';   
SET @i3 = NULL;
SELECT CAST(@i3.ToString() AS CHAR(8)) AS [Null Interval];
IF @i3 IS NULL
   SELECT '@i3 IS NULL' AS [IS NULL Test];
GO

-- Testing setting properties
DECLARE @i1 IntervalCID;
PRINT 'Original interval';
SET @i1 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
PRINT 'Interval after properties modification';
SET @i1.BeginInt = 4;
SET @i1.EndInt = 10;       
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
GO

-- Interval algebra operators
DECLARE @i1 IntervalCID, @i2 IntervalCID;
PRINT 'Overlapping intervals';
SET @i1 = N'(4:8)';
SET @i2 = N'(6:10)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
PRINT 'Intervals that meet';
SET @i1 = N'(2:3)';
SET @i2 = N'(4:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
PRINT 'Intervals that have nothing in common';
SET @i1 = N'(2:3)';
SET @i2 = N'(6:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
PRINT 'One interval contained in another';
SET @i1 = N'(2:10)';
SET @i2 = N'(6:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
GO


-- Testing VB version

-- Drop the C# version
--DROP TYPE dbo.IntervalCID
--GO

-- Deploy assembly
--CREATE ASSEMBLY IntervalCIDVB 
--FROM 'C:\InsideTSQL2008\IntervalCID\IntervalCIDVB\bin\IntervalCIDVB.dll' 
--WITH PERMISSION_SET = SAFE;
--GO

-- Type
--CREATE TYPE dbo.IntervalCID 
--EXTERNAL NAME IntervalCIDVB.IntervalCID;
--GO

-- Testing presentation and Boolean operators
--DECLARE @i1 IntervalCID, @i2 IntervalCID, @i3 IntervalCID;
--PRINT 'Testing presentation';
--SET @i1 = N'(1:5)';
--SELECT @i1 AS i1Bin, CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
--PRINT 'Testing Equals operator';
--SET @i2 = N'(1:5)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Equals(@i2) AS [Equals];
--PRINT 'Testing Before and After operators';       
--SET @i2 = N'(7:10)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Before(@i2) AS [Before], @i1.After(@i2) AS [After];
--PRINT 'Testing Includes and Properly Includes operators';        
--SET @i2 = N'(3:5)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Includes(@i2) AS [i1 Includes i2], 
--       @i1.ProperlyIncludes(@i2) AS [i1 Properly Includes i2];
--SET @i3 = N'(1:5)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i3.ToString() AS CHAR(8)) AS i3,
--       @i1.Includes(@i3) AS [i1 Includes i3], 
--       @i1.ProperlyIncludes(@i3) AS [i1 Properly Includes i3];       
--PRINT 'Testing Meets operator'; 
--SET @i2 = N'(6:6)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Meets(@i2) AS [Meets];
--PRINT 'Testing Overlaps operator';   
--SET @i2 = N'(3:6)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Overlaps(@i2) AS [Overlaps];
--PRINT 'Testing Begins and Ends operators';   
--SET @i2 = N'(1:7)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8)) AS i2,
--       @i1.Begins(@i2) AS [Begins], @i1.Ends(@i2) AS [Ends];
--PRINT 'Testing NULLs';   
--SET @i3 = NULL;
--SELECT CAST(@i3.ToString() AS CHAR(8)) AS [Null Interval];
--IF @i3 IS NULL
--   SELECT '@i3 IS NULL' AS [IS NULL Test];
--GO

-- Testing setting properties
--DECLARE @i1 IntervalCID;
--PRINT 'Original interval';
--SET @i1 = N'(1:5)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
--PRINT 'Interval after properties modification';
--SET @i1.BeginInt = 4;
--SET @i1.EndInt = 10;       
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
--GO

-- Interval algebra operators
--DECLARE @i1 IntervalCID, @i2 IntervalCID;
--PRINT 'Overlapping intervals';
--SET @i1 = N'(4:8)';
--SET @i2 = N'(6:10)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8))AS i2,
--       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
--       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
--       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
--PRINT 'Intervals that meet';
--SET @i1 = N'(2:3)';
--SET @i2 = N'(4:8)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8))AS i2,
--       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
--       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
--       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
--PRINT 'Intervals that have nothing in common';
--SET @i1 = N'(2:3)';
--SET @i2 = N'(6:8)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8))AS i2,
--       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
--       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
--       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
--PRINT 'One interval contained in another';
--SET @i1 = N'(2:10)';
--SET @i2 = N'(6:8)';
--SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
--       CAST(@i2.ToString() AS CHAR(8))AS i2,
--       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
--       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
--       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
--GO


---------------------------------------------------------------------
-- Full temporal tables
---------------------------------------------------------------------

-- Create table Production.Suppliers_During
IF OBJECT_ID('Production.Suppliers_During', 'U') IS NOT NULL
   DROP TABLE Production.Suppliers_During;
CREATE TABLE Production.Suppliers_During
(
  supplierid   INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  beginint AS During.BeginInt PERSISTED,
  endint   AS During.EndInt   PERSISTED,
  CONSTRAINT PK_Suppliers_During PRIMARY KEY(supplierid, during)
);
GO
-- Create table Production.SuppliersProducts_During
IF OBJECT_ID('Production.SuppliersProducts_During', 'U') IS NOT NULL
   DROP TABLE Production.SuppliersProducts_During;
CREATE TABLE Production.SuppliersProducts_During
(
  supplierid   INT          NOT NULL,
  productid    INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  CONSTRAINT PK_SuppliersProducts_During
   PRIMARY KEY(supplierid, productid, during)
);
GO

-- Foreign keys
-- Valid time points
ALTER TABLE Production.Suppliers_During
 ADD CONSTRAINT DateNums_Suppliers_During_FK1
     FOREIGN KEY (beginint)
     REFERENCES dbo.DateNums (n);
ALTER TABLE Production.Suppliers_During
 ADD CONSTRAINT DateNums_Suppliers_During_FK2
     FOREIGN KEY (endint)
     REFERENCES dbo.DateNums (n);
GO
-- M-to-M relationship between suppliers and products          
ALTER TABLE Production.SuppliersProducts_During
 ADD CONSTRAINT Suppliers_SuppliersProducts_During_FK1
     FOREIGN KEY (supplierid)
     REFERENCES Production.Suppliers_Since (supplierid);
ALTER TABLE Production.SuppliersProducts_During
 ADD CONSTRAINT Products_SuppliersProducts_During_FK1
     FOREIGN KEY (productid)
     REFERENCES Production.Products (productid);
GO

-- Additional constraint: no supplies if not under a contract
-- First trigger prevents invalid inserts to the SuppliersProducts_During table
IF OBJECT_ID (N'Production.SuppliersProducts_During_TR1','TR') IS NOT NULL
   DROP TRIGGER Production.SuppliersProducts_During_TR1;
GO
CREATE TRIGGER Production.SuppliersProducts_During_TR1
 ON Production.SuppliersProducts_During
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE NOT EXISTS
         (SELECT * FROM Production.Suppliers_During AS s
           WHERE s.supplierid = i.supplierid
                 AND s.during.Includes(i.during) = 1)
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
             only in periods they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO
-- Second trigger prevents invalid updates and deletes to the Suppliers_During table
IF OBJECT_ID (N'Production.Suppliers_During_TR1','TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_During_TR1;
GO
CREATE TRIGGER Production.Suppliers_During_TR1
 ON Production.Suppliers_During
AFTER UPDATE, DELETE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM Production.SuppliersProducts_During AS sp
   WHERE NOT EXISTS
         (SELECT * FROM Production.Suppliers_During AS s
           WHERE s.supplierid = sp.supplierid
                 AND s.during.Includes(sp.during) = 1)
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
             only in periods they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Test the constraints
-- Suppliers_During valid data
INSERT INTO Production.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(2:5)'),
 (1, N'(7:8)'),
 (2, N'(1:10)');
GO
-- Check data
SELECT *, during.ToString()
  FROM Production.Suppliers_During;
GO
-- SuppliersProducts_During valid data
INSERT INTO Production.SuppliersProducts_During
 (supplierid, productid, during)
VALUES
 (1, 22, N'(2:5)');
GO
-- Check data
SELECT *, during.ToString()
  FROM Production.SuppliersProducts_During;
GO
  
-- Invalid data
-- Invalid data - invalid interval during
INSERT INTO Production.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(1:15000)');
GO
-- A product supplied during a perion supplier did not have a contract
INSERT INTO Production.SuppliersProducts_During
 (supplierid, productid, during)
VALUES
 (1, 20, N'(2:6)');
GO
-- Invalid update of during column for a supplier
UPDATE Production.Suppliers_During
   SET during = N'(3:5)'
 WHERE supplierid = 1 AND
       during = N'(2:5)';
GO
-- Invalid delete of a supplier
DELETE FROM Production.Suppliers_During
 WHERE supplierid = 1 AND
       during = N'(2:5)';
GO

-- Querying full temporal table
-- All rows
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM Production.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN Production.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid;
GO
-- Suppliers with contract during an interval
-- included in given interval
DECLARE @i AS IntervalCID = N'(7:11)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM Production.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN Production.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE @i.Includes(sd.during) = 1;  
GO
-- Suppliers with contract during an interval
-- that overlaps with given interval
DECLARE @i AS IntervalCID = N'(7:11)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM Production.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN Production.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE @i.Overlaps(sd.during) = 1;  
GO
-- Suppliers with contract in a specific time point
DECLARE @i AS IntervalCID = N'(9:9)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM Production.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN Production.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE sd.during.Includes(@i) = 1;  
GO


---------------------------------------------------------------------
-- Unpacking and packing
---------------------------------------------------------------------

-- Preventing overlapping or meeting intervals for a supplier

-- Try with a simple AFTER trigger
IF OBJECT_ID (N'Production.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_During_TR2;
GO
CREATE TRIGGER Production.Suppliers_During_TR2
 ON Production.Suppliers_During
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE EXISTS
         (SELECT * FROM Production.Suppliers_During AS s
           WHERE s.supplierid = i.supplierid
                 AND s.during.Merges(i.during) = 1)
 )
 BEGIN
  RAISERROR('No overlapping or meeting intervals 
             for a given supplier allowed!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Using INSTEAD OF trigger
IF OBJECT_ID (N'Production.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_During_TR2;
GO
CREATE TRIGGER Production.Suppliers_During_TR2
 ON Production.Suppliers_During
INSTEAD OF INSERT, UPDATE
AS
BEGIN
-- Disallowing multi-rows inserts and updates
IF (SELECT COUNT(*) FROM inserted) > 1
 BEGIN
  RAISERROR('Insert or update a single row at a time!', 16, 1);
  ROLLBACK TRAN;
  RETURN;
 END;
-- Disallowing update of supplierid
IF (EXISTS(SELECT * FROM deleted) AND
    UPDATE(supplierid))
 BEGIN
  RAISERROR('Update of supplierid is not allowed!', 16, 1);
  ROLLBACK TRAN; 
 END;
-- Checking for overlapping or meeting intervals
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE EXISTS
         (SELECT * FROM
          (SELECT * FROM Production.Suppliers_During
           -- excluding checking against existing row for an update
           EXCEPT
           SELECT * FROM deleted) AS s
            WHERE s.supplierid = i.supplierid
                  AND s.during.Merges(i.during) = 1)
 )
 BEGIN
  RAISERROR('No overlapping or meeting intervals 
             for a given supplier allowed!', 16, 1);
  ROLLBACK TRAN;
 END;
ELSE
-- Resubmitting update or insert
 IF EXISTS(SELECT * FROM deleted)
  UPDATE Production.Suppliers_During
     SET during = (SELECT during FROM inserted)
   WHERE supplierid = (SELECT supplierid FROM deleted) AND
         during = (SELECT during FROM deleted);
 ELSE  
  INSERT INTO Production.Suppliers_During
   (supplierid, during)
  SELECT supplierid, during
   FROM inserted;
END;
GO

-- Test the trigger
-- Overlapping interval
INSERT INTO Production.Suppliers_During
 (supplierId, during)
VALUES
 (1, N'(3:6)');
GO
-- Meeting interval
INSERT INTO Production.Suppliers_During
 (supplierId, during)
VALUES
 (1, N'(6:6)');
GO
-- Valid insert
INSERT INTO Production.Suppliers_During
 (supplierId, during)
VALUES
 (2, N'(12:20)');
GO
-- Valid update
UPDATE Production.Suppliers_During
   SET during = N'(13:20)'
 WHERE supplierid = 2 AND
       during = N'(12:20)';
GO       
-- Invalid update of supplierid
UPDATE Production.Suppliers_During
   SET supplierid = 3
 WHERE supplierid = 2 AND
       during = N'(13:20)';
GO    
-- Deleting the new row
DELETE FROM Production.Suppliers_During
 WHERE supplierid = 2 AND
       during = N'(13:20)';
GO

-- Drop the trigger
IF OBJECT_ID (N'Production.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_During_TR2;
GO

-- Auxiliary Suppliers_Temp_During table
-- To demonstrate PACK and UNPACK
IF OBJECT_ID('Production.Suppliers_Temp_During', 'U') IS NOT NULL
   DROP TABLE Production.Suppliers_Temp_During;
CREATE TABLE Production.Suppliers_Temp_During
(
  supplierid   INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  beginint AS During.BeginInt PERSISTED,
  endint   AS During.EndInt   PERSISTED,
  CONSTRAINT PK_Suppliers_Temp_During PRIMARY KEY(supplierid, during)
);
GO
INSERT INTO Production.Suppliers_Temp_During
 (supplierId, during)
VALUES
 (1, N'(2:5)'),
 (1, N'(3:7)'),
 (2, N'(10:12)');
GO

-- Unpackig the Suppliers_Temp_During table
-- Current version
SELECT supplierid, during.ToString()
  FROM Production.Suppliers_Temp_During;
GO
-- Unpacking
SELECT sd.supplierid, 
       CAST(sd.during.ToString() AS CHAR(8)) AS completeduring,
       dn.n, dn.d,
       N'(' + CAST(dn.n AS NVARCHAR(10)) + 
       N':' + CAST(dn.n AS NVARCHAR(10)) + N')'
        AS unpackedduring     
  FROM Production.Suppliers_Temp_During AS sd
       INNER JOIN dbo.DateNums AS dn
        ON dn.n BETWEEN sd.beginint AND sd.endint
ORDER BY sd.supplierid, dn.n;
GO

-- Create view Production.Suppliers_During_Unpacked
IF OBJECT_ID('Production.Suppliers_During_Unpacked', 'V') IS NOT NULL
   DROP VIEW Production.Suppliers_During_Unpacked;
GO
CREATE VIEW Production.Suppliers_During_Unpacked
WITH SCHEMABINDING
AS
SELECT sd.supplierid, 
       N'(' + CAST(dn.n AS NVARCHAR(10)) + 
       N':' + CAST(dn.n AS NVARCHAR(10)) + N')'
        AS unpackedduring     
  FROM Production.Suppliers_During AS sd
       INNER JOIN dbo.DateNums AS dn
        ON dn.n BETWEEN beginint AND sd.endint;
GO
CREATE UNIQUE CLUSTERED INDEX Suppliers_During_Unpacked_ClIx
 ON Production.Suppliers_During_Unpacked(supplierid, unpackedduring);
GO

-- Invalid data - invalid interval during
INSERT INTO Production.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(1:3)');
GO

-- Packing the Suppliers_Temp_During table
-- Grouping factor
WITH UnpackedCTE AS
(
  SELECT sd.supplierid,
         CAST(sd.during.ToString() AS CHAR(8)) AS CompleteInterval,
         dn.n, dn.d,
         N'(' + CAST(dn.n AS NVARCHAR(10)) + 
         N':' + CAST(dn.n AS NVARCHAR(10)) + N')' 
           AS UnpackedDuring     
  FROM Production.Suppliers_Temp_During AS sd
    INNER JOIN dbo.DateNums AS dn
       ON dn.n BETWEEN sd.beginint AND sd.endint
),
GroupingFactorCTE AS   
(
  SELECT supplierid, n, 
         DENSE_RANK() OVER (ORDER BY n) AS dr,
         n - DENSE_RANK() OVER(ORDER BY n) AS gf
  FROM UnpackedCTE
)
SELECT * FROM GroupingFactorCTE;

-- Packed form
WITH UnpackedCTE AS
(
  SELECT sd.supplierid,
         CAST(sd.during.ToString() AS CHAR(8)) AS CompleteInterval,
         dn.n, dn.d,
         N'(' + CAST(dn.n AS NVARCHAR(10)) + 
         N':' + CAST(dn.n AS NVARCHAR(10)) + N')' 
           AS UnpackedDuring     
  FROM Production.Suppliers_Temp_During AS sd
    INNER JOIN dbo.DateNums AS dn
       ON dn.n BETWEEN sd.beginint AND sd.endint
),
GroupingFactorCTE AS   
(
  SELECT supplierid, n, 
         DENSE_RANK() OVER (ORDER BY n) AS dr,
         n - DENSE_RANK() OVER(ORDER BY n) AS gf
  FROM UnpackedCTE
)
SELECT supplierid, gf, 
       N'(' + CAST(MIN(n) AS NVARCHAR(10)) + 
       N':' + CAST(MAX(n) AS NVARCHAR(10)) + N')'
        AS packedduring  
FROM GroupingFactorCTE
GROUP BY supplierid, gf
ORDER BY supplierid, packedduring;
GO

---------------------------------------------------------------------
-- Sixth normal form
---------------------------------------------------------------------

-- Adding currentlyactivegflag to Suppliers_Since
USE InsideTSQL2008;
ALTER TABLE Production.Suppliers_Since
  ADD currentlyactivegflag BIT NOT NULL DEFAULT 1;
GO


-- Adding an old, inactive supplier
-- and a future supplier
INSERT INTO Production.Suppliers_Since
 (supplierId, companyname, since, currentlyactivegflag)
VALUES
 (4, N'Supplier NZLIF', 5, 0),
 (5, N'Supplier KEREV', 7000, 0);
-- Adding history for supplier 4
INSERT INTO Production.Suppliers_During
 (supplierid, during)
VALUES
 (4, N'(5:8)');
GO

-- Querying semitemporal table
-- All data
SELECT s.supplierId,
       CAST(s.companyname AS CHAR(20)) AS companyname,
       s.since,
       d.d AS datesince, 
       s.currentlyactivegflag
FROM Production.Suppliers_Since AS s
 INNER JOIN dbo.DateNums AS d
  ON s.since = d.n;
-- Currently active suppliers only
SELECT s.supplierId,
       CAST(s.companyname AS CHAR(20)) AS companyname,
       s.since,
       d.d AS datesince, 
       s.currentlyactivegflag
FROM Production.Suppliers_Since AS s
 INNER JOIN dbo.DateNums AS d
  ON s.since = d.n
WHERE s.currentlyactivegflag = 1;
GO

-- Vertical decomposition
-- SuppliersNamesDuring
IF OBJECT_ID(N'Production.SuppliersNames_During', 'U') IS NOT NULL
   DROP TABLE Production.SuppliersNames_During;
GO 
CREATE TABLE Production.SuppliersNames_During
(
  supplierid   INT          NOT NULL,
  companyname  NVARCHAR(40) NOT NULL,
  during       IntervalCID  NOT NULL
  CONSTRAINT PK_SuppliersNames_Since PRIMARY KEY(supplierid, during)
);
ALTER TABLE Production.SuppliersNames_During
 ADD CONSTRAINT Suppliers_SuppliersNamesDuring_FK1
     FOREIGN KEY (supplierid)
     REFERENCES Production.Suppliers_Since (supplierid);
GO
-- Test data
-- SuppliersNamesDuring
INSERT INTO Production.SuppliersNames_During
 (supplierid, companyname, during)
VALUES
 (3, N'Supplier 3OLDN', N'(17:32)');
GO
-- Check data
SELECT supplierid, companyname, during.ToString()
  FROM Production.SuppliersNames_During;
GO  

-- Trigger when a supplier name is updated
IF OBJECT_ID (N'Production.Suppliers_UpdateName_TR1','TR') IS NOT NULL
   DROP TRIGGER Production.Suppliers_UpdateName_TR1;
GO
CREATE TRIGGER Production.Suppliers_UpdateName_TR1
 ON Production.Suppliers_Since
AFTER UPDATE
AS
IF UPDATE(companyname)
BEGIN
 -- Limit to single row updates
 IF (SELECT COUNT(*) FROM inserted) > 1
  BEGIN
   RAISERROR('Update a single company name at a time!', 16, 1);
   ROLLBACK TRAN;
   RETURN;
  END;
 -- Do nothing for dummy updates
 IF ((SELECT companyname FROM inserted) = 
     (SELECT companyname FROM deleted))
  RETURN;
 -- Find beginning and end time points
 DECLARE @begin int, @end int;
 -- End of during interval for the companyname
 -- equals to the time point when updated - 1
 SET @end = 
  (SELECT n - 1
     FROM dbo.DateNums
    WHERE d = CAST(GETDATE() AS date));
 -- Checking whether history of names already exists
 IF EXISTS
  (SELECT * 
     FROM Production.SuppliersNames_During AS s
          INNER JOIN inserted AS i
           ON s.supplierid = i.supplierid
  )
  BEGIN
   -- Checking whether there is "history" where end is in the future
   IF ((SELECT MAX(during.EndInt)
         FROM Production.SuppliersNames_During AS s
              INNER JOIN inserted AS i
               ON s.supplierid = i.supplierid) > @end + 1)
    BEGIN
     RAISERROR('There is already history for names in the future.
                Delete inappropriate history first.', 16, 1);
     ROLLBACK TRAN;
     RETURN;
    END;
   -- Update was already done in the same time point
   -- @begin and @end must equal to current time point
   IF ((SELECT MAX(during.EndInt)
         FROM Production.SuppliersNames_During AS s
              INNER JOIN inserted AS i
               ON s.supplierid = i.supplierid) = @end) OR
      ((SELECT MAX(during.EndInt)
         FROM Production.SuppliersNames_During AS s
              INNER JOIN inserted AS i
               ON s.supplierid = i.supplierid) = @end + 1)
    BEGIN
     SET @end = @end + 1;
     SET @begin = @end;
    END
   -- "Regular" history: @begin equals MAX(end in history) + 1
   ELSE
    SET @begin = (SELECT MAX(during.EndInt) + 1
                    FROM Production.SuppliersNames_During AS s
                         INNER JOIN inserted AS i
                          ON s.supplierid = i.supplierid);
  END
 -- No history of names for the supplier 
 ELSE
  SET @begin = (SELECT since FROM inserted);
 -- Checking whether @begin > @end
 -- Updates of names of future suppliers
 IF (@begin > @end)
  BEGIN
   -- Just a warning
   RAISERROR('For future suppliers, history of names is not maintained.', 10, 1);
   RETURN;
  END;
 -- Creating during interval as string
 DECLARE @intv NVARCHAR(25);
 SET @intv = N'(' + CAST(@begin AS NVARCHAR(10)) + 
             N':' + CAST(@end AS NVARCHAR(10)) + N')';           
 -- Checking whether there is already a rows for supplier name
 -- with during equal to (@begin : @end)
 -- Can happen for three and more updates in same time point
 IF EXISTS
  (SELECT * 
     FROM Production.SuppliersNames_During
    WHERE supplierid = (SELECT supplierid FROM inserted) AND
          during = CAST(@intv AS IntervalCID)
  )
   UPDATE Production.SuppliersNames_During
      SET companyname = (SELECT companyname FROM deleted)
    WHERE supplierid = (SELECT supplierid FROM inserted) AND
          during = CAST(@intv AS IntervalCID);
 -- "Regular" history
 ELSE
  INSERT INTO Production.SuppliersNames_During
   (supplierid, companyname, during)
  SELECT supplierid, companyname, @intv
    FROM deleted;
END;
GO

-- Test the trigger
-- Checking current state
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 3;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO
-- Invalid update - more than one row
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier BADUP';
GO
-- Valid
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier 3NEWN'
 WHERE supplierid = 3;
GO
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 3;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO
-- Another update of the same supplier name in the same time point
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier 3NEW2'
 WHERE supplierid = 3;
GO
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 3;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO
-- And yet another 
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier 3NEW3'
 WHERE supplierid = 3;
GO
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 3;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO
-- Update of supplier name without existing history of names
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier 2NEWN'
 WHERE supplierid = 2;
GO
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 2;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO
-- Update of supplier name of future supplier
UPDATE Production.Suppliers_Since
   SET companyname = N'Supplier 5NEWN'
 WHERE supplierid = 5;
GO
SELECT supplierid, 
       CAST(companyname AS CHAR(20)) AS companyname
  FROM Production.Suppliers_Since
 WHERE supplierid = 5;
SELECT supplierid,
       CAST(companyname AS CHAR(20)) AS companyname,
       CAST(during.ToString() AS CHAR(10)) AS during
  FROM Production.SuppliersNames_During;
GO


---------------------------------------------------------------------
-- Clean-up code
---------------------------------------------------------------------
USE InsideTSQL2008;
GO
DROP TABLE Production.Suppliers_Temp_During;
DROP VIEW Production.Suppliers_During_Unpacked;
DROP TABLE Production.SuppliersNames_During;
DROP TABLE Production.SuppliersProducts_During;
DROP TABLE Production.Suppliers_During;
DROP TYPE dbo.IntervalCID;
DROP ASSEMBLY IntervalCIDCS;
-- Note: drop the VB assembly instead of CS one 
-- if you tested VB version of IntervalCID
-- DROP ASSEMBLY IntervalCIDVB;
DROP TABLE Production.SuppliersProducts_Since;
DROP TABLE Production.Suppliers_Since;
DROP TABLE dbo.DateNums;
GO
USE master; 
EXEC sp_configure 'clr enabled', 0; 
RECONFIGURE; 
GO
SET NOCOUNT OFF;
GO
