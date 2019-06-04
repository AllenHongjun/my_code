<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EFDemo3.aspx.cs" Inherits="EFDemo.EFDemo3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--先自己代码实现一遍 遇到不懂的再去查询
                使用了这个github 
                每一次提交 都有记录
                图形界面的工具 直接使用
                其实工具方法 也都是有 就是有没有人来逼你一把
                如果 做到一定的阶段 有是混混谔谔的样子 
                我还是会换环境的
                我觉得现在这样的状态其实还是听好 虽然是类一点
                有过放弃的念头 但是 还是很快就消失了
                坚持的动力比较的多
                代码 敲着 敲着调试着 就忘记了很多事情
                
                --%>
            <asp:Button ID="Button1" runat="server" Text="DbContext重复使用" OnClick="Button1_Click" />


            <asp:Button ID="Button2" runat="server" Text="Lamda表达式查询" OnClick="Button2_Click" />

            <asp:Button ID="Button3" runat="server" Text="查询" OnClick="Button3_Click" />
        </div>
    </form>
</body>
</html>
