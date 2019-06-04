<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/webform/Site1.Master" AutoEventWireup="true" CodeBehind="WebFormContainMaster.aspx.cs" Inherits="WebApp.Pages.webform.WebFormContainMaster" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/jquery-3.4.1.js"></script>
    <script>


        //使用模板也的使用 时候 客户端ID只能这么获取  包含模板也的设置
        $("#TextBox1").val();
        $("#<%=TextBox1.ClientID%>").val();

    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>

</asp:Content>
