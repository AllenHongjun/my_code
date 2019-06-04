<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageCacheDemo.aspx.cs" Inherits="WebApp.Pages.Cache.PageCacheDemo" %>

<%--缓存的时间 5秒钟  我是写了这个代码 但是没有看视频。  这个而是放在服务器中缓存当中 
    5秒钟之内 就不会 执行后面的c#代码 和请求管道 有密切的关系  

    这个请求管道的事件 是asp.net webform 和mvc是共享  第7个  第 11 12个 
    数据库数据完整性 也是非常重要的。。。
    
    --%>  
<%@ OutputCache Duration="5" VaryByParam="*" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <a href="ShowDetail.aspx?id=236">用户信息</a>
            <a href="ShowDetail.aspx?id=235">用户信息</a>
        </div>
    </form>
</body>
</html>
