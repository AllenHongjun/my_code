/**
 * Created by 65297 on 2018/7/9.
 */
$(function() {

	var code = Trade.getUrlParam('code');
	var uid = Trade.getUid();
	if(!code || !uid) {
		window.location.href = Trade.USER_URL;
		return;
	}
	var params = {
		"code": code,
		"uid": uid
	}
	//验证交易码是否有效
	getItemData(params, function(data) {
		console.log(data)
		if(data.resultcode == 200) {
			$('.sell').html(template('addItem', data));
		} else {
			window.location.href = Trade.GAME_DETAIL_URL;
		}
	})

	//出售验证码
	$('.mui-btn-danger').on('tap', function() {
		console.log(3);
		var price = $('[name="price"]').val();
		console.log(price)
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
			console.log(data);
			if(data.resultcode == 200) {
				mui.alert(data.errordes, '提示', function() {
					window.location.href = 'item_list.html';
				});
			} else {
				mui.alert(data.errordes, '提示');
			}
		})
	})
})