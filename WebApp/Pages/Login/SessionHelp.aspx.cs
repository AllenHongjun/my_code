using Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class SessionHelp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   
            //这个和页面session是同一个
            SessionHelper2.Add("UserName", "AllenHong");
            string sessionId = HttpContext.Current.Session.SessionID;
            Response.Write(sessionId);

            //持久化存储。不是20分钟就结束 sessionID存储过数据库 或者是缓存当中。
            //不会没过一点时间 又要重新登录

            string userName = SessionHelper2.Get("UserName");
            Response.Write("<br>");
            Response.Write(userName);
        }
    }
}