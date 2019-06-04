using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AppMvcWebForm.Models;

namespace AppMvcWebForm.Controllers
{
    public class HtmlHelperController : Controller
    {
        // GET: HtmlHelper
        public ActionResult Index()
        {

            List<SelectListItem> list = new List<SelectListItem>
            {
                new SelectListItem(){Text="北京",Value="2"},
                new SelectListItem(){Text="天津",Value="3" , Selected=true,  },
                new SelectListItem{ Text="金华", Value="4", Disabled=true}
            };


            //如果ViewData的key的值 与DropDownList的名字一直 会自动填充下拉框  
            //这个就比使用控件要好多了 
            ViewData["city"] = list;

            EFUserModelMVC db = new EFUserModelMVC();
            var user = db.UserInfo.Where(u => u.ID == 112).FirstOrDefault();
            ViewData.Model = user;


            return View();
        }



        /// <summary>
        /// 添加用户的时候 使用自带的表单验证
        /// </summary>
        /// <returns></returns>
        public ActionResult ValidateAddUser()
        {

            return View();
        }


        public ActionResult CreateUserInfo()
        {
            return View();
        }

        public ActionResult CreateUser()
        {
            return View();
        }
    }
}