<template>
	<div class="app-container">
		<!-- <div>
			<h1>Hello XiaoHu</h1>
			<button id="wxLogin" @click="authorize('weixin')">微信登录</button>
		</div> -->
		<!-- mui-action-back -->
		<div class="top">
			<header class="mui-bar mui-bar-nav">
				<a @click="goBack" v-show="flag" class=" mui-icon mui-icon-left-nav mui-pull-left icon-back"></a>
				<h1 class="mui-title">推广中心</h1>
			</header>
		</div>
		<nav class="mui-bar mui-bar-tab">
			<router-link class="mui-tab-item1" to="/home">
				<svg class="mui-icon icon" aria-hidden="true">
					<use xlink:href="#icon-shouye"></use>
				</svg>
				<span class="mui-tab-label">首页</span>
			</router-link>
			<router-link class="mui-tab-item1" to="/user">
				<svg class="mui-icon icon icon-wode" aria-hidden="true">
					<use xlink:href="#icon-qianbao"></use>
				</svg>
				<span class="mui-tab-label">结算中心</span>
			</router-link>
		</nav>

		<transition>
			<router-view></router-view>
		</transition>
	</div>

</template>

<script>
export default {
    data() {
        return {
            flag: false
        };
    },
    created() {
        this.flag = this.$route.path === "/home" ? false : true;

        //rem 布局初始化
        !(function(n) {
            var e = n.document,
                t = e.documentElement,
                i = 750,
                d = i / 100,
                o = "orientationchange" in n ? "orientationchange" : "resize",
                a = function() {
                    var n = t.clientWidth || 320;
                    n > 750 && (n = 750);
                    t.style.fontSize = n / d + "px";
                };
            e.addEventListener &&
                (n.addEventListener(o, a, !1),
                e.addEventListener("DOMContentLoaded", a, !1));
        })(window);
    },
    methods: {
        goBack() {
			console.log(this.$router)
            this.$router.back();
        },
        getUserInfo() {}
    },
    watch: {
        "$route.path": function(newVal) {
            if (newVal === "/home" || newVal == "/user/login") {
                this.flag = false;
            } else {
                this.flag = true;
            }
        }
    }
};

/*export default {
		data() {
			return {
				auths: null,
				aweixin: null,
				photoinfo: {}, // 图片详情
				list: [] // 缩略图的数组
			};
		},
		created() {
				this.wxLoginInit();
		},
		methods: {
			wxLoginInit: function() {				
				var that = this;
				document.addEventListener("plusready", function() {
					// 扩展API加载完毕，现在可以正常调用扩展API
					plus.oauth.getServices(function(services) {
						that.auths = services;
						that.aweixin = services['weixin'];
//						console.log(JSON.stringify(services));
					}, function(e) {
						alert("获取分享服务列表失败：" + e.message + " - " + e.code);
					});
				}, false);
			},
			authorize: function(type="weixin") {
						alert("111");
							if(!this.aweixin){
								alert("当前环境不支持微信登录");
								return;
							}
						alert("222");
				var s;
				console.log(JSON.stringify(this.auths));
				console.log(type);
				for(var i = 0; i < this.auths.length; i++) {
					if(this.auths[i].id == type) {
						s = this.auths[i];
						break;
					}
				}
				
				console.log(JSON.stringify(this.aweixin))
				this.aweixin.authorize(function(e) {
					alert("授权成功：" + JSON.stringify(e));
				}, function(e) {
					alert("授权失败：" + JSON.stringify(e));
				}, {
					scope: 'snsapi_userinfo',
					state: 'authorize test',
					appid: 'wx3c4935f7dbde9928'
				});
			}

		},
		components: {
			// 用来注册子组件的节点
			"app-box": app
		}
	}
*/
/*var auths = null;
	var aweixin = null;
	// 监听plusready事件  
	document.addEventListener("plusready", function() {
		// 扩展API加载完毕，现在可以正常调用扩展API
		plus.oauth.getServices(function(services) {
			auths = services;
			aweixin = services['weixin'];
			console.log(JSON.stringify(services));
		}, function(e) {
			alert("获取分享服务列表失败：" + e.message + " - " + e.code);
		});
	}, false);
	// 授权操作
	function authorize(type) {
		//			if(!aweixin){
		//				alert("当前环境不支持微信登录");
		//				return;
		//			}

		var s;
		for(var i = 0; i < auths.length; i++) {
			if(auths[i].id == type) {
				s = auths[i];
				break;
			}
		}
		console.log(JSON.stringify(s));
		s.authorize(function(e) {
			alert("授权成功：" + JSON.stringify(e));
		}, function(e) {
			alert("授权失败：" + JSON.stringify(e));
		}, {
			scope: 'snsapi_userinfo',
			state: 'authorize test',
			appid: 'WX**********'
		});
	}

	//给按钮绑定微信登录点击事件
	document.getElementById('wxLogin').addEventListener('tap', function() {
		authorize('weixin');
	})
*/
//终端支持的权登录认证服务列表
/*var auths = null;
	var device = null;
		
	//取终端支持的权登录认证服务列表，可用于提示用户进行登录平台的选择
	mui.plusReady(function() {
		localStorage.setItem("trade_userinfo", "");
		device = plus.device;
		plus.oauth.getServices(function(services) {
			auths = services;
			
		}, function(e) {
			console.log(JSON.stringify(e));
		});

		//已经登录的用户直接跳转到首页
		if(localStorage.getItem("trade_userinfo") != "") {
			mui.openWindow({
				id: plus.runtime.appid,
			})
		}
	})
		
	//给按钮绑定微信登录点击事件
	document.getElementById('wxLogin').addEventListener('tap', function() {
		authLogin('weixin');
	})

		
	//微信登录 获取access_token 成功之后跳转
	function authLogin(type) {
		plus.nativeUI.showWaiting("登录中...");
		var s;
		console.log(JSON.stringify(s));
		for(var i = 0; i < auths.length; i++) {
			if(auths[i].id == type) {
				s = auths[i];
				break;
			}
		}
		
		//授权认证结果数据 如果没有授权登录过
		if(!s.authResult) {
			s.login(function(e) {
				var result = e.target.authResult;
				console.log("登录认证成功：" + JSON.stringify(result));
				mui.post(Trade.API_URL + "/account/wxapplogin", {
					token: result.access_token,
					openid: result.openid,
					mac: device.uuid
				}, function(data) {
					//console.log(JSON.stringify(data))
					if(data.resultcode == 200){											
						localStorage.setItem("trade_userinfo", JSON.stringify(data.result));
						//登录成功之后重新刷新一下首页
						var h = plus.webview.getLaunchWebview();
						mui.fire(h, 'refresh');
						if(plus.webview.getWebviewById('pages/user-center.html')) {
							mui.fire(h, 'refreshSub');
						}
						mui.openWindow({
							id: plus.runtime.appid,
						})
						plus.nativeUI.closeWaiting();
						mui.toast(data.errordes);
					}else{
						mui.toast(data.errordes)
					}
				}, 'json');
				
				
				authLogout();
			}, function(e) {
				setTimeout(function() {
					plus.nativeUI.closeWaiting();
				}, 500)
				mui.toast("登录认证失败！");
			});
		} else {
			plus.nativeUI.closeWaiting();
		}
	}
		
	//每次登录主要说获取对用平台的信息，获取之后就可以及时注销了。
	function authLogout() {
		for(var i in auths) {
			var s = auths[i];
			if(s.authResult) {
				s.logout(function(e) {
					console.log("注销登录认证成功！");
				}, function(e) {
					console.log("注销登录认证失败！");
				});
			}
		}
	}*/
</script>

<style scoped>
.app-container {
    /* padding-top: 40px; */
    overflow-x: hidden;
    
}

* {
touch-action: manipulation;
}

.v-enter {
    opacity: 0;
    transform: translateX(100%);
}

.v-leave-to {
    opacity: 0;
    transform: translateX(-100%);
    /* 避免样式切换的时候 有上下重叠 看官网 */
    position: absolute;
}
.v-enter-active,
.v-leave-active {
    transition: all 0.5s ease;
}

.app-container .top header {
    height: 44px;
}

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
</style>