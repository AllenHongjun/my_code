/**
 * Created by 65297 on 2018/7/12.
 */
//退出功能
mui.plusReady(function() {

	mui.init();
	mui('.mui-scroll-wrapper').scroll({
		deceleration: 0.0005 //flick 减速系数，系数越大，滚动速度越慢，滚动距离越小，默认值0.0006
	});

	

//	获取个人信息的数据
	var userinfo = getLoginParams();
	var uid = plus.webview.currentWebview().userid;
	var gameinfo = getGameData();
	//console.log(JSON.stringify(userinfo))
	if(uid == null || uid == undefined || JSON.stringify(userinfo) == '{}') {
		mui.openWindow({
			url: Trade.LOGIN_URL,
			id: 'user-login'
		})
	} else if(JSON.stringify(gameinfo) == '[]') {
		mui.openWindow({
			url: Trade.GAME_LIST_URL,
			id: 'game-list'
		})
	} else {

		var params = {
			'uid': userinfo.uid,
			'skey': userinfo.skey
		}
		getUserInfoData(params, function(data) {
			if(data.resultcode == 200) {

				var user = data.result;
				document.querySelector('.wallet').innerHTML = '￥' + user.balance;
				document.querySelector('.info').innerHTML = template('userinfo', user);
				document.querySelector('.main .list h4').innerHTML = gameinfo[1].gamename;

			} else {
				mui.toast(data.errordes);
			}
		})

	}
	
//	给所有的a链接绑定点击事件
	mui('body').on('tap', '.mui-content a', function(e) {
		//禁止a链接默认跳转
		e.preventDefault();
		
		//如果是退出按钮单独处理
		if(e.target.id == 'loginOut') {
			localStorage.removeItem('trade_userinfo');
			//localStorage.removeItem('TradeGameData')
			
			
			mui.openWindow({
				url: Trade.USER_LOGIN_URL,
				id: Trade.USER_LOGIN_URL,
				extras : {
					type:'logout'
				}
			})
		} else {
			var link = this.getAttribute('href');
			mui.openWindow({
				url: link,
				id: link
			})
		}

	})

})
// 获取用户信息
function getUserInfoData(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'account/getuser',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}