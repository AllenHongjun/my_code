<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ShopList.aspx.cs" Inherits="WebShop.Pages.Shop.ShopList"  EnableViewState="false"%>


<%--禁用viewstate 这个是一个优化点    新版本的微软已经优化了 repeater 不会生成 很多的数据了
    服务器上 数据库 访问起来非常慢 不知道怎么回事。。

    Eval 使用指定的格式 来输出数据。又学到了一点。

    Reapter 控件 复习使用。
    
    --%> 
<%@ Import Namespace="BookShop.Common" %>

<asp:Content ContentPlaceHolderID="Content" runat="server">
    <!-- start danpin -->
		<div class="danpin center">
			
			<div class="biaoti center">编程书籍</div>
			<div class="main center">

                <asp:Repeater ID="BookRepeater" runat="server">
                    <HeaderTemplate>

                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="mingxing fl mb20" style="border:2px solid #fff;width:230px;cursor:pointer;" onmouseout="this.style.border='2px solid #fff'" onmousemove="this.style.border='2px solid red'">
					        
                            <%--点击图片 和点击 标题访问的是不同的页面--%>
                            <div class="sub_mingxing">
                                <a href="<%#GetString(Eval("PublishDate")) %><%#Eval("Id") %>.html" >
                                    <img src="<%#Eval("ISBN","/assets/image/BookCovers/{0}.jpg") %>" alt="">
                                </a>
					        </div>
					        <div class="pinpai"><a href="<%#GetString(Eval("PublishDate")) %><%#Eval("Id") %>.html" ><%#Eval("Title") %></a></div>
					        <div class="youhui"><%#this.CutString(Eval("ContentDescription").ToString(),12)%></div>
                            <%--<div class="youhui"><%#this.GetString(Eval("PublishDate").ToString(),150)%></div>--%>
					        <div class="jiage"><%#Eval("UnitPrice","{0:0.00}") %>元</div>
				        </div>

                    </ItemTemplate>
                    <FooterTemplate>
                        
                       <%-- <%=PageBarHelper.GetPagaBar(PageIndex,PageCount)%>--%>
                          <div class="pager" id="j-page">
                                <%=PageBarHelper.GetPagaBar(PageIndex,PageCount)%>
                            </div>
                            

                        

                    </FooterTemplate>

                </asp:Repeater>


				



				<div class="clear"></div>
			</div>

            

			
		</div>
        

        

</asp:Content>