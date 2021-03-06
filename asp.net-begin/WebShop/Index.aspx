﻿<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebShop.Index" %>
<asp:Content ContentPlaceHolderID="Content" runat="server">
    <!-- start banner_y -->
    <div class="banner_y center">
        <div class="nav">
            <ul>

                <asp:Repeater ID="CateReapter" runat="server">
                    <ItemTemplate>
                        <li>
                            <a href='/Pages/Shop/ShopList.aspx?cate=<%# Eval("Id") %>'><%#Eval("Name") %></a>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
                <%--<li>
                    <a href="">笔记本</a>
                    <a href="">平板</a>
                    <div class="pop">
                        <div class="left fl">
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/xm6_80.png" alt=""></div>
                                        <span class="fl">大米6</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/5c_80.png" alt=""></div>
                                        <span class="fl">大米手机5c</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/xmNOTE2-80.jpg" alt=""></div>
                                        <span class="fl">大米Note 2</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/MIX-80.jpg" alt=""></div>
                                        <span class="fl">大米MIX</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/MIX-80.jpg" alt=""></div>
                                        <span class="fl">大米5s</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/xm5Splus.jpg" alt=""></div>
                                        <span class="fl">大米5s Plus</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                        </div>
                        <div class="ctn fl">
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/xm5-80.jpg" alt=""></div>
                                        <span class="fl">大米手机5</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/hmn4x80.png" alt=""></div>
                                        <span class="fl">红米Note 4X</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/hmnote4-80.jpg" alt=""></div>
                                        <span class="fl">红米Note-4</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/hm4x_80.png" alt=""></div>
                                        <span class="fl">红米4x</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/hm4-80.jpg" alt=""></div>
                                        <span class="fl">红米4</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                            <div>
                                <div class="xuangou_left fl">
                                    <a href="">
                                        <div class="img fl">
                                            <img src="/assets/image/hm4A-80.jpg" alt=""></div>
                                        <span class="fl">红米4A</span>
                                        <div class="clear"></div>
                                    </a>
                                </div>
                                <div class="xuangou_right fr"><a href="">选购</a></div>
                                <div class="clear"></div>
                            </div>
                        </div>

                        <div class="clear"></div>
                    </div>
                </li>--%>
                
            </ul>
        </div>

    </div>

    <div class="sub_banner center">
        <div class="sidebar fl">
            <div class="fl">
                <a href="">
                    <img src="/assets/image/hjh_05.gif">
                </a>
            </div>
            <div class="fl"><a href="">
                <img src="/assets/image/hjh_05.gif"></a></div>
            <div class="fl"><a href="">
                <img src="/assets/image/hjh_05.gif"></a></div>
            
            <div class="clear"></div>
        </div>
        <div class="datu fl"><a href="">
            <img src="/assets/image/hongmi4x.png" alt=""></a></div>
        <div class="datu fl"><a href="">
            <img src="/assets/image/xiaomi5.jpg" alt=""></a></div>
        <div class="datu fr"><a href="">
            <img src="/assets/image/pinghengche.jpg" alt=""></a></div>
        <div class="clear"></div>


    </div>
    <!-- end banner -->
    <div class="tlinks">Collect from <a href="http://www.cssmoban.com/">企业网站模板</a></div>

    <!-- start danpin -->
    <div class="danpin center">

        <div class="biaoti center">大米明星单品</div>
        <div class="main center">

            <asp:Repeater ID="BookList" runat="server">
                <ItemTemplate>
                    <div class="mingxing fl">
                        <div class="sub_mingxing">
                            <a href="<%#GetString(Eval("PublishDate")) %><%#Eval("Id") %>.html">
                            <img src="/assets/image/BookCovers/<%# Eval("ISBN") %>.jpg" alt="">
                            </a>

                        </div>
                        <div class="pinpai"><a href=""><%#Eval("Title") %></a></div>
                        <div class="youhui"><%#CutString(Eval("AurhorDescription").ToString(),20) %></div>
                        <div class="jiage"><%#Eval("UnitPrice","0.00") %>元起</div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            
            <%--<div class="mingxing fl">
                <div class="sub_mingxing"><a href="">
                    <img src="/assets/image/pinpai2.png" alt=""></a></div>
                <div class="pinpai"><a href="">大米5s</a></div>
                <div class="youhui">5月9日-10日，下单立减200元</div>
                <div class="jiage">1999元</div>
            </div>
            <div class="mingxing fl">
                <div class="sub_mingxing"><a href="">
                    <img src="/assets/image/pinpai3.png" alt=""></a></div>
                <div class="pinpai"><a href="">大米手机5 64GB</a></div>
                <div class="youhui">5月9日-10日，下单立减100元</div>
                <div class="jiage">1799元</div>
            </div>
            <div class="mingxing fl">
                <div class="sub_mingxing"><a href="">
                    <img src="/assets/image/pinpai4.png" alt=""></a></div>
                <div class="pinpai"><a href="">大米电视3s 55英寸</a></div>
                <div class="youhui">5月9日，下单立减200元</div>
                <div class="jiage">3999元</div>
            </div>
            <div class="mingxing fl">
                <div class="sub_mingxing"><a href="">
                    <img src="/assets/image/pinpai5.png" alt=""></a></div>
                <div class="pinpai"><a href="">大米笔记本</a></div>
                <div class="youhui">更轻更薄，像杂志一样随身携带</div>
                <div class="jiage">3599元起</div>
            </div>--%>
            <div class="clear"></div>
        </div>
    </div>
    <div class="peijian w">
        <div class="biaoti center">配件</div>
        <div class="main center">
            <div class="content">
                <div class="remen fl">
                    <a href="">
                        <img src="/assets/image/peijian1.jpg"></a>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span>新品</span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian2.jpg"></a></div>
                    <div class="miaoshu"><a href="">大米6 硅胶保护套</a></div>
                    <div class="jiage">49元</div>
                    <div class="pingjia">372人评价</div>
                    <div class="piao">
                        <a href="">
                            <span>发货速度很快！很配大米6！</span>
                            <span>来至于mi狼牙的评价</span>
                        </a>
                    </div>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: #fff"></span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian3.jpg"></a></div>
                    <div class="miaoshu"><a href="">大米手机4c 大米4c 智能</a></div>
                    <div class="jiage">29元</div>
                    <div class="pingjia">372人评价</div>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: red">享6折</span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian4.jpg"></a></div>
                    <div class="miaoshu"><a href="">红米NOTE 4X 红米note4X</a></div>
                    <div class="jiage">19元</div>
                    <div class="pingjia">372人评价</div>
                    <div class="piao">
                        <a href="">
                            <span>发货速度很快！很配大米6！</span>
                            <span>来至于mi狼牙的评价</span>
                        </a>
                    </div>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: #fff"></span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian5.jpg"></a></div>
                    <div class="miaoshu"><a href="">大米支架式自拍杆</a></div>
                    <div class="jiage">89元</div>
                    <div class="pingjia">372人评价</div>
                    <div class="piao">
                        <a href="">
                            <span>发货速度很快！很配大米6！</span>
                            <span>来至于mi狼牙的评价</span>
                        </a>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
            <div class="content">
                <div class="remen fl">
                    <a href="">
                        <img src="/assets/image/peijian6.png"></a>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: #fff"></span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian7.jpg"></a></div>
                    <div class="miaoshu"><a href="">大米指环支架</a></div>
                    <div class="jiage">19元</div>
                    <div class="pingjia">372人评价</div>
                    <div class="piao">
                        <a href="">
                            <span>发货速度很快！很配大米6！</span>
                            <span>来至于mi狼牙的评价</span>
                        </a>
                    </div>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: #fff"></span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian8.jpg"></a></div>
                    <div class="miaoshu"><a href="">米家随身风扇</a></div>
                    <div class="jiage">19.9元</div>
                    <div class="pingjia">372人评价</div>
                </div>
                <div class="remen fl">
                    <div class="xinpin"><span style="background: #fff"></span></div>
                    <div class="tu"><a href="">
                        <img src="/assets/image/peijian9.jpg"></a></div>
                    <div class="miaoshu"><a href="">红米4X 高透软胶保护套</a></div>
                    <div class="jiage">59元</div>
                    <div class="pingjia">775人评价</div>
                </div>
                <div class="remenlast fr">
                    <div class="hongmi"><a href="">
                        <img src="/assets/image/hongmin4.png" alt=""></a></div>
                    <div class="liulangengduo"><a href="">
                        <img src="/assets/image/liulangengduo.png" alt=""></a></div>
                </div>
                <div class="clear"></div>
            </div>
        </div>
    </div>

</asp:Content>

