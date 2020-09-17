/**
 * Created by 65297 on 2018/7/12.
 */
$(function () {

    /*1.从localStorage中获取用户信息
    2. 如果获取失败就跳转到登陆页面
    3. 如果成功就展示用户信息页面
    4. 有些mui 组件的a 链接会失效
    */
    var userinfo = getLoginParams();
    var gameinfo = getGameData();
    if(JSON.stringify(userinfo) == '{}'){
        mui.openWindow({
            url:Trade.LOGIN_URL,
            id:'login'
        })
    }else if(JSON.stringify(gameinfo) == '[]'){
        mui.openWindow({
            url:Trade.GAME_LIST_URL,
            id:'game_list'
        })
    }else{

        var params = {
            'uid':userinfo.uid,
            'skey':userinfo.skey
        }
        getUserInfoData(params,function (data) {
            if(data.resultcode == 200){

                var user = data.result;
                $('.wallet').html('￥'+user.balance)
                $('.info').html(template('userinfo',user));
                $('.main .list h4').html(gameinfo[1].gamename);
            }else{
                mui.toast(data.errordes);
            }
        })

    }


    //点击我的出售跳转
//  $('#item_list').on('tap',function(){
//      mui.openWindow({
//          url:Trade.ITEM_LIST_URL,
//          id:'item_list'
//      })
//  })
//  $('#item_list2').on('tap',function(){
//      mui.openWindow({
//          url:Trade.ITEM_LIST_URL+"?state=2",
//          id:'item_list'
//      })
//  })
//  $('#order_list').on('tap',function(){
//      mui.openWindow({
//          url:Trade.ORDER_LIST_URL,
//          id:'item_list'
//      })
//  })

	$('.mui-content').on('tap','a',function(e){
		e.preventDefault();
		console.log(e);
		console.log(e.target);
		if(e.target.id == 'loginOut'){
			localStorage.removeItem('trade_userinfo');
	        mui.openWindow({
	            url:Trade.LOGIN_URL,
	            id:'login'
	        })
		}else{
			var link = $(this).attr('href');
			mui.openWindow({
				url:link,
				id:link
			})
		}					
	})
})

// 获取用户信息
var getUserInfoData = function (params,callback) {
    Trade.ajaxNeedLogin({
        url:'account/getuser',
        type:'POST',
        data:params,
        dataType:'json',
        success:function (data) {
            callback&&callback(data);
        }
    })
}