<template>
	<!--头部   结束-->

	<div class="container">
		<div class="mui-content">
			<ul class="mui-table-view">
				<li class="mui-table-view-cell mui-media total">
					<a href="javascript:;">
						<div class="mui-media-body">
							账户余额:<span class="yellow">￥85.00</span>
							<p class='mui-ellipsis'>累计收入：￥115.00</p>
						</div>
						<router-link class="mui-badge mui-badge-primary mui-badge-inverted" tag="span" to="/user/forward">
							<button type="button" class="mui-btn">提现</button>
						</router-link>
					</a>
				</li>
			</ul>
		</div>

		<div class="mui-content income" ref="wrapper" :style="{ height: wrapperHeight + 'px'}">

			<ul class="mui-table-view" v-infinite-scroll="loadMore" infinite-scroll-disabled="loading" infinite-scroll-distance="50">
				<li class="mui-table-view-cell" v-for="item in list" :key="item.id">
					<div class="mui-media-body">
						完成"圣手捕鱼"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+2.00</span>
				</li>
				<!-- <li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"圣手捕鱼"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+2.00</span>
				</li>
				
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"圣手捕鱼"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+2.00</span>
				</li> -->
			</ul>
			<p v-show="loading" class="page-infinite-loading">
				<mt-spinner type="fading-circle"></mt-spinner>
				加载中...
			</p>
			<!-- <mt-loadmore :top-method="loadTop" :bottom-method="loadBottom" :bottom-all-loaded="allLoaded" ref="loadmore">
			</mt-loadmore> -->

			<!-- <ul class="mui-table-view">
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"圣手捕鱼"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+2.00</span>
				</li>
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						签到抽奖
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+10.00</span>
				</li>
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"39Y游戏中心"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+10.00</span>
				</li>
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"圣手捕鱼"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+2.00</span>
				</li>
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						签到抽奖
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+10.00</span>
				</li>
				<li class="mui-table-view-cell">
					<div class="mui-media-body">
						完成"39Y游戏中心"推广任务
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge">+10.00</span>
				</li>
			</ul> -->
		</div>
	</div>

</template>

<script>
import { Loadmore, InfiniteScroll ,Spinner} from "mint-ui";

export default {
    data() {
        return {
            list: [],
            loading: false,
            allLoaded: false,
            wrapperHeight: 0
        };
    },

    methods: {
        loadMore() {
            this.loading = true;
            setTimeout(() => {
                let last = this.list[this.list.length - 1];
                for (let i = 1; i <= 10; i++) {
                    this.list.push(last + i);
                }
                this.loading = false;
            }, 2500);
        }
    },

    mounted() {
        this.wrapperHeight =
            document.documentElement.clientHeight - 80;
            // this.$refs.wrapper.getBoundingClientRect().top;
        for (let i = 1; i <= 20; i++) {
            this.list.push(i);
        }
    }
};
</script>

<style scoped>
.container {
    padding: 5px 0 1rem 0;
    height: 100%;
    overflow: scroll;
}

.total {
    padding: 0.25rem 15px 0.22rem;
    font-size: 0.34rem;
}
.total button {
    background: #ff8020;
    color: #fff;
    border: none;
    padding: 0.12rem 0.4rem;
    font-size: 0.29rem;
    border-radius: 4px;
}
.total p {
    margin-top: 0.12rem;
    font-size: 0.28rem;
}
.total .yellow {
    margin-left: 5px;
}

/*收入记录*/
.income {
    margin-top: -0.12rem;
	font-size: 0.28rem;
	position: relative;
	overflow:scroll;
}
.income ul,
.record ul {
    padding-top: 0.06rem;
}
.income p,
.record p {
    margin-top: 0.08rem;
}
.income .mui-badge {
    background: none;
    color: #ff8020;
    font-size: 0.28rem;
}

/*记录查询*/
.record h6 {
    padding: 0.2rem 0 0.2rem 15px;
    font-size: 0.24rem;
}
.record .shouyi,
.record .tixian {
    width: 0.7rem;
    height: 0.7rem;
    line-height: 0.75rem;
    border-radius: 16px;
    text-align: center;
    color: #fff;
}
.record .mui-table-view .mui-media-object.mui-pull-left {
    margin-right: 0.25rem;
}
.shouyi {
    background: #ff8020;
}
.tixian {
    background: #ffc040;
}
.record .mui-badge {
    background: none;
    font-size: 0.28rem;
}

/* 加载中图标居中 */
.page-infinite-loading {
    position: absolute;
    left: 50%;
    width: 60px;
    height: 50px;
    margin-left: -30px;
}

        
</style>

