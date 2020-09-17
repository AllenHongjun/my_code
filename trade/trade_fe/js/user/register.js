$(function () {
    $('body').on('tap','.code-btn',function (e) {
        //获取验证码
        var phone =$('[name=phone]').val();
        var code = $('[name=code]').val();

        if(!isPoneAvailable(phone)){
            mui.toast('请输入正确的手机号码');
            return false;
        }
        var params = {
            phone:phone
        }
        GetSendCodeData(params,function (data) {
            console.log(data);
            var time = 60;
            var btn = $('.code-btn');
            btn.val(time+'秒后再获取');
            var timer = setInterval(function(){
                time --;
                btn.val(time+'秒后再获取');
                if(time <= 0) {
                    clearInterval(timer);
                    btn.removeAttr('disabled').val('获取验证码');
                }
            },1000);
            mui.toast(data.errordes);
        })
    }).on('tap','#regBtn',function () {
        //注册绑定
        var data = {
            phone:$.trim($('[name=phone]').val()),
            password:$.trim($('[name=password]').val()),
            rePass:$.trim($('[name=rePassword]').val()),
            vCode:$.trim($('[name=code]').val())
        }
        if(!isPoneAvailable(data.phone)){
            mui.toast('请输入正确的手机号码');
            return false;
        }
        if(!data.password){
            mui.toast('请输入密码');
            return false;
        }

        if(!data.rePass){
            mui.toast('请再次输入密码');
            return false;
        }

        if(data.password != data.rePass){
            mui.toast('密码需要一致');
            return false;
        }

        if(!data.vCode){
            mui.toast('请输入验证码');
            return false;
        }
        if(!/^(\d{4})|(\d{6})$/.test(data.vCode)){
            mui.toast('请输入合法验证码');
            return false;
        }

        var params  ={
            phone:data.phone,
            pwd:hex_md5(data.password),
            code:data.vCode
        }
        console.log(params)
        GetPhoneRegData(params,function (data) {
            console.log(data)
            if(data.resultcode == 200){
                mui.alert(data.errordes,'提示',function () {
                    window.location.href = Trade.LOGIN_URL;
                })
            }else{
                $('#regBtn').removeAttr('disabled').val('注册');
                mui.toast(data.errordes);
            }
        })
    })
})

//验证手机号码
function isPoneAvailable(phoneInput) {
    var myreg=/^[1][3,4,5,7,8][0-9]{9}$/;
    if (!myreg.test(phoneInput)) {
        return false;
    } else {
        return true;
    }
}


//获取手机验证码
function GetSendCodeData(params,callback) {
    Trade.ajax({
        url:'account/sendcode',
        type:'POST',
        data:params,
        dataType:'json',
        beforeSend:function(){
            var btn = $('.code-btn');
            btn.attr('disabled',true).val('正在发送...');
        },
        success:function (data) {
            callback&&callback(data);
        }
    })
}

//手机号码注册
function GetPhoneRegData(params,callback) {
    Trade.ajax({
        url:'account/phonereg',
        type:'POST',
        data:params,
        dataType:'json',
        beforeSend:function () {
            $('#regBtn').attr('disabled',true).val('正在提交...');
        },
        success:function (data) {
            callback&&callback(data);
        }
    })
}