<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditUser.aspx.cs" Inherits="WebApp.Pages.EditUser" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>修改用户</title>
    <!-- Bootstrap -->
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />

</head>
<body>
    <form  class="form-horizontal" runat="server">
        <div class="container">
            <div class="form-group">
                <label for="inputEmail3" class="col-sm-2 control-label">用户名</label>
                <div class="col-sm-10">
                    <input type="text" value="<%=user.UserName %>" name="txtName" class="form-control" id="inputUserName" placeholder="Email">
                </div>
            </div>
            <div class="form-group">
                <label for="inputEmail3" class="col-sm-2 control-label">邮箱</label>
                <div class="col-sm-10">
                    <input type="email" value="<%=user.Email %>"" name="txtEmail" class="form-control" id="inputEmail3" placeholder="Email">
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword3" class="col-sm-2 control-label">密码</label>
                <div class="col-sm-10">
                    <input type="password" value="<%=user.UserPass %>"" name="txtPwd" class="form-control" id="inputPassword3" placeholder="Password">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox">
                            记住我
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">提交</button>
                    <a href="UserInfoList.aspx" class="btn  btn-primary">返回首页</a>
                </div>
            </div>
        </div>
    </form>

    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="/Scripts/jquery-3.4.1.min.js"></script>
    <script src="/Scripts/bootstrap.min.js"></script>
</body>
</html>

