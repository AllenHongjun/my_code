<template>

    <!--底部导航   结束-->
    <div class="mui-content">
        <div class="notice">
            <ul class="news_li">
                <li><img src="../../static/img/avatar.png" class="swiper_img" />
                    <p>木*妞通过推广福利获取赏金80元</p>
                </li>
                <li><img src="../../static/img/avatar.png" class="swiper_img" />
                    <p>西*子crazy通过推广福利获取赏金80元</p>
                </li>
                <li><img src="../../static/img/avatar.png" class="swiper_img" />
                    <p>木*妞通过推广福利获取赏金80元</p>
                </li>
                <li><img src="../../static/img/avatar.png" class="swiper_img" />
                    <p>444</p>
                </li>
                <li><img src="../../static/img/avatar.png" class="swiper_img" />
                    <p>555</p>
                </li>
            </ul>
        </div>

        <!--轮播   开始-->
        <div class="mui-slider">
            <div id="slider" class="mui-slider">
                <div class="mui-slider-group mui-slider-loop">
                    <!-- 额外增加的一个节点(循环轮播：第一个节点是最后一张轮播) -->
                    <div class="mui-slider-item mui-slider-item-duplicate">
                        <a href="#">
                            <img src="../../static/img/pic/banner3.jpg">
			  	      </a>
                    </div>
                    <!-- 第一张 -->
                    <div class="mui-slider-item">
                        <a href="#">
                            <img src="../../static/img/pic/banner1.jpg">
			  	      </a>
                    </div>
                    <!-- 第二张 -->
                    <div class="mui-slider-item">
                        <a href="#">
                            <img src="../../static/img/pic/banner2.jpg">
			  	      </a>
                    </div>
                    <!-- 第三张 -->
                    <div class="mui-slider-item">
                        <a href="#">
                            <img src="../../static/img/pic/banner3.jpg">
			  	      </a>
                    </div>
                    <!-- 额外增加的一个节点(循环轮播：最后一个节点是第一张轮播) -->
                    <div class="mui-slider-item mui-slider-item-duplicate">
                        <a href="#">
                            <img src="../../static/img/pic/banner1.jpg">
			  	      </a>
                    </div>
                </div>
                <div class="mui-slider-indicator">
                    <div class="mui-indicator mui-active"></div>
                    <div class="mui-indicator"></div>
                    <div class="mui-indicator"></div>
                </div>
            </div>
        </div>
        <!--轮播   结束-->

        <ul class="mui-table-view">
            <router-link v-for="item in taskList" :key="item.id" class="mui-table-view-cell mui-media card" tag="li" :to="'game/gameinfo/'+item.id">
                <img class="mui-media-object mui-pull-left card-pic" :src=" item.icon ">
                <div class="mui-media-body card-desc">
                    <span>{{ item.name }}</span>
                    <p class="mui-ellipsis">游戏类型：<b>{{ item.introduce }} </b></p>
                    <p class="mui-ellipsis">购买价格：<b>0</b></p>
                    <p class="mui-ellipsis">结束时间：<b>2018-08-31</b></p>
                    <p class="mui-ellipsis">剩余赏金：<b>282020元/450000元</b></p>
                </div>
                <div class="card-bottom">
                    <p class="card-price">赚 {{ item.reward }}元<text>&nbsp;/&nbsp;推荐注册成功</text></p>
                    <button type="button" class="mui-btn buttonTg">立即推广</button>
                </div>
            </router-link>

            <p v-show="loading" class="page-infinite-loading">
                <mt-spinner type="fading-circle"></mt-spinner>
                加载中...
            </p>
        </ul>
    </div>

</template>

<script>
import { Spinner } from "mint-ui";
import Jquery from "jquery";
import mui from "../../static/js/mui.min.js";
// window.jQuery = $;
// window.$ = $;

export default {
    data() {
        return {
            flag: false,
            timer: null,
            taskList: [],
            loading: true
        };
    },
    created() {
        this.getAllTask();
        this.noticeScroll();
    },
    mounted() {
        this.gallerySlide();
    },
    beforeDestroy() {
        window.clearInterval(this.timer);
    },
    methods: {
        //获取任务列表
        getAllTask() {
            var that = this;
            setTimeout(function() {
                that.$http.post("task/GetAllTask").then(result => {
                    console.log(result.body);
                    if (result.body.state === 1) {
                        console.log(result.body.result.list);
                        that.taskList = result.body.result.list;
                    } else {
                        // Toast("数据加载失败");
                    }
                    that.loading = false;
                });
            }, 1000);
        },
        //公告信息滚动
        noticeScroll() {
            var that = this;
            this.timer = window.setInterval(function() {
                that.noticeUp(".notice ul", "-0.7rem", 500);
            }, 2000);
        },

        noticeUp(obj, top, time) {
            Jquery(obj).animate(
                {
                    marginTop: top
                },
                time,
                function() {
                    Jquery(this)
                        .css({ marginTop: "0" })
                        .find(":first")
                        .appendTo(this);
                }
            );
        },
        gallerySlide() {
            console.log(3);
            //获得轮播slider插件对象
            var gallery = mui(".mui-slider");
            gallery.slider({
                interval: 2500 //自动轮播周期，若为0则不自动播放，默认为0；
            });
        }
    }
};
</script>

<style scoped>
.mui-table-view {
    background: none;
    position: relative;
}
.card {
    padding-top: 0.3rem;
    margin-bottom: 0.2rem;
    background: #fff;
}
.mui-table-view .mui-media-object.card-pic {
    width: 2.15rem;
    height: 2.15rem;
    background: #fff;
    max-width: none;
    margin-right: 0.25rem;
    margin-left: -0.1rem;
}
.card-desc {
    font-size: 0.26rem;
    color: #000;
    line-height: 0.44rem;
}
.card-desc span {
    font-size: 0.34rem;
}
.card-desc p {
    color: #999;
}
.card-desc p b {
    color: #858585;
    font-weight: normal;
}

.card-bottom {
    /*width:6.90rem;*/
    margin: 0.25rem 0 0.1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    /* background: #06BF04; */
    /* height: 50rem; */
}
.card-price {
    color: #cd4331;
    font-size: 0.34rem;
}
.card-price > text {
    font-size: 0.26rem;
    color: #7d7d7d;
}
.card-bottom .buttonTg {
    background: #ff8020;
    color: #fff;
    width: 1.5rem;
    height: 0.52rem;
    line-height: 0.52rem;
    text-align: center;
    padding: 0;
    border: 0;
    font-size: 0.25rem;
}

/*通告栏*/
.swiper_img {
    float: left;
    width: 0.45rem;
    height: 0.45rem;
    margin: 0.12rem 0.15rem 0 0.25rem;
}
.notice {
    width: 100%;
    margin: 0;
    /* line-height: 0.7rem;*/
    background: #fefcee;
    color: #e77639;
    height: 0.7rem;
    overflow: hidden;
}
.news_li {
    margin: 0;
    padding: 0;
}
.notice ul li {
    display: block;
    height: 0.7rem;
    list-style: none;
    line-height: 0.75rem;
    display: block;
    /*margin-left: -0.5rem;*/
    font-size: 0.22rem;
}
.news_li p {
    float: left;
    color: #e77639;
}
.notice li:first-child {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}


/*************/
.page-infinite-loading {
    position: absolute;
    left: 50%;
    width: 60px;
    height: 50px;
    margin-left: -30px;
}
</style>