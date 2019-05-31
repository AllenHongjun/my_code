using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebShop.ashx
{
    /// <summary>
    /// Seo 的摘要说明
    /// </summary>
    public class Seo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {   
            //跳转的 超级链接  

            // url地址跳转。。。

            //  也是一点 一点积累起来的。。

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