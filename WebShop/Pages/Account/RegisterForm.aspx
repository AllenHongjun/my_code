<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterForm.aspx.cs" Inherits="WebShop.Pages.Account.RegisterForm" %>

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

            //输入框失去焦点的时候验证
            $("#userMail").blur(function () {
                validateEmail();
            });
            $("#validateCode").blur(function () {
                validateUserCode();
            });
            $("input[name=tel]").blur(function () {
                validateMobile();

            })
            $("input[name=username]").blur(function () {
                validateUserName();

            })
            
            $("input[name=password]").blur(function () {
                validatePassword();

            })
            $("input[name=repassword]").blur(function () {
                validateRepassword();

            })
             $("input[name=address]").blur(function () {
                validateAddress();

            })

            //表单提交的时候验证
            $("#registerForm").submit(function (e) {

                //表单提交的时候 客户端的验证还要一模一样的来一遍。。
                if ($("#userMail").val() == "") {
                    $("#msg").text("邮箱不能为空!!");
                    return false;
                }
                if ($("#validateCode").val() == "") {
                    $("#validateCodeMsg").text("验证码不能为空!!");
                    return false;
                }
                if ($("input[name=username]").val() == "") {
                    $("input[name=username]").next().text("用户名不能为空");
                    return false;
                }
                if ($("input[name=realname]").val() == "") {
                    $("input[name=realname]").next().text("真实不能为空");
                    return false;
                }
                if ($("input[name=password]").val() == "") {
                    $("input[name=password]").next().text("密码不能为空");
                    return false;
                }
                if ($("input[name=repassword]").val() == "") {
                    $("input[name=repassword]").next().text("确认密码不能为空");
                    return false;
                }
                if ($("input[name=address]").val() == "") {
                    $("input[name=address]").next().text("请输入地址");
                    return false;
                }
                if ($("input[name=tel]").val() == "") {
                    $("input[name=tel]").next().text("请输入手机号");
                    return false;
                }



            });

            //点击切换验证码
            $("#codeImg").click(function () {
                console.log($(this).attr("src"));
                $(this).attr("src", $(this).attr("src") +"?id="+ 1);

            })

        })

        function validateEmail() {
            var val = $("#userMail").val();
            var isValidate = false;
            if (val != "") {
                var reg = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                if (reg.test(val)) {
                    //$("#msg").css("display", "none");
                    $.post("/ashx/ValidateReg.ashx", { "action": "mail", "userMail": val }, function (data) {
                        //$("#msg").css("display", "block");
                        $("#msg").text(data);

                        //这里是异步的。。程序会往下执行。。
                        isValidate = true;
                        console.log(isValidate)
                        
                    });
                } else {
                    $("#msg").text("邮箱格式错误!!");
                    isValidate =  false;
                }

            } else {
                $("#msg").text("邮箱不能为空!!");
                isValidate = false;
            }
            console.log(isValidate)
            return isValidate;
        }
        //验证校验码
        function validateUserCode() {
            var code = $("#validateCode").val();
            var isValidate = false;
            if (code != "") {
                var reg = /^[0-9]*$/;
                if (reg.test(code)) {
                    $.post("/ashx/ValidateReg.ashx", { "action": "code", "validateCode": code }, function (data) {
                        $("#validateCodeMsg").text(data);
                        isValidate =  true;
                    });
                }
                else {
                    $("#validateCodeMsg").text("验证码格式错!!");
                    isValidate =  false;
                }

            } else {
                $("#validateCodeMsg").text("验证码不能为空!!");
                isValidate =  false;
            }
            return isValidate;
        }

        //验证手机号码 
        function validateMobile() { 
            var tel = $("input[name=tel]").val();
            if ($("input[name=tel]").val() != "") {
                console.log($("input[name=tel]").val());
                var reg = /^((\+86)|(86))?(13|15)\d{9}$/;
                if (reg.test(tel)) {
                    $("input[name=tel]").next().text("手机号可以注册");
                } else {
                    $("input[name=tel]").next().text("手机号格式不正确");
                }
            } else {
                $("input[name=tel]").next().text("手机号不能为空");
            }
        } 

        //用户名 验证 var reg=/^[a-zA-Z][a-zA-Z0-9]{3,15}$/;    

        function validateUsername() { 
            var password = $("input[name=username]").val();
            if ($("input[name=username]").val() != "") {
                console.log($("input[name=username]").val());
                var reg=/^[a-zA-Z][a-zA-Z0-9]{3,15}$/;    
                if (reg.test(password)) {
                    $("input[name=username]").next().text("输入正确");
                } else {
                    $("input[name=username]").next().text("至少3-15位");
                }
            } else {
                $("input[name=username]").next().text("用户名不能为空");
            }
        } 

        //验证密码
        function validatePassword() { 
            var password = $("input[name=password]").val();
            if ($("input[name=password]").val() != "") {
                console.log($("input[name=password]").val());
                var reg = /^[a-zA-Z\d_]{6,}$/;
                if (reg.test(password)) {
                    $("input[name=password]").next().text("输入正确");
                } else {
                    $("input[name=password]").next().text("密码至少6位");
                }
            } else {
                $("input[name=password]").next().text("密码不能为空");
            }
        } 

        //确认密码

        function validateRepassword() {
            var password = $("input[name=password]").val();
            var repassword = $("input[name=repassword]").val();
            if (password != repassword) {
                $("input[name=repassword]").next().text("两次输入密码不一致");
            } else {
                $("input[name=repassword]").next().text("输入正确");
            }

        }

        function validateAddress() {
            var address = $("input[name=address]").val();
            if (address.length < 6) {
                $("input[name=address]").next().text("请至少输入6个汉字");
            } else {
                $("input[name=address]").next().text("输入正确");
            }
        }

    </script>


</head>
<body>
    <form id="registerForm" method="post"  runat="server">
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
                        <span></span>
                    </div>
                    <div class="username">
                        <label> 真实姓名:</label>
                        <input class="shurukuang" type="text" name="realname" placeholder="请输入你的真实姓名" />
                        <span></span>
                    </div>
                    <div class="username">
                        <label> 密  码:</label>
                        <input class="shurukuang" type="password" name="password" placeholder="请输入你的密码" />
                        <span></span>
                    </div>

                    <div class="username">
                        <label> 确认密码:</label>
                        <input class="shurukuang" type="password" name="repassword" placeholder="请确认你的密码" />
                        <span></span>

                    </div>
                    <div class="username">
                        <label> 地址:</label>
                        <input class="shurukuang" type="text" name="address" placeholder="请输入你的地址" />
                        <span></span>
                    </div>
                    <div class="username">
                        <label> 邮箱:</label>
                        <input id="userMail" class="shurukuang" type="text" name="email" placeholder="请输入你的邮箱" />
                        <span id="msg"></span>
                    </div>
                    <div class="username">
                        <label> 手机号:</label>
                        <input class="shurukuang" type="text" name="tel" placeholder="请填写正确的手机号" />
                        <span ></span>

                    </div>
                    <div class="username">
                        <div class="left fl">
                            <label> 验证码:</label>
                            <input id="validateCode" class="yanzhengma" type="text" name="txtCode" placeholder="请输入验证码" />
                        </div>
                        <div class="right fl">
                            <img id="codeImg" src="/ashx/ValidateCode.ashx"></div>
                        <div class="left fl"><span id="validateCodeMsg"></span> </div>
                        <div class="clear"></div>
                        
                        
                    </div>
                </div>
                <div class="regist_submit">
                    <input id="btnSubmit" class="submit" type="submit" name="submit" value="立即注册" runat="server">
                </div>

            </div>
        </div>
    </form>
</body>
</html>
