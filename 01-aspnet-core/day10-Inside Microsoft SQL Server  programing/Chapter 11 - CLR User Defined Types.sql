---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Chapter 11 - CLR User Defined Types
-- Copyright Dejan Sarka, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Listing 11-1 C#-based ComplexNumberCS_SUM UDA
---------------------------------------------------------------------

/*
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Globalization;

[Serializable]
[SqlUserDefinedType(Format.Native, IsByteOrdered = true)] 
public struct ComplexNumberCS : INullable
{
    //Regular expression used to parse values of the form (a,bi) 
    private static readonly Regex _parser
        = new Regex(@"\A\(\s*(?<real>\-?\d+(\.\d+)?)\s*,\s*(?<img>\-?\d+(\.\d+)?)\s*i\s*\)\Z",
                    RegexOptions.Compiled | RegexOptions.ExplicitCapture);

    // Real and imaginary parts 
    private double _real;
    private double _imaginary;

    // Internal member to show whether the value is null 
    private bool _isnull;

    // Null value returned equal for all instances 
    private const string NULL = "<<null complex>>";
    private static readonly ComplexNumberCS NULL_INSTANCE
       = new ComplexNumberCS(true);

    // Constructor for a known value 
    public ComplexNumberCS(double real, double imaginary)
    {
        this._real = real;
        this._imaginary = imaginary;
        this._isnull = false;
    }

    // Constructor for an unknown value 
    private ComplexNumberCS(bool isnull)
    {
        this._isnull = isnull;
        this._real = this._imaginary = 0;
    }


    // Default string representation with SqlFacet
    [return:SqlFacet(MaxSize = 40)]
    public override string ToString()
    {
        return this._isnull ? NULL : ("("
            + this._real.ToString(CultureInfo.InvariantCulture) + ","
            + this._imaginary.ToString(CultureInfo.InvariantCulture)
            + "i)");
    }

    // Null handling 
    public bool IsNull
    {
        get
        {
            return this._isnull;
        }
    }

    public static ComplexNumberCS Null
    {
        get
        {
            return NULL_INSTANCE;
        }
    }

    // Parsing input using regular expression 
    public static ComplexNumberCS Parse(SqlString sqlString)
    {
        string value = sqlString.ToString();

        if (sqlString.IsNull || value == NULL)
            return new ComplexNumberCS(true);

        // Check whether the input value matches the regex pattern 
        Match m = _parser.Match(value);

        // If the input’s format is incorrect, throw an exception 
        if (!m.Success)
            throw new ArgumentException(
                "Invalid format for complex number. "
                + "Format is ( n, mi ) where n and m are floating "
                + "point numbers in normal (not scientific) format "
                + "(nnnnnn.nn).");

        // If everything is OK, parse the value;  
        // we will get two double type values 
        return new ComplexNumberCS(double.Parse(m.Groups[1].Value,
            CultureInfo.InvariantCulture), double.Parse(m.Groups[2].Value,
            CultureInfo.InvariantCulture));
    }

    // Properties to deal with real and imaginary parts separately 
    public double Real
    {
        get
        {
            if (this._isnull)
                throw new InvalidOperationException();
            return this._real;
        }
        set
        {
            this._real = value;
        }
    }

    public double Imaginary
    {
        get
        {
            if (this._isnull)
                throw new InvalidOperationException();
            return this._imaginary;
        }
        set
        {
            this._imaginary = value;
        }
    }

    // Integer representation of real part
    public int RealInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            if (this._isnull)
                throw new InvalidOperationException();
            return (int)Math.Floor(this._real);
        }
    }

    // Region with arithmetic operations 
    #region arithmetic operations 
 
    // Addition 
    public ComplexNumberCS AddCN(ComplexNumberCS c) 
    { 
        // null checking 
        if (this._isnull || c._isnull) 
            return new ComplexNumberCS(true); 
        // addition 
        return new ComplexNumberCS(this.Real + c.Real,  
            this.Imaginary + c.Imaginary); 
    } 
 
    // Subtraction 
    public ComplexNumberCS SubCN(ComplexNumberCS c) 
    { 
        // null checking 
        if (this._isnull || c._isnull) 
            return new ComplexNumberCS(true); 
        // subtraction 
        return new ComplexNumberCS(this.Real - c.Real, 
            this.Imaginary - c.Imaginary); 
    } 
 
    // Multiplication 
    public ComplexNumberCS MulCN(ComplexNumberCS c) 
    { 
        // null checking 
        if (this._isnull || c._isnull) 
            return new ComplexNumberCS(true); 
        // multiplication 
        return new ComplexNumberCS(this.Real * c.Real - this.Imaginary * c.Imaginary, 
            this.Imaginary * c.Real + this.Real * c.Imaginary); 
    } 
 
    // Division 
    public ComplexNumberCS DivCN(ComplexNumberCS c) 
    { 
        // null checking 
        if (this._isnull || c._isnull) 
            return new ComplexNumberCS(true); 
        // division 
        return new ComplexNumberCS( 
            (this.Real * c.Real + this.Imaginary * c.Imaginary)  
              / (c.Real * c.Real + c.Imaginary * c.Imaginary), 
            (this.Imaginary * c.Real - this.Real * c.Imaginary) 
              / (c.Real * c.Real + c.Imaginary * c.Imaginary) 
            ); 
    } 
    #endregion 
}
*/

---------------------------------------------------------------------
-- Listing 11-2 Visual Basic-based ComplexNumberVB UDT
---------------------------------------------------------------------

/*
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server
Imports System.Text.RegularExpressions
Imports System.Globalization

<Serializable()> _
<SqlUserDefinedType(Format.Native, IsByteOrdered:=True)> _
Public Structure ComplexNumberVB
    Implements INullable

    Private Shared ReadOnly parser As New Regex("\A\(\s*(?<real>\-?\d+(\.\d+)?)\s*,\s*(?<img>\-?\d+(\.\d+)?)\s*i\s*\)\Z", _
    RegexOptions.Compiled Or RegexOptions.ExplicitCapture)
    Private realValue As Double
    Private imaginaryValue As Double
    Private isNullValue As Boolean
    Private Const nullValue As String = "<<null complex>>"
    Private Shared ReadOnly NULL_INSTANCE As New ComplexNumberVB(True)

    Public Sub New(ByVal real As Double, ByVal imaginary As Double)
        Me.realValue = real
        Me.imaginaryValue = imaginary
        Me.isNullValue = False
    End Sub

    Private Sub New(ByVal isnull As Boolean)
        Me.isNullValue = isnull
        Me.realValue = 0
        Me.imaginaryValue = 0
    End Sub

    Public Overrides Function ToString() As <SqlFacet(maxSize:=40)> String
        If Me.isNullValue = True Then
            Return nullValue
        Else
            Return "(" & Me.realValue.ToString(CultureInfo.InvariantCulture) _
                & "," & Me.imaginaryValue.ToString( _
                  CultureInfo.InvariantCulture) _
                & "i)"
        End If
    End Function

    Public ReadOnly Property IsNull() As Boolean Implements INullable.IsNull
        Get
            Return Me.isNullValue
        End Get
    End Property

    Public Shared ReadOnly Property Null() As ComplexNumberVB
        Get
            Return NULL_INSTANCE
        End Get
    End Property

    Public Shared Function Parse(ByVal sqlString As SqlString) _
      As ComplexNumberVB
        Dim value As String = sqlString.ToString()

        If sqlString.IsNull Or value = nullValue Then
            Return New ComplexNumberVB(True)
        End If

        Dim m As Match = parser.Match(value)

        If Not m.Success Then
            Throw New ArgumentException( _
                "Invalid format for complex number. Format is " + _
                  "( n, mi ) where n and m are floating point numbers " + _
                  "in normal (not scientific) format (nnnnnn.nn).")
        End If

        Return New ComplexNumberVB(Double.Parse(m.Groups(1).Value, _
          CultureInfo.InvariantCulture), _
            Double.Parse(m.Groups(2).Value, CultureInfo.InvariantCulture))
    End Function

    Public Property Real() As Double
        Get
            If Me.isNullValue Then
                Throw New InvalidOperationException()
            End If
            Return Me.realValue
        End Get
        Set(ByVal Value As Double)
            Me.realValue = Value
        End Set
    End Property

    Public Property Imaginary() As Double
        Get
            If Me.isNullValue Then
                Throw New InvalidOperationException()
            End If
            Return Me.imaginaryValue
        End Get
        Set(ByVal Value As Double)
            Me.imaginaryValue = Value
        End Set
    End Property

    Public ReadOnly Property RealInt() As Integer
        <SqlMethod(IsDeterministic:=True, IsPrecise:=True)> _
        Get
            If Me.isNullValue Then
                Throw New InvalidOperationException()
            End If
            Return CInt(Math.Floor(Me.realValue))
        End Get
    End Property

#Region "arithmetic operations"

            ' Addition 
    Public Function AddCN(ByVal c As ComplexNumberVB) As ComplexNumberVB
        'Null(checking) 
        If Me.isNullValue Or c.isNullValue Then
            Return New ComplexNumberVB(True)
        End If
        ' addition 
        Return New ComplexNumberVB(Me.Real + c.Real, _
            Me.Imaginary + c.Imaginary)
    End Function

    ' Subtraction 
    Public Function SubCN(ByVal c As ComplexNumberVB) As ComplexNumberVB
        'Null(checking) 
        If Me.isNullValue Or c.isNullValue Then
            Return New ComplexNumberVB(True)
        End If
        ' subtraction 
        Return New ComplexNumberVB(Me.Real - c.Real, _
            Me.Imaginary - c.Imaginary)
    End Function


    ' Multiplication 
    Public Function MulCN(ByVal c As ComplexNumberVB) As ComplexNumberVB
        'Null(checking) 
        If Me.isNullValue Or c.isNullValue Then
            Return New ComplexNumberVB(True)
        End If
        ' multiplication 
        Return New ComplexNumberVB(Me.Real * c.Real - _
          Me.Imaginary * c.Imaginary, _
            Me.Imaginary * c.Real + Me.Real * c.Imaginary)
    End Function


    ' Division 
    Public Function DivCN(ByVal c As ComplexNumberVB) As ComplexNumberVB
        'Null(checking) 
        If Me.isNullValue Or c.isNullValue Then
            Return New ComplexNumberVB(True)
        End If
        'Zero checking
        If c.Real = 0 And c.Imaginary = 0 Then
            Throw New ArgumentException()
        End If
        ' division 
        Return New ComplexNumberVB( _
            (Me.Real * c.Real + Me.Imaginary * c.Imaginary) _
              / (c.Real * c.Real + c.Imaginary * c.Imaginary), _
            (Me.Imaginary * c.Real - Me.Real * c.Imaginary) _
              / (c.Real * c.Real + c.Imaginary * c.Imaginary) _
          )
    End Function

#End Region

End Structure
*/

---------------------------------------------------------------------
-- Deploying C# UDT
---------------------------------------------------------------------

SET NOCOUNT ON;
GO

-- Enable CLR
USE master; 
EXEC sp_configure 'clr enabled', 1; 
RECONFIGURE; 
GO 
USE InsideTSQL2008;
GO

-- Deploy assembly
CREATE ASSEMBLY ComplexNumberCS 
FROM 'C:\InsideTSQL2008\ComplexNumber\ComplexNumberCS\bin\Debug\ComplexNumberCS.dll' 
WITH PERMISSION_SET = SAFE;
GO

-- Create UDT
CREATE TYPE dbo.ComplexNumberCS  
EXTERNAL NAME ComplexNumberCS.[ComplexNumberCS];
GO

-- Create a table using the UDT
CREATE TABLE dbo.CNUsage 
( 
  id INT IDENTITY(1,1) NOT NULL, 
  cn ComplexNumberCS NULL 
);
GO

-- Testing inserts
-- Correct values 
INSERT INTO dbo.CNUsage(cn) VALUES('(2,3i)'); 
INSERT INTO dbo.CNUsage(cn) VALUES('(1,7i)'); 
GO 
-- An incorrect value 
INSERT INTO dbo.CNUsage(cn) VALUES('(1i,7)');
GO

-- Check the data - byte stream
SELECT * FROM dbo.CNUsage;

-- Use default string representation
SELECT id, cn.ToString() AS cn 
FROM dbo. CNUsage;

-- Test ordering
SELECT id, cn.ToString() AS cn 
FROM dbo.CNUsage 
ORDER BY cn;
GO

-- Test NULLs
INSERT INTO dbo.CNUsage(cn) VALUES(NULL); 
 
SELECT id, cn.ToString() AS cn,  
  cn.Real AS [Real part], 
  cn.Imaginary AS [Imaginary part] 
FROM dbo.CNUsage;
GO

-- Arithmetic operations 
-- Addition 
DECLARE @cn1 ComplexNumberCS, @cn2 ComplexNumberCS, @cn3 ComplexNumberCS; 
SET @cn1 = CAST('(8, 5i)' AS ComplexNumberCS); 
SET @cn2 = '(2, 1i)'; 
SET @cn3 = @cn1.AddCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Subtraction 
DECLARE @cn1 ComplexNumberCS, @cn2 ComplexNumberCS, @cn3 ComplexNumberCS; 
SET @cn1 = CAST('(3, 4i)' AS ComplexNumberCS); 
SET @cn2 = '(1, 2i)'; 
SET @cn3 = @cn1.SubCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Multiplication 
DECLARE @cn1 ComplexNumberCS, @cn2 ComplexNumberCS, @cn3 ComplexNumberCS; 
SET @cn1 = CAST('(3, 2i)' AS ComplexNumberCS); 
SET @cn2 = '(1, 4i)'; 
SET @cn3 = @cn1.MulCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Division 
DECLARE @cn1 ComplexNumberCS, @cn2 ComplexNumberCS, @cn3 ComplexNumberCS; 
SET @cn1 = CAST('(10, 5i)' AS ComplexNumberCS); 
SET @cn2 = '(2, 4i)'; 
SET @cn3 = @cn1.DivCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO

-- Try built-in operator
DECLARE @cn1 ComplexNumberCS, @cn2 ComplexNumberCS, @cn3 ComplexNumberCS; 
SET @cn1 = CAST('(10, 5i)' AS ComplexNumberCS); 
SET @cn2 = '(2, 4i)'; 
SET @cn3 = @cn1 + @cn2; 
GO
-- Invalid operator error

-- Try built-in aggregate function
SELECT SUM(cn) FROM dbo.CNUsage;
GO
-- Invalid operator type error

-- Alter assembly to add the ComplexNumberCS_SUM UDA 
ALTER ASSEMBLY ComplexNumberCS 
FROM 'C:\InsideTSQL2008\ComplexNumber\ComplexNumberCS\bin\Debug\ComplexNumberCS.dll' 
GO 
 
-- Create the aggregate function 
CREATE AGGREGATE dbo.ComplexNumberCS_SUM(@input ComplexNumberCS) 
RETURNS ComplexNumberCS 
EXTERNAL NAME ComplexNumberCS.[ComplexNumberCS_SUM];
GO

-- Test the UDA
SELECT dbo.ComplexNumberCS_SUM(cn).ToString() AS ComplexSum 
FROM CNUsage 
WHERE cn IS NOT NULL;
GO

-- Try SELECT INTO of the UDT
SELECT id, cn
INTO #tmp
FROM dbo.CNUsage;
GO
-- Error - UDT does not exist in target db

-- SELECT INTO with string and other presentations
SELECT id, cn.ToString() AS cn,  
  cn.Real AS [Real part], 
  cn.Imaginary AS [Imaginary part],
  cn.RealInt AS [Real part int]
INTO #tmp
FROM dbo.CNUsage;
GO
-- Success

-- Check the #tmp structure
USE tempdb;
EXEC sp_help #tmp;
GO

-- Alter assembly to check the SqlFacet attribute
-- Drop the #tmp table
USE InsideTSQL2008;
DROP TABLE #tmp;
ALTER ASSEMBLY ComplexNumberCS 
FROM 'C:\InsideTSQL2008\ComplexNumber\ComplexNumberCS\bin\Debug\ComplexNumberCS.dll' 
GO 

-- SELECT INTO with string and other presentations
SELECT id, cn.ToString() AS cn,  
  cn.Real AS [Real part], 
  cn.Imaginary AS [Imaginary part],
  cn.RealInt AS [Real part int]
INTO #tmp
FROM dbo.CNUsage;
GO

-- Check the #tmp structure
USE tempdb;
EXEC sp_help #tmp;
GO

-- Drop the #tmp table
DROP TABLE #tmp;
GO

-- Check indexing

-- Index on the type
USE InsideTSQL2008;
CREATE INDEX CNUsage_cn ON dbo.CNUsage(cn);
GO

-- Try to index Real property only
CREATE INDEX CNUsage_Real ON dbo.CNUsage(cn.Real);
GO
-- Incorrect syntax error

-- Alter the table to try to add a persisted computed column
ALTER TABLE dbo.CNUsage
 ADD RealInt AS cn.RealInt PERSISTED;
GO
-- Error - the column is non-deterministic

-- Alter assembly to check the SqlMethod attribute
USE InsideTSQL2008;
ALTER ASSEMBLY ComplexNumberCS 
FROM 'C:\InsideTSQL2008\ComplexNumber\ComplexNumberCS\bin\Debug\ComplexNumberCS.dll' 
GO 

-- Alter the table to try to add a persisted computed column
ALTER TABLE dbo.CNUsage
 ADD RealInt AS cn.RealInt PERSISTED;
GO
-- No errors this time

-- Index the computed column
CREATE INDEX CNUsage_RealInt ON dbo.CNUsage(RealInt);
GO


---------------------------------------------------------------------
-- Deploying VB UDT
---------------------------------------------------------------------

-- Deploy assembly
CREATE ASSEMBLY ComplexNumberVB 
FROM 'C:\InsideTSQL2008\ComplexNumber\ComplexNumberVB\bin\ComplexNumberVB.dll' 
WITH PERMISSION_SET = SAFE;
GO

-- Create UDT
CREATE TYPE dbo.ComplexNumberVB  
EXTERNAL NAME ComplexNumberVB.[ComplexNumberVB];
GO

-- Create a table using the UDT
-- Drop table if exsists from the C# example first
-- DROP TABLE dbo.CNUsage
CREATE TABLE dbo.CNUsage 
( 
  id INT IDENTITY(1,1) NOT NULL, 
  cn ComplexNumberVB NULL 
);
GO

-- Testing inserts
-- Correct values 
INSERT INTO dbo.CNUsage(cn) VALUES('(2,3i)'); 
INSERT INTO dbo.CNUsage(cn) VALUES('(1,7i)'); 
GO 
-- An incorrect value 
INSERT INTO dbo.CNUsage(cn) VALUES('(1i,7)');
GO

-- Check the data - byte stream
SELECT * FROM dbo.CNUsage;

-- Use default string representation
SELECT id, cn.ToString() AS cn 
FROM dbo. CNUsage;

-- Test ordering
SELECT id, cn.ToString() AS cn 
FROM dbo.CNUsage 
ORDER BY cn;
GO

-- Test NULLs
INSERT INTO dbo.CNUsage(cn) VALUES(NULL); 
 
SELECT id, cn.ToString() AS cn,  
  cn.Real AS [Real part], 
  cn.Imaginary AS [Imaginary part] 
FROM dbo.CNUsage;
GO

-- Arithmetic operations 
-- Addition 
DECLARE @cn1 ComplexNumberVB, @cn2 ComplexNumberVB, @cn3 ComplexNumberVB; 
SET @cn1 = CAST('(8, 5i)' AS ComplexNumberVB); 
SET @cn2 = '(2, 1i)'; 
SET @cn3 = @cn1.AddCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Subtraction 
DECLARE @cn1 ComplexNumberVB, @cn2 ComplexNumberVB, @cn3 ComplexNumberVB; 
SET @cn1 = CAST('(3, 4i)' AS ComplexNumberVB); 
SET @cn2 = '(1, 2i)'; 
SET @cn3 = @cn1.SubCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Multiplication 
DECLARE @cn1 ComplexNumberVB, @cn2 ComplexNumberVB, @cn3 ComplexNumberVB; 
SET @cn1 = CAST('(3, 2i)' AS ComplexNumberVB); 
SET @cn2 = '(1, 4i)'; 
SET @cn3 = @cn1.MulCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO 
-- Division 
DECLARE @cn1 ComplexNumberVB, @cn2 ComplexNumberVB, @cn3 ComplexNumberVB; 
SET @cn1 = CAST('(10, 5i)' AS ComplexNumberVB); 
SET @cn2 = '(2, 4i)'; 
SET @cn3 = @cn1.DivCN(@cn2); 
SELECT @cn3.ToString(), CAST(@cn3 AS VARCHAR(MAX)), @cn3.Real, @cn3.Imaginary; 
GO

-- Try built-in operator
DECLARE @cn1 ComplexNumberVB, @cn2 ComplexNumberVB, @cn3 ComplexNumberVB; 
SET @cn1 = CAST('(10, 5i)' AS ComplexNumberVB); 
SET @cn2 = '(2, 4i)'; 
SET @cn3 = @cn1 + @cn2; 
GO
-- Invalid operator error

-- Try built-in aggregate functio
SELECT SUM(cn) FROM dbo.CNUsage;
GO
-- Invalid operator type error

 
-- Create the aggregate function 
CREATE AGGREGATE dbo.ComplexNumberVB_SUM(@input ComplexNumberVB) 
RETURNS ComplexNumberVB
EXTERNAL NAME ComplexNumberVB.[ComplexNumberVB_SUM];
GO

-- Test the UDA
SELECT dbo.ComplexNumberVB_SUM(cn).ToString() AS ComplexSum 
FROM CNUsage 
WHERE cn IS NOT NULL;
GO

-- SELECT INTO with string and other presentations
SELECT id, cn.ToString() AS cn,  
  cn.Real AS [Real part], 
  cn.Imaginary AS [Imaginary part],
  cn.RealInt AS [Real part int]
INTO #tmp
FROM dbo.CNUsage;
GO

-- Check the #tmp structure
USE tempdb;
EXEC sp_help #tmp;
GO

-- Drop the #tmp table
DROP TABLE #tmp;
GO

-- Check indexing

-- Index on the type
USE InsideTSQL2008;
CREATE INDEX CNUsage_cn ON dbo.CNUsage(cn);
GO

-- Alter the table to try to add a persisted computed column
ALTER TABLE dbo.CNUsage
 ADD RealInt AS cn.RealInt PERSISTED;
GO

-- Index the computed column
CREATE INDEX CNUsage_RealInt ON dbo.CNUsage(RealInt);
GO

---------------------------------------------------------------------
-- Clean-up code
---------------------------------------------------------------------
USE InsideTSQL2008;
GO
DROP TABLE dbo.CNUsage;
DROP AGGREGATE dbo.ComplexNumberCS_SUM;
DROP TYPE dbo.ComplexNumberCS;
DROP ASSEMBLY ComplexNumberCS;
DROP AGGREGATE dbo.ComplexNumberVB_SUM;
DROP TYPE dbo.ComplexNumberVB;
DROP ASSEMBLY ComplexNumberVB;
GO
SET NOCOUNT OFF;
GO
