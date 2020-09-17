// pages/user/user.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    hasUserInfo: false
  },
  getUserInfo: function () {
    //0. 这种方式授权登入不会跳出弹框
    this.login();
  },

  login: function () {
    let that = this;
    // 封装一个 ajaxneedlogin 的请求处理方法。
    
    // 页面加载的时候单独判断一下 是否已经登录
    // let that = this;
    // let userInfo = wx.getStorageSync('userInfo')
    // if (!userInfo) {
    //   wx.navigateTo({
    //     url: "/pages/authorize/index"
    //   })
    // } else {
    //   that.setData({
    //     userInfo: userInfo,
    //     version: app.globalData.version
    //   })
    // }

    // let token = wx.getStorageSync('token') ;
    // if (token) {
    //   wx.request({
    //     url: app.globalData.apiDomain + '/user/check-token',
    //     data: {
    //       token: token
    //     },
    //     method:"POST",
    //     header: {
    //       'content-type': 'application/x-www-form-urlencoded' // 默认值
    //     },
    //     success: function (res) {
    //       if (res.data.code != 0) {
    //         wx.removeStorageSync('token')
    //         that.login();
    //       } else {
    //         // 回到原来的地方放
    //         wx.navigateBack();
    //       }
    //     }
    //   })
    //   return;
    // }
    wx.login({
      success: function (res) {
        //1. 第一步返回code
        console.log(res);
        wx.request({
          url: app.globalData.apiDomain + '/account/login',
          data: {
            code: res.code
          },
          method: "POST",
          success: function (res) {
            //console.log(res);
            wx.setStorageSync('sessionid', res.data.result.sessionid)
            that.registerUser();
            if (res.data.resultcode != 200) {
              // 登录错误
              wx.hideLoading();
              wx.showModal({
                title: '提示',
                content: '无法登录，请重试',
                showCancel: false
              })
              return;
            }


          }
        })
      }
    })
  },
  //即是注册 也是登录验证接口
  registerUser: function () {
    var that = this;
    wx.getUserInfo({
      success: function (res) {
        console.log(res);
        app.globalData.userInfo = res.userInfo

        var iv = res.iv;
        var encryptedData = res.encryptedData;
        var compareSignature = res.signature;
        var rawData = res.rawData;
        var sessionid = wx.getStorageSync('sessionid');
        // 下面开始调用注册接口
        wx.request({
          url: app.globalData.apiDomain + '/account/Register',
          data: {
            encryptedData: encryptedData,
            iv: iv,
            compareSignature: compareSignature,
            rawData: rawData,
            sessionid: sessionid
          }, // 设置请求的 参数
          method: "POST",
          header: {
            'content-type': 'application/x-www-form-urlencoded' // 默认值
          },
          success: (res) => {
            //console.log(res);
            wx.hideLoading();

            //存储和保存登录状态
            //wx.setStorageSync('token', res.data.data.token)
            wx.setStorageSync('uid', res.data.result.uid)
            // 回到原来的地方放
            wx.navigateBack();
            console.log("back");
          }
        })
      }
    })
  },

  /**
   * 
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {},

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {

  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {

  }
})