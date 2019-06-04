using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvcWebForm.Controllers
{
    public class FilterController : Controller
    {
        // GET: Filter

        //过滤器  方法的过滤器  请求管道 。。


        //请求 到达 最终的处理犯法之前可以做的一些事情 

        //这回就真得可以使用框架了  有一点类似请求管道 
        //AOP 面向切面变成   形象  一个请求的时候中间切一刀 然后处理 spring框架

        //可以处理一点事情   做用户是否登录的验证  做页面访问权限的验证 。左右的请求都要做的事情 在这里做
        //如何做
        //面向接口编程 
        public ActionResult Index()
        {
            return View();
        }
    }
}