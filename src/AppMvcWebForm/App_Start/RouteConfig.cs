using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
/*
 确定控制器 确定方法 
 确定参数
 将url地址 参数 映射到 我们的控制器和方法 
 将参数转交给具体的controller action 
 System.Web.Routing 都是一个一个的 dll 

     
     */
using System.Web.Routing;

namespace AppMvcWebForm
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");



            //{controller}-{action}/{id} 注意ID之前的斜杠 这么写 最后一个/浏览器是会自动加上的

            //注意 路由规则匹配是和严格的 一定要注意这个写法 

            //actionLink  会根据第一个路由规则的写法 来自动的生成链接
            //routes.MapRoute(
            //    name: "DefaultFirst",
            //    url: "{controller}-{action}/{id}",
            //    defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            //);


            ////先安装第一个路由规则 匹配 就匹配第2个 之后按照顺序继续匹配

            //第一个如果匹配到了 就不会匹配第二个路由规则

            //调用 MapRoute 来添加 路由规则

            //关键是请求 传递参数的方式  还可以约束一下 控制器  请求的类型 只能是 post get
            // 参数的就是另外的知识点 会参数自己映射和匹配

            //这个里面的路由规则 应该如何来写 有什么要求 hotel/{#value}  =>跳转到哪个控制器
            routes.MapRoute(
                name: "DefaultSecond",  //名字不要重复就可以了
                url: "{controller}/{action}/{id}",  //可以根据自己的需求定义 一般都是/
                //id 是可以选择的  第一段 是控制器 第二段是 action 第3段是 id  
                //如果这几段都没有 就访问 http://localhost:8322/Home/Index/3?name = 3& class =4
                //将url的地址 映射到你的程序  可以按照他的要就 添加一个配置 /v1/{controller}/{action}/{id}
                //查查查  一堆乱七八糟的东西 
                //还记得刚刚使用 thinkphp的时候 那会还是挺痛苦的 折腾了大半天 折腾不出一个什么结果来。。
                // 定义一个默认的值 如果规则都不输入的情况
                //默认会跳转到哪个控制器

                //越具体的路由规则 定义在前面  越是范围比较 具体的就放在后面。。
                //网页最少要跳转到网页的首页  可以参考一下 别人的网站是如何来定义路由的规则的 
                //路由规则的使用。actionLink 
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );



            //路由规则对象 主要有4个 请求的原理的时候  个人站长 。

            /*
             * 
             * 提供一点api的服务
             * 这些内容 是程序运行起来的时候 这些对象会一直存在 会一直运行的。
             RouteCollection  存放路由规则的集合 
             Route  存放一条路由规则 

             RouteData 根据路由规则 解析之后内容
             RouteTalbe   Stores the URL routes for an application. RouteCollection存放其中
             表 里面有集合  集合里面有一个一个的规则  匹配解析  解析之后 RouteData
             
            ASP.Net是如何使用这个框架 
            搭建一个通用的项目框架 


             */
        }
    }
}
