using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using AppMvcWebForm.Models;

namespace AppMvcWebForm.Controllers
{
    public class AjaxController : Controller
    {
        // GET: Ajax
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// 获取时间
        /// </summary>
        /// <returns></returns>
        public ActionResult GetDate()
        {
            var date = DateTime.Now;
            return Content(date.ToLongDateString());
        }

        /// <summary>
        /// 返回 appliction/json json字符串 这个时候jquery会自动的解析
        /// </summary>
        /// <returns></returns>
        public ActionResult GetJson()
        {
            string msg = "{name:zhangsan,age:19}";

            //Json方法 会帮你吧一个对象 直接序列化为一个对象
            var obj = new
            {
                name = "zhangsan",
                age = 19
            };

            //会告诉 返回的数据格式就是json 格式 jquery会自动转换  
            //返回的内容还都是 字符串 
            //josn.net  哪个框架的使用
            return Json(obj);
        }

        /// <summary>
        /// 就是一样的功能使用 mvc api webform 3中表现都实现一套 其实其中的业务逻辑 数据层都是相通的
        /// 添加修改删除用户 就是一部一部 一点一点的做的
        /// </summary>
        /// <returns></returns>
        public ActionResult GetList()
        {
            EFUserModelMVC db = new EFUserModelMVC();
            var userList = db.UserInfo.Where(u =>u.ID<20).ToList();
            JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
            string userListJson = javaScriptSerializer.Serialize(userList);
            return Content(userListJson);
        }

        public ActionResult Create()
        {
            return View();
        }

        /// <summary>
        /// 添加用户
        /// </summary>
        /// <returns></returns>
        /// 
        [HttpPost]
        public ActionResult CreateUser()
        {
            var date = DateTime.Now;
            return Json(date);
        }





    }
}