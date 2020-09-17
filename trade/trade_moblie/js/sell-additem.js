/**
 * Created by 65297 on 2018/7/9.
 */
$(function() {

	mui.plusReady(function() {

		//1. 根据商品code获取道具信息
		//2. 提交商品发布信息
		//3. 发布之后跳转发布列表也 提示发布成功或者失败
		//4.保证数据获取成功之后再展示页面
		//5.获取数据显示加载动画
		//var code = Trade.getUrlParam('code');
		var self = plus.webview.currentWebview();
		var code = self.code ;
		var uid = Trade.getUid();
		//console.log(code);
		
		if(!code || !uid) {
			mui.openWindow({
				url: Trade.INDEX_URL,
				id: Trade.INDEX_URL
			})
			return;
		}
		var params = {
			"code": code,
			"uid": uid
		}

		getItemData(params, function(data) {
			//console.log(JSON.stringify(data));
			if(data.resultcode == 200) {
				$('.sell').html(template('addItem', data));
			} else {
//				mui.openWindow({
//					url: Trade.INDEX_URL,
//					id: Trade.INDEX_URL
//				})
				mui.toast(data.errordes);
			}

		})

		$('.mui-btn-danger').on('tap', function() {

			var price = $('[name="price"]').val();
			//console.log(price)
			if(!price) {
				mui.toast('请输入价格！');
				return false;
			}
			if(isNaN(price)) {
				mui.toast('请输入合法的价格');
				return false;
			}
			var paramsAdd = {
				'price': price,
				'code': code
			}

			getAddItemData(paramsAdd, function(data) {
				//console.log(JSON.stringify(data));
				$('#sellBtn').removeAttr('disabled').html('确定发布')
				if(data.resultcode == 200) {
					mui.alert(data.errordes, '提示', function() {
						
						mui.openWindow({
							url:Trade.SELL_ITEMLIST_URL,
							id:Trade.SELL_ITEMLIST_URL,
							extras:{
								isBack:true
							}
						})
						//self.close();
					});
				} else {
					mui.alert(data.errordes, '提示');
				}
			})
		})

	})
})