using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using System.IO;

namespace WebApp.User
{
    /// <summary>
    /// ShowEdit 的摘要说明
    /// </summary>
    public class ShowEdit : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";
            int id;
            bool res = int.TryParse(context.Request.QueryString["id"], out id);
            if (res)
            {
                UserInfoService userInfoService = new UserInfoService();
                var userInfo = userInfoService.GetUserInfo(id);
                if (userInfo !=null)
                {
                    string filePath = context.Request.MapPath("ShowEditUser.html");
                    string fileContext = File.ReadAllText(filePath);
                    fileContext = fileContext.Replace("$name", userInfo.UserName)
                        .Replace("$pwd", userInfo.UserPass)
                        .Replace("$mail", userInfo.Email)
                        .Replace("$Id",userInfo.Id.ToString());
                    context.Response.Write(fileContext);
                }
                else
                {
                    context.Response.Write("没有此用户");
                }
            }
            else
            {
                context.Response.Write("参数错误!!");
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