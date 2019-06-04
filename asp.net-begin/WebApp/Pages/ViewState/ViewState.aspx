<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewState.aspx.cs" Inherits="WebApp.Pages.ViewState.ViewState" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>

    <%--<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="+zZ1MhSHp8gc6pgsk7wP1uvNjSq8oXCIkTu8CuM6MfnxGsHWRz+C+hhW6N8CiDgPGs0Xj0MaU8H2dg+CQZeZ/SuC+oRjIMYWqASqheCeFIo=" />--%>

    <form id="form1" runat="server">
        <div>
            <span><%=Count %></span>
            <input type="submit" name="name" value="提交" />
        </div>
    </form>
</body>
</html>
