using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        public BookShop.Model.User UserInfo { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserInfo"] != null)
            {

                var abc = Session["UserInfo"];
                UserInfo = (BookShop.Model.User)Session["UserInfo"];
            }
        }
    }
}