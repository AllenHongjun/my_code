/**
 * Created by 65297 on 2018/7/3.
 */

if(!Trade) var Trade = {};
/*常用地址*/
//Trade.LOGIN_URL = '/mobile/user/login.html';
//Trade.SEARCH_LIST_URL = '/mobile/searchList.html';
//Trade.CART_URL = '/mobile/cart.html';


//常用给的URL地址配置
Trade.API_URL = 'https://m.579y.com/';
Trade.Test_API_URL = 'http://m.579y.com/';


Trade.USER_URL = '/user/index.html';
Trade.LOGIN_URL = '/user/login.html';
Trade.BIND_URL  = '/user/bind.html'

Trade.PRODUCT_URL = '/product.html';
Trade.PRODUCT_LIST_URL = '/search_list.html';

Trade.ITEM_LIST_URL = '/sell/item_list.html';
Trade.GAME_LIST_URL = '/game_list.html';
Trade.GAME_DETAIL_URL = '/game_detail.html';
Trade.ORDER_LIST_URL = '/order_list.html';



/*全局ajax工具函数    */
Trade.ajax = function(options){
    if(!options.url) return false;
    $.ajax({
        url:Trade.API_URL+options.url,
        type:options.type||'post',
        data:options.data||'',
        dataType:options.dataType||'json',
        timeout:options.timeout||50000,
        async:false,
        beforeSend:function(){
            options.beforeSend && options.beforeSend();
        },
        success:function(data){
            /*400代表未登录*/
            //if(data && data.error == '400'){
            //    window.location.href = Trade.LOGIN_URL+'?returnUrl='+decodeURI(location.href);
            //    return false;
            //}
            //setTimeout(function(){
            //    options.success && options.success(data);
            //},1000);
            //console.log('Trade.ajax')
            //请求有异常的地方 可以统一处理
            // if( data && data.resultcode == '500'){
            //     mui.alert(data.errordes);
            //     return false;
            // }
            options.success && options.success(data);
        },
        error:function(xhr,type,errorThrown){
            mui.toast('服务繁忙');
            //console.log({xhr:xhr,type:type,errorThrown:errorThrown});
            options.error && options.error({xhr:xhr,type:type,errorThrown:errorThrown});
        }
    });
};


//请求需要登陆的业务
Trade.ajaxNeedLogin = function(options){
	
	/*先判断用户登陆信息是否存在*/
	var objLoginParams = getLoginParams();
	if(JSON.stringify(objLoginParams) == '{}'){

		mui.openWindow({
			url:Trade.LOGIN_URL,
			id:'login'
		})
		return false;
	}
    Trade.UID = objLoginParams.uid;
	var loginParams = '?uid='+objLoginParams.uid +'&mac=&skey='+objLoginParams.sessionid;

    if(!options.url) return false;
    $.ajax({
        url:Trade.API_URL+options.url+loginParams,
        type:options.type||'post',
        data:options.data||'',
        dataType:options.dataType||'json',
        timeout:options.timeout||50000,
        beforeSend:function(){
            options.beforeSend && options.beforeSend();
        },
        success:function(data){
            /*400代表未登录*/

            if(data && data.resultcode == '403'){
                console.log(data.errordes);
                window.location.href = Trade.LOGIN_URL+'?returnUrl='+decodeURI(location.href);
                return false;
            }
            /*if(data.resultcode == 503){
                //密文校验失败
                mui.toast(data.errordes);
                //console.log(data.errordes)
                return false;
            }*/
            options.success && options.success(data);
        },
        error:function(xhr,type,errorThrown){
            mui.toast('服务繁忙');
            options.error && options.error({xhr:xhr,type:type,errorThrown:errorThrown});
        }
    });
};


/*
 * 获取当前页面的url数据根据key
 * */
Trade.getUrlParam = function(key){
    var strings = location.search.substr(1).split("&");
    var value = null;
    for(var i = 0; i < strings.length; i ++) {
        var arr = strings[i].split("=");
        if(arr[0] == key){
            /*urlcode 转码*/
            value = decodeURI(arr[1]);
            break;
        }
    }
    return value;
};
/*
 * 根据数组中对象数据获取索引
 * */
Trade.getIndexFromId = function(arr,id){
    var index = null;
    for(var i = 0 ; i < arr.length ; i++){
        var item = arr[i];
        if(item && item.id == id){
            index = i;
            break;
        }
    }
    return index;
};
/*
 * 根据数组中对象数据ID获取索引
 * */
Trade.getObjectFromId = function(arr,id){
    var object = null;
    for(var i = 0 ; i < arr.length ; i++){
        var item = arr[i];
        if(item && item.id == id){
            object = item;
            break;
        }
    }
    return object;
};


/*获取用户登陆的id*/
Trade.getUid = function() {
    var objLoginParams = getLoginParams();
    if(!objLoginParams){
        mui.openWindow({
            url:'/user/login.html',
            id:'login'
        })
        return false;
    }
    return objLoginParams.uid;
}

// 将数字转换为金额的格式
Trade.toMoney = function (num) {
    var num = num.toFixed(2);  //将数字转成带有2位小数的字符串
    num = parseFloat(num)  //将带有2位小数的字符串转成带有小数的数字
    num = num.toLocaleString();  //将带有2位小数的数字转成金额格式
    return num;//返回的是字符串23,245.12保留2位小数
}

/***************localStorage使用方法*****************************/

var getLoginParams = function(){
    return JSON.parse(localStorage.getItem('trade_userinfo') || '{}');
}

//将gameID 等全局数据保存到localStoryage中 页面传值
var getGameData = function () {
    return JSON.parse(localStorage.getItem('TradeGameData')||'[]');
}

var addGameData = function(data){
    console.log(data);
    var list = getGameData();
    list = JSON.parse('[]');
    list.push({gameid:data.gameID});
    list.push({gamename:data.gameName});
    localStorage.setItem('TradeGameData',JSON.stringify(list));
}

var removeGameData = function () {
    var list = getGameData();
    list = JSON.parse('[]');
}
/***************localStorage使用方法*****************************/








/*此处放置公用的 获取数据和处理的方法*/

$(function(){

    /********TAP统一地址赋值***********/

    //处理用户没有选择游戏的情况 就默认跳转到游戏列表页面
    if(getGameData() == null ||getGameData().length <= 0){
        var u=window.location.pathname;
        if(u.indexOf("game_list.html")<0){
            mui.openWindow({
                url: '/game_list.html',
                id: 'game_list'
            })
        }
    }else{
        var gameid = parseInt(getGameData()[0].gameid);
        $('.mui-bar-tab a:first-child').attr('href', '/game_detail.html?gameid=' + gameid);
    }

    //出售验证码
    $('#promptBtn').off('tap').on('tap',function(e){

        e.preventDefault();
        e.detail.gesture.preventDefault(); //修复iOS 8.x平台存在的bug，使用plus.nativeUI.prompt会造成输入法闪一下又没了
        //mui.toast('123');
        var btnArray = ['取消', '下一步'];
        mui.prompt('  ', '请输入您的合约ID：', '道具出售', btnArray, function(e) {
            if (e.index == 0) {
                console.log(0);
            } else {
                var code = $('.mui-popup-input input').val();
                if(!code){
                    mui.toast('请输入正确的合约ID');
                    return false;
                }
                var uid = Trade.getUid();
                var params = {
                    "code":code,
                    "uid":uid
                }
                getItemData(params,function(data){

                    if(data.resultcode == 200){
                        window.location.href='/sell/add_item.html?code='+code;
                    }else{
                        mui.toast(data.errordes)
                    }
                })

            }
        })

        return false;
    })

    //mui 框架a链接点击会失效 click延迟太大也被禁止使用
    $('.mui-bar-tab').on('tap','a',function(){
        window.top.location.href=this.href;
    });

})



//根据商品码验证商品信息
var getItemData = function(params,callback){
    Trade.ajaxNeedLogin({
        url:'product/checkcode',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            //console.log(data);
            callback&&callback(data);
        }
    })
}