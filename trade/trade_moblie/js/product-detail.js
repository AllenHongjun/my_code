/**
 * Created by 65297 on 2018/7/3.
 */

/* 出售道具详细信息*/
mui.plusReady(function() {
	var self = plus.webview.currentWebview();
	var hyid = self.hyid || 0;
	if(!hyid) {
		mui.openWindow({
			'url': Trade.PRODUCT_LIST_URL,
			'id': Trade.PRODUCT_LIST_URL
		})
	}
	var params = {
		"hyid": hyid
	};
	
	//console.log(hyid);
	getProductDetailData(params, function(data) {
		//console.log(JSON.stringify(data));
		if(data.resultcode != 200){
			mui.openWindow({
				'url': Trade.PRODUCT_LIST_URL,
				'id': Trade.PRODUCT_LIST_URL
			})
			return false;
		}
		var infoDom = document.querySelector('.info');
		infoDom.innerHTML = template('productDetail', data)

	})

	//点击购买生成订单
	// 跳转订单页面
	mui('.payment').on('tap', 'button', function() {
		
		var params2 = {
            uid:Trade.getUid()
        }
        GetUserGameData(params2,function (data) {
            var gameid = getGameData()[0].gameid;
           //获取已经绑定主链id的信息
            if(data.result.length <= 0 ){
                showTip();
            }else{
            	//只有绑定当前游戏主链的用户才能购买
                for(var i = 0; i < data.result.length; i++){
                    if(gameid == data.result[i].gid){                   	
                    	mui.openWindow({
							url: Trade.ORDER_URL,
							id: Trade.ORDER_URL,
							extras: {
								hyid: hyid,
								chainid:data.result[i].chinlid
							}
						})
                        return;
                    }
                }
                showTip();
            }
        })
	})

})

//显示提示绑定游戏
function showTip() {
    var btnArray = ['去绑定', '取消'];
    mui.confirm('购买道具需要绑定当前游戏的主链id', '提示', btnArray, function(e) {
        if (e.index == 0) {
        	mui.openWindow({
        		id:Trade.USER_BIND_URL,
        		url:Trade.USER_BIND_URL
        	})
        }
    })
}


//获取商品详情
function getProductDetailData(params, callback) {
	Trade.ajax({
		url: 'product/productdetail',
		type: 'POST',
		data: params,
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}

	})
}

//获取已经绑定的游戏主链id
function GetUserGameData(params,callback) {
    Trade.ajaxNeedLogin({
        url:'account/usergame',
        data:params,
        type:'POST',
        dataType:'json',
        success:function (data) {
            callback&&callback(data);
        }
    })
}