using BookShop.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace WebShop.ashx
{
    /// <summary>
    /// ValidateReg 的摘要说明
    /// </summary>
    public class ValidateReg : IHttpHandler, IRequiresSessionState
    {

        UserManager userManager = new UserManager();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "mail")
            {
                CheckUserMail(context);
            }
            else if (action == "code")//验证码校验
            {
                string validateCode = context.Request["validateCode"];
                if (Common.WebCommon.CheckValidateCode(validateCode))
                {
                    context.Response.Write("验证码正确!!");
                }
                else
                {
                    context.Response.Write("验证码错误!!");
                }
            }
            else if (action == "name")//判断用户名是否被注册。
            {

            }
            else
            {
                context.Response.Write("参数错误!!");
            }
        }

        /// <summary>
        /// 校验用户邮箱
        /// </summary>
        private void CheckUserMail(HttpContext context)
        {
            string userMail = context.Request["userMail"];
            if (userManager.CheckUserMail(userMail))
            {
                context.Response.Write("邮箱已经存在");
            }
            else
            {
                context.Response.Write("邮箱可以注册");
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}