using BLL;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace WebApp.User
{
    /// <summary>
    /// ShowDetail 的摘要说明
    /// </summary>
    public class ShowDetail : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType= "text/html";
            int id;
            bool res = int.TryParse(context.Request.QueryString["uid"], out id);
            if (res)
            {
                UserInfoService user = new UserInfoService();
                var userInfo = user.GetUserInfo(id);
                if (userInfo != null)
                {
                    string filePath = context.Request.MapPath("Detail.html");
                    string fileContent = File.ReadAllText(filePath);
                    fileContent = fileContent.Replace("$name", userInfo.UserName)
                        .Replace("$pwd", userInfo.UserPass);
                    context.Response.Write(fileContent);
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