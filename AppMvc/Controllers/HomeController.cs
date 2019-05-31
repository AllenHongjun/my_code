using MVC.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;
using MVC.Model;

namespace AppMvc.Controllers
{
    public class HomeController : Controller
    {

        //UserInfoService 创建控制器对象的属性的时候 就已经完成了之前的操作 所以有很多的操作 都是在进入控制器的方法之前执行的
        //还有很多方法是一直都是在执行的。这个一定是要搞清楚的

        //c常用的哪些数据库操作。数据应该如何来使用 如何玩耍 
        //项目的文件 工作的文件。如何来区分好。如何做好。

        
        IUserInfoService UserInfoService = new UserInfoService();
        public ActionResult Index()
        {
            IQueryable<UserInfo> users =  UserInfoService.LoadEntities(u => u.ID < 100);
            ViewData.Model = users;
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}