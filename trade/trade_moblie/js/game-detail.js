/**
 * Created by 65297 on 2018/7/3.
 */

mui.init();

mui('.mui-scroll-wrapper').scroll({
	deceleration: 0.003
});

mui.plusReady(function() {
	//页面之间传值得两种方式

	
	
	var data = getGameData();
	var gameID = data[0].gameid;
	if(gameID == null || !gameID || gameID == undefined) {
		mui.openWindow({
			url: 'game-list.html',
			id: 'game-list'
		})
		return;
	}

	var params = {
		"id": gameID
	};

	getGameDetaiData(params, function(data) {
		setTimeout(function() {
		}, 300)
			$('.top').html(template('top', data));
			$('.mui-scroll-wrapper .mui-scroll').html(template('list', data));
			$('.loading').remove();
		
	})

	mui('body').on('tap','.mui-table-view a',function(){
		
		var gameid = this.getAttribute('data-id');
		var propid = this.getAttribute('data-propid');
		var productid = this.getAttribute('data-id');
		
		mui.openWindow({
			url:Trade.PRODUCT_LIST_URL,
			id:Trade.PRODUCT_LIST_URL,
			extras:{
				gameid:gameid,
				propid:propid,
				productid:productid,
			}
		})
	})
});




//获取游戏详情数据
function getGameDetaiData(params, callback) {
	Trade.ajax({
		url: 'game/getgamedetail',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		},
		error: function() {

		}
	})
}