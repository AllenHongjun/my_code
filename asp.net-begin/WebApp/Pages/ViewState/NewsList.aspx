<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewsList.aspx.cs" Inherits="WebApp.Pages.ViewState.NewsList" %>

<%@ Import Namespace="Model" %>
<%@ Import Namespace="Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <title>新闻中心--北京华科世佳软件开发有限公司</title>
    <meta name="robots" content="index, follow" />
    <meta name="author" content="北京多维网讯科技有限公司" />
    <meta name="keywords" content="软件开发、房地产业管理类软件、新建商品房网上备案系统、存量房网上备案系统、统计与发布系统、项目管理系统、从业主题管理系统、产权产籍管理系统、测绘成果及管理系统" />
    <meta name="description" content="北京华科世佳软件开发有限公司地处国家计算机应用软件研发腹地——北京市海淀区上地信息产业基地，具有明显的人才优势、技术优势和环境优势。我公司在2004年12月通过了北京市科委的软件企业认证和北京市软件行业协会软件产品的认定。" />
    <link href="WebDemos/style/style.css" type="text/css" rel="stylesheet" />
    <link rel="icon" href="WebDemos/favicon.ico" type="image/x-icon" />
</head>
<body class="body_column">
    <div id="wrap_column">
        <!----------------------------------begin header_column---------------------------------->
        <div id="header_column" class="header_news">
            <!-- #BeginLibraryItem "/Library/header.lbi" -->
            <h1 class="logo_column"><a href="../index.html">
                <img src="WebDemos/images/logo.png" width="179" height="55" alt="北京华科世佳软件开发有限公司" /></a></h1>

            <!-- #EndLibraryItem -->
            <div class="nav_column">
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="754" height="37" id="FlashID" title="北京华科世佳软件开发有限公司">
                    <param name="movie" value="WebDemos/flash/sub_fla.swf" />
                    <param name="quality" value="high" />
                    <param name="wmode" value="transparent" />
                    <param name="swfversion" value="8.0.35.0" />
                    <!-- 此 param 标签提示使用 Flash Player 6.0 r65 和更高版本的用户下载最新版本的 Flash Player。如果您不想让用户看到该提示，请将其删除。 -->
                    <param name="expressinstall" value="WebDemos/Script/expressInstall.swf" />
                    <!-- 下一个对象标签用于非 IE 浏览器。所以使用 IECC 将其从 IE 隐藏。 -->
                    <!--[if !IE]>-->
                    <object type="application/x-shockwave-flash" data="../flash/sub_fla.swf" width="754" height="37">
                        <!--<![endif]-->
                        <param name="quality" value="high" />
                        <param name="wmode" value="transparent" />
                        <param name="swfversion" value="8.0.35.0" />
                        <param name="expressinstall" value="../Script/expressInstall.swf" />
                        <!-- 浏览器将以下替代内容显示给使用 Flash Player 6.0 和更低版本的用户。 -->
                        <div>
                            <h4>此页面上的内容需要较新版本的 Adobe Flash Player。</h4>
                            <p>
                                <a href="http://www.adobe.com/go/getflashplayer">
                                    <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="获取 Adobe Flash Player" width="112" height="33" /></a>
                            </p>
                        </div>
                        <!--[if !IE]>-->
                    </object>
                    <!--<![endif]-->
                </object>
            </div>
        </div>
        <!----------------------------------end header_column---------------------------------->
        <!----------------------------------begin main_column---------------------------------->
        <div id="main_column">
            <div id="sidebar_column">
                <h2 class="title_news">新闻中心</h2>
                <!-- #BeginLibraryItem "/Library/menu_prd.lbi" -->
                <dl class="menu_prd">
                    <dt>软件产品</dt>
                    <dd><a class="graylink" href="../Product/NewHouse.html">新建商品房网上备案系统</a></dd>
                    <dd><a class="graylink" href="../Product/StockHouse.html">存量房网上备案系统</a></dd>
                    <dd><a class="graylink" href="../Product/Statistics.html">统计与发布系统</a></dd>
                    <dd><a class="graylink" href="../Product/ProjectManagement.html">项目管理系统</a></dd>
                    <dd><a class="graylink" href="../Product/Practitioners.html">从业主题管理系统</a></dd>
                    <dd><a class="graylink" href="../Product/Property.html">产权产籍管理系统</a></dd>
                    <dd><a class="graylink" href="../Product/Mapping.html">测绘成果及管理系统</a></dd>
                    <dd><a class="graylink" href="../Product/MaintenanceFunds.html">维修资金管理系统</a></dd>
                    <dd><a class="graylink" href="../Product/HousingSecurity.html">住房保障管理体系</a></dd>
                    <dd><a class="graylink" href="../Product/Transaction.html">房产交易资金监管系统</a></dd>
                </dl>
                <a href="../Contact/Contact.html" class="contct">
                    <img src="../images/img_contact_sidebarcolumn.png" width="160" height="52" alt="联系我们" /></a><!-- #EndLibraryItem -->
            </div>
            <div id="content_column">
                <div class="position"><a class="graylink" href="../index.html">首页</a>&nbsp;&lt;&nbsp;<span class="color0range">新闻中心</span></div>
                <div class="cont">
                    <ul class="list_news">
                        <%  foreach (UserInfo item in user)
                            {%>

                        <li><span><%=item.RegTime.ToShortDateString() %></span><a href="Shownews.html" target="_blank"><%=item.UserName %></a></li>

                        <% } %>
                    </ul>
                    <div class="pages">
                        <a href="NewsList.aspx?page=1"> 首页  | </a>
                        <a href="NewsList.aspx?page=<%=PageIndex-1 < 1 ? 1:PageIndex-1 %>"> 前页  |</a>
                        <%=PageBarHelper.GetPageBar(PageIndex,PageCount) %>
                        <a href="NewsList.aspx?page=<%=PageIndex +1 > PageCount-1 ? PageCount-1: PageIndex+1 %>">后页 | </a>
                        <a href="NewsList.aspx?page=<%=PageCount-1 %>">尾页  </a>
                        页次：   <%=PageIndex %> /   <%=PageCount %>页   

                    </div>
                    <div>
                        
                    </div>
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <!----------------------------------end main_column---------------------------------->
        <!----------------------------------begin footer_column---------------------------------->
        <!-- #BeginLibraryItem "/Library/fooer.lbi" -->
        <div id="footer_column">
            <span class="copyright"></span><span class="frdlink">友情链接：<select name="">
                <option>公司或合作伙伴网站</option>
            </select>
            </span>
        </div>
        <!-- #EndLibraryItem -->
        <!----------------------------------end footer_column---------------------------------->
    </div>
</body>
</html>


