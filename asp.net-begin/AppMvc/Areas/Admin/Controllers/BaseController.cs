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

        
        /// <summary>
        /// 在控制器中的方法之前先执行的方法
        /// </summary>
        /// <param name="filterContext"></param>
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            //重写父类的方法 。。这样调用父类的方法的时候就会变为调用子类的改方法

            // 只要是在请求过来的执行控制器的方法之前 调用就可以
            // 向数据库中直接保存一个可以为null 的值
            // 控制器中 也有这个方法  过滤器中也有 请求过滤的方法
            // 不要老是去想那些没有的东西。把我好已经有的东西
            base.OnActionExecuting(filterContext);

            /*
             *1. 先判断 sessionId是否为null 就是用户是否登陆
             * 2. 登陆的用户在进行用户权限的判断 在缓存中获取登陆用户的信息
             *3. 如果是 自己就 不进行权限验证(留一个后门 测试方便。发布的时候一定要删除该代码。)
             *
             * 4,获取用户请求的url地址 和请求的方式 来查找权限表，找到对应的该权限
             *
             * 5.更具用户权限这条线 查找 对应的用户是否 有访问改地址的权限
             *
             * 6. 根据用户角色 权限着条线 来查找 对应的 用户是否有该权限。
             *
             * 7.如果没有就提示 用户没有该权限。如果有正确的显示 页面。
             *
             * (每一次请求都要查询权限表过滤。查询 权限关系表
             * 如果用户比较多 这个就可以写在缓存中。
             * )
             * 什么样子的配置能够承受多少的服务器的并发。
             *
             *
             * 过滤用户所具有的菜单权限。 是否禁用。启用
             *
             * 就挑选那种 没有什么印象的特别害怕的视频内容 多看两边 多做做
             *
             */


            if (Request.Cookies["sessionId"] != null)
            {
                
            }




        }



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