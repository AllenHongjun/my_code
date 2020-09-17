<template>
    <div class="login">
        <img src="../../static/img/39buyu-logo.png" class="logo" />
        <form id='login-form' class="mui-input-group">
            <div class="mui-input-row register-btn">
                <label>
                    <svg class="mui-icon icon" aria-hidden="true">
                        <use xlink:href="#icon-zhanghao"></use>
                    </svg>
                </label>
                <input id='phone' type="text" class="mui-input-clear mui-input" placeholder="请输入手机号" v-model="phoneNumber">
            </div>
            <div class="code">
                <div class="mui-input-row register-btn">
                    <label>
                        <span class="mui-icon-extra mui-icon-extra-calc icon"></span>
                    </label>
                    <input id='code' type="text" class="mui-input-clear mui-input" placeholder="请输入验证码" v-model="mobileCode">
                </div>
                <button class="mui-btn mui-btn-block mui-btn-primary code-btn" @click.prevent="getVerifyCode" v-show="!computedTime">获取验证码</button>
                <button class="mui-btn mui-btn-block mui-btn-primary code-btn" @click.prevent v-show="computedTime">已发送({{computedTime}}s)</button>
                <div class="clear"></div>
            </div>
            <div class="code">
                <div class="mui-input-row register-btn">
                    <label for="password">
                        <span class="mui-icon mui-icon-locked"></span>
                    </label>
                    <input id="pwd" type="password" class="mui-input-clear mui-input" placeholder="请输入密码" v-model="password">
                </div>
            </div>
        </form>
        <div class="mui-content-padded">
            <button id='login' class="mui-btn mui-btn-block mui-btn-primary login-btn" @click.prevent="register">注册</button>
            <h6>*未注册用户直接登录即可完成登录</h6>
        </div>

    </div>
</template>

<script>
import { Toast } from "mint-ui";
import md5 from "js-md5";
export default {
    data() {
        return {
            phoneNumber: null,
            mobileCode: null,
            password: null,
            computedTime: 0
        };
    },
    created() {},
    methods: {
        //获取验证码
        getVerifyCode() {
            if (this.rightPhoneNumber) {
                this.computedTime = 30;
                this.timer = setInterval(() => {
                    this.computedTime--;
                    if (this.computedTime == 0) {
                        clearInterval(this.timer);
                    }
                }, 1000);

                //获取验证码接口
                this.$http.post("api/getCode",{

                }).then(result => {
                    if (result.body.state === 1) {
                        console.log(result.body.state);
                        Toast(result.body.message);
                    } else {
                        Toast("获取失败");
                    }
                });
                return false;
            } else {
                Toast("请输入正确的手机号");
            }
        },
        //账号注册
        register() {
            if (!this.phoneNumber) {
                Toast("请输入手机号");
                return;
            }
            if (!this.mobileCode) {
                Toast("请输入验证码");
                return;
            }
            if (!this.password) {
                Toast("请输入密码");
                return;
            }

            this.$http
                .post(
                    "account/PhoneReg",
                        {
                            phone:this.phoneNumber,
                            code:this.mobileCode,
                            pwd: md5(this.password)
                        }
                )
                .then(result => {
                    if (result.body.state === 1) {
                        //console.log(result.body);
                        Toast(result.body.errordes);
                        this.$router.go(-1);
                    } else {
                        Toast(result.body.errordes);
                    }
                });
        }
    },
    computed: {
        //判断手机号码
        rightPhoneNumber: function() {
            return /^1\d{10}$/gi.test(this.phoneNumber);
        }
    }
};
</script>

<style scoped>
body,
.mui-content {
    background: #fff;
    position: absolute;
    width: 100%;
    /*height: 100%;*/
}

/*绑定*/
.games-btn {
    width: 85%;
    margin: 2.5rem auto 0.3rem;
    padding: 0.2rem 0;
    text-align: left;
    text-indent: 15px;
    background: #e6e6e6;
    color: #9c9c9c;
    font-size: 0.27rem;
}
.mui-input-group {
    width: 85%;
    margin: 0 auto;
}
.mui-input-group:before {
    background: none;
}
.mui-input-group:after,
.mui-input-group .mui-input-row:after {
    background: none;
}
.binding .mui-input-row .mui-btn + input,
.binding .mui-input-row label + input,
.binding .mui-input-row:last-child {
    /*background: #e6e6e6;*/
}
.binding-btn,
.register-btn {
    /*background: #e6e6e6;
	border: 1px solid #ccc;*/
    margin-bottom: 0.3rem;
}
.binding-btn label {
    width: 20%;
}
.binding-btn input,
.binding-btn label ~ input,
.binding-btn label ~ select,
.binding-btn label ~ textarea {
    width: 100%;
    font-size: 0.27rem;
}
.login-btn {
    width: 90%;
    margin: 0.5rem auto 0.2rem;
    padding: 0.2rem 0;
    background: #ff8020;
    font-size: 0.29rem;
    font-weight: bold;
    border-color: #ff8020;
}
.logo {
    width: 2.75rem;
    height: 1.36rem;
    margin: 0 auto 1rem;
    float: none;
}

/*登录*/
.login {
    margin-top: 1.25rem;
    text-align: center;
}
.register-btn label {
    width: 12%;
    padding: 7px 8px;
}
.register-btn input,
.register-btn label ~ input,
.register-btn label ~ select,
.register-btn label ~ textarea {
    width: 87.5%;
    font-size: 0.3rem;
}
.register-btn label .icon {
    color: #9c9c9c;
}
.link-area {
    margin-top: 0.4rem;
    text-align: center;
    font-size: 0.26rem;
}
.link-area a {
    color: #9c9c9c;
}
.others {
    width: 40%;
    position: absolute;
    text-align: center;
    bottom: 1rem;
    left: 30%;
    /*background: #000;*/
}
.others a {
    margin: 0rem 0.2rem;
}
.others a .mui-icon {
    font-size: 0.7rem;
    color: #0078ff;
    margin-top: 0.3rem;
}

/*注册*/
.mui-content-padded h6 {
    width: 90%;
    margin: 8px auto 0;
    text-align: left;
}
.mui-icon-extra-calc {
    font-size: 23px;
    vertical-align: 0;
    line-height: 1.1;
}
.code {
    width: 100%;
    overflow: hidden;
}
.code .register-btn {
    width: 70%;
    float: left;
}
.code .register-btn label {
    width: 18%;
}
.code .register-btn input,
.code .register-btn label ~ input {
    width: 82%;
}
.code-btn {
    width: 27%;
    height: 40px;
    line-height: 38px;
    float: right;
    padding: 0;
    font-size: 0.26rem;
    background: none;
    border: none;
    color: #ff8020;
}
</style>