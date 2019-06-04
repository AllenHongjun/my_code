using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;

namespace WebApp.User
{
    /// <summary>
    /// DeleteUser 的摘要说明
    /// </summary>
    public class DeleteUser : IHttpHandler
    {
        /// <summary>
        /// 传过来ID一个 get请求 一般接口 都是post
        /// 了解有哪些业务 怎么处理这些业务
        /// </summary>
        /// <param name="context"></param>
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int id;
            bool res = int.TryParse(context.Request.QueryString["id"], out id);
            if (res)
            {
                UserInfoService user = new UserInfoService();
                if (user.DeleteUserInfo(id))
                {
                    context.Response.Redirect("UserInfoList.ashx");
                }
                else
                {
                    context.Response.Redirect("Error.html");
                }
            }
            else
            {
                context.Response.Redirect("Error.html");
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