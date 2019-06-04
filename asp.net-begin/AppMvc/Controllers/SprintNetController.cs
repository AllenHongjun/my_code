using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Controllers
{
    public class SprintNetController : Controller
    {
        // GET: SprintNet
        public ActionResult Index()
        {
            return View();
        }
        //chm 的文件 不能放在C# 带有#的文件架下不然死活打不开 我也是醉了

        //项目分层价格 数据程 一个层其实就是一个网站 一个dll能直接运行吗 不行吧
        //一个项目 一个网站是一个层 出一个问题  很多方面来处理 痛苦的要死
        //分布式架构  请求 响应 都是一套代码 还好。。多套代码的话 还是不同的语言的话 还是除非 你都会
    }
}