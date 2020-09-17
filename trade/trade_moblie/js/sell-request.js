// 获取出售列表
function getSellListData(params,callback){
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
function getProductDownData(params,callback) {
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
function getItemData(params,callback){
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
function getAddItemData(params,callback){
    Trade.ajaxNeedLogin({
        url:'product/productshelf',
        type:'POST',
        data:params,
        dataType:'json',
        beforeSend:function(){
        	console.log()
        	$('#sellBtn').attr('disabled',true).html('加载中...')
        },
        success:function(data){
            callback&&callback(data);
        }

    })
}
