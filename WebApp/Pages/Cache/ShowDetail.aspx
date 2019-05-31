<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShowDetail.aspx.cs" Inherits="WebApp.Pages.Cache.ShowDetail" %>
<%@ OutputCache Duration="12" VaryByParam="*"%>

<%--根据参数来缓存数据 * 是代表所有的--%>

<%--我这边没有执行的效果--%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:DetailsView ID="DetailsView1" runat="server" 
                Height="50px" Width="125px" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black">
                <EditRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                <RowStyle BackColor="White" />

            </asp:DetailsView>



        </div>
    </form>
</body>
</html>
