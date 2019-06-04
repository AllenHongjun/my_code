using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp.Pages
{
    public partial class ShowDetail : System.Web.UI.Page
    {   
        public UserInfo userInfo { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            int id;
            bool res = int.TryParse(Request.QueryString["id"], out id);
            if (res)
            {
                UserInfoService userInfoService = new UserInfoService();
                userInfo = userInfoService.GetUserInfo(id);
            }
            else
            {
                Response.Redirect("/Error.html");
            }
        }
    }
}