/**
 * Created by 65297 on 2018/7/3.
 */
$(function(){
   /* 出售道具详细信息*/
    window.hyid = Trade.getUrlParam('hyid');
    if(!hyid){
        window.location.href="searchList.html";
    }
    var params={
        "hyid": hyid
    };

    getProductDetailData(params,function(data){
        console.log(data);
        if(data.resultcode == '200' && data.result.state == 1){
            $('.info').html(template('productDetail',data));
        }else{
            window.location.href=Trade.GAME_DETAIL_URL;
        }

    })

    //点击购买生成订单
    // 跳转订单页面
    $('.payment').on('tap','button',function(){

        //只有绑定了当前游戏的主链id才能够购买道具  一个游戏的主链id一个账号只能绑定一次（只能绑定同一个账号）
        var params2 = {
            uid:Trade.getUid()
        }
        GetUserGameData(params2,function (data) {
            var gameid = getGameData()[0].gameid;
            //console.log(gameid)
            //console.log(data.result)
            if(data.result.length <= 0 ){
                showTip();
            }else{
                for(var i = 0; i < data.result.length; i++){
                    if(gameid == data.result[i].gid){
                        window.location.href="order.html?hyid="+window.hyid+'&chainid='+data.result[i].chinlid;
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
            window.location.href = Trade.BIND_URL;
        }
    })
}

//获取商品详情
var getProductDetailData =function(params,callback){
    Trade.ajax({
        url:'product/productdetail',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            callback&&callback(data);
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