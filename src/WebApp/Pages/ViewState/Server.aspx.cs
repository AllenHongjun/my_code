using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.ViewState
{
    public partial class Server : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //path:
            //     Web 应用程序中的虚拟路径。  
            string path = Server.MapPath("Request.aspx");
            Response.Write(path);

        }
    }
}