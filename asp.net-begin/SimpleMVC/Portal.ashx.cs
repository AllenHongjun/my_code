using SimpleMVC.Controller;
using SimpleMVC.MVC;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVC
{
    /// <summary>
    /// Portal 的摘要说明
    ///  /// 第7到8个事件 创建这个对象 11-12 处理这个这个请求 
    /// 起到请求分发的作用 不参与任何的业务逻辑
    /// 目的是 通过这么一个东西 mvc 这一块能得到提高
    /// 了解 mvc是如何来实现的。。 路由的地方 
    /// 对应 就是 前台的小妹妹  就是路由 。。
    /// 
    /// 修改项目的默认命名空间 合理的修改自己命名空间
    /// </summary>
    public class Portal : IHttpHandler
    {

        /// <summary>
       
        /// </summary>
        /// <param name="context"></param>
        public void ProcessRequest(HttpContext context)
        {   
            //有不懂的东西就记录下来 问下需求
            var c = context.Request.QueryString["c"] ?? "Name";

            IController controller = null;
            context.Response.Write("处理请求1");
            switch (c.ToLower())
            {
                case "member":
                    context.Response.Write("处理请求1");
                    context.Response.Write("处理请求2");
                    context.Response.Write("处理请求3");
                    //多态 子类对象 可以赋值给 实现了接口的类型变量  或者 父类类型的变量
                    controller = new MemberController();
                    //处理所有的
                    break;
                case "user":
                    break;
                case "product":
                    //会过头来自己一步一步 一点一点写代码的能力其实是很重要的。
                    controller = new ProductController();
                    break;
                default:
                    break;
            }

            //确保一定是能够找到一个东东来帮你处理的
            //一定要先敲一下代码  看视频 是为了找到你能写代码的思路
            //不是说 去看视频 
            //自己敲了一遍代码 回头在去对着视频 看一下 你敲过的代码 
            if (controller == null)
            {
                throw new HttpException(404,"Not Found");
            }

            controller.Execute(context);

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