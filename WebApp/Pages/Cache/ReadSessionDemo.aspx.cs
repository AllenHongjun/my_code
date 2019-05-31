using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class ReadSessionDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Session当中也是一个缓存 
            //webapi 通过客户端app 是否能够使用Session 

            if (Session["str"] != null)
            {
                Response.Write(Session["str"]);
            }
        }
    }
}