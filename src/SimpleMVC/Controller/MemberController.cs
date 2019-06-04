using SimpleMVC.MVC;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVC.Controller
{
    public class MemberController : IController
    {
        private HttpContext context;
        public void Execute(HttpContext context)
        {
            this.context = context;

            var actionName = context.Request.QueryString["a"];
            if (actionName == null)
            {
                context.Response.Write("缺少控制器的名字");
                context.Response.End();
            }

            switch (actionName.ToLower())
            {
                case "index":
                    Index();
                    break;
                default:
                    break;
            }



            //如果直接抛出一个异常不做任何的处理的 就会 跳出一个错误的黄页
            // 这个也就是 throw 抛出一个异常的处理效果。。 自己实现一下 每一个步骤都做一遍 这个效果确实也是不一样的。
            //完成这么一个小的demo开始 有一定的成就感的。
            //throw new NotImplementedException();
        }

        public void Index()
        {   
            //这也可以这个项目可以值 5w 50 W 500w 5000W
            //asp.net mvc 这个项目 这个软件系统 .net平台这个都是值 好几个亿的项目上面做东西  
            // 想想这个都是开心呀 使用的都是价值多少的项目软件 来开发 制作东西。
            context.Response.Write("大哥赶紧来，这里有一个500W的项目");
        }
    }
}