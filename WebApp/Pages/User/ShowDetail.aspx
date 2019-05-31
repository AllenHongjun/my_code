<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowDetail.aspx.cs" Inherits="WebApp.Pages.ShowDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="/Content/bootstrap.min.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <table class="table table-condensed">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>用户名</th>
                                <th>密码</th>
                                <th>邮箱</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><%=userInfo.Id %></td>
                                <td><%= userInfo.UserName %></td>
                                <td><%=userInfo.UserPass %></td>
                                <td>@<%=userInfo.Email %></td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
