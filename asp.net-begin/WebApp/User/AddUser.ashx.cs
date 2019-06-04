using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;

namespace WebApp.User
{
    /// <summary>
    /// AddUser 的摘要说明
    /// html css js sql 数据库一套 全部都自己会弄 爽歪歪呀
    /// </summary>
    public class AddUser : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string userName = context.Request.Form["txtName"];
            string userPwd = context.Request.Form["txtPwd"];
            string userEmail = context.Request.Form["txtMail"];

            UserInfo userInfo = new UserInfo();
            userInfo.UserName = userName;
            userInfo.UserPass = userPwd;
            userInfo.Email = userEmail;
            userInfo.RegTime = DateTime.Now;
            BLL.UserInfoService userInfoService = new BLL.UserInfoService();
            if (userInfoService.AddUserInfo(userInfo))
            {
                context.Response.Redirect("UserInfoList.ashx");
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