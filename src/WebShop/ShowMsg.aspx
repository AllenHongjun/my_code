<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ShowMsg.aspx.cs" Inherits="WebShop.ShowMsg" %>


<asp:Content ContentPlaceHolderID="Content" runat="server">

    <style>
        .msgBox{
            text-align:center;
            font-size:20px;
        }

    </style>
    <form id="form1" runat="server" class="msgBox">
        <div class="center ">
             <%=Msg%>
        </div>
        <p>
            5秒钟以后自动跳转到 <a href="<%=Url%>"> <%=Title %></a>
        </p>
    </form>

</asp:Content>


