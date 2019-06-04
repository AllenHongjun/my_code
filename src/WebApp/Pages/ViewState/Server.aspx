<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Server.aspx.cs" Inherits="WebApp.Pages.ViewState.Server" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--<% Server.Execute("ServerChild.aspx"); %>--%>

            会把子页面的内容 放到这个位置来
            <%--ifream不一样--%>


             <%--&lt;p font=&#39;red&#39;&gt;abced&lt;/p&gt;  一个方法就能把 html全部编码之后输出。
                 html编码能用在哪里  发表评论。  商品详细页面。
                 评论的内容 有sql  写一个<script> window.location ="http://www.douniwan.com/"</script> 有脚本  浏览器就会执行脚本
                 安全漏洞。。xss 跨站脚本攻击。形象的例子。。
                 将接收的数据 html编码之后 存储。只是显示数据 不会执行 

                 限制发表评论的内容。。限制 敏感内容。
                 中国有权查封任何一个网站。。
                 
                 --%>
            <%= Server.HtmlEncode("<p font='red'>abced</p>") %>

            <%= Server.HtmlDecode("aadfdf") %>
           
                <a href="aa.aspx?a=<%=Server.UrlEncode("特殊字符") %>"></a>

            <%--参数如果是特殊字符的话  通过URL地址传递参数 出现意想不到的问题 就需要 将URL先编码一下
                只是将一个参数编码 不是整个url地址编码
                --%>
             <a href="aa.aspx?a=<%=Server.UrlEncode("% = + @！@*&*") %>"></a>
               
            <%--相当于页面的跳转-
                js压缩 css压缩 图片 压缩 
                C#代码 优化 
                sql执行效率优化 
                一点一点 的优化。
                -%>
            <%
                Server.Transfer("ServerChild.aspx");
                %>

            <%--<iframe src="LoginDemo.html" width="70%" height="100%"></iframe>--%>

            <%--手机网站 webapp--%> 

            <%--seo 搜索引擎优化--%>
        </div>
    </form>
</body>
</html>
