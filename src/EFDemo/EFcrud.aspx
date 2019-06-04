<%@ Page EnableViewState="false" Language="C#" AutoEventWireup="true" CodeBehind="EFcrud.aspx.cs" Inherits="EFDemo.EFcrud" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>


            <asp:Button ID="Button1" runat="server" Text="点击按钮自动添加一个用户 好牛逼呀" />
        </div>
        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="执行查询1" />
        <p>
            <asp:Button ID="Button3" runat="server" Text="删除一条数据" OnClick="Button3_Click" />
        </p>
        <asp:Button ID="Button4" runat="server" Text="修改一条数据3" OnClick="Button4_Click" />
    </form>
</body>
</html>
