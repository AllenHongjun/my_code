import Dialog from '../../assets/vant-weapp/dist/dialog/dialog';
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {

  },
  btnTuiguang :function(){
    var that = this
    console.log(1);
    Dialog.alert({
      // title: '提示',
      message: "点击 '确定' 按钮,向客服发送 '1' ,获取您的专属推广链接。",
      confirmButtonOpenType:"contact",
      overlay:true
    }).then(() => {
      // on close
    });

  },
  getShareImg: function () {
    this.setData({
      windowWidth: 375
    })
    var that = this;
    wx.downloadFile({
      url: app.globalData.apiDomain + "/static/img/gyy.jpg",
      success: function (res) {
        //保存背景图片
        that.setData({
          bgcImg: res.tempFilePath
        })
        //获取二维码图片
        wx.downloadFile({
          url: app.globalData.apiDomain + "/static/img/qrcode.jpg",
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
  },
  
  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

  },

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