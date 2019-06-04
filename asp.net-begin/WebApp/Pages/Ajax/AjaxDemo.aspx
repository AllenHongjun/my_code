<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AjaxDemo.aspx.cs" Inherits="WebApp.Pages.Ajax.AjaxDemo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../../Scripts/jquery-3.4.1.min.js"></script>
    <script>
        //会根据不同的请求 创建不同的sesssion对象
        //通过 js 代码 客户端代码来发送 请求

        $(function () {
            $("#btnGetDate").click(function () {
                //通过AJAX向服务器发送请求
                var xhr;
                if (XMLHttpRequest) {
                    xhr = new XMLHttpRequest();
                } else {
                    xhr = new ActiveXObject("Microsoft.XMLHTTP");
                }

                xhr.open("get", "GetDate.ashx?name=zhangsan&age=12", true);
                xhr.send();//开始发送

                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4) {
                        //表示服务端已经将数据完整返回，并且浏览器全部接受完毕
                        if (xhr.status == 200) {
                            alert(xhr.responseText);
                        }
                    }
                }



            })


        })

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--和用户有关的数据 安全性的问题
                浏览器给服务器发送请求 异步的时候  浏览器不会刷新 
                请求处理的过程 用户还能在浏览器上做其他的事情。
                
                --%>
            <input id="btnGetDate" type="button" name="" value="获取服务端时间" />

        </div>
    </form>
</body>
</html>
