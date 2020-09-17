/**
 * Created by 65297 on 2018/7/3.
 */
$(function(){

    window.hyid = Trade.getUrlParam('hyid');
    var chainid = Trade.getUrlParam('chainid');
    $('[name="main-id"]').val(chainid);
    if(!hyid){
        window.location.href="searchList.html";
    }



    var uid = Trade.getUid()
    var params={
        "hyid": hyid
    };
	
	
    
    //获取商品详情的信息
    getProductDetailData(params,function(data){
        console.log(data);
        if(data.result.state != 1){
            window.location.href = 'order_list.html';
            return false;
        }
        $('.mui-table-view .mui-media').html(template('orderDetail',data));

        //1.合计金额显示
        var productNum = parseInt(data.result.stock);
        var price = parseFloat(data.result.price);
        $('.payment strong').html('￥'+price);

        //2.购买数量不能大于现有商品数量 给出提示 按钮不能点击
        $('.mui-numbox').on('tap','.mui-numbox .mui-btn',function(){
            var num = parseInt(mui('.mui-numbox').numbox().getValue());
            $('.payment strong').html('￥'+num*price);
            if(num >=productNum){
                mui.toast('库存不足');
                mui('.mui-numbox').numbox().setOption('max',productNum);
            }
        })

        //2.获取用户信息



    })

    //3.根据不同的支付方式拉起支付  绑定事件 取消绑定事件
    $('body').on('tap','.payment button',function(){
		
		var mainID = $.trim($('[name=main-id]').val());
		console.log(mainID)
		// if(!mainID){
		// 	mui.toast('请输入主链接ID');
		// 	return false;
		// }


		var paramsOrder={
	        "uid": uid,
	        "hyid": hyid,
	        "toaccount": mainID
	    }
		
		
        $('.mui-table-view-radio li').forEach(function(item,i){
            if($(item).hasClass('mui-selected')){
                var paytype = $(item).find('[data-paytype]').attr('data-paytype');
                switch (paytype){
                    case 'wxpay':
                        mui.alert( '拉起微信支付','支付提示', function() {
                            getAddOrderData($.extend(paramsOrder,{"bank": 2}),function(data){
                                if(data.resultcode == 200){
                                    var orderid = data.result.orderid;
                                    console.log('此处调用支付接口');
                                    var paramsWxpay ={
                                        'orderid':orderid,
                                        'uid':uid,
                                    }
                                    getWxPayData(paramsWxpay,function (data) {
                                        console.log(data);
                                    })

                                }else{
                                    mui.toast(data.errordes);
                                }

                            })

                        });
                        break;
                    case 'alipay':
                        mui.alert( '拉起支付宝支付','支付提示', function() {
                            getAddOrderData($.extend(paramsOrder,{"bank": 1}),function(data){
                                if(data.resultcode == 200){
                                    var orderid = data.result.orderid;
                                    console.log('此处调用支付接口');


                                }else{
                                    mui.toast(data.errordes);
                                }

                            })
                        });
                        break;
                    case 'yinpay':
                        mui.alert( '拉起网银支付','支付提示', function() {
                            //info.innerText = '你刚关闭了警告框';
                        });
                        break;
                    case 'localpay':
                        var btnArray = ['确认', '取消'];
                        mui.confirm( '即将使用零钱支付','支付提示',btnArray, function(e) {
                            if (e.index == 0) {
                                getAddOrderData($.extend(paramsOrder,{"bank": 3}),function(data){

                                    if(data.resultcode == 200){
                                        var orderid = data.result.orderid;
                                        var paramsWxpay ={
                                            'orderid':orderid,
                                            'uid':uid,
                                        }
                                        getLocalPay(paramsWxpay,function (data) {
                                            if(data.resultcode == 200){
                                                mui.openWindow({
                                                    url:'order_result.html?orderid='+orderid,
                                                    id:'order_result'
                                                })
                                            }else{
                                                mui.alert(data.errordes,function () {

                                                    window.location.href = Trade.ORDER_LIST_URL;
                                                });
                                            }
                                        })
                                    }else{
                                        mui.alert(data.errordes,function () {
                                            console.log('订单添加失败')
                                            //window.location.href = Trade.ORDER_LIST_URL;
                                        });
                                    }

                                })
                            } else {
                                console.log('您取消了')
                            }

                        });
                        break;
                    default :
                        console.log('error paytype');
                        break;
                }

            }

        })
    })

    //4.提示框样式修改 css 文件不要去改




})




//获取商品详情
var getProductDetailData =function(params,callback){
    Trade.ajax({
        url:'product/productdetail',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            callback&&callback(data);
        }

    })
}


//生成订单接口
var getAddOrderData = function(params,callback){
    Trade.ajaxNeedLogin({
        url:'order/addorder',
        type:'POST',
        data:params,
        dataType:'json',
        beforeSend:function(){

        },
        success:function(data){
            callback&&callback(data);
        }
    })
}




//拉起微信支付接口
var getWxPayData = function (params,callback) {
    Trade.ajaxNeedLogin({
        url:'Pay/WxH5Pay',
        type:'POST',
        data:params,
        dataType:'json',
        success:function (data) {
            callback&&callback(data);
        }
    })
}


//拉起零钱支付
var getLocalPay = function (params,callback) {
    Trade.ajaxNeedLogin({
        url:'pay/BalancePay',
        type:'POST',
        data:params,
        dataType:'json',
        success:function (data) {
            callback&&callback(data);
        }
    })
}























