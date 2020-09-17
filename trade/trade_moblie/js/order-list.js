/**
 * Created by 65297 on 2018/7/5.
 */
$(function() {

	mui.plusReady(function() {

		//跳转到首页链接
		var gameid = parseInt(getGameData()[0].gameid);
		$('#index-link').attr('href', 'game_detail.html?gameid=' + gameid);
		
		
		var uid = plus.webview.currentWebview().userid;

		window.params = {
			"uid": uid,
			"pageindex": 1,
			"pagesize": 8,
			"type": 0 //0全部 1待付款 2待确认收货 3已结束 此处type和订单state字段不同
		}

		//artTemplate访问外部公用函数，金额格式化显示
		template.helper('priceFormat', function(num) {
			return Trade.toMoney(num);
		})

		/*页面初始化加载数据*/
		mui.init({
			pullRefresh: {
				container: "#refreshContainer", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
				down: {
					style: 'circle', //必选，下拉刷新样式，目前支持原生5+ ‘circle’ 样式
					callback: function() {
						window.params.pageindex = 1;
						setTimeout(function() {
							getOrderListData(window.params, function(data) {
								//console.log(JSON.stringify(data));
								if(data.resultcode == 200) {
									$('#item' + window.params.type).html(template('orderListAll', data))
								} else {
									mui.toast(data.errordes);
								}
								mui('#refreshContainer').pullRefresh().endPulldownToRefresh();
								mui('#refreshContainer').pullRefresh().refresh(true);
							})
						}, 500)
					}
				},
				up: {
					auto: true, //可选,默认false.首次加载自动上拉刷新一次
					height: 50, //可选.默认50.触发上拉加载拖动距离
					contentrefresh: "正在加载...", //可选，正在加载状态时，上拉加载控件上显示的标题内容
					contentnomore: '没有更多数据了',
					callback: function() {
						//console.log(JSON.stringify(params));
						window.params.pageindex++;
						var that = this;
						setTimeout(function() {
							getOrderListData(window.params, function(data) {
								if(data.resultcode == 200) {
									$('#item' + window.params.type).append(template('orderListAll', data));
									if(!data.result.list || data.result.list.length < 8) {
										mui('#refreshContainer').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
									} else {
										mui('#refreshContainer').pullRefresh().endPullupToRefresh();
									}
								} else {
									mui.toast(data.errordes);
								}
							})
						}, 700)

					}
				}
			}
		});

		/*选者不同的状态显示不同的数据*/
		$('body').on('tap', '.tab-select a', function(e) {
			//列表切换
			var dataType = $(this).attr('data-type');
			window.params.type = dataType;
			window.params.pageindex = 1;
			/*刷新*/
			mui('.mui-scroll-wrapper').pullRefresh().pulldownLoading();

		}).on('tap', '.btn-cancel', function(e) {
			// 取消订单
			var that = this;
			var hyid = $(this).parent().attr('data-hyid');
			var oid = $(this).parent().attr('data-orderid');
			var paramsCancel = {
				'uid': uid,
				'hyid': hyid,
				'oid': oid
			}

			var btnArray = ['是', '否'];
			mui.confirm('删除当前订单，确认？', '提示', btnArray, function(e) {
				if(e.index == 0) {
					getCancelOrderData(paramsCancel, function(data) {
						if(data.errorcode == 200) {
							$(that).attr('disabled', true).siblings().attr('disabled', true);
						}
						mui.toast(data.errordes);
					})
				}
			})

		}).on('tap', '.btn-confirm', function(e) {
			//确认订单
			var that = this;
			var order_item_id = $(this).parent().parent().attr('id');
			var oid = $(this).parent().attr('data-orderid');
			var paramsComfirm = {
				'oid': oid,
				'uid': uid
			}
			var btnArray = ['是', '否'];
			mui.confirm('确认收货钱将直接打入对方账户，确认？', '提示', btnArray, function(e) {
				if(e.index == 0) {
					getConfirmOrderData(paramsComfirm, function(data) {
						if(data.resultcode == 200) {
							$(that).attr('disabled', true);
							$('#' + order_item_id + ' .mui-table-view-cell .state-str').html('交易成功');
						}
						mui.toast(data.errordes);
					})
				}
			})
		})

	})
})

//分状态获取订单列表数据
function getOrderListData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'order/orderlist',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		},
		error: function() {
			mui('.mui-scroll-wrapper').pullRefresh().endPulldownToRefresh();
		}
	})
}

//取消订单接口
function getCancelOrderData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'order/cancelorder',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}

//已经付款的订单确认收货
function getConfirmOrderData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'order/ConfirmOrder',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}