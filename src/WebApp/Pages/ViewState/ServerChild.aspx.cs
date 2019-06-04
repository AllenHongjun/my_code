using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.ViewState
{
    public partial class ServerChild : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("这个页面可以使用Server.Excute来执行 可以实现类似 iFream的效果");

        }
    }
}