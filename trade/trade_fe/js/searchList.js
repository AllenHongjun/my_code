/**
 * Created by 65297 on 2018/7/3.
 */
$(function(){

    var gameid = Trade.getUrlParam('gameid');
    var tpid = Trade.getUrlParam('id')||0;
    window.params = {
        "gameid": gameid,
        "pageindex": 0,
        "pagesize": 8,
        "tpid": tpid
    };
    //下拉刷新 上拉加载
    mui.init({
        pullRefresh : {
            container:".mui-scroll-wrapper",//下拉刷新容器标识，querySelector能定位的css选择器均可，比如：id、.class等
            down : {

                callback :function(){
                    var that = this;
                    setTimeout(function () {
                        window.params.pageindex=1;
                        getProductListData(window.params,function(data){

                            $('.list .search-box').html(template('searchList',data));
                            mui('#refreshContainer').pullRefresh().endPulldownToRefresh(); //refresh completed
                            if(data.result.list.length > 0){
                                //重置上拉加载
                                mui('#refreshContainer').pullRefresh().refresh(true);
                            }

                        })
                    },500)

                }
            },
            up : {
                contentrefresh : "正在加载...",
                contentnomore:'没有更多数据了',

                auto: true,//可选,默认false.首次加载自动上拉刷新一次
                callback :function(){
                    window.params.pageindex++;
                    var that  = this;
                    setTimeout(function(){
                        getProductListData(window.params,function(data){
                            if(!data.result.list || data.result.list.length <8){
                                mui('#refreshContainer').pullRefresh().endPullupToRefresh(true);
                            }else{
                                mui('#refreshContainer').pullRefresh().endPullupToRefresh(false);
                            }

                            $('.list .search-box').append(template('searchList',data));
                        })
                    },700)
                }
            }
        }
    });

    //点击选项切换 按钮搜索
    $('body').on('tap','.sort a', function (e) {
        $(this).addClass('checked').siblings().removeClass('checked');
        var dataType = $(this).attr('data-type');
        window.params.orderType = dataType;
        /*刷新*/
        mui('.mui-scroll-wrapper').pullRefresh().pulldownLoading();

    }).on('submit','#search-form',function(e){

        var searchValue = $('.mui-search input').val();
        params.searchValue = searchValue;
        /*刷新*/
        mui('#refreshContainer').pullRefresh().pulldownLoading();
        return false;
    })

    //点击链接跳转商品详情
    $('body').on('tap','.list-product',function(e){
        console.log(e);
        var hyid = $(this).attr('data-hyid');
        console.log('hyid');
        location.href="product.html?hyid="+hyid;
    })


})


/*获取出售中的商品列表*/
var getProductListData = function(params,callback){
    Trade.ajax({
        url:'product/productlist',
        data:params,
        type:'POST',
        dataType:'json',
        success:function(data){
            callback&&callback(data);
        }
    })
}


