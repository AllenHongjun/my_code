<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThridPage.aspx.cs" Inherits="WebApp.Pages.ThridPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    隐藏于的内容 是 base64编码过了 所以有点看不太懂

    可以状态保持 表格中的数据 都保存在了 __ViewState隐藏域中
    拖一个控件 出来 。然后给控件赋值 就可以了。
    不需要了解 http协议 
    __viewState 中的数据 都会在网络中传输 所以页面性能会比较变慢

<div class="aspNetHidden">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="3Fa2aSlQT8Tcu2SS5CQkUf76YO1s1xvkrlIdv/CMhG3iXR5n2BQ/VDa6WWU15zkMINUOYxoZlBN6t0awCIIOjS0Jq6bWUT8mUHIKE5LZpY4=" />
</div>

<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="A49C3DB6" />


    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
