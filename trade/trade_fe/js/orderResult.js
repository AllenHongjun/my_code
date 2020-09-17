$(function () {


    /*1. 订单号为空
    2. 订单号错误
    3. 订单号状态失败 已经完成 已经付款  未付款
    4.订单支付成功
    5. 已经支付为到账的情况

    */

    var oid = Trade.getUrlParam('orderid');
    var uid = Trade.getUid();
    var params = {
        'oid': oid,
        'uid': uid
    }


    // 获取订单详情
    getOrderDetailData(params,function (data) {
        console.log(data);
        if(data.resultcode == 200){
            $('.order-success').html(template('success_result',data));



        }else{
            $('.order-fail').html(template('fail_result',data));
            $('.order-success').hide();
            $('.order-fail').show();
        }
    })


    // 点击复制交易码
    // $('body').on('tap','.mui-btn-blue',function (e) {
    //
    //     copyText();
    // })

    var clipboard = new ClipboardJS('.mui-btn-blue',{
        target: function() {

            var text = document.getElementById("trade-code").innerText;
            var input = document.querySelector(".trade-code-input");
            console.log(text)
            input.value = text; // 修改文本框的内容
            return document.querySelector('.trade-code-input');
        }
    });
    //优雅降级:safari 版本号>=10,提示复制成功;否则提示需在文字选中后，手动选择“拷贝”进行复制
    clipboard.on('success', function(e) {
        console.log(e);
        mui.alert('复制成功!')
        e.clearSelection();
    });
    clipboard.on('error', function(e) {
        mui.alert('请选择“拷贝”进行复制!')
    });


})


function copyText() {
    var text = document.getElementById("trade-code").innerText;
    var input = document.getElementById("trade-code-input");
    input.value = text; // 修改文本框的内容
    input.select(); // 选中文本

    document.execCommand("copy"); // 执行浏览器复制命令
    mui.alert("复制成功");
}

//查询订单详细信息
var getOrderDetailData = function (params,callback){
    Trade.ajaxNeedLogin({
        url:"Order/Orderdetail",
        type:'POST',
        data:params,
        dataType:'json',
        success:function (data) {
            callback&&callback(data)
        }
    })
}


