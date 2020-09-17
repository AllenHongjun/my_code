/**
 * Created by 65297 on 2018/7/3.
 */

//1.默认加载搜索列表数据
//2.点击搜索功能
//3.下拉刷新功能
//4.下拉加载功能 重制参数
//5 排序方式选着

//点击选项切花 按钮搜索
//  mui('body').on('tap','.sort a', function (e) {
//      $(this).addClass('checked').siblings().removeClass('checked');
//      var dataType = $(this).attr('data-type');
//      window.params.orderType = dataType;
//      window.params.pageindex = 1;
//      /*刷新*/
//      mui('.mui-scroll-wrapper').pullRefresh().pulldownLoading();
//
//  }).on('submit','#search-form',function(e){
//
//      var searchValue = $('.mui-search input').val();
//      params.searchValue = searchValue;
//      /*刷新*/
//      mui('#refreshContainer').pullRefresh().pulldownLoading();
//      return false;
//  })
//
//点击链接跳转商品详情
mui('body').on('tap', '.list-product', function(e) {

	var hyid = this.getAttribute('data-hyid');
	//console.log('hyid');
	mui.openWindow({
		'url': 'product-detail.html',
		'id': 'product-detail.html',
		extras: {
			'hyid': hyid
		}
	})

})

mui.plusReady(function() {

	var self = plus.webview.currentWebview();

	var gameID = getGameData()[0].gameid;
	var tpid = self.productid || 0;

	window.params = {
		"gameid": gameID,
		"pageindex": 0,
		"pagesize": 8,
		"tpid": tpid
	};

})

mui.init({
	pullRefresh: {
		container: "#refreshContainer", //下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
		down: {
			style: 'circle', //必选，下拉刷新样式，目前支持原生5+ ‘circle’ 样式

			callback: pulldownToRefresh //必选，刷新函数，根据具体业务来编写，比如通过ajax从服务器获取新数据；
		},
		up: {
			contentrefresh: "正在加载...",
			contentnomore: '没有更多数据了',
			auto: true, //可选,默认false.自动上拉加载一次
			callback: pullupToRefresh

		}
	}
});

function pulldownToRefresh() {
	window.params.pageindex = 1
	getProductListData(window.params, function(data) {
		document.querySelector('.list .search-box').innerHTML = template('searchList', data)
		mui('#refreshContainer').pullRefresh().endPulldownToRefresh(); //refresh completed
		mui('#refreshContainer').pullRefresh().refresh(true);

	})
}

function pullupToRefresh() {
	window.params.pageindex++;
	var that = this;
	setTimeout(function() {
		getProductListData(window.params, function(data) {
			if(!data.result.list || data.result.list.length < 8) {
				mui('#refreshContainer').pullRefresh().endPullupToRefresh(true);
			} else {
				mui('#refreshContainer').pullRefresh().endPullupToRefresh();
			}

			document.querySelector('.search-box').appendChild(stringToDom(template('searchList', data)));
		})
	}, 700)
}
// 将字符串转为dom对象
function stringToDom(htmlString) {
	var div = document.createElement("div");
	div.innerHTML = htmlString;
	return div.children[0];
}

/*获取出售中的商品列表*/
function getProductListData(params, callback) {
	Trade.ajax({
		url: 'product/productlist',
		data: params,
		type: 'POST',
		dataType: 'json',
		success: function(data) {
			callback && callback(data);
		}
	})
}