<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DropDownList.aspx.cs" Inherits="WebApp.Pages.webform.DropDownList" %>

<%@ Import Namespace="Common" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>


    <%-- ViewState禁用 可以减少一下

    ViewState对象 被禁用了也就不能使用了--%>

    <%-- ItemTemplate
    分页搜索排序--%>
    <form id="form1" runat="server">
        <table style="width: 558px">
            <asp:Repeater ID="Repeater1" runat="server" EnableViewState="false" OnItemCommand="Repeater1_ItemCommand">
                <HeaderTemplate>
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
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <%--就相当于一个输出 绑定--%>
                        <td><%#Eval("Id") %></td>
                        <td><%#Eval("UserName") %></td>
                        <td><%#Eval("UserPass") %></td>
                        <td><%#Eval("Email") %></td>
                        <td>
                            <asp:Button CommandName="BtnEditUser" CommandArgument='<%#Eval("Id") %>' ID="Button2" runat="server" Text="编辑" />
                        </td>
                        <td>详细</td>
                        <td>
                            <asp:Button CommandName="BtnDeleteUser" CommandArgument='<%#Eval("Id") %>' ID="Button1" runat="server" Text="删除" />
                        </td>
                    </tr>
                </ItemTemplate>
                <%--显示交替项目的内容--%>
                <AlternatingItemTemplate>
                    <tr style="background-color: gray">
                        <%--就相当于一个输出 绑定--%>
                        <td><%#Eval("Id") %></td>
                        <td><%#Eval("UserName") %></td>
                        <td><%#Eval("UserPass") %></td>
                        <td><%#Eval("Email") %></td>
                        <td>
                            <asp:Button CommandName="BtnEditUser" CommandArgument='<%#Eval("Id") %>' ID="Button2" runat="server" Text="编辑" />
                        </td>
                        <td>详细</td>
                        <td>
                            <asp:Button CommandName="BtnDeleteUser" CommandArgument='<%#Eval("Id") %>' ID="Button1" runat="server" Text="删除" />
                        </td>
                    </tr>

                </AlternatingItemTemplate>
                <SeparatorTemplate>
                    <tr>
                        <td colspan="6">
                            <hr />
                        </td>
                    </tr>

                </SeparatorTemplate>
                <FooterTemplate>
                </FooterTemplate>
            </asp:Repeater>
        </table>
        <%--分页其实就是放置一个分页的页码条。。想要什么样的样式就直接拿出来就可以了--%>
         <%=PageBarHelper.GetPageBar(PageIndex,PageCount)%>

        <%--相当于一个 foreach
                Eval()绑定输出的意思
                可以直接使用C# 代码 
                可以使用ajax
               可以使用控件

        --%>
        <%--Repeater是一个表格--%>
        <div>

            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="ObjectDataSource1" DataTextField="UserName" DataValueField="Id"></asp:DropDownList>

        </div>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetList" TypeName="BLL.UserInfoService"></asp:ObjectDataSource>
        <asp:DropDownList ID="DropDownList2" runat="server"></asp:DropDownList>
    </form>
</body>
</html>
