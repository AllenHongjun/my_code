<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserLogin.aspx.cs" Inherits="WebApp.Pages.Login.UserLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script type="text/javascript">
        window.onload = function () {

            //看不清楚按钮链接 msdn上 cookie的文档
            var validateCode = document.getElementById("validateCode");

            validateCode.onclick = function () {
                //每次点击按钮会重新放验证码的请求
                //正式功能 很多第三方sdk的使用
                document.getElementById("imgCode").src =
                    "ValidateImageCode.ashx?d=" + new Date().getMilliseconds();
            }

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            用户名：<input type="text" name="txtName" value="<%--<%=UserName %>--%>" />
            <br />
            密码:  <input type="password" name="txtPwd" value="" /> 
            <br />
            验证码： <input type="text" name="txtCode" value="" />

            <img src="ValidateImageCode.ashx" id="imgCode" />
            <a href="javascript:void(0)" id="validateCode">看不清楚</a>

            <input type="checkbox" name="autoLogin" value="auto" />自动登录
            <input type="submit" name="name" value="登录" />

            <span style="font-size:14px;color:aquamarine">
                <%=Msg %>
            </span>

        </div>
    </form>
</body>
</html>
