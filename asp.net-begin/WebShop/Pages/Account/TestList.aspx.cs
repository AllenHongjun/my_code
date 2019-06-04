using BookShop.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Account
{
    public partial class TestList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            UserManager user = new UserManager();

            var list = user.GetAllList();
            Repeater1.DataSource = list;
            Repeater1.DataBind();


        }
    }
}