<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApp.Pages.Ajax.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../../Scripts/jquery-3.4.1.min.js"></script>
    <script>
        $(function () {
            $("msg").css("display", "none");
            //每次输入框失去焦点的时候就发送一个请求
            //cs 可以直接连接数据库 

            //那会感觉 公司代码 系统有太多的地方的是可以完善的
            //优化 有很多的功能 可以开发 还是挺爽的

            //这么简单的代码 你都不思考一下 直接操 其实是不好的

            //每次失去焦点的时候验证一下也是可以的。
            //有的时候公司的代码 为了实现效果
            //很多重复 简单的 工作要做 也是没有办法的

            //比如他有10 个输入框 那就有很多的判断 
            //这个也是没有办法的
            $("#txtUserName").blur(function () {
                var userName = $(this).val();
                if (userName != "") {

                    $.post("CheckUserName.ashx", { "name": userName }, function (data) {
                        $("#msg").css("display", "block").text(data);

                    })
                } else {

                    alert("用户名不能为空！");
                }
            })
        })

    </script>



</head>
<body>
    <form id="form1" runat="server">
        <div>

            用户名: <input type="text" name="txtName" value="" id="txtUserName" />

            密码: <input type="password" name="txtPwd" value="" />

            <input type="button" name="name" value="注册" />


            <span id="msg" style="font-size:14px;color:red"></span><br />
        </div>
    </form>
</body>
</html>
