mui.plusReady(function() {
	//设置固定固定像素高度  固定安卓手机
	var bodyHeight = document.querySelector('body').clientHeight;
	var bindDom = document.querySelector('.binding');
	bindDom.style.height = bodyHeight + 'px';

	var loginBtn = document.getElementById('login');
	loginBtn.addEventListener('tap', function(e) {
		var account = document.querySelector('[name=account]').value;
		var pwd = document.querySelector('[name = pwd]').value;

		if(!account) {
			mui.toast('请输入账号');
			return false;
		}
		if(!pwd) {
			mui.toast('请输入密码');
			return false;
		}
		pwd = hex_md5(pwd);
		var params = {
			'account': account,
			'pwd': pwd
		}
		getUserLoginData(params, function(data) {
			if(data.resultcode == 200) {
				/*保存用户登陆的信息*/
				localStorage.setItem("trade_userinfo", JSON.stringify(data.result));

				var h = plus.webview.getLaunchWebview();
				mui.fire(h, 'refresh');
				if(plus.webview.getWebviewById('pages/user-center.html')) {
					mui.fire(h, 'refreshSub');
				}
				//
				mui.openWindow({
					//真机调试 是 hbuild 打包出来的是 appid
					id: plus.runtime.appid,
					extras: {
						isLogin: 'true'
					}
				})

			} else {
				mui.toast(data.errordes);
			}
		})

		console.log(account);
	})

	//从退出页面进入是 重写mui.back方法，返回的时候回到默认首页
	var self = plus.webview.currentWebview();
	var type = self.type;
	var old_back = mui.back;
	mui.back = function() {

		if(self.type == 'logout') {
			console.log(1)
			//首页刷新之后 ，返回首页 
			var h = plus.webview.getWebviewById(plus.runtime.appid);
			mui.fire(h, 'refresh');
			mui.openWindow({
				id: plus.runtime.appid
			})
		} else {
			old_back();
		}
	}

	//	绑定注册账号和忘记密码
	mui('.link-area').on('tap', 'a', function() {
		var link = this.getAttribute('href');
		mui.openWindow({
			id: link,
			url: link
		})
	})

})

//调用登陆接口获取返回数据
function getUserLoginData(params, callback) {
	Trade.ajax({
		url: 'account/userlogin',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend: function() {
			mui('#buyBtn').button('loading');
		},
		success: function(data) {
			mui('#login').button('reset');
			callback && callback(data);
		}
	})
}