<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserInfoList.aspx.cs" Inherits="WebApp.Pages.UserInfoList" %>

<%--导入命名空间 就是当做一个C#的类来使用--%>
<%@ Import Namespace="Model" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>用户列表</title>
    <!-- Bootstrap -->
    <link href="/Content/bootstrap.min.css" rel="stylesheet" />

</head>
<body>

    <%--vs如何知识 Emmet能更加方便的敲打html
        IIS aspx dotnet 先父类  再是子类里面的 C#的代码 然后生成 一坨html 返回给 客户端 然后客户端执行 js 渲染页面

        详细 的asp.net 处理流程。反编译 看源码 整个处理流程 mvc 里面的流程
        不要怕麻烦 只能如何使用 能做出来就万事大吉了。

        所有的控件都必须放到 from runat ="server"  能省事
    --%>

    <form action="/" method="post" runat="server">

        <div class="container">
            <h1>你好，世界！</h1>
            <asp:LinkButton PostBackUrl="~/Pages/AddUserInfo.aspx" Text="添加用户" CssClass="btn btn-primary" runat="server" />
            <div class="row">
                <div class="col-md-12">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>用户名</th>
                                <th>密码</th>
                                <th>邮箱</th>
                                <th>日期</th>
                                <th>删除</th>
                                <th>详细</th>
                                <th>编辑</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%--
                            webform页面指令 模板语法的官方文档
                            没有找到哪里可以查看
                            <%= string %>--%>
                            <% foreach (UserInfo userInfo in UserList)
                                {%>
                            <tr>
                                <td><%=userInfo.Id %></td>
                                <td><%=userInfo.UserName %></td>
                                <td><%=userInfo.UserPass %></td>
                                <td><%=userInfo.Email %></td>
                                <td><%= userInfo.RegTime.ToLongDateString()%></td>
                                <td><a class="deletes" href="Delete.aspx?id=<%=userInfo.Id %>">删除</a></td>
                                <td><a href="ShowDetail.aspx?id=<%=userInfo.Id %>">详细</a></td>
                                <td><a href="EditUser.aspx?id=<%=userInfo.Id %>">编辑</a></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%--girdview 就是一个表格  表格中数据 会存到 ____VIEWSTATE  复制一份存到这个隐藏域中一份
            __ViewStat 
            确定是 如何和前端的样式对应 
            不知道 感觉不出来是在做网页。  有很多网页上的东西会弄不明白
            
            用拖控件 拖几个页面

            --%>    
        <br />
        <hr />
        <hr />
        <div class="container">
            <div class="row">
                <div class="col-10">

                    <asp:GridView CssClass="table table-striped" ID="GridView1" runat="server" ></asp:GridView>

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
