<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Control.aspx.cs" Inherits="WebApp.Pages.ViewState.Control" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:FileUpload ID="FileUpload1" runat="server" />

            <asp:HiddenField ID="HiddenTest" runat="server" />


            <asp:Image Width="50%" ID="Image1" runat="server" ImageUrl="~/Image/image3.jpg" />

            <asp:ImageButton ID="ImageButton1" runat="server" />

            <asp:Table ID="Table1" runat="server" >


            </asp:Table>

            <asp:DropDownList ID="DropDownList1" runat="server">
                <asp:ListItem Text="金华"   Value="1"  Selected="True"/>
                <asp:ListItem Text="上海"   Value="1"  Selected="false"/>
                <asp:ListItem Text="背景"   Value="1"  Selected="False"/>
            </asp:DropDownList>

        </div>
    </form>
</body>
</html>
