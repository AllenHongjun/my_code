using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FirstWebApplication
{
    /// <summary>
    /// HandlerFirst 的摘要说明
    /// </summary>
    public class HandlerFirst : IHttpHandler
    {

        // code behing clas 就是有一个命名空间 和对应的类名

        //<%@ WebHandler Language="C#" CodeBehind="HandlerFirst.ashx.cs" Class="FirstWebApplication.HandlerFirst" %>
        
            //
            /// <summary>
            /// 
            /// 这个换行不知道为什么那么的不舒服
            /// </summary>
            /// <param name="context"></param>
            /// 





        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Hello World");
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