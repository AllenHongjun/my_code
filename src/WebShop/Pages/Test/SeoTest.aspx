<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SeoTest.aspx.cs" Inherits="WebShop.Pages.Test.SeoTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script src="../../Scripts/jquery-3.0.0.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#a1").click(function () {
                $.post("/ashx/Seo.ashx", {}, function (data) {
                    $("#div1").append(data);
                });
                return false;
            });

             $("#a12").click(function () {
                $.post("/ashx/Seo.ashx", {}, function (data) {
                    $("#div1").append(data);
                 });

                 //阻止了默认的事件。。
                return false;
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <%--这一种方式不利于seo 的优化  爬虫不会请求链接里面的内容--%>
        <a href="javascript:void(0);" id="a1">测试链接111</a>


        <%--链接的请求 改成爬虫可以访问的地址 。。可以直接请求 能够获得内容的--%>
        <a href="/ashx/seo.ashx" id="a12">测试链接2222</a>
        <div id="div1">




        </div>
    </form>
</body>
</html>
