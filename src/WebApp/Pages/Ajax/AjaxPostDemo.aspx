<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AjaxPostDemo.aspx.cs" Inherits="WebApp.Pages.Ajax.AjaxPostDemo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

    <script src="../../Scripts/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        $(function () {

            //浏览器提供的api js可以调用
            //兼容不同的浏览器
            //直接使用 别人分装好的第三方类库
            //越来越 知识让前端的人员使用

            //同一个站点下 的SessionID 都是相同的
            //ajax 其实就是一个请求和响应的过程
            //其实也不是很复杂。正好可以学习
            // 任何语言都能很请求的发送 和接受一个http的请求

            //异步 socket的请求
            $("#btnPost").click(function () {
                    var xhr;
                    if (XMLHttpRequest) {
                        xhr = new XMLHttpRequest();
                    } else {
                        xhr = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    xhr.open("post", "GetDate.ashx", true);
                    xhr.setRequestHeader("Content-Type",
                        "application/x-www-form-urlencoded");
                    xhr.send("name=zhangsan&pwd=123");
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState == 4) {
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
   <%-- form 表单需要一个submit按钮才会提交
    或者是服务端控件的按钮 不然是不会提交 的
    这里是客户端提交--%>
    <form id="form1" runat="server">
        <div>
            <input type="button" name="name" value="POSt获取数据" id="btnPost" />
        </div>
    </form>
</body>
</html>
