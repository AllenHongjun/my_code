<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestList.aspx.cs" Inherits="WebShop.Pages.Account.TestList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">


        <div>
            <asp:ListView ID="ListView1" runat="server">
            </asp:ListView>

        </div>

        <asp:Repeater ID="Repeater1" runat="server">
            <HeaderTemplate>
                <table>

                
            </HeaderTemplate>
            <ItemTemplate>
                <tr> 
                    <td><%#Eval("LoginId") %></td>
                    <td><%#Eval("LoginPwd") %></td>
                    <td><%#Eval("Name") %></td>
                    <td><%#Eval("Phone") %></td>
                    <td><%#Eval("Mail") %></td>

                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </form>
</body>
</html>
