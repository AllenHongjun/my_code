<template>
    <div class="container">
        <!--底部导航   开始-->
        <nav class="mui-bar mui-bar-tab pages-bottom">
            <a class="mui-tab-item1" href="#">
                <button type="button" class="mui-btn mui-btn-warning mui-btn-outlined pages-bottom1">体验游戏</button>
            </a>
            <router-link @click.native="receiveOrder" class="mui-tab-item1" to="">
                <button type="button" class="mui-btn mui-btn-warning pages-bottom2">立即接单</button>
            </router-link>
        </nav>
        <!--底部导航   结束-->
        <div class="mui-content">
            <div class="banner">
                <div class="pic">
                    <img :src="taskDetail.gameicon" width="100%" height="100%" />
                </div>
                <div class="info">
                    <h3>{{ taskDetail.name }}</h3>
                    <p>游戏类型：mmorpg</p>
                    <span>{{  taskDetail.remark  }}</span>
                </div>
            </div>
            <div class="time">
                开始时间  {{  taskDetail.startdate  }}  ~  结束时间   {{ taskDetail.enddate}}
            </div>
            <div class="intro">
                这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字这里是游戏介绍文字
            </div>
            <!--任务列表   开始-->
            <div class="mission">
                <ul>
		    		<li class="mission-item1 indent grey">游戏任务</li>
		    		<li class="mission-item2 grey">玩家奖励</li>
		    		<li class="mission-item3">我的分成</li>
		    	</ul>
                <ul v-for="item in recordList" :key="item.points">
                    <li class="mission-item1 indent grey">{{ item.taskname }}</li>
                    <li class="mission-item2 grey">{{ item.points }}</li>
                    <li class="mission-item3">{{ item.mypoints }}</li>
                </ul>
                
                <div class="clear"></div>
            </div>
            <!--任务列表   结束-->
        </div>
    </div>
</template>

<script>
import { Toast ,MessageBox  } from "mint-ui";
export default {
    data() {
        return {
            // id: this.$route.params.id, // 将 URL 地址中传递过来的 Id值，挂载到 data上，方便以后调用
            taskId: this.$route.params.id,
            pageIndex: 0, //当前页面（0代表第一页）
            taskDetail: {},  //初始化的时候这里需要赋值为空不然会报错
            recordList: {}
        };
    },
    created() {
        this.getTaskDetail();
    },
    methods: {
        //获取任务详情以及任务奖励明细
        getTaskDetail() {
            this.$http
                .post("task/gettaskdetail", {
                    id: this.taskId,
                    pageindex: this.pageIndex
                })
                .then(result => {
                    //console.log(result.body);
                    if (result.body.state === 1) {
                        this.taskDetail = result.body.result;
                        //将获取到的数据处理一下
                        var arr = result.body.result.recordlist;
                        var newArr = [];
                        for( var i = 0; i < arr.length; i++){
                            var item = arr[i];
                            item.taskname = (i+1) + ". " + item.taskname;
                            item.id = i + 1;
                            newArr.push(item);
                        }
                        this.recordList = newArr;
                    } else {
                        Toast(result.body.errordes);
                    }
                });
        },
        receiveOrder(){
            
            var user =JSON.parse(localStorage.getItem("dt_userinfo") || '[]');
            if( user.length <=0){
                this.$router.push("/user/login");
            }else{
                //发送接单的接口请求

                MessageBox({
                title: '提示',
                message: '恭喜你接单成功，因涉及到技术对接，暂时先不能推广哦~ <br>  你可以通过<a href="#">技术文档</a>了解技术需求。<br>或者加商务qq<a href="javascript:;">123213</a>咨询详情。',
                });
            }
        }
    }
};
</script>

<style scoped>
.mui-bar-tab .mui-tab-item1.mui-active {
    color: #ff8020;
}

.mui-bar-tab .mui-tab-item1 {
    display: table-cell;
    overflow: hidden;
    width: 1%;
    height: 50px;
    text-align: center;
    vertical-align: middle;
    white-space: nowrap;
    text-overflow: ellipsis;
    color: #929292;
}

.mui-bar-tab .mui-tab-item1 .mui-icon {
    top: 3px;
    width: 24px;
    height: 24px;
    padding-top: 0;
    padding-bottom: 0;
}

.mui-bar-tab .mui-tab-item1 .mui-icon ~ .mui-tab-label {
    font-size: 11px;
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
}



/*头部*/
.banner {
    width: 100%;
    height: 4.55rem;
    background: url(../../static/img/pic/pagesBg1.jpg) no-repeat;
    background-size: cover;
    position: relative;
}
.pic {
    position: absolute;
    width: 1.24rem;
    height: 1.24rem;
    left: 0.3rem;
    bottom: 0.3rem;
}
.info {
    /* float: left; */
    left: 2rem;
    bottom: 0.28rem;
    position: absolute;
}
.info h3 {
    font-size: 0.32rem;
    line-height: 0;
    margin-bottom: 0.2rem;
    color: #000;
}
.info p {
    color: #ff8020;
    font-size: 0.22rem;
    line-height: 0.36rem;
    margin: 0;
}
.info span {
    font-size: 0.28rem;
    color: #cd4331;
}

/*底部按钮*/
.pages-bottom .mui-btn {
    top: 0;
    width: 3rem;
    height: 0.6rem;
}
.mui-bar .mui-btn.pages-bottom1 {
    font-weight: bold;
    color: #ff8020;
    border-color: #ff8020;
}
.mui-bar .mui-btn.pages-bottom2 {
    background: #ff8020;
}

.time {
    font-size: 0.22rem;
    background: #fafafa;
    color: #707070;
    border-top: 1px solid #f2f2f2;
    border-bottom: 1px solid #f2f2f2;
    padding: 0.17rem 0;
    text-indent: 0.3rem;
}
.intro {
    padding: 0.3rem 0.3rem;
    font-size: 0.27rem;
    color: #333;
}

/*任务列表*/
.mission {
    background: #fff;
    text-align: center;
}
.mission ul {
    margin: 0;
    padding: 0;
    border-bottom: 1px solid #f2f2f2;
    clear: both;
}
.mission li {
    float: left;
    padding: 0.25rem 0;
    font-size: 0.26rem;
    white-space: nowrap;
}
.mission-item1 {
    width: 50%;
    text-align: left;
    color: #333;
}
.indent {
    text-indent: 0.75rem;
}
.indent2 {
    text-indent: 0.35rem;
}
.grey {
    color: #666;
}
.mission-item2 {
    width: 25%;
    color: #333;
}
.mission-item3 {
    width: 25%;
    color: #cd4331;
}
</style>
