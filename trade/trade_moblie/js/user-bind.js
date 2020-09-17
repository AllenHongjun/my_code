/**
 * Created by 65297 on 2018/7/12.
 */
$(function() {

	mui.plusReady(function() {

		//设置固定固定像素高度
		$('.binding').height($('body')[0].clientHeight);

		var params = {
			"num": 0
		};
		//显示可以绑定的游戏列表
		mui.init();
		var userPicker = new mui.PopPicker();
		getGameListData(params, function(data) {
			//console.log(JSON.stringify(data))
			var gameList = data.result.list;
			//数据处理遍历
			var dataArray = [];
			gameList.forEach(function(item, i) {
				dataArray.push({
					'gameid': item.id,
					'text': item.name
				});
			});

			userPicker.setData(dataArray);
			var showUserPickerButton = document.getElementById('showUserPicker');
			var userResult = document.getElementById('showUserPicker');
			showUserPickerButton.addEventListener('tap', function(event) {
				userPicker.show(function(items) {
					console.log(items)
					userResult.innerText = items[0].text;
					$(userResult).attr('data-id', items[0].gameid);

				});
			}, false);
		})
		
//		绑定用户
		$('#btnBind').on('tap', function() {
			var account = $.trim($('[name=account]').val());
			var pwd = $.trim($('[name=pwd]').val());
			var gameid = $('#showUserPicker').attr('data-id');

			if(!account) {

				mui.toast("请输入主链ID",'提示');
				return false;
			}
			if(!pwd) {
				mui.toast("请输入密码");
				return false;
			}

			if(gameid == undefined || gameid < 0) {
				mui.toast("选择你要绑定的游戏");
				return false;
			}
			pwd = hex_md5(pwd);
			var paramsBind = {
				"uid": Trade.getUid(),
				"account": account,
				"pwd": pwd,
				"gid": gameid
			};

			getUserInfoData(paramsBind, function(data) {
				console.log(JSON.stringify(data));
				if(data.resultcode == 200) {
					var btnArray = ['确认', '取消'];
					mui.confirm('用户昵称：' + data.result.nickname, '信息确认', btnArray, function(e) {
						if(e.index == 0) {

							getBindData(paramsBind, function(data) {
								if(data.resultcode == 200) {
									//绑定过的账号提示 账号不存在
									mui.alert(data.errordes, '提示', function() {
										mui.openWindow({
											url: 'user-center.html',
											id: 'user-center'
										})
									});
								} else {
									mui.alert(data.errordes, '提示');
								}
							})
						} else {
							console.log('取消了绑定');
						}
					})

				} else {
					mui.alert(data.errordes, '提示', function() {

					});
				}
			})

			return false;

		})
	})
})

//获取可以绑定的游戏列表数据
var getGameListData = function(params, callback) {
	Trade.ajax({
		url: 'game/gamelist',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend: function() {

		},
		success: function(data) {
			callback && callback(data);
		},
		error: function(data) {

		}

	})
}

//绑定之前检查一下用户信息
var getUserInfoData = function(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'account/checkusergame',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend: function() {
			$('#btnBind').html('加载中...').attr('disabled', true);

		},
		success: function(data) {
			callback && callback(data);
			$('#btnBind').html('去绑定').removeAttr('disabled');
		},
		error: function(data) {
			$('#btnBind').html('去绑定').removeAttr('disabled');
		}
	})
}

//获取绑定用户返回数据
var getBindData = function(params, callback) {
	Trade.ajaxNeedLogin({
		url: 'account/bindgame',
		type: 'POST',
		data: params,
		dataType: 'json',
		beforeSend: function() {

		},
		success: function(data) {
			callback && callback(data);
		},
		error: function(data) {

		}
	})
}