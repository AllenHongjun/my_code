<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="SelfInfo.aspx.cs" Inherits="WebShop.Pages.Account.SelfInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <!-- start banner_x -->
   
    <!-- end banner_x -->
    <!-- self_info -->
    <div class="grzxbj">
        <div class="selfinfo center">
            <div class="lfnav fl">
                <div class="ddzx">订单中心</div>
                <div class="subddzx">
                    <ul>
                        <li><a href="/Pages/Order/Index.aspx">我的订单</a></li>
                        <li><a href="">意外保</a></li>
                        <li><a href="">团购订单</a></li>
                        <li><a href="">评价晒单</a></li>
                    </ul>
                </div>
                <div class="ddzx">个人中心</div>
                <div class="subddzx">
                    <ul>
                        <li><a href="/Pages/Account/SelfInfo.aspx" style="color: #ff6700; font-weight: bold;">我的个人中心</a></li>
                        <li><a href="">消息通知</a></li>
                        <li><a href="">优惠券</a></li>
                        <li><a href="">收货地址</a></li>
                    </ul>
                </div>
            </div>
            <div class="rtcont fr">
                <div class="grzlbt ml40">我的资料</div>
                <div class="subgrzl ml40"><span>昵称</span><span><%=user.LoginId %></span><span><a href="">编辑</a></span></div>
                <div class="subgrzl ml40"><span>手机号</span><span><%=user.Phone %></span><span><a href="">编辑</a></span></div>
                <div class="subgrzl ml40"><span>密码</span><span>************</span><span><a href="">编辑</a></span></div>
                <div class="subgrzl ml40"><span>真实姓名</span><span><%=user.Name %></span><span><a href="">编辑</a></span></div>
                <div class="subgrzl ml40"><span>我的爱好</span><span><%=user.Mail %></span><span><a href="">编辑</a></span></div>
                <div class="subgrzl ml40"><span>收货地址</span><span><%=user.Address %></span><span><a href="">编辑</a></span></div>

            </div>
            <div class="clear"></div>
        </div>
    </div>
    <!-- self_info -->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="foot" runat="server">
</asp:Content>
