using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvcWebForm.Areas.OA.Controllers
{
    public class OAIndexController : Controller
    {
        // GET: OA/OAIndex

        //控制器不能和之前的同名 添加一个其他的标记

        //注意下 控制的名称不要同名 t
        public ActionResult Index()
        {
            return View();
        }
    }
}