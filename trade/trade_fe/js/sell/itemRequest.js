// 获取出售列表
var getSellListData = function(params,callback){
    Trade.ajaxNeedLogin({
        url:'product/selllist',
        type:'POST',
        data:params,
        success:function(data){
            callback&&callback(data);
        }
    })
}


// 出售商品下架
var getProductDownData = function (params,callback) {
    Trade.ajaxNeedLogin({
        url:'product/downproduct',
        type:'POST',
        data:params,
        success:function (data) {
            callback&&callback(data);
        }
    })
}


//根据商品码验证商品信息
var getItemData = function(params,callback){
    Trade.ajaxNeedLogin({
        url:'product/checkcode',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            //console.log(data);
            callback&&callback(data);
        }
    })
}


//获取上架商品接口数据
var getAddItemData  = function(params,callback){
    Trade.ajaxNeedLogin({
        url:'product/productshelf',
        type:'POST',
        data:params,
        dataType:'json',
        success:function(data){
            callback&&callback(data);
        }

    })
}
