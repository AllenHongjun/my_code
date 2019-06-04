using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class TestController : Controller
    {
        // GET: Admin/Test
        public ActionResult Index()
        {

            ILog logger = LogManager.GetLogger("errorMsg");
            logger.Info("这个是测试日志，查看是是否可以记录接口的数据");

            //log4net按照不同级别记录到不同文件夹 文件当中 

            //测试 过滤器中异常的使用
            int a = 5;
            int b = 0;
            int c = a / b;
            return View();
        }

        public ActionResult TestException()
        {
           

            return View();
        }

        /*
         * 
         * 一张表多张表
         MemberCache 
         queing.NET 插件
         spring.Net 依赖注入
         JqueryUI 
         权限模块功能
         数据库设计查询
         多表连接查询 CURD涉及多张表的操作
         定时组件
         json.net 组件的使用
         ASP.netMVC
         N层架构的搭建
         
         
         */
    }
}