$(function() {

	mui.plusReady(function() {
		var self = plus.webview.currentWebview();
		
		//关闭其他不用的wevview 循环  !当前的判断
		//		var productListWebView = plus.webview.getWebviewById(Trade.PRODUCT_LIST_URL);
		//		var productDetailWebView = plus.webview.getWebviewById(Trade.PRODUCT_DETAIL_URL);
		//		var productOrderWebView = plus.webview.getWebviewById(Trade.ORDER_URL);
		//		productListWebView.close();
		//		productDetailWebView.close();
		//		productOrderWebView.close();
		
		var oid = self.orderid || Trade.getUrlParam('orderid');
		var uid = Trade.getUid();
		var params = {
			'oid': oid,
			'uid': uid
		}
		
		
		
		console.log(JSON.stringify(params))
		getOrderDetailData(params, function(data) {
			console.log(JSON.stringify(data));
			if(data.resultcode == 200) {
				$('.order-success').html(template('success_result', data));
			} else {
				$('.order-fail').html(template('fail_result', data));
				$('.order-success').hide();
				$('.order-fail').show();
			}
		})
		
		
		
		//点击返回直接回到首页
		Trade.BackToIndex();
		
		mui('body').on('tap','a',function(){
			var href = this.getAttribute('href');
			Trade.CloseAll();
			Trade.GoToIndex();
			return false;
		})
	})
	
	
})

//查询订单详细信息
function getOrderDetailData(params, callback) {
	Trade.ajaxNeedLogin({
		url: "Order/Orderdetail",
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data)
		}
	})
}