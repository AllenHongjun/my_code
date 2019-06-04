<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JsonNetDemo.aspx.cs" Inherits="WebShop.Pages.Test.JsonNetDemo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="seriliaze" Text="序列号一个对象" runat="server" OnClick="seriliaze_Click" />

            <asp:Button ID="Button1" runat="server" Text="List集合序列化" OnClick="Button1_Click" />


            <%--一个对象里面包了一个对象 又包了一个对象 包了好几层如何使用--%>
            <asp:Button ID="Button2" runat="server" Text="DataTalbe序列化" OnClick="Button2_Click" />

            <asp:Button ID="Button3" runat="server" Text="匿名对象序列化反序列化" OnClick="Button3_Click1" />
        </div>
    </form>
</body>
</html>
