<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApp.Pages.Login.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            用户名：<input type="text" name="txtName" value="<%=LoginUserName %>"" />
            <br />
            密码：<input type="password" name="txtPwd" value="" />
            <br />
            <input type="submit" name="name" value="登陆" />
        </div>
    </form>
</body>
</html>
