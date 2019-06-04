using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Common;

namespace WebApp.Pages.Login
{
    public partial class UserInfoList : CheckSession
    {
        protected void Page_Load(object sender, EventArgs e)
        {   

            //分装了一个方法 统一校验
            //if (Session["userInfo"] == null)
            //{
            //    Response.Redirect("UserLogin.aspx");
            //}
            //else
            //{
            //    Response.Write("欢迎" + ((UserInfo)Session["userInfo"]).UserName + "登录本系统");
            //}
        }
    }
}