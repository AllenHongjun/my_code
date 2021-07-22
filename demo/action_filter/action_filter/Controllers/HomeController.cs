using action_filter_api.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace action_filter.Controllers
{
    
    public class HomeController : Controller
    {
        [CustomerActionFilter]
        public ActionResult Index()
        {
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

        [CustomerActionFilter]
        [HttpPost]
        public JsonResult OrderDetail(int id = 1)
        {
            return Json("");
        }

        [CustomerActionFilter]
        [HttpPost]
        public JsonResult OrderList(string keyword = "",int page = 0,int limit = 10)
        {
            return Json("");
        }
    }
}