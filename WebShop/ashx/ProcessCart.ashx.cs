using BookShop.BLL;
using BookShop.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace WebShop.ashx
{
    /// <summary>
    /// ProcessCart 的摘要说明
    /// </summary>
    public class ProcessCart : IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            //商品加入购物车
            //验证是否有该商品 用户是否登陆 是否第一次加入购物车
            UserManager userManager = new UserManager();
            if (userManager.ValidateUserLogin())
            {
                int bookId = Convert.ToInt32(context.Request["bookId"]);

                //判断数据库中是否有该商品
                BookManager bookManager = new BookManager();
                Book bookModel = bookManager.GetModel(bookId);



            }
            else
            {
                context.Response.Write("login:没有登录");
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