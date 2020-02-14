---------------------------------------------------------------------
-- Inside Microsoft SQL Server 2008: T-SQL Programming (MSPress, 2009)
-- Appendix A - Companion to CLR Routines
-- Copyright Itzik Ben-Gan and Dejan Sarka, 2009
-- All Rights Reserved
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Create CLRUtilities Database: SQL Server
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Development: Visual Studio
---------------------------------------------------------------------

/*
Create Project
-----------------

1. Create a new project using your preferred language (C# or Visual Basic)
     (File | New | Project | Visual C# | Visual Basic)

2. Choose a project template based on the Visual Studio edition

For the Professional or higher edition:
  Use either the Database SQL Server template (Database | SQL Server Project)
  Or the Windows Class Library template (Class Library)

For the Standard edition:
  Use the Windows Class Library template (Class Library)

3. Specify the following details in the New Project dialog box:

     Name: CLRUtilities
     Location: C:\
     Solution Name: CLRUtilities

     Confirm

4. Create a database reference in the Add Database Reference dialog box
     (relevant only if you chose the SQL Server Project template)

     Create a new database reference to the CLRUtilities database
     or choose an existing reference if you created one already
     
     Do not confirm SQL/CLR debugging on this connection
      
Develop Code
---------------

1. Add/Rename the class

SQL Server Project template:
  (Project | Add Class... | Class | Name: CLRUtilities.cs | CLRUtilities.vb | Add)

Class Library template: 
  (Rename Class1.cs to CLRUtilities.cs or Class1.vb to CLRUtilities.vb)

2. Replace the code in the class with the code
     from Listing A-2 (C#) or Listing A-3 (Visual Basic)
*/

---------------------------------------------------------------------
-- Deployment/Testing: Visual Studio, SQL Server
---------------------------------------------------------------------

/*
Deploy/Build Solution
------------------------

1. SQL Server Project template: (Build | Deploy)

     Done

2. Class Library template: (Build | Build)

     In SQL Server: run CREATE ASSEMBLY | FUNCTION | PROCEDURE | TRIGGER
     code in Listing A-4 (C#), A-5 (Visual Basic)
     (relevant only for Class Library template)

Test Solution
----------------

Run test code in Listing A-4 (C#), A-5 (Visual Basic) without the CREATE statements
*/

-- Listing A-1: T-SQL code to enable CLR and Create CLRUtilities Database and T1 Table
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
GO

-- Create T1 table
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);

-- Listing A-2: C# Code for CLRUtilities class
/*
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;

public partial class CLRUtilities
{

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

  // GetEnvInfo Procedure
  // Returns environment info in tabular format
  [SqlProcedure]
  public static void GetEnvInfo()
  {
    // Create a record - object representation of a row
    // Include the metadata for the SQL table
    SqlDataRecord record = new SqlDataRecord(
        new SqlMetaData("EnvProperty", SqlDbType.NVarChar, 20),
        new SqlMetaData("Value", SqlDbType.NVarChar, 256));
    // Marks the beginning of the result set to be sent back to the client
    // The record parameter is used to construct the metadata
    // for the result set
    SqlContext.Pipe.SendResultsStart(record);
    // Populate some records and send them through the pipe
    record.SetSqlString(0, @"Machine Name");
    record.SetSqlString(1, Environment.MachineName);
    SqlContext.Pipe.SendResultsRow(record);
    record.SetSqlString(0, @"Processors");
    record.SetSqlString(1, Environment.ProcessorCount.ToString());
    SqlContext.Pipe.SendResultsRow(record);
    record.SetSqlString(0, @"OS Version");
    record.SetSqlString(1, Environment.OSVersion.ToString());
    SqlContext.Pipe.SendResultsRow(record);
    record.SetSqlString(0, @"CLR Version");
    record.SetSqlString(1, Environment.Version.ToString());
    SqlContext.Pipe.SendResultsRow(record);
    // End of result set
    SqlContext.Pipe.SendResultsEnd();
  }

  // GetAssemblyInfo Procedure
  // Returns assembly info, uses Reflection
  [SqlProcedure]
  public static void GetAssemblyInfo(SqlString asmName)
  {
    // Retrieve the clr name of the assembly
    String clrName = null;
    // Get the context
    using (SqlConnection connection =
             new SqlConnection("Context connection = true"))
    {
      connection.Open();
      using (SqlCommand command = new SqlCommand())
      {
        // Get the assembly and load it
        command.Connection = connection;
        command.CommandText =
          "SELECT clr_name FROM sys.assemblies WHERE name = @asmName";
        command.Parameters.Add("@asmName", SqlDbType.NVarChar);
        command.Parameters[0].Value = asmName;
        clrName = (String)command.ExecuteScalar();
        if (clrName == null)
        {
          throw new ArgumentException("Invalid assembly name!");
        }
        Assembly myAsm = Assembly.Load(clrName);
        // Create a record - object representation of a row
        // Include the metadata for the SQL table
        SqlDataRecord record = new SqlDataRecord(
            new SqlMetaData("Type", SqlDbType.NVarChar, 50),
            new SqlMetaData("Name", SqlDbType.NVarChar, 256));
        // Marks the beginning of the result set to be sent back
        // to the client
        // The record parameter is used to construct the metadata
        // for the result set
        SqlContext.Pipe.SendResultsStart(record);
        // Get all types in the assembly
        Type[] typesArr = myAsm.GetTypes();
        foreach (Type t in typesArr)
        {
          // The type should be Class or Structure
          if (t.IsClass == true)
          {
            record.SetSqlString(0, @"Class");
          }
          else
          {
            record.SetSqlString(0, @"Structure");
          }
          record.SetSqlString(1, t.FullName);
          SqlContext.Pipe.SendResultsRow(record);
          // Find all public static methods
          MethodInfo[] miArr = t.GetMethods();
          foreach (MethodInfo mi in miArr)
          {
            if (mi.IsPublic && mi.IsStatic)
            {
              record.SetSqlString(0, @"  Method");
              record.SetSqlString(1, mi.Name);
              SqlContext.Pipe.SendResultsRow(record);
            }
          }
        }
        // End of result set
        SqlContext.Pipe.SendResultsEnd();
      }
    }
  }

  // trg_GenericDMLAudit Trigger
  // Generic trigger for auditing DML statements
  // trigger will write first 200 characters from all columns
  // in an XML format to App Event Log
  [SqlTrigger(Name = @"trg_GenericDMLAudit", Target = "T1",
     Event = "FOR INSERT, UPDATE, DELETE")]
  public static void trg_GenericDMLAudit()
  {
    // Get the trigger context to get info about the action type
    SqlTriggerContext triggContext = SqlContext.TriggerContext;
    // Prepare the command and pipe objects
    SqlCommand command;
    SqlPipe pipe = SqlContext.Pipe;

    // Check type of action
    switch (triggContext.TriggerAction)
    {
      case TriggerAction.Insert:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type, cast it
          // to nvarchar and select only a substring from it
          // Info from Inserted
          command = new SqlCommand(
            @"SELECT 'New data: '
                + REPLACE(
                    SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200
              FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE)
                AS a(InsertedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          // Note: if the following line would use
          // Environment.MachineName instead of "." to refer to
          // the local machine event log, the assembly would need
          // the UNSAFE permission set
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      case TriggerAction.Update:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type,
          // cast it to nvarchar and select only a substring from it
          // Info from Deleted
          command = new SqlCommand(
            @"SELECT 'Old data: '
                + REPLACE(
                    SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 
              FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE)
                AS a(DeletedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Info from Inserted
          command.CommandText =
            @"SELECT ' // New data: '
                + REPLACE(
                    SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 
              FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE)
                AS a(InsertedContents);";
          msg = msg + (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      case TriggerAction.Delete:
        // Retrieve the connection that the trigger is using
        using (SqlConnection connection
           = new SqlConnection(@"context connection=true"))
        {
          connection.Open();
          // Collect all columns into an XML type,
          // cast it to nvarchar and select only a substring from it
          // Info from Deleted
          command = new SqlCommand(
            @"SELECT 'Old data: '
                + REPLACE(
                    SUBSTRING(CAST(a. DeletedContents AS NVARCHAR(MAX))
                      ,1,200),
                    CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 
              FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE)
                   AS a(DeletedContents);",
             connection);
          // Store info collected to a string variable
          string msg;
          msg = (string)command.ExecuteScalar();
          // Write the audit info to the event log
          EventLogEntryType entry = new EventLogEntryType();
          entry = EventLogEntryType.SuccessAudit;
          EventLog ev = new EventLog(@"Application",
            ".", @"GenericDMLAudit Trigger");
          ev.WriteEntry(msg, entry);
          // send the audit info to the user
          pipe.Send(msg);
        }
        break;
      default:
        // Just to be sure - this part should never fire
        pipe.Send(@"Nothing happened");
        break;
    }
  }

  // SalesRunningSum Procedure
  // Queries dbo.Sales, returns running sum of qty for each empid, dt 
  [Microsoft.SqlServer.Server.SqlProcedure]
  public static void SalesRunningSum()
  {
    using (SqlConnection conn = new SqlConnection("context connection=true;"))
    {
      SqlCommand comm = new SqlCommand();
      comm.Connection = conn;
      comm.CommandText = "" +
          "SELECT empid, dt, qty " +
          "FROM dbo.Sales " +
          "ORDER BY empid, dt;";

      SqlMetaData[] columns = new SqlMetaData[4];
      columns[0] = new SqlMetaData("empid", SqlDbType.Int);
      columns[1] = new SqlMetaData("dt", SqlDbType.DateTime);
      columns[2] = new SqlMetaData("qty", SqlDbType.Int);
      columns[3] = new SqlMetaData("sumqty", SqlDbType.BigInt);

      SqlDataRecord record = new SqlDataRecord(columns);

      SqlContext.Pipe.SendResultsStart(record);

      conn.Open();

      SqlDataReader reader = comm.ExecuteReader();

      SqlInt32 prvempid = 0;
      SqlInt64 sumqty = 0;

      while (reader.Read())
      {
        SqlInt32 empid = reader.GetSqlInt32(0);
        SqlInt32 qty = reader.GetSqlInt32(2);

        if (empid == prvempid)
        {
          sumqty += qty;
        }
        else
        {
          sumqty = qty;
        }

        prvempid = empid;

        record.SetSqlInt32(0, reader.GetSqlInt32(0));
        record.SetSqlDateTime(1, reader.GetSqlDateTime(1));
        record.SetSqlInt32(2, qty);
        record.SetSqlInt64(3, sumqty);

        SqlContext.Pipe.SendResultsRow(record);
      }

      SqlContext.Pipe.SendResultsEnd();
    }
  }
};
*/

-- Listing A-3: Visual Basic Code for CLRUtilities class
/*
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server
Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Collections
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Reflection
Imports System.Runtime.InteropServices


Partial Public Class CLRUtilities

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

  ' Compare implicit vs. explicit casting
  <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
  Public Shared Function ImpCast(ByVal inpStr As String) As String
    Return inpStr.Substring(2, 3)
  End Function

  <SqlFunction(IsDeterministic:=True, DataAccess:=DataAccessKind.None)> _
  Public Shared Function ExpCast(ByVal inpStr As SqlString) As SqlString
    Return CType(inpStr.ToString().Substring(2, 3), SqlString)
  End Function

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

  ' GetEnvInfo Procedure
  ' Returns environment info in tabular format
  <SqlProcedure()> _
  Public Shared Sub GetEnvInfo()
    ' Create a record - object representation of a row
    ' Include the metadata for the SQL table
    Dim record As New SqlDataRecord( _
        New SqlMetaData("EnvProperty", SqlDbType.NVarChar, 20), _
        New SqlMetaData("Value", SqlDbType.NVarChar, 256))
    ' Marks the beginning of the result set to be sent back to the client
    ' The record parameter is used to construct the metadata for
    ' the result set
    SqlContext.Pipe.SendResultsStart(record)
    '' Populate some records and send them through the pipe
    record.SetSqlString(0, "Machine Name")
    record.SetSqlString(1, Environment.MachineName)
    SqlContext.Pipe.SendResultsRow(record)
    record.SetSqlString(0, "Processors")
    record.SetSqlString(1, Environment.ProcessorCount.ToString())
    SqlContext.Pipe.SendResultsRow(record)
    record.SetSqlString(0, "OS Version")
    record.SetSqlString(1, Environment.OSVersion.ToString())
    SqlContext.Pipe.SendResultsRow(record)
    record.SetSqlString(0, "CLR Version")
    record.SetSqlString(1, Environment.Version.ToString())
    SqlContext.Pipe.SendResultsRow(record)
    ' End of result set
    SqlContext.Pipe.SendResultsEnd()
  End Sub

  ' GetAssemblyInfo Procedure
  ' Returns assembly info, uses Reflection
  <SqlProcedure()> _
  Public Shared Sub GetAssemblyInfo(ByVal asmName As SqlString)
    ' Retrieve the clr name of the assembly
    Dim clrName As String = Nothing
    ' Get the context
    Using connection As New SqlConnection("Context connection = true")
      connection.Open()
      Using command As New SqlCommand
        ' Get the assembly and load it
        command.Connection = connection
        command.CommandText = _
          "SELECT clr_name FROM sys.assemblies WHERE name = @asmName"
        command.Parameters.Add("@asmName", SqlDbType.NVarChar)
        command.Parameters(0).Value = asmName
        clrName = CStr(command.ExecuteScalar())
        If (clrName = Nothing) Then
          Throw New ArgumentException("Invalid assembly name!")
        End If
        Dim myAsm As Assembly = Assembly.Load(clrName)
        ' Create a record - object representation of a row
        ' Include the metadata for the SQL table
        Dim record As New SqlDataRecord( _
            New SqlMetaData("Type", SqlDbType.NVarChar, 50), _
            New SqlMetaData("Name", SqlDbType.NVarChar, 256))
        ' Marks the beginning of the result set to be sent back
        ' to the client
        ' The record parameter is used to construct the metadata
        ' for the result set
        SqlContext.Pipe.SendResultsStart(record)
        ' Get all types in the assembly
        Dim typesArr() As Type = myAsm.GetTypes()
        For Each t As Type In typesArr
          ' The type should be Class or Structure
          If (t.IsClass = True) Then
            record.SetSqlString(0, "Class")
          Else
            record.SetSqlString(0, "Structure")
          End If
          record.SetSqlString(1, t.FullName)
          SqlContext.Pipe.SendResultsRow(record)
          ' Find all public static methods
          Dim miArr() As MethodInfo = t.GetMethods
          For Each mi As MethodInfo In miArr
            If (mi.IsPublic And mi.IsStatic) Then
              record.SetSqlString(0, "  Method")
              record.SetSqlString(1, mi.Name)
              SqlContext.Pipe.SendResultsRow(record)
            End If
          Next
        Next
        ' End of result set
        SqlContext.Pipe.SendResultsEnd()
      End Using
    End Using
  End Sub

  ' trg_GenericDMLAudit Trigger
  ' Generic trigger for auditing DML statements
  ' trigger will write first 200 characters from all columns 
  ' in an XML format to App Event Log
  <SqlTrigger(Name:="trg_GenericDMLAudit", Target:="T1", _
    Event:="FOR INSERT, UPDATE, DELETE")> _
  Public Shared Sub trg_GenericDMLAudit()
    ' Get the trigger context to get info about the action type
    Dim triggContext As SqlTriggerContext = SqlContext.TriggerContext
    ' Prepare the command and pipe objects
    Dim command As SqlCommand
    Dim pipe As SqlPipe = SqlContext.Pipe

    ' Check type of action
    Select Case triggContext.TriggerAction
      Case TriggerAction.Insert
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Inserted
          command = New SqlCommand( _
            "SELECT 'New data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 " & _
            "FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE) " & _
            "AS a(InsertedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          ' Note: if the following line would use
          ' Environment.MachineName instead of "." to refer to
          ' the local machine event log, the assembly would need
          ' the UNSAFE permission set
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case TriggerAction.Update
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Deleted
          command = New SqlCommand( _
            "SELECT 'Old data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 " & _
            "FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE) " & _
            "AS a(DeletedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Info from Inserted
          command.CommandText = _
            "SELECT ' // New data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.InsertedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS InsertedContents200 " & _
            "FROM (SELECT * FROM Inserted FOR XML AUTO, TYPE) " & _
            "AS a(InsertedContents);"
          msg = msg + CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case TriggerAction.Delete
        ' Retrieve the connection that the trigger is using
        Using connection _
          As New SqlConnection("Context connection = true")
          connection.Open()
          ' Collect all columns into an XML type,
          ' cast it to nvarchar and select only a substring from it
          ' Info from Deleted
          command = New SqlCommand( _
            "SELECT 'Old data: ' + REPLACE(" & _
            "SUBSTRING(CAST(a.DeletedContents AS NVARCHAR(MAX)" & _
            "),1,200), CHAR(39), CHAR(39)+CHAR(39)) AS DeletedContents200 " & _
            "FROM (SELECT * FROM Deleted FOR XML AUTO, TYPE) " & _
            "AS a(DeletedContents);", _
             connection)
          ' Store info collected to a string variable
          Dim msg As String
          msg = CStr(command.ExecuteScalar())
          ' Write the audit info to the event log
          Dim entry As EventLogEntryType
          entry = EventLogEntryType.SuccessAudit
          Dim ev As New EventLog("Application", _
            ".", "GenericDMLAudit Trigger")
          ev.WriteEntry(msg, entry)
          ' send the audit info to the user
          pipe.Send(msg)
        End Using
      Case Else
        ' Just to be sure - this part should never fire
        pipe.Send("Nothing happened")
    End Select
  End Sub

  ' SalesRunningSum Procedure
  ' Queries dbo.Sales, returns running sum of qty for each empid, dt 
  <Microsoft.SqlServer.Server.SqlProcedure()> _
  Public Shared Sub SalesRunningSum()

    Using conn As New SqlConnection("context connection=true")
      Dim comm As New SqlCommand
      comm.Connection = conn
      comm.CommandText = "" & _
          "SELECT empid, dt, qty " & _
          "FROM dbo.Sales " & _
          "ORDER BY empid, dt;"

      Dim columns() As SqlMetaData = New SqlMetaData(3) {}
      columns(0) = New SqlMetaData("empid", SqlDbType.Int)
      columns(1) = New SqlMetaData("dt", SqlDbType.DateTime)
      columns(2) = New SqlMetaData("qty", SqlDbType.Int)
      columns(3) = New SqlMetaData("sumqty", SqlDbType.BigInt)

      Dim record As New SqlDataRecord(columns)

      SqlContext.Pipe.SendResultsStart(record)

      conn.Open()

      Dim reader As SqlDataReader = comm.ExecuteReader

      Dim prvempid As SqlInt32 = 0
      Dim sumqty As SqlInt64 = 0

      While (reader.Read())
        Dim empid As SqlInt32 = reader.GetSqlInt32(0)
        Dim qty As SqlInt32 = reader.GetSqlInt32(2)

        If (empid = prvempid) Then
          sumqty = sumqty + qty
        Else
          sumqty = qty
        End If

        prvempid = empid

        record.SetSqlInt32(0, reader.GetSqlInt32(0))
        record.SetSqlDateTime(1, reader.GetSqlDateTime(1))
        record.SetSqlInt32(2, qty)
        record.SetSqlInt64(3, sumqty)

        SqlContext.Pipe.SendResultsRow(record)
      End While

      SqlContext.Pipe.SendResultsEnd()
    End Using

  End Sub
End Class
*/

---------------------------------------------------------------------
-- Deployment and Testing: Visual Studio, SQL Server
---------------------------------------------------------------------

-- Listing A-4: C# code to deploy and test CLR routines
USE CLRUtilities;
GO

-- Create assembly 
CREATE ASSEMBLY CLRUtilities
FROM 'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll'
WITH PERMISSION_SET = SAFE;
-- If no Debug folder, use instead:
-- FROM 'C:\CLRUtilities\CLRUtilities\bin\CLRUtilities.dll'
GO

---------------------------------------------------------------------
-- Scalar Function: RegexIsMatch
---------------------------------------------------------------------

-- Create RegexIsMatch function
CREATE FUNCTION dbo.RegexIsMatch
  (@inpstr AS NVARCHAR(MAX), @regexstr AS NVARCHAR(MAX)) 
RETURNS BIT
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexIsMatch;
GO

-- Note: By default, automatic deployment with VS will create functions
-- with the option CALLED ON NULL INPUT
-- and not with RETURNS NULL ON NULL INPUT 

-- Test RegexIsMatch function
SELECT dbo.RegexIsMatch(
  N'dejan@solidq.com',
  N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$');
GO

---------------------------------------------------------------------
-- Scalar Function: RegexReplace
---------------------------------------------------------------------

-- Create RegexReplace function 
CREATE FUNCTION dbo.RegexReplace(
  @input       AS NVARCHAR(MAX),
  @pattern     AS NVARCHAR(MAX),
  @replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexReplace;
GO

-- Test RegexReplace function
SELECT dbo.RegexReplace('(123)-456-789', '[^0-9]', '');
GO

---------------------------------------------------------------------
-- Scalar Function: FormatDatetime
---------------------------------------------------------------------

-- Create FormatDatetime function
CREATE FUNCTION dbo.FormatDatetime
  (@dt AS DATETIME, @formatstring AS NVARCHAR(500)) 
RETURNS NVARCHAR(500)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.FormatDatetime;
GO

-- Test FormatDatetime function
SELECT dbo.FormatDatetime(GETDATE(), 'MM/dd/yyyy');
GO

---------------------------------------------------------------------
-- Scalar Functions: ImpCast, ExpCast
---------------------------------------------------------------------

-- Create ImpCast function
CREATE FUNCTION dbo.ImpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ImpCast;
GO
-- Create ExpCast function
CREATE FUNCTION dbo.ExpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ExpCast;
GO

-- Test ImpCast and ExpCast functions
SELECT dbo.ImpCast(N'123456'), dbo.ExpCast(N'123456');
GO

---------------------------------------------------------------------
-- Scalar Function: SQLSigCLR
---------------------------------------------------------------------

-- Create SQLSigCLR function
CREATE FUNCTION dbo.SQLSigCLR
  (@rawstring AS NVARCHAR(MAX), @parselength AS INT) 
RETURNS NVARCHAR(MAX)
EXTERNAL NAME CLRUtilities.CLRUtilities.SQLSigCLR;
GO

-- Test SQLSigCLR function
SELECT dbo.SQLSigCLR
  (N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);
GO

---------------------------------------------------------------------
-- Table Function: SplitCLR
---------------------------------------------------------------------

-- Create SplitCLR function
CREATE FUNCTION dbo.SplitCLR
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

-- Test SplitCLR function
SELECT pos, element FROM dbo.SplitCLR(N'a,b,c', N',');
GO

-- Create SplitCLR_OrderByPos function
CREATE FUNCTION dbo.SplitCLR_OrderByPos
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
ORDER(pos) -- new in SQL Server 2008
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

-- Test SplitCLR_OrderByPos function
SELECT *
FROM dbo.SplitCLR_OrderByPos(N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z', N',')
ORDER BY pos;
GO

---------------------------------------------------------------------
-- Stored Procedure: GetEnvInfo
---------------------------------------------------------------------

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
GO
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative:

-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master;
GO
CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey;
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
GO
*/

-- Create GetEnvInfo stored procedure
CREATE PROCEDURE dbo.GetEnvInfo
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetEnvInfo;
GO

-- Test GetEnvInfo stored procedure
EXEC dbo.GetEnvInfo;
GO

---------------------------------------------------------------------
-- Stored Procedure: GetAssemblyInfo
---------------------------------------------------------------------

-- Create GetAssemblyInfo stored procedure
CREATE PROCEDURE GetAssemblyInfo
  @asmName AS sysname
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetAssemblyInfo;
GO

-- Test GetAssemblyInfo stored procedure
EXEC GetAssemblyInfo N'CLRUtilities';
GO

---------------------------------------------------------------------
-- Trigger: trg_GenericDMLAudit
---------------------------------------------------------------------

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);
GO

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
GO
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative:

-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master;
GO
CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey;
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
GO
*/

-- Create trg_T1_iud_GenericDMLAudit trigger
USE CLRUtilities;
GO

CREATE TRIGGER trg_T1_iud_GenericDMLAudit
 ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
EXTERNAL NAME CLRUtilities.CLRUtilities.trg_GenericDMLAudit;
GO

-- Test trg_GenericDMLAudit trigger
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, N'A');
UPDATE dbo.T1 SET datacol = N'B' WHERE keycol = 1;
DELETE FROM dbo.T1 WHERE keycol = 1;
-- Examine Windows Application Log
GO

---------------------------------------------------------------------
-- Stored Procedure: SalesRunningSum
---------------------------------------------------------------------

-- Create and populate Sales table
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;

CREATE TABLE dbo.Sales
(
  empid INT      NOT NULL,                -- partitioning column
  dt    DATETIME NOT NULL,                -- ordering column
  qty   INT      NOT NULL DEFAULT (1),    -- measure 1
  val   MONEY    NOT NULL DEFAULT (1.00), -- measure 2
  CONSTRAINT PK_Sales PRIMARY KEY(empid, dt)
);
GO

INSERT INTO dbo.Sales(empid, dt, qty, val) VALUES
  (1, '20100212', 10, 100.00),
  (1, '20100213', 30, 330.00),
  (1, '20100214', 20, 200.00),
  (2, '20100212', 40, 450.00),
  (2, '20100213', 10, 100.00),
  (2, '20100214', 50, 560.00);
GO

-- Create SalesRunningSum procedure
CREATE PROCEDURE dbo.SalesRunningSum
AS EXTERNAL NAME CLRUtilities.CLRUtilities.SalesRunningSum;
GO

-- Test SalesRunningSum procedure
EXEC dbo.SalesRunningSum;
GO

-- Listing A-5: Visual Basic code to deploy and test CLR routines
USE CLRUtilities;
GO

-- Create assembly 
CREATE ASSEMBLY CLRUtilities
FROM 'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll'
WITH PERMISSION_SET = SAFE;
-- If no Debug folder, use instead:
-- FROM 'C:\CLRUtilities\CLRUtilities\bin\CLRUtilities.dll'
GO

---------------------------------------------------------------------
-- Scalar Function: RegexIsMatch
---------------------------------------------------------------------

-- Create RegexIsMatch function
CREATE FUNCTION dbo.RegexIsMatch
  (@inpstr AS NVARCHAR(MAX), @regexstr AS NVARCHAR(MAX)) 
RETURNS BIT
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].RegexIsMatch;
GO

-- Note: By default, automatic deployment with VS will create functions
-- with the option CALLED ON NULL INPUT
-- and not with RETURNS NULL ON NULL INPUT 

-- Test RegexIsMatch function
SELECT dbo.RegexIsMatch(
  N'dejan@solidq.com',
  N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$');
GO

---------------------------------------------------------------------
-- Scalar Function: RegexReplace
---------------------------------------------------------------------

-- Create RegexReplace function 
CREATE FUNCTION dbo.RegexReplace(
  @input       AS NVARCHAR(MAX),
  @pattern     AS NVARCHAR(MAX),
  @replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].RegexReplace;
GO

-- Test RegexReplace function
SELECT dbo.RegexReplace('(123)-456-789', '[^0-9]', '');
GO

---------------------------------------------------------------------
-- Scalar Function: FormatDatetime
---------------------------------------------------------------------

-- Create FormatDatetime function 
CREATE FUNCTION dbo.FormatDatetime
  (@dt AS DATETIME, @formatstring AS NVARCHAR(500)) 
RETURNS NVARCHAR(500)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].FormatDatetime;
GO

-- Test FormatDatetime function
SELECT dbo.FormatDatetime(GETDATE(), 'MM/dd/yyyy');
GO

---------------------------------------------------------------------
-- Scalar Functions: ImpCast, ExpCast
---------------------------------------------------------------------

-- Create ImpCast function
CREATE FUNCTION dbo.ImpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].ImpCast;
GO
-- Create ExpCast function
CREATE FUNCTION dbo.ExpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].ExpCast;
GO

-- Test ImpCast and ExpCast functions
SELECT dbo.ImpCast(N'123456'), dbo.ExpCast(N'123456');
GO

---------------------------------------------------------------------
-- Scalar Function: SQLSigCLR
---------------------------------------------------------------------

-- Create SQLSigCLR function
CREATE FUNCTION dbo.SQLSigCLR
  (@rawstring AS NVARCHAR(MAX), @parselength AS INT) 
RETURNS NVARCHAR(MAX)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SQLSigCLR;
GO

-- Test SQLSigCLR function
SELECT dbo.SQLSigCLR
  (N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);
GO

---------------------------------------------------------------------
-- Table Function: SplitCLR
---------------------------------------------------------------------

-- Create SplitCLR function
CREATE FUNCTION dbo.SplitCLR
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SplitCLR;
GO

-- Test SplitCLR function
SELECT pos, element FROM dbo.SplitCLR(N'a,b,c', N',');
GO

-- Create SplitCLR_OrderByPos function
CREATE FUNCTION dbo.SplitCLR_OrderByPos
  (@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
ORDER(pos)
EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SplitCLR;
GO

-- Test SplitCLR_OrderByPos function
SELECT *
FROM dbo.SplitCLR_OrderByPos(N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z', N',')
ORDER BY pos;
GO

---------------------------------------------------------------------
-- Stored Procedure: GetEnvInfo
---------------------------------------------------------------------

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
GO
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative:

-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master;
GO
CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey;
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
GO
*/

-- Create GetEnvInfo stored procedure
CREATE PROCEDURE dbo.GetEnvInfo
AS EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].GetEnvInfo;
GO

-- Test GetEnvInfo stored procedure
EXEC dbo.GetEnvInfo;
GO

---------------------------------------------------------------------
-- Stored Procedure: GetAssemblyInfo
---------------------------------------------------------------------

-- Create GetAssemblyInfo stored procedure
CREATE PROCEDURE GetAssemblyInfo
  @asmName AS sysname
AS EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].GetAssemblyInfo;
GO

-- Test GetAssemblyInfo stored procedure
EXEC GetAssemblyInfo N'CLRUtilities';
GO

---------------------------------------------------------------------
-- Trigger: trg_GenericDMLAudit
---------------------------------------------------------------------

-- Create T1 table
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);
GO

-- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
GO
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative:

-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master;
GO
CREATE ASYMMETRIC KEY CLRUtilitiesKey
  FROM EXECUTABLE FILE =
    'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey;
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
GO
*/

-- Create trg_T1_iud_GenericDMLAudit trigger
USE CLRUtilities;
GO

CREATE TRIGGER trg_T1_iud_GenericDMLAudit
 ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
EXTERNAL NAME
  CLRUtilities.[CLRUtilities.CLRUtilities].trg_GenericDMLAudit;
GO

-- Test trg_GenericDMLAudit trigger
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, N'A');
UPDATE dbo.T1 SET datacol = N'B' WHERE keycol = 1;
DELETE FROM dbo.T1 WHERE keycol = 1;
-- Examine Windows Application Log
GO

---------------------------------------------------------------------
-- Stored Procedure: SalesRunningSum
---------------------------------------------------------------------

-- Create and populate Sales table
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;

CREATE TABLE dbo.Sales
(
  empid INT      NOT NULL,                -- partitioning column
  dt    DATETIME NOT NULL,                -- ordering column
  qty   INT      NOT NULL DEFAULT (1),    -- measure 1
  val   MONEY    NOT NULL DEFAULT (1.00), -- measure 2
  CONSTRAINT PK_Sales PRIMARY KEY(empid, dt)
);
GO

INSERT INTO dbo.Sales(empid, dt, qty, val) VALUES
  (1, '20100212', 10, 100.00),
  (1, '20100213', 30, 330.00),
  (1, '20100214', 20, 200.00),
  (2, '20100212', 40, 450.00),
  (2, '20100213', 10, 100.00),
  (2, '20100214', 50, 560.00);
GO

-- Create SalesRunningSum procedure
CREATE PROCEDURE dbo.SalesRunningSum
AS EXTERNAL NAME CLRUtilities.[CLRUtilities.CLRUtilities].SalesRunningSum;
GO

-- Test SalesRunningSum procedure
EXEC dbo.SalesRunningSum;
GO
