using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CZBK.ItcastOA.WebApp.Controllers
{
    public class LoginController : Controller
    {
        //
        // GET: /Login/
        IBLL.IUserInfoService UserInfoService { get; set; }
        public ActionResult Index()
        {
            return View();
        }
        #region 完成用户登录
        public ActionResult UserLogin()
        {
            string validateCode = Session["validateCode"] != null ? Session["validateCode"].ToString() : string.Empty;
            if (string.IsNullOrEmpty(validateCode))
            {
                return Content("no:验证码错误!!");
            }
            Session["validateCode"] = null;
            string txtCode = Request["vCode"];
            if (!validateCode.Equals(txtCode, StringComparison.InvariantCultureIgnoreCase))
            {
                return Content("no:验证码错误!!");
            }
            string userName=Request["LoginCode"];
            string userPwd=Request["LoginPwd"];
           var userInfo=UserInfoService.LoadEntities(u=>u.UName==userName&&u.UPwd==userPwd).FirstOrDefault();//根据用户名找用户
           if (userInfo != null)
           {
              // Session["userInfo"] = userInfo;
               //产生一个GUID值作为Memache的键.
             //  System.Web.Script.Serialization.JavaScriptSerializer
               string sessionId = Guid.NewGuid().ToString();
               Common.MemcacheHelper.Set(sessionId, Common.SerializeHelper.SerializeToString(userInfo)
                   ,DateTime.Now.AddMinutes(20));//将登录用户信息存储到Memcache中。
               Response.Cookies["sessionId"].Value = sessionId;//将Memcache的key以Cookie的形式返回给浏览器。
               

               return Content("ok:登录成功");
           }
           else
           {
               
               return Content("no:登录失败");
           }
        }
        #endregion

        #region 显示验证码
        public ActionResult ShowValidateCode()
        {
            Common.ValidateCode vliateCode = new Common.ValidateCode();
            string code=vliateCode.CreateValidateCode(4);//产生验证码
            Session["validateCode"] = code;
            byte[]buffer=vliateCode.CreateValidateGraphic(code);//将验证码画到画布上.
            return File(buffer,"image/jpeg");
        }
        #endregion

    }
}
