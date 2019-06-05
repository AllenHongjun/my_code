using CZBK.ItcastOA.IBLL;
using CZBK.ItcastOA.Model;
using Spring.Context;
using Spring.Context.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CZBK.ItcastOA.WebApp.Controllers
{
    public class BaseController : Controller
    {
        
        public UserInfo LoginUser { get; set; }
        /// <summary>
        /// 执行控制器中的方法之前先执行该方法。
        /// </summary>
        /// <param name="filterContext"></param>
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            //if (Session["userInfo"] == null)
            bool isSucess = false;
            if(Request.Cookies["sessionId"]!=null)
            {
                string sessionId = Request.Cookies["sessionId"].Value;
                //根据该值查Memcache.
                object obj=Common.MemcacheHelper.Get(sessionId);
                if(obj!=null)
                {
                    UserInfo userInfo = Common.SerializeHelper.DeserializeToObject<UserInfo>(obj.ToString());
                   LoginUser = userInfo;
                   isSucess = true;
                   Common.MemcacheHelper.Set(sessionId, obj, DateTime.Now.AddMinutes(20));//模拟出滑动过期时间.
                    //留一个后门，测试方便。发布的时候一定要删除该代码。
                   if (LoginUser.UName == "itcast")
                   {
                       return;
                   }
                    //完成权限校验。
                    //获取用户请求的URL地址.
                   string url = Request.Url.AbsolutePath.ToLower();
                    //获取请求的方式.
                   string httpMehotd = Request.HttpMethod;
                    //根据获取的URL地址与请求的方式查询权限表。
                   IApplicationContext ctx = ContextRegistry.GetContext();
                   IBLL.IActionInfoService ActionInfoService = (IBLL.IActionInfoService)ctx.GetObject("ActionInfoService");
                  var actionInfo= ActionInfoService.LoadEntities(a=>a.Url==url&&a.HttpMethod==httpMehotd).FirstOrDefault();
                  if (actionInfo != null)
                  {
                      filterContext.Result = Redirect("/Error.html");
                      return;
                  }

                    //判断用户是否具有所访问的地址对应的权限
                   IUserInfoService UserInfoService = (IUserInfoService)ctx.GetObject("UserInfoService");
                   var loginUserInfo = UserInfoService.LoadEntities(u=>u.ID==LoginUser.ID).FirstOrDefault();
                    //1:可以先按照用户权限这条线进行过滤。
                   var isExt =(from a in loginUserInfo.R_UserInfo_ActionInfo
                               where a.ActionInfoID == actionInfo.ID
                               select a).FirstOrDefault();
                   if (isExt != null)
                   {
                       if (isExt.IsPass)
                       {
                           return;
                       }
                       else
                       {
                           filterContext.Result = Redirect("/Error.html");
                           return;
                       }

                   }
                    //2：按照用户角色权限这条线进行过滤。
                   var loginUserRole = loginUserInfo.RoleInfo;
                   var count = (from r in loginUserRole
                               from a in r.ActionInfo
                               where a.ID == actionInfo.ID
                               select a).Count();
                   if (count < 1)
                   {
                       filterContext.Result = Redirect("/Error.html");
                       return;
                   }
                    

                }
               
               

              //  filterContext.HttpContext.Response.Redirect("/Login/Index");
               
            }
            if (!isSucess)
            {
                filterContext.Result = Redirect("/Login/Index");//注意.
            }
        }
    }
}
