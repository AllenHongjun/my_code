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
    public partial class AddUserInfo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   


           //IsPostBack 是Page类的属性 就可以来使用 根据 __ViewState 中的内容来判断

            //有控件 有控件的好处 就好好的利用
            if (IsPostBack)
            {
                string userName = Request.Form["txtName"];
                string userEmail = Request.Form["txtEmail"];
                string userPwd = Request.Form["txtPwd"];


                UserInfo user = new UserInfo();
                user.UserName = userName;
                user.Email = userEmail;
                user.UserPass = userPwd;
                user.RegTime = DateTime.Now.ToUniversalTime();

                UserInfoService userInfoService = new UserInfoService();
                bool isAdd = userInfoService.AddUserInfo(user);
                if (isAdd)
                {
                    Response.Redirect("UserInfoList.aspx");
                }
                else
                {
                    Response.Write("用户添加失败！！");
                }


            }
            
        }
    }
}