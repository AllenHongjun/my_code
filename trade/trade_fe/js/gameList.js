/**
 * Created by 65297 on 2018/7/3.
 */
$(function(){
    /*
    * 1. 获取游戏列表
    * 2. 渲染列表数据
    * 3. 选择成功之后跳转 保存选择游戏的id
    * 4. 选中的游戏 添加选中的样式
    * 5. 重新选择游戏链接
    * */
    var params = {
        "num": 4
    };

    getGameList(params,function(data){
        $('.mui-content .game-list').html(template('gamelist',data));
        //选着游戏添加样式
        change(li1Ele);
    })
    //代理绑定事件 点击按钮跳转
    $('body').on('tap','button',function(){
        var gameID = $('.mui-table-view li.checked a').attr('data-id');
        var gameName = $.trim($('li.checked div').html());

        addGameData({'gameID':gameID,'gameName':gameName});
        window.location.href = './game_detail.html?gameid='+gameID;
    })

})



/*获取游戏列表数据*/
var getGameList = function (params, callback) {
    Trade.ajax({
        url:'game/gamelist',
        data:params,
        type:'POST',
        dataType:'json',
        success:function(data){
            callback&&callback(data);
        },
        error:function(){

        }
    })

}


var hasClass = function (obj, cls) {
    return obj.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
}

var addClass = function addClass(obj, cls) {
    if (!this.hasClass(obj, cls)) obj.className += " " + cls;
}

var removeClass = function removeClass(obj, cls) {
    if (hasClass(obj, cls)) {
        var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
        obj.className = obj.className.replace(reg, '');
    }
}
var li1Ele = document.getElementsByClassName("game");

var change=function (obj) {
    for(var i = 0; i < obj.length; i++){
        obj[i].onclick = function() {
            for(var i = 0; i < obj.length; i++){
                removeClass(obj[i],"checked")
            }
            addClass(this,"checked");

        };
    }
};
