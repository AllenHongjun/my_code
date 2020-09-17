$(function() {

    //设置固定固定像素高度
    //$('.binding').height($('body')[0].clientHeight);
   // alert($('body')[0].clientHeight);

	/*点击登陆业务处理*/
	$('#login').on('tap', function() {
		var account = $.trim($('[name=account]').val());
		var pwd = $.trim($('[name=pwd]').val());
		if(!account) {
			mui.toast("请输入账号");
			return false;
		}
		if(!pwd) {
			mui.toast("请输入密码");
			return false;
		}
		/*
		* a123456
		* wsxw*/
		pwd = hex_md5(pwd);
		var params = {
			'account': account,
			'pwd': pwd
		}
		getUserLoginData(params, function(data) {
			if(data.resultcode == 200) {
				/*保存用户登陆的信息*/
				localStorage.setItem("trade_userinfo", JSON.stringify(data.result));
				var returnUrl = Trade.GAME_LIST_URL;
				if(location.search && location.search.indexOf('returnUrl') > 0 ) {
					returnUrl = location.search.replace('?returnUrl=', '');
				}
				window.location.href = returnUrl
			} else {
				mui.toast(data.errordes);
			}
		})
	})
})

//调用登陆接口获取返回数据
var getUserLoginData = function(params, callback) {
	Trade.ajax({
		url: 'account/userlogin',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend:function () {
			mui('#login').button('loading');
        },
		success: function(data) {
			mui('#login').button('reset');
			callback && callback(data);
		}
	})
}