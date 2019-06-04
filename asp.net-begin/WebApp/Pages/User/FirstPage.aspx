<%@ Page   Language="C#" AutoEventWireup="true" CodeBehind="FirstPage.aspx.cs" Inherits="WebApp.Pages.FirstPage" %>
<%@ Import   Namespace="Model" %>
<%--可以导入命名控件  还有很多的指令 规定好的
    WebApp.Pages.FirstPage  命名空间下的类如  如果 重新复制以一分文件  这个这个页面 要继承哪个类
    这也会编译成几个类 继承 WebApp.Pages.FirstPage 那就牛逼了 FirstPage 这个类里面的属性 方法 。这个页面也就都可以使用了


    Page Import 可以导入命名空间 也就可以 使用其他的类里面的方法了。
    连个 <% %>  就可以注释了。

    __VIEWSTATE
    --%>
<%--<%@ Assembly=""      %>--%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script type="text/javascript">
        window.onload = function () {
            alert("这个实在Page_load之后执行的!");
        }
        console.log(123);

    </script>
</head>
<body>
    <form id="form1" runat="server">

        <%--如果布局复杂
            一般处理程序 无法处理。
            有控件 当做是一个模板引擎来处理。
            有事件来处理。
            可以直接写 C#的代码 和 代码来集成来渲染数据 
            给页面赋值 就是可以在服务端渲染数据。。

            渲染页面的牛逼之处 

            还有前端 js渲染也是可以的
            功能强大在主要还有事件 
            Page指令

            可以理解为模板 占位符 asp.net webform会替换其中的代码 然后渲染数据。

            开发效率会快很多。
            =  就是输出 可以理解为 respons.Write
            --%>
        <h2>Hello WebForm！！</h2>
        <%= strHtml %>
        <div>
        </div>
    </form>
</body>
</html>
