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
    public partial class EditUser : System.Web.UI.Page
    {
        //页面中使用的数据 都是封装到一个属性当中 页面就可以使用了。经常这么 使用 要记住 要读使用

        /*
         session cookie
         asp.net 请求处理的过程 10个事件
         使用一个企业网站的页面 
         viewState保存数据的原理 了解。
         更多细节的知识  登陆路验证码。状态保存记住我。
             
             */
        public UserInfo user { get; set; }
        private UserInfoService userInfoServcie = new UserInfoService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                UpdateUser();
            }
            else
            {
                ShowUser();
            }
        }

        /// <summary>
        /// 修改用户信息
        /// </summary>
        private void UpdateUser()
        {
            int id;

            //Request.Form["id"]  这个id应该是放在隐藏域当中 传递过来 要好很多
            bool res = int.TryParse(Request.QueryString["id"], out id);
            if (res)
            {
                UserInfo user2 = new UserInfo();
                user2.UserName = Request.Form["txtName"];
                user2.UserPass = Request.Form["txtPwd"];
                user2.Email = Request.Form["txtEmail"];
                user2.RegTime = DateTime.Now;
                user2.Id = id;
                userInfoServcie.EditUserInfo(user2);
                user = userInfoServcie.GetUserInfo(id);

            }
            else
            {
                Response.Redirect("UserInfoList.aspx");
            }
        }

        /// <summary>
        /// 显示用户信息
        /// </summary>
        private void ShowUser()
        {
            int id;
            bool res = int.TryParse(Request.QueryString["id"], out id);
            if (res)
            {
                user = userInfoServcie.GetUserInfo(id);
            }
            else
            {
                Response.Redirect("UserInfoList.aspx");
            }
        }
    }
}