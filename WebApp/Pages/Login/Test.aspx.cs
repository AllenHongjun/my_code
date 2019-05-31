using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class Test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //ASP.NET_SessionId
            //0hda1xnqk3geoavdhrv0yqcq
            // 如果不是页面上
            //单独请求处理的时候 。
            //就要选择合适的方法
            //session对应的物理路径是哪里 
            //session中其他方法属性的使用 过期时间 删除 
            //例子  判断用户是否登陆 验证验证 的例子来理解一下 session的使用
            if (Session["userName"] != null)
            {
                Response.Write(Session.ToString());
                Response.Write(Session["userName"].ToString());
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}