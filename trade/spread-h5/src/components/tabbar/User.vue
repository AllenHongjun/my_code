<template>
    <div>
        <div class="mui-content">
            <!-- 个人信息  开始-->
            <div class="info">
                <div class="tx"><img :src="user.faceurl == '' ? '../../src/static/img/tx.jpg':user.faceurl" width="100%" /></div>
                <div class="name">{{  user.nick }}</div>
            </div>
            <!-- 个人信息  结束-->

            <!-- 钱包  开始-->
            <div class="wallet">
                <div class="income">
                    <p class="title">累计获得赏金（元）</p>
                    <span>{{ user.balance}}</span>
                </div>
                <div style="width: 1px;height:0.5rem;background:#fcb54d;"></div>
                <div class="income">
                    <p class="title">今日收入（元）</p>
                    <span>0.00</span>
                </div>
            </div>
            <!-- 钱包  结束-->

            <!--面包屑   开始-->
            <div class="nav">
                <div class="mui-bar mui-segmented-control">
                    <router-link class="mui-control-item1" to="/user/forward">
                        <svg class="mui-icon icon" aria-hidden="true">
                            <use xlink:href="#icon-zhinan"></use>
                        </svg>
                        <br /> 我要提现
                    </router-link>
                    <router-link class="mui-control-item1" to="/user/login">
                        <svg class="mui-icon icon" aria-hidden="true">
                            <use xlink:href="#icon--"></use>
                        </svg>
                        <br /> 我的卡包
                    </router-link>
                    <router-link class="mui-control-item1" to="/user/income">
                        <svg class="mui-icon icon" aria-hidden="true">
                            <use xlink:href="#icon-maichu2"></use>
                        </svg>
                        <br /> 收入查询
                    </router-link>
                    <router-link class="mui-control-item1" to="/user/record">
                        <svg class="mui-icon icon" aria-hidden="true">
                            <use xlink:href="#icon-lianxi-"></use>
                        </svg>
                        <br /> 记录查询
                    </router-link>
                </div>
            </div>
            <!--面包屑   结束-->
        </div>

        <div class="mui-content" style="margin-top: 0.2rem;padding-bottom: 0;">
            <ul class="mui-table-view activity">
                <li class="mui-table-view-cell">
                    <router-link href="javascript:;" class="mui-navigate-right" to="/user/loadmore">
                        <svg class="mui-icon icon" aria-hidden="true">
                            <use xlink:href="#icon-qiandao"></use>
                        </svg>
                        签到抽奖
                    </router-link>
                </li>
            </ul>
        </div>
    </div>

</template>

<script>
export default {
    data() {
        return {
            user:{}
        };
    },
    created() {
         this.userIsLogin();
    },
    methods: {
        userIsLogin(){
            //如果本地没有保存过用户信息就挑战登录页面
            var userinfo = JSON.parse(localStorage.getItem('dt_userinfo') || '[]');
            if( userinfo.length <= 0) {
                this.$router.push('/user/login');
            }else{
                console.log(userinfo)
                this.user = userinfo[0];
            }
        }
    }
};
</script>

<style scoped>

.nav .mui-segmented-control .mui-control-item1[data-v-1a30cb1c] {
    border: 0;
    color: #666;
}

.mui-segmented-control .mui-control-item1:first-child {
    border-left-width: 0;
}

.mui-segmented-control .mui-control-item1 {
    line-height: 38px;
    display: table-cell;
    overflow: hidden;
    width: 1%;
    -webkit-transition: background-color .1s linear;
    transition: background-color .1s linear;
    text-align: center;
    white-space: nowrap;
    text-overflow: ellipsis;
    color: #007aff;
    border-color: #007aff;
    border-left: 1px solid #007aff;
}


.mui-content {
    background: #fff;
}
.mui-bar-tab ~ .mui-content {
    padding-bottom: 0.15rem;
}
.info {
    background: url(../../static/img/my_bg.jpg) no-repeat center;
    background-size: cover;
    margin-top: 0.78rem;
    padding-top: 0.3rem;
    height: 3.5rem;
}
.tx {
    width: 1.5rem;
    height: 1.5rem;
    margin: 0.25rem auto 0.25rem;
    border: 4px solid #ffedcb;
    border-radius: 50%;
    overflow: hidden;
}
.name {
    text-align: center;
    color: #fff;
    font-size: 0.3rem;
    margin-bottom: 0.2rem;
}

/* 钱包 */
.wallet {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 0.5rem;
    /* flex-wrap: wrap; */
    /* align-content:flex-start; */
}
.wallet .income {
    width: 50%;
    color: #ff8020;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    align-content: flex-start;
}
.wallet .income span {
    width: 100%;
    font-size: 0.36rem;
    margin: 0.07rem 0;
}
.wallet .income p {
    color: #ff8020;
    font-size: 0.28rem;
}

/*面包屑*/
.nav {
    background: #fff;
}
.nav .mui-segmented-control .mui-control-item {
    border: 0;
    color: #666;
}
.nav .mui-segmented-control .mui-control-item .icon {
    color: #000;
}
.nav .mui-segmented-control {
    border: 0;
    font-size: 0.28rem;
    margin: 0rem 0 0.15rem;
    padding: 0.2rem 0px 0.1rem;
}
.nav .mui-bar {
    box-shadow: none;
}
.nav .mui-bar .mui-icon {
    font-size: 1rem;
    padding: 0;
}
.nav .mui-segmented-control .mui-control-item.mui-active {
    background: none;
}
.nav .icon {
    vertical-align: -0.2em;
}
.nav .mui-bar .mui-icon.wallet {
    font-size: 0.3rem;
    color: #f5ac3a;
    font-weight: bold;
    top: -0.15rem;
}

/* 活动 */
.activity {
    font-size: 0.27rem;
}
.activity .icon {
    vertical-align: -0.32em;
}
@media (max-width: 375px) {
    .activity .icon {
        vertical-align: -0.35em;
    }
}
@media (max-width: 320px) {
    .activity .icon {
        vertical-align: -0.4em;
    }
}
.mui-table-view:after {
    background: #fff;
}

.activity li a .icon {
    font-size: 30px;
    margin-right: 5px;
}
</style>