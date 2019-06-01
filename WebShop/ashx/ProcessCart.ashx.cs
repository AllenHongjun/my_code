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
                if (bookModel != null)
                {
                    //包括添加和更新的功能 两步 session中登陆的key值一定是一致的
                    //专注电商行业。。后台系统的开发。这个做好来。
                    //如何确保数据库数据的完整性。。约束 知道概念还要实践 组合主键

                    //实际需求是怎么样子的 数据库设计的 就需要他是这样的。
                    int userId = ((User)context.Session["userInfo"]).Id;
                    CartManager cartManager = new CartManager();
                    Cart cart =  cartManager.GetModel(userId,bookModel.Id);
                    if (cart == null)
                    {
                        Cart cartAdd = new Cart();
                        cartAdd.Count = 1;
                        cartAdd.Book = bookModel;
                        cartAdd.User = (User)context.Session["userInfo"];
                        cartManager.Add(cartAdd);
                    }
                    else
                    {
                        cart.Count += 1;
                        cartManager.Update(cart);
                        
                    }

                    context.Response.Write("ok:加入购物车成功");
                }
                else
                {
                    context.Response.Write("no:改商品已经下架!");
                }


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