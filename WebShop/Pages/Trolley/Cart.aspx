<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="WebShop.Pages.Trolley.Cart" %>

<%@ Import Namespace="BookShop.Model" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="author" />
    <title>我的购物车-XX商城</title>
    <link href="../../assets/css/normalize.css" rel="stylesheet" />
    <link href="../../Content/bootstrap.min.css" rel="stylesheet" />
    <link href="../../Content/sweetalert/sweet-alert.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="/assets/css/style.css">
</head>
<body>
    <!-- start header -->
    <!--end header -->

    <!-- start banner_x -->

    <%--页面跳转过过来的时候 商品加入购物车  
        购物的流程 以及是非常的普遍了。。看看别人是怎么做的
        模仿的做一做。。

        商城系统 后台系统数据库 这个方便的业务 做精通。。
        做好来。

        --%>

    <div class="banner_x center">
        <a href="/index.aspx">
            <div class="logo fl"></div>
        </a>

        <div class="wdgwc fl ml40">我的购物车</div>
        <div class="wxts fl ml20">温馨提示：产品是否购买成功，以最终下单为准哦，请尽快结算</div>
        <div class="dlzc fr">
            <ul>
                 <li>欢迎你,<%=user.LoginId %></li>
                
            </ul>

        </div>
        <div class="clear"></div>
    </div>
    <div class="xiantiao"></div>
    <div class="gwcxqbj">
        <div class="gwcxd center">
            <div class="top2 center">
                <div class="sub_top fl">
                    <input type="checkbox" value="quanxuan" class="quanxuanAll" checked="true" />全选
                </div>
                <div class="sub_top fl">商品名称</div>
                <div class="sub_top fl">单价</div>
                <div class="sub_top fl">数量</div>
                <div class="sub_top fl">小计</div>
                <div class="sub_top fr">操作</div>
                <div class="clear"></div>
            </div>

            <%--获取购物车列表 遍历其中的数据--%>

            <%--购物车商品 数量加1 减1  总价格变化--%> 

            <%--移除 批量移除购物车中商品--%>


            <%foreach (var cartItem in CartList)
                {
                    %>

             
            <div class="content2 center">
                <div class="sub_content fl ">
                    <input type="checkbox" value="quanxuan" class="quanxuan" checked />
                </div>
                <div class="sub_content fl">
                    <img width="30px;" src="/assets/image/BookCovers/<%=cartItem.Book.ISBN %>.jpg"></div>
                <div class="sub_content fl " style="overflow:hidden;"><%=cartItem.Book.Title %></div>
                <div class="sub_content fl " style="width:53px;"><i class="unit_price"><%=cartItem.Book.UnitPrice.ToString("0.00") %></i>元</div>
                <div class="sub_content fl">
                    <input id="txtCount<%=cartItem.Book.Id %>" onchange='changeCount(<%=cartItem.Id %>,<%=cartItem.Book.Id %>)' class="shuliang" type="number" value='<%=cartItem.Count %>' step="1" min="1">
                </div>
                <div class="sub_content fl" style="width:80px;"><%=(cartItem.Count * cartItem.Book.UnitPrice).ToString("0.00") %>元</div>
                <div class="sub_content fl"><a onclick='removeBookInCart(<%=cartItem.Id %>,this);'>×</a></div>
                <div class="clear"></div>
            </div>
             <%  } %>

            

            <%--结算跳转点单结算页面--%>

            <%--页面的链接  基本的布局
                这两天的目标就是做 这个商城的网站。。


                
                --%> 

        </div>
        <div class="jiesuandan mt20 center">
            <div class="tishi fl ml20">
                <ul>
                    <li><a href="/Shop/ShopList.aspx">继续购物</a></li>
                    <li>|</li>
                    <li>共<span>2</span>件商品，已选择<span>1</span>件</li>
                    <div class="clear"></div>
                </ul>
            </div>
            <div class="jiesuan fr">
                <div class="jiesuanjiage fl">合计（不含运费）：<span id="totalMoney"></span></div>
                <div class="jsanniu fr">
                    <input id="btnJieSuan" class="jsan" type="submit" name="jiesuan" value="去结算" /></div>
                <div class="clear"></div>
            </div>
            <div class="clear"></div>
        </div>

    </div>

    <!-- footer -->
    <footer class="center">

        <div class="mt20">XX商城|多看书城|XX路由器|视频电话|XX天猫店|XX淘宝直营店|XX网盟|XX移动|隐私政策|Select Region</div>
        <div> 京ICP证11xxxx号  京网文[2014]0059-xxxx号</div>
        <div>违法和不良信息举报电话：185-0130-xxxx，本网站所列数据，除特殊说明，所有数据均出自我司实验室测试</div>
    </footer>


    <script src="../../Scripts/jquery-3.0.0.min.js"></script>
    <script src="../../Scripts/bootstrap.min.js"></script>
    <script src="../../Scripts/sweetAlert.js"></script>
    <script>

        $(function () {
            getTotalMoney() 

            //有些可能是版本的问题。。
            $(".quanxuanAll").click(function () {
                var isChecked = $(".quanxuanAll").get(0).checked;
                if (isChecked) {
                    $(".quanxuan").attr("checked", true);
                } else {
                    $(".quanxuan").attr("checked", false);
                }
            })
            
        });

        //点击加号减号修改购物车中商品的数量
        function changeCount(cartId,bookId) {
            //不是说很精通 但是一个功能 一个流程 自己都要理解 遇到那个点都是要能写出来
            var count = $("#txtCount" + bookId).val();
            $.post("/ashx/EditCart.ashx", { "action": "edit", "count": count, "cartId": cartId },
                function (data) {
                    if (data == "ok") {
                        $("#txtCount" + bookId).val(count);
                        getTotalMoney();
                    } else {
                        swal("数量更新失败");
                    }
            })
        }

        //手动更新文本框中商品的数量
        function changeTextOnBlur(cartId, control) {
            var count = $(countrol).val();
            var reg = /^\d+$/;
            if (reg.test(count)) {
                //更新商品的数量
                //调用getTotalmoney()重新计算价格
                $.post("/ashx/EditCart.ashx", { "action": "edit", "count": count, "cartId": cartId },
                    function (data) {
                        if (data == "ok") {
                            $("#txtCount" + bookId).val(count);
                            getTotalMoney();
                        } else {
                            swal("数量更新失败");
                        }
                    })
            } else {
                swal("商品的数量只能是数字");
                $(control).val($("#pCount").val());
            }

        }


        //计算总金额
        function getTotalMoney() {
            var totalMoney = 0;
            $(".content2").each(function () {
                var price = $(this).find(".unit_price").text();
                var count = $(this).find(".shuliang").val();
                totalMoney += parseFloat(price) * parseInt(count);
            })
            //显示总金额并且保留两位小数
            $("#totalMoney").text(fmoney(totalMoney, 2)+"元");
        }


        //前端浙中 开发好的组件 调用一下 确实 效果要好不少

        function removeBookInCart(cartId,control) {
            swal({
                  title: "确定吗?",
                  text: "购物车中的商品将要被删除",
                  type: "warning",
                  showCancelButton: true,
                  confirmButtonClass: "btn-danger",
                  confirmButtonText: "确定!",
                  cancelButtonText:"取消"
                  //closeOnConfirm: false
            },
                function () {
                   
                    $.post("/ashx/EditCart.ashx", { "action": "delete", "cartId": cartId }, function (data) {
                        var res = data.split(":");
                        if (res[0] == "ok") {
                            //swal("提示!", "删除成功", "success");
                            $(control).parent().parent().remove();
                            getTotalMoney();
                        }
                    })
                 
            });
        }

       

        //弹出对话框
        $("#btnJieSuan").click(function () {
                swal("跳转结算页面")
        });


        function fmoney(s, n) {
            n = n > 0 && n <= 20 ? n : 2;
            s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + "";//更改这里n数也可确定要保留的小数位  
            var l = s.split(".")[0].split("").reverse(),
                r = s.split(".")[1];
            t = "";
            for (i = 0; i < l.length; i++) {
                t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : "");
            }
            return t.split("").reverse().join("") + "." + r.substring(0, 2);//保留2位小数  如果要改动 把substring 最后一位数改动就可  
        }
    </script>

</body>
</html>
