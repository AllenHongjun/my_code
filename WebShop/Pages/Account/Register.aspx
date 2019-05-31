<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebShop.Pages.Account.Register" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8">
    <meta name="author" />
    <title>用户注册</title>
    <link rel="stylesheet" type="text/css" href="~/assets/css/login.css">
    <script src="../../Scripts/jquery-3.0.0.min.js"></script>
    <script>
        $(function () {

            /*
             Content-Type: application/x-www-form-urlencoded; charset=UTF-8
             username=&password=&repassword=&tel=&username=
             会帮你手机表单对象 然后以 form-urlencode的形式提交到服务端。
             表单校验的规则。。表单校验的东西   看一下别人是怎么做的 复制过来 就搞定了。
            课后完成一遍客户端的表单验证
             */
            $("#btnSubmit").click(function () {
                var par = $("#registerForm").serializeArray();
                 console.log(par);
                $.post("/ashx/UserRegister.ashx", par, function (data) {
                    //data = JSON.parse(data);
                    data = $.parseJSON(data);
                    console.log(data);
                    if (data.code == 1) {
                        window.location.href = "/index.aspx";
                    } else {
                        //或者在某一块区域显示一下错误信息
                        alert(data.code);
                        alert(data.msg)
                    }

                });


            })

        })

        //验证邮箱
        function validateEmail(data) {


        }

        //验证手机号
        function validateTel(data) {


        }

    </script>


</head>
<body>
    <form id="registerForm" method="post" >
        <div class="regist">
            <div class="regist_center">
                <div class="regist_top">
                    <div class="left fl">会员注册</div>
                    <div class="right fr"><a href="/index.aspx" target="_self">小米商城</a></div>
                    <div class="clear"></div>
                    <div class="xian center"></div>
                </div>
                <div class="regist_main center">
                    <div class="username">
                        <label>用户名:</label>
                        <input class="shurukuang" type="text" name="username" placeholder="请输入你的用户名" />
                        <span>请不要输入汉字</span>
                    </div>
                    <div class="username">
                        <label> 真实姓名:</label>
                        <input class="shurukuang" type="text" name="realname" placeholder="请输入你的真实姓名" />
                        <span>请不要输入汉字</span>
                    </div>
                    <div class="username">
                        <label> 密  码:</label>
                        <input class="shurukuang" type="password" name="password" placeholder="请输入你的密码" />
                        <span>请输入6位以上字符</span>
                    </div>

                    <div class="username">
                        <label> 确认密码:</label>
                        <input class="shurukuang" type="password" name="repassword" placeholder="请确认你的密码" />
                        <span>两次密码要输入一致哦</span>

                    </div>
                    <div class="username">
                        <label> 地址:</label>
                        <input class="shurukuang" type="text" name="address" placeholder="请输入你的地址" />
                        <span>请不要输入汉字</span>
                    </div>
                    <div class="username">
                        <label> 邮箱:</label>
                        <input class="shurukuang" type="text" name="email" placeholder="请输入你的邮箱" />
                        <span>请不要输入汉字</span>
                    </div>
                    <div class="username">
                        <label> 手机号:</label>
                        <input class="shurukuang" type="text" name="tel" placeholder="请填写正确的手机号" />
                        <span>填写下手机号吧，方便我们联系您！</span>

                    </div>
                    <div class="username">
                        <div class="left fl">
                            <label> 验证码:</label>
                            <input class="yanzhengma" type="text" name="yanzhenma" placeholder="请输入验证码" />
                        </div>
                        <div class="right fl">
                            <img src="/ashx/ValidateCode.ashx"></div>
                        <div class="clear"></div>
                    </div>
                </div>
                <div class="regist_submit">
                    <input id="btnSubmit" class="submit" type="button" name="submit" value="立即注册">
                </div>

            </div>
        </div>
    </form>
</body>
</html>
