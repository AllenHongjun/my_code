using action_filter.Models;
using action_filter_api.Core.Attribute;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace action_filter.Controllers
{
    
    public class HomeController : Controller
    {
        [RequestActionFilter]
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

        [RequestActionFilter]
        [HttpPost]
        public JsonResult OrderDetail(int id = 1)
        {
            return Json("");
        }

        [RequestActionFilter]
        [HttpPost]
        public JsonResult OrderList(string keyword = "",int page = 0,int limit = 10)
        {   
           
            return Json("");
        }

        [RequestActionFilter]
        [HttpPost]
        public JsonResult OrderListJson( OrderReqDto orderReqDto)
        {
            return Json("");
        }
    }
}