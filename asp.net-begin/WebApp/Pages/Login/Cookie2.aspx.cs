using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class Cookie2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   

            //每个用户cookie是存储在用户自己的电脑上。
            //
            if (Request.Cookies["cp3"].Value !=null)
            {
                Response.Write(Request.Cookies["cp3"].Value);
            }

        }
    }
}