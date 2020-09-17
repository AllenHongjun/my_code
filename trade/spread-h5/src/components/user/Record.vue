<template>
	<div class="mui-content record">
		<div class="month">
			<h6>2018年&nbsp;9月</h6>
			<ul class="mui-table-view">
				<li class="mui-table-view-cell" v-for="item in spreadList" :key="item.rowid">
					<span class="mui-media-object mui-pull-left shouyi">益</span>
					<div class="mui-media-body">
						{{ item.taskname}}
						<p class='mui-ellipsis'>{{ item.taskdate}}</p>
					</div>
					<span class="mui-badge yellow">+{{ item.mypoints }}</span>
				</li>
				
			</ul>
		</div>
		<div class="month">

			<!-- 如何向组件内部传值。灵活使用mint-ui插件 -->
			<!-- <mt-loadmore :top-method="loadTop" :bottom-method="loadBottom" :bottom-all-loaded="allLoaded" ref="loadmore">
				<ul>
					<li v-for="item in list" :key="item.id">{{ item }}</li>
				</ul>
			</mt-loadmore> -->

			<h6>2018年&nbsp;8月</h6>
			<ul class="mui-table-view">
				<li class="mui-table-view-cell">
					<span class="mui-media-object mui-pull-left shouyi">益</span>
					<div class="mui-media-body">
						完成"圣手捕鱼"推广收益
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge yellow">+2.00</span>
				</li>
				<!-- <li class="mui-table-view-cell">
					<span class="mui-media-object mui-pull-left tixian">提</span>
					<div class="mui-media-body">
						提现
						<p class='mui-ellipsis'>2018-09-20</p>
					</div>
					<span class="mui-badge green">-10.00</span>
				</li> -->

			</ul>
		</div>
	</div>
</template>

<script>
import { Loadmore,Toast } from "mint-ui";

export default {
    data() {
        return {
            list: {
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1,
                id: 1
            },
			spreadList: [], //推广成功记录列表
			uid:0,
			pageIndex:0,
			pageSize:10,
			// 类别，2:已完成，3:未完成，4：全部
			type:4,
			//	用户登陆session
			skey:'',
        };
    },
    created() {
		this.getSpreadList();
	},
    methods: {
        loadTop() {
            // this.$refs.loadmore.onTopLoaded();
        },
        loadBottom() {
            // this.allLoaded = true; // 若数据已全部获取完毕
            // this.$refs.loadmore.onBottomLoaded();
        },
        getSpreadList() {
			var user = JSON.parse(localStorage.getItem("dt_userinfo") || '[]');
			this.uid = user[0].uid;
			this.skey = user[0].sessionid;
            this.$http
                .post("task/mytasklist", {
                    uid: this.uid,
                    pageindex: this.pageIndex,
                    pagesize: this.pageSize,
                    type: this.type,
                    skey: this.skey
                })
                .then(result => {
					if(result.body.state === 1){
						console.log(result.body);
						this.spreadList = result.body.result.list;
					}else if(result.body.resultcode == 403){
                        //统一403的错误用户需要重新登录
                        this.$router.push("/user/login");
                        localStorage.setItem("dt_userinfo","[]");
                        Toast(result.body.errordes);
                    }else{
						Toast(result.body.errordes);
					}
				});
        }
    }
};
</script>

<style scoped>
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
</style>
