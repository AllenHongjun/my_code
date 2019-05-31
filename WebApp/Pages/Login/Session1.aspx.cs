using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class Session1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //session 对象的基本使用  session有一个id保存在服务端 也是可以持久化存储 
            //知道如何来使用就可以
            if (IsPostBack)
            {
                string name = Request.Form["txtName"];
                //已经封装到一个页面的属性中直接使用就可以了
                //当然也是可以创建对象 使用 这个sessionID怎么获得


                //会存储过服务器的内容当中 
                /*
                 服务器内存中会 每个单元 会有sessionID
                 
                 */
                Session["userName"] = name;

                //会返回一个
                //Set-Cookie: ASP.NET_SessionId=0hda1xnqk3geoavdhrv0yqcq; path=/; HttpOnly
                //自动的帮你设置了一个cookie 使用asp.net webform页面的时候
                //Response.Redirect("Test.aspx");
                //如果已经设置活就不会再设置了
            }



        }
    }
}