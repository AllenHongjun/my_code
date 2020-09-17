
$(function () {

    //点击按钮复制功能
    var clipboard = new ClipboardJS('.copy',{
        target: function() {
            return document.querySelector('.trade-code-input');
        }
    });

    //优雅降级:safari 版本号>=10,提示复制成功;否则提示需在文字选中后，手动选择“拷贝”进行复制
    clipboard.on('success', function(e) {
        mui.alert('复制成功!')
        e.clearSelection();
    });
    clipboard.on('error', function(e) {
        mui.alert('请选择“拷贝”进行复制!')
    });


    var params2 = {
        uid:Trade.getUid()
    }
    GetUserGameData(params2,function (data) {
        console.log(JSON.stringify(data));
        if(data.result){
            $('.chainid-box').html(template('chain-id',data))
        }

    })
})

function GetUserInfoData(params,callback) {
    Trade.ajaxNeedLogin({
        url:'account/getuser',
        data:params,
        type:'POST',
        dataType:'json',
        success:function (data) {
            callback&&callback(data);
        }
    })
}

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