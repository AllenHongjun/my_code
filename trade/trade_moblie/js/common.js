/**
 * Created by 65297 on 2018/7/3.
 *
 *_____                 		&&&&_) )
        \/,---<                &&&&&&\ \
        ( )c~c~~@~@            )- - &&\ \
        C   >/                \<   |&/
        \_O/ - 哇塞          _`*-'_/ /
        ,- >o<-.              / ____ _/
        /   \/   \            / /\  _)_)
        / /|  | |\ \          / /  )   |
        \ \|  | |/ /          \ \ /    |
        \_\  | |_/            \ \_    |
        /_/`___|_\            /_/\____|
        |  | |                  \  \|
        |  | |                   `. )
        |  | |                   / /
        |__|_|_                 /_/|
        (____)_)                |\_\_

 *
 */

if(!Trade) var Trade = {};

//常用给的URL地址配置
Trade.API_URL = 'https://m.579y.com/';


Trade.INDEX_URL = '/index.html'
Trade.USER_LOGIN_URL = '/pages/user-login.html';
Trade.USER_CENTER_URL = 'user-center.html';

Trade.USER_BIND_URL = 'user-bind.html';
Trade.USER_REGISTER_URL = 'user-register.html';

Trade.SELL_ITEMLIST_URL = 'sell-itemlist.html';
Trade.SELL_ADDITEM_URL = 'sell-additem.html';

Trade.GAME_DETAIL_URL = 'game-detail.html';
Trade.GAME_LIST_URL = 'game-list.html';
Trade.PRODUCT_LIST_URL = 'product-list.html';
Trade.PRODUCT_DETAIL_URL = 'product-detail.html';

Trade.ORDER_URL = 'order.html';
Trade.ORDER_LIST_URL = 'order-list.html';
Trade.ORDER_RESULT_URL = 'order-result.html';


//会关闭程序
Trade.CloseAllandIndex = function(){
	var ws = plus.webview.all(); 			   //获取所有已打开页面
	console.log(ws.length);                            		 			　　
	for(var i = 0, len = ws.length; i < len; i++) {　　　 // 首页以及当前窗口对象，不关闭； 			 
		ws[i].close('none');　　 	      //关闭所有不需要的窗口对象； 	'none' 就没有动画了	 	

	}
}

//关闭除了首页以外的其他 webview 再次打开的时候可以刷新
Trade.CloseAll = function(){
	var ws = plus.webview.all(); 			   //获取所有已打开页面
	console.log(ws.length);                            		 			　　
	for(var i = 0, len = ws.length; i < len; i++) {　　　 // 首页以及当前窗口对象，不关闭； 			 
		　 	      //关闭所有不需要的窗口对象； 	'none' 就没有动画了	 	
		if(ws[i].id === plus.runtime.appid || ws[i].id == 'pages/game-detail.html') {　　　　　　　　     //这里"main"就是我需要返回页面的ID			 				　　　　　　
			continue;　　　　		      //保留页面
		} else {　　　　　　
			ws[i].close('none');　				　　　　
		}
	}
}

//回到首页
Trade.GoToIndex = function(){
	//var self = plus.webview.currentWebview();
	var h=plus.webview.getWebviewById( plus.runtime.appid );
	mui.fire(h, 'refresh');

	mui.openWindow({
			id:plus.runtime.appid,
			waiting:{
				titite:'正在加载...'
			}
	})
	console.log('backtoindex');
	
}

//点击返回回到首页
Trade.BackToIndex = function(){
	//从退出页面进入是 重写mui.back方法，返回的时候回到默认首页
	var self = plus.webview.currentWebview();
	var h=plus.webview.getWebviewById( plus.runtime.appid );
	mui.back = function(){
		Trade.CloseAll();
		mui.fire(h, 'refresh');
		mui.openWindow({
			id:plus.runtime.appid
		})
	}		
}

/*全局ajax工具函数    */
Trade.ajax = function(options){
    if(!options.url) return false;
    mui.ajax({
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


Trade.GetCurrentUrl = function(){
	
	
	mui.plusReady(function(){
		var currentWebView = plus.webview.currentWebview();
	})
}

//请求需要登陆的业务
Trade.ajaxNeedLogin = function(options){
	
	/*先判断用户登陆信息是否存在*/
	var objLoginParams = getLoginParams();
	if(JSON.stringify(objLoginParams) == '{}'){
		
		console.log(location.href)
		return false;
		mui.openWindow({
        	url:Trade.USER_LOGIN_URL,
        	id:Trade.USER_LOGIN_URL,
        	extras:{
        		returnUrl:decodeURI(location.href)
        	}
        })
		return false;
	}
    Trade.UID = objLoginParams.uid;
	var loginParams = '?uid='+objLoginParams.uid +'&mac=&skey='+objLoginParams.sessionid;

    if(!options.url) return false;
    mui.ajax({
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

                mui.openWindow({
                	url:Trade.USER_LOGIN_URL,
                	id:Trade.USER_LOGIN_URL,
                	extras:{
                		returnUrl:decodeURI(location.href)
                	}
                })

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
            url:'/pages/user-login.html',
            id:'/pages/user-login.html'
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

//删除左右两端的空格
Trade.trim = function (str){ 
　　  return str.replace(/(^\s*)|(\s*$)/g, "");
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
    //console.log(JSON.stringify(data));
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
