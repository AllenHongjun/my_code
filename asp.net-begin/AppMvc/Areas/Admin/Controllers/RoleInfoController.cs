using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;

namespace AppMvc.Areas.Admin.Controllers
{
    public class RoleInfoController : Controller
    {   
        public IRoleService RoleService { get; set; }

        public IActionInfoService ActionInfoService { get; set; }
        // GET: Admin/RoleInfo
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult GetRoleInfoList()
        {

        }
    }
}