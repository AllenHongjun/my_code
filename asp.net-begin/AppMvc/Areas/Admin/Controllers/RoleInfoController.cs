using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class RoleInfoController : Controller
    {
        // GET: Admin/RoleInfo
        public ActionResult Index()
        {
            return View();
        }
    }
}