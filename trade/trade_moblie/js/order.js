/**
 * Created by 65297 on 2018/7/3.
 */


$(function() {

	mui.plusReady(function() {
		var self = plus.webview.currentWebview();
		var hyid = self.hyid || 0;
		if(!hyid) {
			mui.openWindow({
				'url': Trade.PRODUCT_LIST_URL,
				'id': Trade.PRODUCT_LIST_URL
			})
		}
		
		var chainid = self.chainid;
		
		$('[name="chain-id"]').val(chainid);
		var uid = Trade.getUid()
		var params = {
			"hyid": hyid
		};

		
		//获取商品详情的信息
		getProductDetailData(params, function(data) {
			//console.log(JSON.stringify(data));
			$('.mui-table-view .mui-media').html(template('orderDetail', data));
			
			
			//1.合计金额显示
			var productNum = parseInt(data.result.stock);
			var price = parseFloat(data.result.price);
			$('.payment strong').html('￥' + price);
			$('#product-num').html(productNum +'个');

			//2.购买数量不能大于现有商品数量 给出提示 按钮不能点击
			$('.mui-numbox').on('tap', '.mui-numbox .mui-btn', function() {
				var num = parseInt(mui('.mui-numbox').numbox().getValue());
				$('.payment strong').html('￥' + num * price);
				if(num >= productNum) {
					mui.toast('库存不足');
					mui('.mui-numbox').numbox().setOption('max', productNum);
				}
			})

			//2.获取用户信息

		})

		//3.根据不同的支付方式拉起支付  绑定事件 取消绑定事件
		$('body').on('tap', '.payment button', function() {
			
			

			//console.log(chainid);
			var paramsOrder = {
					"uid": uid,
					"hyid": hyid,
					"toaccount": chainid
				}
			if(!chainid){
				mui.toast('请输入主链ID');
				return false;
			}
			$('.mui-table-view-radio li').forEach(function(item, i) {
				if($(item).hasClass('mui-selected')) {
					var paytype = $(item).find('[data-paytype]').attr('data-paytype');
					switch(paytype) {
						case 'wxpay':
							mui.alert('拉起微信支付', '支付提示', function() {
								getAddOrderData($.extend(paramsOrder, {
									"bank": 2
								}), function(data) {
									mui('#login').button('reset');
									if(data.resultcode == 200) {
										var orderid = data.result.orderid;
										console.log('此处调用支付接口');
										var paramsWxpay = {
											'orderid': orderid,
											'uid': uid,
										}
										getWxPayData(paramsWxpay, function(data) {
											console.log(data);
										})

									} else {
										mui.toast(data.errordes);
									}

								})

							});
							break;
						case 'alipay':
							mui.alert('拉起支付宝支付', '支付提示', function() {
								getAddOrderData($.extend(paramsOrder, {
									"bank": 1
								}), function(data) {
									if(data.resultcode == 200) {
										var orderid = data.result.orderid;
										console.log('此处调用支付接口');

									} else {
										mui.toast(data.errordes);
									}

								})
							});
							break;
						case 'yinpay':
							mui.alert('拉起网银支付', '支付提示', function() {
								//info.innerText = '你刚关闭了警告框';
							});
							break;
						case 'localpay':
							mui.alert('拉起零钱支付', '支付提示', function() {
								getAddOrderData($.extend(paramsOrder, {
									"bank": 3
								}), function(data) {
									console.log(JSON.stringify(data));
									
									if(data.resultcode == 200) {
										var orderid = data.result.orderid;
										var paramsWxpay = {
											'orderid': orderid,
											'uid': uid,
										}
										getLocalPay(paramsWxpay, function(data) {
											
											console.log(JSON.stringify(data));
											mui('#buyBtn').button('reset');
											if(data.resultcode == 200) {
												console.log(orderid);
												mui.openWindow({
													url: 'order-result.html',
													id: 'order-result',
													extras:{
														orderid:orderid
													}
												})
											} else {
												mui.alert(data.errordes,'提示',function(){
													Trade.CloseAll();
													Trade.GoToIndex();
												});
											}
										})

									} else {
										mui.alert(data.errordes,'提示',function(){
											Trade.CloseAll();
											Trade.GoToIndex();
										});
									}

								})
							});
							break;
						default:
							console.log('error paytype');
							break;
					}

				}

			})
		})

	})

	//4.提示框样式修改 css 文件不要去改

})

//获取商品详情
function getProductDetailData(params, callback) {
	Trade.ajax({
		url: 'product/productdetail',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}

	})
}

//生成订单接口
function getAddOrderData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'order/addorder',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}

//拉起微信支付接口
function getWxPayData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'Pay/WxH5Pay',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}

//零钱支付
function getLocalPay(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'pay/BalancePay',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend:function(){
			mui('#buyBtn').button('loading');
		},
		success: function(data) {
			callback && callback(data);
		}
	})
}