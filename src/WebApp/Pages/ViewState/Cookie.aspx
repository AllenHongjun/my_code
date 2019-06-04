<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cookie.aspx.cs" Inherits="WebApp.Pages.ViewState.Cookie" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <p>
        cookie是小段文本 存储在 浏览器的 内存 或者 磁盘当中
        js可以操作 可以通过请求响应  写cookie的内容
        自己的网站 只能操作自己网站的cookie

        
        cookie可以设置一个Path来限制某个路径下面的页面才会把cookie发送到后台。
        可以持久存储

        cookie是通过响应报文的方式写到前台。最终写入Cookie是通过响应报文头来的
        cookie有限制（大多数浏览器）

    </p>

    <p>
        <%--cookie的值 可以设置过期 时间 使用urlencode() 进行编码--%>
      <%--  Webstorm-bfad3077=6e61a73b-7251-4f1a-ac52-a23162016854; _ga=GA1.1.1352785291.1538529151;
        Hm_lvt_0558502420ce5fee054b31425e77ffa6=1552838768; __atuvc=6|12; 
        .AUXBLOGENGINE-96d5b379-7e1d-4dac-a6ba-1e50db561b04=721F14AEA2CA84110F13970C794E4F55BBE3B7366B5686C318C8FE8E1F54CFFE46B4B01D8B
        23B2D13AEFF8405B02E63424AC2816BCBB2332B6C53E960C1E9940D4CEC5C547F1A1A20AD460491AAFD01321191CADF9F05BAF19F7D2780464C92A99FE9A66
        ADC5DEB008E3EA6C9496C190786CA028ADF77157C095A063D8499F8F6C0C70DEAB77C7A3D3A42C242055CDD2E8F386DBF9E3A26D9F4
        C1CA39249B084D8A933A196EF2824A9DBE64D16BEB96754AC342AE4E14B6382277C96CF4E171342F6EAD580688B1C8C1F57D
        AFA4442B0D780EF9DCCD747EE8EAD802CC876BAF8C679B875B237E034435E098EFF66D400DD7034B2B9F9B3C8A0CDD80
        6981B6B396652842107B4EF4657597E353A30245D13CE697ADC41555A3685186B806B0D3FE4C6565
        9E7CF5C7ABA914316F7262AF40DE421A27F0208FA6D3FEF2D9FF6ADDC7AEEA380DEE74FD8DA1B768D48BCFB11940EAE838E5819B990ECD457B120646C9EE2A943; 
        UM_distinctid=169c9b8ecaa174-0b83c421a59edc-5a40201d-1fa400-169c9b8ecac46b; 
        CNZZDATA1996164=cnzz_eid=2029537698-1553865209-&ntime=1553865209;
        Hm_lvt_5793b8e3dc0e9c35e0bff8e90285157e=1553867648; Nop.customer=f82c5155-0bab-4d57-83f9-0a079aaf61b1; 
        .AspNet.Consent=yes; .Nop.Customer=e4d4d855-11c2-4e83-80ba-77f1103194fc;
        CNZZDATA1272621644=637759302-1555242145-|1555242145;
        ai_user=Vm/Vs|2019-04-14T14:25:11.764Z;
        .AspNet.ApplicationCookie=QN04J28APTdrwjuP012BvHKNT7EVIhY8SH9U7KVKBtjPeNT-N3fLDbLpJVtQXYbZePrxJts4GUgu3sSt
        bK3z8uXWRp2PbMZn3eEmJZ8eXIi_kP9MZDtJMiF_cJSINxDFL7D4RL0Y2n_IlUUC3d-UyvqmlDnFDgHLAK0iGLsIOYtjN60ApkPWyHZn1F6GMw3
        ZVtTtnmlq71SnASjrFD2wtxWFTTr2aJ9DzTG_AYXoXgErxGZ1_BdfwTXSQez4UDQrtPvM17cWVh6lLWv4TDdw1e_nmf2QIfncyE6gt0WfhWI13o1cRJ_vJ4mSyZ
        cB1jZ82ZX0y_u9DcAYp_faGDRecytRxidG_6UmHOKpBXIJ81oCOVaTHtTFCB1EcpVxljrqvyqn8IhOfsig90Jezbqd3PU9tlxVMyYrZKmB4aM5ZPlctRBF6JD_RMOL0VGXduiQ8
        bgEPm5Wws4MYitbLLPjgTpu57sX2SCCwICEjde1N5PewZIox5MT1GtZyrUDLQSj--%>

    </p>

    <p>
        记住我 两周内登陆保持 下次自动登陆
        购物车的资料  网站里面的购物车  用户要购买的商品  每一用户 每一个浏览器浏览的商品
        localStorage SessionStoage  这个是客户端数据保持
        浏览器端数据的记录 用户没有登陆获取用户浏览商品的数据 
        电商网站 用户浏览的商品的数据
        字符串就可以序列化 各种数据 变成一个对象 数组 对象里面的子对象。






    </p>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
