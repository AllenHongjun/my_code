//app.js
App({
  onLaunch: function () {
    // 展示本地存储能力
    var logs = wx.getStorageSync('logs') || []
    logs.unshift(Date.now())
    wx.setStorageSync('logs', logs)
    
    // 全局需要判断一次用户是否绑定过手机号码

    var uid = wx.getStorageSync('uid') || 0 ;
    if(uid == 0 ){
      wx.navigateTo({
        url: 'pages/auth/auth'
       
      })
    }

    // 登录
    // wx.login({
    //   success: res => {
    //     // 发送 res.code 到后台换取 openId, sessionKey, unionId
    //     console.log(res);
    //     wx.request({
    //       url: 'https://test.com/onLogin',
    //       data: {
    //         code: res.code
    //       },
    //       success:res=>{
    //         console.log(res);
    //         //发送平台的账号密码 登录信息 保存到本地存储当中 验证登录
    //       }
    //     })
    //   }
    // })
    // 获取用户信息
  //   wx.getSetting({
  //     success: res => {
  //       if (res.authSetting['scope.userInfo']) {
  //         console.log(res)
  //         // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
  //         wx.getUserInfo({
  //           success: res => {
  //             // 可以将 res 发送给后台解码出 unionId
  //             this.globalData.userInfo = res.userInfo

  //             // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
  //             // 所以此处加入 callback 以防止这种情况
  //             if (this.userInfoReadyCallback) {
  //               this.userInfoReadyCallback(res)
  //             }
  //           }
  //         })
  //       }
  //     }
  //   })
  },
  globalData: {
    userInfo: null,
    apiDomain:"https://wechat.0u.com"
  }
})