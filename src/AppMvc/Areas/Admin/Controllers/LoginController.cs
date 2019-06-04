using MVC.BLL;
using MVC.Common;
using MVC.IBLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class LoginController : Controller
    {
        IUserInfoService UserInfoService = new UserInfoService();
        // GET: Admin/Login
        public ActionResult Index()
        {   
            return View();
        }


        /*
         OA企业 政府网站 
         军队 一个项目好几千万都有。。
         吹牛逼
         关注一下我们这个行业的 
         有哪些公司是比较有名的。。
         已经好的项目产品。。
         后台是什么样子的 产品是什么？
         其实就是字段多一些。。连接的表多一些
         没有什么牛逼不牛逼的样子。
             
             */


        public ActionResult UserLogin()
        {
            //获取session的验证码 和请求的验证码比对

            //验证用户名和密码 md5加密

            //将用户登陆的sessionID存储到缓存当中 然后返回给客户端 
            //哪些每一个项目里都有的功能 其实是不重要的。更加的重要的是单独着项目有的功能
            //这些功能更加的值钱。都是要单独开发的。

            string validateCode = Session["ValidateCode"] != null ? Session["ValidateCode"].ToString() : String.Empty;
            if (string.IsNullOrEmpty(validateCode))
            {
                return Content("no:验证码错误");
            }
            string reqcode = Request["vcode"];
            if (!reqcode.Equals(validateCode,StringComparison.CurrentCultureIgnoreCase))
            {
                return Content("no:验证码错误");
            }

            string username = Request["LoginCode"];
            string userpass = Request["loginPwd"];

            //这里服务端校验

            var userinfo = UserInfoService.LoadEntities(u => u.UserName == username && u.UserPass == userpass).FirstOrDefault();
            if (userinfo != null)
            {
                //之前是将用户登陆状态记录在session当中 
                //记录在数中 token 唯一的token 唯一的sessionID 
                //可以记录在缓存中 
                //这个session的值用户登陆的状态值 一个是每一个用户都是唯一的
                //可以有过期时间。记录的值的状态可以比较持久一点
                //某一块功能 非常完善的做法是什么样子 
                //比如产品 比如购物车比如分类 别人是怎么做 
                //比如权限。
                Session["UserInfo"] = userinfo;
                return Content("ok:用户登陆成功");

            }
            else
            {
                return Content("no:用户名或者密码错误");
            }


        }





        //memecache缓存的使用。读取
        //cookiesession jwt一些新的组件的使用和测试
        //复习验证码 登陆校验 session的机制 jquery的使用
        //生成验证码的数字 生成验证码的图片 先把基础的正在使用东西弄明白
        //数据库查询 linq查询 弄明白 又几个痛点 记录下来 多研究一下
        //session统一校验 过滤器  mvc里面返回一个文件类型的请求

        



        /// <summary>
        /// 生成验证码
        /// </summary>
        /// <returns></returns>
        public ActionResult ShowValidateCode()
        {
            ValidateCode validateCode = new ValidateCode();
            string code = validateCode.CreateValidateCode(4);
            //返回一个文件流的字节数组  http返回的是一个stream 获取返回
            Session["ValidateCode"] = code;
            byte[] buffer = validateCode.CreateValidateGraphic(code);
            return File(buffer,"image/jpeg");
        }





    }
}