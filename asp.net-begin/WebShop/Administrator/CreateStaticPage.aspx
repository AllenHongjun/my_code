<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateStaticPage.aspx.cs" Inherits="WebShop.Administrator.CreateStaticPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

          <%--  添加一条产品的时候 可以选择生成 一个静态页面
            也可以批量全部生成--%>

            <asp:Button ID="Button1" runat="server" Text="点击按钮生成详情页面的静态页面" OnClick="Button1_Click" />

        </div>
    </form>
</body>
</html>
