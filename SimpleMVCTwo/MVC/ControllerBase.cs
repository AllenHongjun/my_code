using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace SimpleMVCTwo.MVC
{   


    //会想起做一个银行的 一步一步 的人家是怎么来完成这的 一点点的做出来
    //


    public abstract class ControllerBase:IController
    {
        protected HttpContext Context { get; set; }

        protected IDictionary<string , object> RouteData { get; set; }

        public ActionResult Execute(RequestContext context)
        {
            //获取请求中内容 获取路由数据


            //找到控制器中的方法 


            //找到路由数据中的参数 。映射到对应的地方。


            //调用这个方法。返回结果。。不只是会用。。还要知道它是如何实现的。。
            //一些原理 。这样 以后换了 一个框架 。学习 使用起来也就会更加的容易 
            // 一个新的东西 类比 一步一步走慢慢来 。。不要排斥 有好的东西 使用的话 其实是很简单的。

            Context = context.HttpContext;
            RouteData = context.RouteData;

            //获取action的名字

            string actionName = RouteData["action"].ToString();

            //找到当前类的实例中 当中的所有方法

            //通过反射 GETType 返回的是个什么？？？？  | 或的运算符号  你也的没一种用法 其实都是别人早就用过的
            //有自己的思想 写出一些自己的代码 才是更加的关键的。。我觉得这个其实就是挺难的 创造了。


            var methods = this.GetType().GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly);


            MethodInfo method = null;
            foreach (var item in methods)
            {
                if (item.Name.Equals(actionName,StringComparison.InvariantCultureIgnoreCase))
                {
                    method = item;
                    break;
                }
            }

            if (method == null)
            {
                throw new HttpException(404, "找不到控制器对应的方法");
            }

            // 找当前类当中所有的方法 

            List<object> values = new List<object>();
            var parameters = method.GetParameters();


            return null;

        }
    }
}