/**
 * Created by 65297 on 2018/7/3.
 */
$(function(){
	

	
    //道具列表区域滚动效果
    mui('.mui-scroll-wrapper').scroll({
        deceleration: 0.0005
    });
	
	//判断是否有gameid参数 如果没有就跳转
    var gameID = Trade.getUrlParam('gameid') || parseInt(getGameData()[0].gameid);
    if(!gameID){
        window.location.href="game_list.html";
        return false;
    }

    /*
    * 1.根据分类跳转搜索列表
    * 2.图片链接显示
    * 3.底部路径要带上参数
    * 4.请求超时处理 请求接口其他错误处理
    * */
    var params = {
        "id":gameID
    };
    getGameDetaiData(params,function(data){
        setTimeout(function () {
            console.log(data);
            $('.top').html(template('top', data));
            $('.mui-scroll-wrapper .mui-scroll').html(template('list', data));
            $('.loading').remove();
        }, 300)
    })

    //首页链接
    var gameid = parseInt(getGameData()[0].gameid);
    $('.mui-bar-tab:first-child').attr('href','game_detail.html?gameid='+gameid);

})


//获取游戏详情数据
var getGameDetaiData = function (params,callback) {
    Trade.ajax({
        url:'game/getgamedetail',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            callback&&callback(data);
        },
        error: function () {

        }
    })
}

