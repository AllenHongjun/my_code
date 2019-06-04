<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index2.aspx.cs" Inherits="WebApp.Pages.webform.Index2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>

    <%--数据源控件 数据绑定控件 listview Repeater--%>
    <form id="form1" runat="server">
        <div>
            <%--配置一下 点点鼠标 就搞定了
                可以配置多个数据库连接 好牛逼呀
                但是其实这样使用并不好 不能这么使用
                GridView 其实是一个表格 
                --%>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource1">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="编号" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                    <asp:BoundField DataField="UserName" HeaderText="姓名" SortExpression="UserName" />
                    <asp:BoundField DataField="UserPass" HeaderText="密码" SortExpression="UserPass" />
                    <asp:BoundField DataField="RegTime" HeaderText="注册时间" SortExpression="RegTime" />
                    <asp:BoundField DataField="Email" HeaderText="邮箱" SortExpression="Email" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:EFFristModelConnectionString %>" SelectCommand="SELECT * FROM [UserInfo] WHERE ([ID] &lt; @ID)">
                <SelectParameters>
                    <asp:Parameter DefaultValue="500" Name="ID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>

        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="ObjectDataSource1">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="Id" SortExpression="Id" />
                <asp:BoundField DataField="UserName" HeaderText="UserName" SortExpression="UserName" />
                <asp:BoundField DataField="UserPass" HeaderText="UserPass" SortExpression="UserPass" />
                <asp:BoundField DataField="RegTime" HeaderText="RegTime" SortExpression="RegTime" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
            </Columns>
        </asp:GridView>

        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetList" TypeName="BLL.UserInfoService"></asp:ObjectDataSource>
    </form>
</body>
</html>
