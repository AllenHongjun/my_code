using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
namespace WebApp.Pages
{
    public partial class Delete : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id ;
            bool res = int.TryParse(Request.QueryString["id"], out id);
            if (res)
            {
                UserInfoService userInfoService = new UserInfoService();
                bool isDelete = userInfoService.DeleteUserInfo(id);
                if (isDelete)
                {
                    Response.Redirect("UserInfoList.aspx");
                }
                else
                {
                    Response.Write("用户删除失败！");
                }

            }
            else
            {
                Response.Redirect("/Error.html");
            }
        }
    }
}