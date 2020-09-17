
function errorTips(o, t, c) {
    var c = c || "";
    var html = "<p><i class=" + c + "></i>" + t + "</p>"
    o.parent().append(html);
}

function successTips(o, v) {
    var v = v ? v : 0;
    var t = "";
    if (v) {
        var level = getPwdLevel(v);
        switch (level) {
            case 1: t = "弱：试试大小写字母、数字混搭"; break;
            case 2: t = "中：试试大小写字母、数字混搭"; break;
            case 3: t = "强：请牢记您的密码"; break;
        }
    }
    var html = "<p><i class='true'></i>" + t + "</p>"
    o.parent().append(html)
}

function isEasyPwd(v) {
    v = v.toLowerCase();
    var a1 = "0123456789";
    var a2 = "9876543210";
    var b1 = "abcdefghijklmnopqrstuvwxyz";
    var b2 = "zyxwvutsrqponmlkjihgfedcba";
    if (a1.indexOf(v) > -1 || a2.indexOf(v) > -1 || b1.indexOf(v) > -1 || b2.indexOf(v) > -1) {
        return true;
    }
    return false;
}
function getPwdLevel(v) {
    var a1 = a2 = a3 = a4 = false;
    for (var i = 0; i < v.length; i++) {
        var a, c = v.charCodeAt(i);
        if (c >= 48 && c <= 57) a1 = true; //数字
        else if (c >= 65 && c <= 90) a2 = true; //大写字母
        else if (c >= 97 && c <= 122) a3 = true; //小写字母
        else a4 = true; //特殊字符
    }
    var lv = 1;
    if (a4) lv = 3;
    else if (a1 && a2 && a3) lv = 3;
    else if (a2 || a3) lv = 2;
    else lv = 1;
    return lv;
}

//校验昵称
function IsForbiddenNickName(nickName) {
    var filter = "<,>, ,&#,&lt,&gt,&nbsp,&ensp,&emsp,&quot,&copy,&reg,&times,&divide";
    var arr = filter.split(',')
    for (var i = 0; i < arr.length; i++) {
        if (nickName.toLowerCase().indexOf(arr[i]) > -1)
            return true;
    }
    return false;
}

function checkIdcard(idcard) {
    var Errors = ["验证通过!", "身份证号码位数不对!", "身份证号码出生日期超出范围或含有非法字符!", "身份证号码校验错误!", "身份证地区非法!", "身份证号码不能为空!", "身份证号码年龄未满18周岁", "身份证号码年龄超出范围"];
    idcard = idcard.toUpperCase(); 	//lzd add	
    if (idcard.length == 0)
        return Errors[5];

    idcard = idcard.replace('(', '').replace(')', '');
    var len = idcard.length;
    //15,18,8,9,10
    if (len != 15 && len != 18 && len != 8 && len != 9 && len != 10)
        return Errors[1];
    var pattern = /^[A-Za-z0-9]+$/;
    if (!pattern.test(idcard))
        return Errors[3];

    var area = { 11: "北京", 12: "天津", 13: "河北", 14: "山西", 15: "内蒙古", 21: "辽宁", 22: "吉林", 23: "黑龙江", 31: "上海", 32: "江苏", 33: "浙江", 34: "安徽", 35: "福建", 36: "江西", 37: "山东", 41: "河南", 42: "湖北", 43: "湖南", 44: "广东", 45: "广西", 46: "海南", 50: "重庆", 51: "四川", 52: "贵州", 53: "云南", 54: "西藏", 61: "陕西", 62: "甘肃", 63: "青海", 64: "宁夏", 65: "新疆", 71: "台湾", 81: "香港", 82: "澳门", 91: "国外" }
    var idcard, Y, JYM;
    var S, M;
    var idcard_array = new Array();
    idcard_array = idcard.split("");
    //地区检验 
    if (area[parseInt(idcard.substr(0, 2))] == null) {
        if (idcard.length == 15 || idcard.length == 18)
            return Errors[4];
    }
    //身份号码位数及格式检验 
    switch (idcard.length) {
        case 15:
            if ((parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0 || ((parseInt(idcard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0)) {
                ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/; //测试出生日期的合法性 
            } else {
                ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/; //测试出生日期的合法性 
            }
            if (ereg.test(idcard)) return Errors[0];
            else return Errors[2];
            break;
        case 18:
            //18位身份号码检测 
            //出生日期的合法性检查  
            //闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
            //平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
            if (parseInt(idcard.substr(6, 4)) % 4 == 0 || (parseInt(idcard.substr(6, 4)) % 100 == 0 && parseInt(idcard.substr(6, 4)) % 4 == 0)) {
                ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/; //闰年出生日期的合法性正则表达式 
            } else {
                ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/; //平年出生日期的合法性正则表达式 
            }
            if (ereg.test(idcard)) {//测试出生日期的合法性 
                var currentYear = 2016; //当前年，该值需要每年改一次
                var age = 18; //合法年龄
                var idcardyear = parseInt(idcard.substr(6, 4));
                if (idcardyear < 1910)
                    return Errors[7];
                else if (idcardyear >= (currentYear - age)) {
                    var month = parseInt(idcard.substr(10, 2), 10);
                    var day = parseInt(idcard.substr(12, 2), 10);
                    var theDate = new Date(idcardyear + age, month - 1, day);
                    var date = new Date();
                    var currentDate = new Date(currentYear, date.getMonth(), date.getDate());
                    if ((theDate - currentDate) > 0)
                        return Errors[6];
                }
                //计算校验位 
                S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7
	+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9
	+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10
	+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5
	+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8
	+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4
	+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2
	+ parseInt(idcard_array[7]) * 1
	+ parseInt(idcard_array[8]) * 6
	+ parseInt(idcard_array[9]) * 3;
                Y = S % 11;
                M = "F";
                JYM = "10X98765432";
                M = JYM.substr(Y, 1); //判断校验位 
                if (M == idcard_array[17]) return Errors[0]; //检测ID的校验位 
                else return Errors[3];
            }
            else return Errors[2];
            break;
            //start add by wsp 2011-4-6 
        case 8:
            //校验香港或澳门身份证号码
            if (checkHKIdcard(idcard) || checkMCIdcard(idcard))
                return Errors[0];
            else
                return Errors[3];
            break;
        case 9:
            //校验香港身份证号码
            if (checkHKIdcard(idcard))
                return Errors[0];
            else
                return Errors[3];
            break;
        case 10:
            //校验台湾身份证号
            if (checkTWIdcard(idcard))
                return Errors[0];
            else
                return Errors[3];
            break;
            //end 

        default:
            return Errors[1];
            break;
    }
}


//start 港澳台身份证验证 
//校验香港身份证号
function checkHKIdcard(IdCard) {
    IdCard = IdCard.toUpperCase();
    if (IdCard.length != 9 && IdCard.length != 8)
        return false;
    return true;
}

//校验台湾身份证号
function checkTWIdcard(IdCard) {
    if (IdCard.length != 10)
        return false;
    return true;
}
//校验澳门身份证号码
function checkMCIdcard(IdCard) {
    //1、5、7开头共8位，最后一位为校验码
    if (IdCard.length != 8)
        return false;
    return true;
}
//end 港澳台身份证验证 

//检查阅读协议
function CheckProtocol() {
    if (!document.getElementById("Checkbox1").checked) {
        return false;
    }
    return true;
}

//显示验证码
//function ShowValidatePic() {
//  if (document.getElementById("validatePicArea").style.display == "none") {
//      document.getElementById("validatePicArea").style.display = "inline";
//      document.getElementById("validateImage").src = "ValidationImageReg.ashx?" + Math.random();
//  }
//}

//检查验证码
//function CheckValidCode() {
//  var validCode = document.getElementById("txtValidCode").value;
//  if (validCode.length == 0) {
//      return false;
//  }
//  return true;
//}

$(function () {
    var regist = $("#regist");
    var registInput = regist.find("input").not(".btnSubmit");

    registInput.focus(function () {
        var _this = $(this);
        if (_this.parent().find("i").attr("class") == "true")
            return false;
        _this.parent().find("p").remove();

        //帐号获得焦点
        if (this.id == "txtAccount") {
            var t = "4-12位英文或数字，区分大小写";
            errorTips(_this, t, "warn");
            return false;
        }

        //密码获得焦点
        if (this.id == "txtPassword") {
            var t = "6-18位英文或数字，区分大小写";
            errorTips(_this, t, "warn");
            return false;
        }
        //确认密码获得焦点
        if (this.id == "txtConfirmPassword") {
            var t = "重复输入上面的密码";
            errorTips(_this, t, "warn");
            return false;
        }

        //昵称获得焦点
        if (this.id == "txtNickName") {
            errorTips(_this, "1-8个中文或1-16个英文、数字、符号", "warn");
            return false;
        }

        //姓名获得焦点
        if (this.id == "txtName") {
            errorTips(_this, "请填写真实姓名，作为申诉依据", "warn");
            return false;
        }

        //身份证获得焦点
        if (this.id == "txtIDCardNum") {
            errorTips(_this, "请填写真实身份证信息，作为申诉依据", "warn");
            return false;
        }


        //验证码获得焦点
//      if (this.id == "txtValidCode") {
//          ShowValidatePic();
//      }
    });

    registInput.blur(function () {
        var v = this.value;
        var _this = $(this);
        _this.parent().find("p").remove();

        //验证帐号
        if (this.id == "txtAccount") {
            if (v.length < 4 || v.length > 12) {
                var t = "长度不正确，请输入4-12位的英文或数字"
                errorTips(_this, t, "error");
                return false;
            }
            if (v.indexOf(' ') != -1) {
                var t = "账号不能存在空格"
                errorTips(_this, t, "error");
                return false;
            }
            var pattern = /^[A-Za-z0-9]+$/;
            if (!pattern.test(v)) {
                var t = "账号只能是英文和或数字的组合";
                errorTips(_this, t, "error");
                return false;
            }
            var specialpattern = /^1[0-9]{10}$/;
            if (specialpattern.test(v)) {
                var t = "暂不支持该格式账号";
                errorTips(_this, t, "error");
                return false;
            }

            if (this.dataobj && this.dataobj.v == v) {
                if (this.dataobj.r)
                    successTips(_this);
                else
                    errorTips(_this, this.dataobj.m, "error");
                return false;
            }
            var tid = this.id;
            var ajaxData = "account=" + v;
            $.ajax({
                type: "GET", url: "LKAjax_CheckAccount.ashx",
                data: ajaxData, async: true,
                success: function (data) {
                    var o = $.parseJSON(data);
                    if (o.value != 0) {
                        errorTips(_this, o.text, "error");
                        document.getElementById(tid).dataobj = { "r": false, "v": v, "m": o.text };
                    }
                    else {
                        successTips(_this);
                        document.getElementById(tid).dataobj = { "r": true, "v": v, "m": o.text };
                    }
                }
            });
            return true;
        }

        //验证密码
        if (this.id == "txtPassword") {
            if (v == $("#txtAccount").val()) {
                errorTips(_this, "密码跟账号不能相同", "error");
                return false;
            }
            if (v.length < 6 || v.length > 18) {
                var t = "长度不正确，请输入6-18位的英文或数字";
                errorTips(_this, t, "error");
                return false;
            }
            var patternP = /^[A-Za-z0-9]+$/;
            if (!patternP.test(v)) {
                var t = "密码只能是英文和或数字的组合";
                errorTips(_this, t, "error");
                return false;
            }
            if (isEasyPwd(v)) {
                var t = "密码过于简单，不能是连续的英文或数字";
                errorTips(_this, t, "error");
                return false;
            }
            successTips(_this, v);
            return true;

        }

        //确认密码
        if (this.id == "txtConfirmPassword") {
            var pv = $("#txtPassword").val();
            if (v.length < 6 || v.length > 18) {
                errorTips(_this, "长度不正确，请输入6-18位的英文或数字", "error");
                return false;
            }
            if (pv != v) {
                var t = "两次输入的密码不一致";
                errorTips(_this, t, "error");
                return false;
            }

            successTips(_this);
            return true;
        }

        //昵称检测
        if (this.id == "txtNickName") {
            var nickName = v;
            var length = nickName.replace(/[^\x00-\xff]/g, "xx").length; 	//中文占两个位置
            if (length < 1 || length > 16) {
                errorTips(_this, "请输入1-8个中文或1-16个英文、数字、符号", "error");
                return false;
            }
            if (nickName.indexOf(' ') != -1 || nickName.indexOf('　') != -1) {
                errorTips(_this, "昵称不能存在空格", "error");
                return false;
            }
            if (nickName.indexOf("'") != -1) {
                errorTips(_this, "昵称不能存在单引号", "error");
                return false;
            }
            if (IsForbiddenNickName(nickName)) {
                errorTips(_this, "昵称含非法字符", "error");
                return false;
            }
            if (this.dataobj && this.dataobj.v == v) {
                if (this.dataobj.r)
                    successTips(_this);
                else
                    errorTips(_this, this.dataobj.m, "error");
                return false;
            }
            var tid = this.id;
            var ajaxData = "nickname=" + escape(v);
            $.ajax({
                type: "GET", url: "LKAjax_CheckNickName.ashx",
                data: ajaxData,
                success: function (data) {
                    var o = $.parseJSON(data);
                    if (o.value != 0) {
                        errorTips(_this, o.text, "error");
                        document.getElementById(tid).dataobj = { "r": false, "v": v, "m": o.text };
                    }
                    else {
                        successTips(_this);
                        document.getElementById(tid).dataobj = { "r": true, "v": v, "m": o.text };
                    }
                }
            });

            return true;
        }
        //检测姓名
        if (this.id == "txtName") {
            var name = v;
            if (name.length < 2 || name > 4) {
                errorTips(_this, "姓名长度不正确，2-4位的中文", "error");
                return false;
            }
            if (!/^[\u4e00-\u9fa5]+$/.test(name)) {
                errorTips(_this, "姓名存在非法字符", "error");
                return false;
            }
            successTips(_this);
            return true;
        }
        //检测身份证
        if (this.id == "txtIDCardNum") {
            var idCard = v;
            var name = $("#txtName").val();
            var result = checkIdcard(idCard);
            if (result != "验证通过!") {
                errorTips(_this, result, "error");
                return false;
            }
            if ((idCard.length == 15 || idCard.length == 18) && (name.length >= 2 && name.length <= 4)) {
                //校验身份证号和姓名是否一致
                var tid = this.id;
                var ajaxData = "idcard=" + idCard + "&name=" + escape(name);
                $.ajax({
                    type: "GET", url: "LKAjax_CheckIDCardAndName.ashx",
                    data: ajaxData, async: true,
                    success: function (data) {
                        var o = $.parseJSON(data);
                        if (o.value != 0) {
                            successTips(_this);
                            document.getElementById(tid).dataobj = { "r": false, "v": v, "m": o.text };
                        }
                        else {
                            successTips(_this);
                            document.getElementById(tid).dataobj = { "r": true, "v": v, "m": o.text };
                        }
                    }
                });
            }
            else {
                successTips(_this);
            }
            return true;
        }

        //验证QQ
        if (this.id == "txtQQ") {
            if (v.length == 0) { return true; }

            if (v.length < 4 || v.length > 12) {
                errorTips(_this, "长度不对，请输入4-12位数字", "error");
                return false;
            }
            var pattern = /^[0-9]{4,12}$/;
            if (!pattern.test(v)) {
                errorTips(_this, "号码格式不正确，请输入4-12位数字", "error");
                return false;
            }
            successTips(_this);
            return true;
        }

        //验证推广员账户
        if (this.id == "txtSpreadAccount") {
            if (this.value.length < 1) {
                $(this).val(this.defaultValue);
                return true;
            }
            if (this.dataobj && this.dataobj.v == v) {
                if (this.dataobj.r)
                    successTips(_this);
                else
                    errorTips(_this, this.dataobj.m, "error");
                return false;
            }
            var tid = this.id;
            var ajaxData = "spreader=" + v;
            $.ajax({
                type: "GET", url: "LKAjax_CheckSpreadAccount.ashx",
                data: ajaxData,
                success: function (data) {
                    var o = $.parseJSON(data);
                    if (o.value != 0) {
                        errorTips(_this, o.text, "error");
                        document.getElementById(tid).dataobj = { "r": false, "v": v, "m": o.text };
                    }
                    else {
                        successTips(_this);
                        document.getElementById(tid).dataobj = { "r": true, "v": v, "m": o.text };
                    }
                }
            });
            return true;
        }

        //验证体验卡卡密
        if (this.id == "txtCardPwd") {
            if (this.value.length < 1) {
                $(this).val(this.defaultValue);
                return true;
            }
            if (this.dataobj && this.dataobj.v == v) {
                if (this.dataobj.r)
                    successTips(_this);
                else
                    errorTips(_this, this.dataobj.m, "error");
                return false;
            }
            var tid = this.id;
            var ajaxData = "cardpwd=" + v;
            $.ajax({
                type: "GET", url: "LKAjax_CheckCardPwd.ashx",
                data: ajaxData,
                success: function (data) {
                    var o = $.parseJSON(data);
                    if (o.value != 0) {
                        errorTips(_this, o.text, "error");
                        document.getElementById(tid).dataobj = { "r": false, "v": v, "m": o.text };
                    }
                    else {
                        successTips(_this);
                        document.getElementById(tid).dataobj = { "r": true, "v": v, "m": o.text };
                    }
                }
            });
        }
        return true;
    });

    var selectList = $("#selectList");
    var selectListDL = selectList.find("dl");
    selectList.hover(function () {
        selectListDL.slideDown();
    }, function () {
        selectListDL.stop(true, false).slideUp();
    });

    selectList.find("dd").on("click", function () {
        var rblGender = $("#rblGender");
        var index = selectList.find("dd").index(this);
        selectList.find("span").text($(this).text());
        rblGender.find("option").attr("selected", false);
        rblGender.find("option").eq(index).attr("selected", true);
        selectListDL.stop(true, false).slideUp();
    });

    var optional = $("#optional");

    optional.on("click", function () {
        $(this).toggleClass("develop");
        optional.parent().find("ul").toggle();
    });

    var btnSubmit = $("#btnSubmit");

    btnSubmit.on("click", function (e) {
        var e = e || event;
        //registInput.trigger('blur');
        var numError = regist.find(".error").length;
        if (numError > 0) {
            return false;
        }
        else {
            if (!CheckProtocol()) {
                alert("请先阅读集结号游戏中心用户服务协议并点击“我接受”");
                return false;;
            }
//          if (!CheckValidCode()) {
//              alert("验证码非法，请重新输入");
//              return false;
//          }
            return true;
        }
    });

});

function registCB(o) {
    alert(o.msg);
}