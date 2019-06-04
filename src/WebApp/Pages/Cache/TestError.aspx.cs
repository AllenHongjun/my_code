using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class TestError : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            int a = 5;
            int b = 0;
            int c = 5 / b;
            Response.Write(c);

            //常用件的配置的使用

        }
    }
}