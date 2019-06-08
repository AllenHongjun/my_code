using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class BaseController : Controller
    {
        // GET: Admin/Base
        //public ActionResult Index()
        //{
        //    return View();
        //}



        public class Result 
        {
           

            #region 构造函数
            public Result()
            {
            }
            #endregion

            #region 属性
            public bool success { get; set; }
            
            public string msg { get; set; }
           

            /// <summary>
            /// 状态
            /// <para>1表成功，0表示未处理（默认）</para>
            /// </summary>
            public int code { get; set; }
           
            /// <summary>
            /// 数据总量
            /// </summary>
            public int total { get; set; }
           

            public object data { get; set; }
            #endregion

            
        }

    }
}