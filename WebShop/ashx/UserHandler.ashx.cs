using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BookShop.Common;
using System.Web.SessionState;

namespace Shop.Web.User
{
    /// <summary>
    /// UserHandler 的摘要说明
    /// </summary>
    public class UserHandler : IHttpHandler,IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            ValidateCode validateCode = new ValidateCode();
            string code = validateCode.CreateValidateCode(4);
            context.Session["Code"] = code;
            validateCode.CreateValidateGraphic(code, context);

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