/**
 * Created by 65297 on 2018/7/3.
 */

/*
 * 1. 获取游戏列表
 * 2. 渲染列表数据
 * 3. 选择成功之后跳转 保存选择游戏的id
 * 4. 选中的游戏 添加选中的样式
 * 5. 重新选择游戏链接
 * */
mui.plusReady(function() {

	var li1Ele = document.getElementsByClassName("game");
	var params = {
		"num": 4
	};
	
	getGameList(params, function(data) {
		var gameListDom = document.querySelector(".mui-content .game-list");
		gameListDom.innerHTML = template('gamelist', data)

		//选着游戏添加样式
		change(li1Ele);
	})
	//代理绑定事件 点击按钮跳转
	mui('body').on('tap', 'button', function() {
		var gameID = document.querySelector('.mui-table-view li.checked a').getAttribute('data-id');
		var gameName = Trade.trim(document.querySelector('li.checked div').innerHTML);

		addGameData({
			'gameID': gameID,
			'gameName': gameName
		});
		
		

		var h=plus.webview.getWebviewById( plus.runtime.appid );
		mui.fire(h, 'refresh');
		if(Trade.getUid()){
			mui.fire(h,'refreshSub');
		}
		setTimeout(function(){
			mui.openWindow({					
				id: plus.runtime.appid
			})
			plus.webview.currentWebview().close();
		},300)
		

	})
})
/*获取游戏列表数据*/
function getGameList(params, callback) {
	Trade.ajax({
		url: 'game/gamelist',
		data: params,
		type: 'POST',
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		},
		error: function() {

		}
	})

}

//列表切换样式修改
function hasClass(obj, cls) {
	return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
}

function addClass(obj, cls) {
	if(!this.hasClass(obj, cls)) obj.className += " " + cls;
}

function removeClass(obj, cls) {
	if(hasClass(obj, cls)) {
		var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
		obj.className = obj.className.replace(reg, '');
	}
}

function change(obj) {
	for(var i = 0; i < obj.length; i++) {
		obj[i].onclick = function() {
			for(var i = 0; i < obj.length; i++) {
				removeClass(obj[i], "checked")
			}
			addClass(this, "checked");

		};
	}
};