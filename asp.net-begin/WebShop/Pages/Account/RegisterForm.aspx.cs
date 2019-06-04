using BookShop.BLL;
using BookShop.Model;
using Shop.Model.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Account
{
    public partial class RegisterForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {

                AddUserInfo();

                ////验证码验证 
                //if (CheckSession())
                //{
                    
                //}
                //else
                //{   
                //    //如果用户点击返回按钮 验证码的请求其实没有重新发 重新获取一遍的。
                //    //这个时候 session里面的验证码已经清空 就获取不到了。
                //    string msg = "验证码错误或者已经过期";
                //    Response.Redirect("/ShowMsg.aspx?msg=" + msg + "&txt=首页" + "&url=/Default.aspx");
                //}
                ////添加用户数据
            }


        }


        #region 完成用户注册
        protected void AddUserInfo()
        {
            User userInfo = new User();
            userInfo.LoginId = Request["username"];
            userInfo.Name = Request["realname"];
            userInfo.LoginPwd = Request["password"];
            userInfo.Address = Request["address"];
            userInfo.Mail = Request["email"];
            userInfo.Phone = Request["tel"];
            userInfo.UserState.Id = Convert.ToInt32(UserStateEnum.NormalState);
            UserManager userManager = new UserManager();
            string msg = string.Empty;
            if (userManager.Add(userInfo, out msg) > 0)
            {
                Session["userInfo"] = userInfo;
                //一般页面跳转了 就是默认成功了。
                Response.Redirect("Login.aspx");
            }
            else
            {   
                //通过一个ajax注册一个提示 或者调整一个提示页面
                Response.Redirect("/ShowMsg.aspx?msg=" + msg + "&txt=首页" + "&url=/Index.aspx");
            }

        }
        #endregion


        #region 验证码校验
        protected bool CheckSession()
        {
            bool isSucess = false;
            if (Session["vCode"] != null)
            {
                string txtCode = Request["txtCode"];
                string sysCode = Session["vCode"].ToString();
                if (sysCode.Equals(txtCode, StringComparison.InvariantCultureIgnoreCase))
                {
                    isSucess = true;
                    //注意验证码的session值呀清空一下
                    Session["vCode"] = null;
                }
            }
            return isSucess;
        }
        #endregion

    }
}