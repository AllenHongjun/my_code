using BookShop.BLL;
using BookShop.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebShop.ashx
{
    /// <summary>
    /// EditCart 的摘要说明
    /// </summary>
    public class EditCart : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            //通过索引器来访问对象的值

            //有的时候代码有一个换行 有一个排版 看起来就会舒服很多
            string action = context.Request["action"];
            if (action == "edit")
            {
                int count = Convert.ToInt32(context.Request["count"]);
                int cartId = Convert.ToInt32(context.Request["cartId"]);
                CartManager cartManager = new CartManager();
                //最简单 也是最核心就是 修改用户购物中商品的数量

                //通过分层的话 更新数据都是先找到这条数据 着样有什么好处 

                Cart cart = cartManager.GetModel(cartId);
                cart.Count = count;
                cartManager.Update(cart);

                //如果删除过更新失败出异常的话 会有一个统一的异常处理
                //所以那些判断其实也是就没有太大的必要了。
                context.Response.Write("ok");
            }
            else if(action == "delete")
            {   
                //删除购物车列表中 用户选购的商品
                int cartId = Convert.ToInt32(context.Request["cartId"]);
                CartManager cartManager = new CartManager();
                cartManager.Delete(cartId);
                context.Response.Write("ok");
            }
            else
            {
                context.Response.Write("no");
            }



        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}