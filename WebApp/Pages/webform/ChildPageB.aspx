<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/webform/MainMater.Master" AutoEventWireup="true" CodeBehind="ChildPageB.aspx.cs" Inherits="WebApp.Pages.webform.ChildPageB" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <div>
        Head
    </div>
    这里是要填写的内容  ContentPlaceHolderID="head" 着就和模板页的 坑相互关联
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <p>ContentPlaceHolder1</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="Container" runat="server">
    <p>Container</p>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="footer" runat="server">
    <p>底部版权信息</p>
</asp:Content>
