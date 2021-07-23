using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace action_filter_api.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index([FromBody] string keyword)
        {
            ViewBag.Title = "Home Page";

            return View();
        }
    }
}
