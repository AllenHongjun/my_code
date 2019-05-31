using BLL;
using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Pages.Ajax
{
    /// <summary>
    /// UserLogin 的摘要说明
    /// </summary>
    public class UserLogin : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string userName = context.Request["userName"];
            string userPwd = context.Request["userPwd"];
            UserInfoService userInfoService = new UserInfoService();
            string msg = string.Empty;
            UserInfo userInfo = null;

            if (userInfoService.ValidateUserInfo(userName,
                userPwd,out msg,out userInfo))
            {
                //Cookie: ASP.NET_SessionId=npgt1esysszqrqovkkvckdoe
                //ajax请求也是一样可以设置的
                //System.Web.SessionState.IRequiresSessionState 未将对象引用到空对象的实例 报的是奇怪的错误 这个标记接口一定要实现以下
                context.Session["userInfo"] = userInfo;
                context.Response.Write("OK:" + msg);
            }
            else
            {
                context.Response.Write("NO:" + msg);
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