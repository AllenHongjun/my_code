<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/webform/MainMater.Master" AutoEventWireup="true" CodeBehind="ChildPage.aspx.cs" Inherits="WebApp.Pages.webform.ChildPage" %>






<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    创建一个包含模板页面的内容
    头部内容
    放头部不一样的 css

    还可以嵌套第3层
    使用模板页面的web 窗体
    MasterPageFile="~/Pages/webform/MainMater.Master"   多了一个这样的属性

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    ContentPlaceHolder1 1
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="Container" runat="server">
    学了你不一定会用到
    但是用了你不会 就一定要是要学了


</asp:Content>


<%--<asp:ContentPlaceHolder ID="ThirdInner" runat="server">
    </asp:ContentPlaceHolder>--%>


<asp:Content ID="Content4" ContentPlaceHolderID="footer" runat="server">

    这个是底部的内容
</asp:Content>
