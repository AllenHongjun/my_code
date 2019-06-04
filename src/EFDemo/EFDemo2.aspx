<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EFDemo2.aspx.cs" Inherits="EFDemo.EFDemo2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button Text="添加关联数据" runat="server" OnClick="Unnamed1_Click" style="height: 21px" />

            <br />  
            <asp:Button Text="关联数据查询" runat="server" OnClick="Unnamed2_Click" />

            <br />

            <asp:Button Text="根据用户名查询订单信息" runat="server" OnClick="Unnamed3_Click" />

            <br />  

            <asp:Button Text="根据订单号查询用户信息" runat="server" OnClick="Unnamed4_Click" />

            <br />  

            <asp:Button Text="删除某个用户的订单" runat="server" OnClick="Unnamed5_Click" />

        </div>
    </form>
</body>
</html>
