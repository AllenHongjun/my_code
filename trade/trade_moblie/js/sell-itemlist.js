/**
 * Created by 65297 on 2018/7/9.
 */
$(function() {
	mui.plusReady(function() {

		/*
		 * 1. 下架商品的功能
		 * 2. 重新上架商品
		 * 3. 商品不同状态 显示不同的按钮
		 * 4. 根据不同的参数显示不同的状态的商品列表
		 * 5. 列表页面请求发送的太多 将数据放到window.data里面缓存起来
		 * 6.
		 * */
		
		//产品发布成功之后 点击后退直接返回首页
		var oldBack = mui.back;
		mui.back = function(){
			var self = plus.webview.currentWebview();
			var isBack = self.isBack;
			console.log(isBack);
			if(isBack){
				
				Trade.CloseAll();
				Trade.GoToIndex()
			}else{
				oldBack();
			}
			self.close();
		}
		
		var state = Trade.getUrlParam('state') || 0;

		
		window.params = {
			'state': parseInt(state),
			'pageindex': 1,
			'pagesize': 6
		}

		var uid = Trade.getUid();
		//分页下拉刷新上拉加载组件
		mui.init({
			pullRefresh: {
				container: "#refreshContainer", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
				down: {
					style: 'circle', //必选，下拉刷新样式，目前支持原生5+ ‘circle’ 样式
					callback: function() {
						var that = this;
						window.params.pageindex = 1;

						getSellListData(window.params, function(data) {
							//console.log($('#item'+window.params.state))
							//console.log(data);//mui选项卡 切换的方法

							$('#item' + window.params.state).html(template('sell_list', data))
							mui('#refreshContainer').pullRefresh().endPulldownToRefresh();
							mui('#refreshContainer').pullRefresh().refresh(true);
						})
					}
				},
				up: {
					auto:true,//可选,默认false.自动上拉加载一次
					contentrefresh: "正在加载...",
					contentnomore: '没有更多数据了',
					callback: function() {
						var that = this;
						window.params.pageindex++;
						getSellListData(window.params, function(data) {
							setTimeout(function() {
								if(!data.result.list || data.result.list.length < 6) {
									mui('#refreshContainer').pullRefresh().endPullupToRefresh(true); //参数为true代表没有更多数据了。
								} else {
									mui('#refreshContainer').pullRefresh().endPullupToRefresh();
								}
								$('#item' + window.params.state).append(template('sell_list', data));
							}, 700)
						})
					}
				}
			}
		});

		//点击TAP切换
		$('.tab-select a').on('tap', function() {
			var dataType = $(this).attr('data-type');
			window.params.state = parseInt(dataType);
			window.params.pageindex = 1;
			/*刷新*/
			mui('#refreshContainer').pullRefresh().pulldownLoading();
		})

		//根据参数加载指定的tap标签页面
		$("[href='#item" + state + "']").trigger('touchstart');
		$("[href='#item" + state + "']").trigger('tap');

		// 上架列表 上架 下架 删除等操作
		$('body').on('tap', '.btnSaleOff', function(e) {
			// 商品下架
			var sell_item_id = $(this).parent().parent().attr('id');
			var hyid = $(this).parent().attr('data-hyid');
			console.log(hyid);

			var paramsSellOut = {
				'hyid': hyid,
				'uid': uid
			}
			var that = this;
			getProductDownData(paramsSellOut, function(data) {
				if(data.resultcode == 200) {
					$('#' + sell_item_id + ' li span.sell-state').html('下架');
					$(that).css('display', 'none');
					$(that).next().css('display', 'block').html('重新上架');
				}
				mui.toast(data.errordes);
			})

		}).on('tap', '.btnSaleAdd', function(e) {
			//检查商品码

			//商品重新上架
			var price = $(this).parent().attr('data-price');
			var hyid = $(this).parent().attr('data-hyid');
			var paramsSaleAdd = {
				'price': price,
				'code': hyid
			}
			var that = this;
			var sell_item_id = $(this).parent().parent().attr('id');
			getAddItemData(paramsSaleAdd, function(data) {
				if(data.resultcode == 200) {
					$('#' + sell_item_id + ' li span.sell-state').html('上架');
					$(that).css('display', 'none');
					$(that).prev().css('display', 'block').html('下架');

				} else {
					mui.toast(data.errordes);
				}
			})

		})
	})
})