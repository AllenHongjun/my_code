<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Shop.Web.User.Login" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" content="order by dede58.com" />
    <title>会员登录</title>
    <link rel="stylesheet" type="text/css" href="/assets/css/login.css">
    <style>
        #loginForm label.error {
            margin-left: 60px;
            width: auto;
            display: block;
            font-size: 12px;
            color: #ff6700;
        }
        .codeImg {
            width:98px;
            height:40px;
        }
    </style>
</head>
<body>
    <!-- login -->
    <div class="top center">
        <div class="logo center">
            <a href="/index.aspx" target="_blank">
                <img src="/assets/image/mistore_logo.png" alt=""></a>
        </div>
    </div>
    <form id="loginForm" method="post"  class="form center" runat="server">
        <div class="login">
            <div class="login_center">
                <div class="login_top">
                    <div class="left fl">会员登录</div>
                    <div class="right fr">测试账号demo 密码123456<a href="/Pages/Account/Register.aspx" target="_self">立即注册</a></div>
                    <div class="clear"></div>
                    <div class="xian center"></div>
                </div>
                <div class="login_main center">
                    <div class="username">
                        用户名:&nbsp;
                        <input class="shurukuang" type="text" name="txtUsername" placeholder="请输入你的用户名" />

                    </div>
                    <div class="username">
                        密&nbsp;&nbsp;&nbsp;&nbsp;码:&nbsp;
                        <input class="shurukuang" type="password" name="txtPassword" placeholder="请输入你的密码" />

                    </div>
                    <div class="username">
                        <div class="left fl">
                            验证码:&nbsp;
                            <input class="yanzhengma" type="text" name="txtYzm" placeholder="请输入验证码" />

                        </div>
                        <div class="right fl">
                            <img id="codeImg" class="codeImg" src="/ashx/ValidateCode.ashx">
                        </div>
                        <div class="clear"></div>
                    </div>
                    <div class="username" style="margin-bottom:0;">
                        <div class="left fl">
                            记住我:&nbsp;
                            <input  type="checkBox" name="autoLogin" />
                        </div>
                        
                    </div>
                </div>
                <div class="login_submit">
                    <input id="btnSubmit"  type="submit" name="submit" value="立即登录" class="submit">
                    <label  class="error" style="padding-top:10px;" ><%=Msg %></label>
                </div>
                <%--<asp:TextBox ID="HiddenReturnUrl"   runat="server" name="HiddenReturnUrl"></asp:TextBox>--%>
                <input type="hidden" name="HiddenReturnUrl" value="<%=HiddenReturnUrl %>"" />
                
            </div>
        </div>
    </form>
    <footer>
        <div class="copyright">简体 | 繁体 | English | 常见问题</div>
        <div class="copyright">XX公司版权所有-京ICP备10046444-<img src="/assets/image/ghs.png" alt="">京公网安备11010802020134号-京ICP证110507号</div>

    </footer>
   
    <script src="../../Scripts/jquery-3.0.0.min.js"></script>
    <script src="../../Scripts/jquery.validate.min.js"></script>

    <script>
        //$.validator.setDefaults({
        //    submitHandler: function () {
        //        alert("submitted!");
        //    }
        //});

        function validateLogin(form) {
             // 验证登陆登陆表单 键盘抬起和表单提交的时候
            console.log(form);
            form.validate({
                rules: {
                    txtUsername: {
                        required: true,
                        minlength: 4
                    },
                    txtPassword: {
                        required: true,
                        minlength: 4
                    },
                    txtYzm: {
                        required: true,
                        minlength: 4,
                    }
                },
                messages: {
                    txtUsername: {
                        required: "请输入用户名",
                        minlength: "用户名长度只要大于2个汉字"
                    },
                    txtPassword: {
                        required: "请输入密码",
                        minlength: "密码至少为4个字符"
                    },
                    txtYzm: {
                        required: "请输入验证码！",
                        minlength: "至少为4个字符"
                    }
                },

                //我去 表单提交的办法 已经写在他单独的里面 。。这些前端的插件的使用。，。
                // 还是要找个demo看清楚。。  不是你想怎么写就怎么写的。。
                submitHandler: function (form) {
                    form.submit();
                    
                    /*
                    var username = $("input[name=txtUsername]").val();
                    var password = $("input[name=txtPassword]").val();
                    var code = $("input[name=txtYzm]").val();
                    var data = {
                        "username":username,
                        "password":password,
                        "code":code
                    };
                       


                    
                    $.post("Login.aspx", data, function (data) {
                        if (true) {
                            alert("表单提交成功")
                            return false;
                            window.location.href = "/index.html";
                        }
                    })
                    */
 
                }

            });
        }

        $().ready(function () {
            validateLogin($("#loginForm"));

            //点击切花验证码
            $("#codeImg").click(function () {
                $(this).attr("src", "/ashx/ValidateCode.ashx?date=" + new Date().getMilliseconds());
            })
            ////点击按钮提交表单
            //$("#loginForm").submit(function () {
            //    validateLogin($("#loginForm"));
                
            //})
        });
	</script>
</body>
</html>
