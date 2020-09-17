<template>
    <div class="mui-content">
			<div class="money"><h1>12.56</h1>&nbsp;&nbsp;元</div>
			<!--提现框   开始-->
			<div class="box">
				<h3>提现到微信钱包</h3>
				<form>
					<span>￥</span>
					<input type="text" placeholder="最低1元起提"/>
					<button type="button" class="mui-btn mui-btn-warning mui-btn-outlined">全部</button>
					<div class="clear"></div>
				</form>
				<input type="text" placeholder="填写手机号" class="phone"/>
			</div>
			<div class="tips">*&nbsp;提现免手续费，预计1个工作日内到账</div>
			<!--提现框   结束-->
			<a href="#" class="txBtn">立即提现</a>
		</div>
</template>


<script>
    export default {

    }
</script>


<style scoped>
.money{
	text-align: center;
	padding: 0.85rem 0;
	font-size: 0.3rem;
}
.money h1{
	display:inline;
}

.box{
	width: 6.6rem;
	height: 3.7rem;
	background: #fff;
	margin: 0 auto;
	border-radius: 8px;
	padding: 0.3rem 0.3rem 0;
}
.box h3{
	font-size: 0.3rem;
	text-align: center;
	color: #333;
	margin-bottom: 0.5rem;
}
.box form input,.box form button,.box form span{
	float: left;
	vertical-align: middle;
	height: 0.65rem;
}
.box form span{
	font-weight: bold;
	font-size: 0.5rem;
	margin-top: 0.1rem;
}
.box form input{
	width: 4.2rem;
	border: 0;
	font-size: 0.34rem;
}
.box form button{
	padding: 0rem 0.35rem;
	height: 0.58rem;
	border-color: #ff8020;
}
.box .mui-btn-outlined.mui-btn-warning, .mui-btn-outlined.mui-btn-yellow{
	color: #ff8020;
}
.phone{
	background: #f0f0f0!important;
	border: 0!important;
	margin-top: 0.35rem;
	color: #333!important;
}
.tips{
	width: 6.5rem;
	margin: 0 auto;
	color: #8e8e8e;
	font-size: 0.24rem;
	margin-top: 0.15rem;
	list-style: disc;
}
.txBtn{
	display: block;
	text-align: center;
	width: 6.6rem;
	height: 0.8rem;
	line-height: 0.85rem;
	margin: 0.6rem auto 0;
	background: #FFC040;
	border-radius: 1rem;
	color: #390a00;
	font-weight: bold;
}

</style>

