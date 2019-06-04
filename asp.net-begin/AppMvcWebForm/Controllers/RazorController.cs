using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvcWebForm.Controllers
{
    public class RazorController : Controller
    {
        // GET: Razor
        public ActionResult Index()
        {
            return View();
        }


        public ActionResult MyLayout()
        {   

            //使用布局页面
            return View();
        }
    }
}