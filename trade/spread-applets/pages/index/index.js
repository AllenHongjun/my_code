//index.js
//获取应用实例
const app = getApp()

Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo')
  },
  //事件处理函数
  bindViewTap: function () {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  getUserInfo: function (e) {
    console.log(e)
    app.globalData.userInfo = e.detail.userInfo
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },
  //通知栏滚动效果
  onLoad(e) {
    
    this.setData({
      msgList: [{
          image: "/assets/images/avatar.png",
          title: "木*妞通过推广福利获取赏金80元"
        },
        {
          image: "/assets/images/avatar.png",
          title: "西*子crazy通过推广福利获取赏金80元"
        },
        {
          image: "/assets/images/avatar.png",
          title: "木*妞通过推广福利获取赏金80元"
        }
      ]
    });
  },
  btnTuiguang: function (e) {
   
    wx.navigateTo({
      url: '/pages/game-info/game-info'
    })
  },
  onGetContact: function (e) {
    console.log(e);
  },
  //从网络上获取图片资源保存到本地
  getShareImg: function () {
    wx.showModal({
      title: '提示',
      content: '这是一个模态弹窗',
     
    })
    this.setData({
      windowWidth: 375
    })
    var that = this;
    wx.downloadFile({
      url: "https://www.39y.com/down/img/gyy.jpg",
      success: function (res) {
        //保存背景图片
        that.setData({
          bgcImg: res.tempFilePath
        })
        //获取二维码图片
        wx.downloadFile({
          url: "https://www.39y.com/templates/main/img/index/wx.jpg",
          success: function (res2) {
            that.setData({
              qrcodeImgTemp: res2.tempFilePath
            })
            that.drawImage();
            wx.showLoading();
            //将画布转化为图片
            setTimeout(function(){
              that.canvasToImage();
            },300)
            //导出图片
          }
        })
      }
    })
  },
  //在canvas 上绘制图片
  drawImage: function () {
    var that = this;
    var qrPath = that.data.qrcodeImgTemp;
    var shareBg = that.data.bgcImg;
    var windowWidth = that.data.windowWidth;
    that.setData({
      scale: 1.6
    })
    var ctx = wx.createCanvasContext("myCanvas");
    //绘制背景图片
    ctx.drawImage(shareBg, 0, 0, windowWidth, windowWidth * that.data.scale);
    ctx.drawImage(qrPath, 0.64 * windowWidth / 2, 1.1* windowWidth, 0.36 * windowWidth, 0.36 * windowWidth)
    ctx.draw();
  },
  //将canvas 转化为图片并且保存到本地
  canvasToImage: function () {
    var that = this;
    wx.canvasToTempFilePath({
      x: 0,
      y: 0,
      width: that.data.windowWidth,
      height: that.data.windowWidth * that.data.scale,
      destWidth: that.data.windowWidth ,
      destHeight: that.data.windowWidth * that.data.scale,
      canvasId: 'myCanvas',
      success: function (res) {
        wx.hideLoading();
        console.log('朋友圈分享图生成成功:' + res.tempFilePath)
        // wx.previewImage({
        //   current: res.tempFilePath, // 当前显示图片的http链接
        //   urls: [res.tempFilePath] // 需要预览的图片http链接列表
        // })

        wx.saveImageToPhotosAlbum({
          filePath: res.tempFilePath,
          success: function () {
            wx.showToast({
              title: '已经保存到相册'
            })
          }
        })

      },
      fail: function (err) {
        console.log('失败')
        console.log(err)
      }
    })
  }

})