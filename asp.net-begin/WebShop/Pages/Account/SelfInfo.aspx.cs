using BookShop.BLL;
using BookShop.Model;
using Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Account
{
    public partial class SelfInfo : System.Web.UI.Page
    {   
        
        public User user { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            UserManager userManager = new UserManager();
            if (!userManager.ValidateUserLogin())
            {
                WebCommon.RedirectPage();
            }
            else
            {
                user = (User)Session["userInfo"];
            }
            

        }
    }
}