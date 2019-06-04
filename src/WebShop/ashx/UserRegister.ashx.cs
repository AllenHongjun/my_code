using BookShop.BLL;
using BookShop.Model;
using Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebShop.ashx
{
    /// <summary>
    /// UserRegister 的摘要说明
    /// </summary>
    public class UserRegister : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string username = context.Request["username"];
            string userpass = context.Request["password"];
            string email = context.Request["email"];
            string tel = context.Request["tel"];

            UserManager userManager = new UserManager();

            //查找一下用户名
            var isRegister = userManager.Exists(username);
            if (!isRegister)
            {
                User user = new User();
                user.LoginId = username;
                user.Name = username;
                user.UserState.Id = 1;
                user.Address = "某一个未知的地方";
                user.LoginPwd = WebCommon.GetMd5String(userpass).ToUpper();
                user.Mail = tel;
                user.Phone = tel;
                if (userManager.Add(user) > 0)
                {   

                    //json的格式非常严格 必须加上爽引号才会解析。。我日了。。

                    //繁琐的验证判断 。。请求返回的格式。乱起八糟的东西。
                    context.Response.Write("{\"code\":1,\"msg\":\"注册成功！\"}");
                }
                else
                {
                    context.Response.Write("{\"code\":-1,\"msg\":\"注册失败！\"}");
                }
            }
            else
            {
                context.Response.Write("{\"code\":1,\"msg\":\"用户已经注册！\"}");
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