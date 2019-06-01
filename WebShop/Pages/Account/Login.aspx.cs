using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BookShop.Model;
using BookShop.BLL;
using Common;

namespace Shop.Web.User
{
    public partial class Login : System.Web.UI.Page
    {   
        public  string Msg { get; set; }

        //你要是想学习控件的使用 就 3层那个小项目在去做一遍 就会了。
        public string HiddenReturnUrl { get; set; }

        

        protected void Page_Load(object sender, EventArgs e)
        {   
            //判断用户是否已经登录 是的话 就显示已经登录的状态。

            string msg = "";
            if (IsPostBack)
            {
                #region 使用ajax的做法
                //string userName = Request["username"];
                //string password = Request["password"];
                //if (CheckValidateCode())
                //{
                //    if (CheckUserInfo())
                //    {
                //        Response.Redirect("index.aspx");
                //        msg = "{'ok':'用户登陆成功'}";
                //    }
                //    else
                //    {
                //        msg = "{'err':'用户名密码不正确'}";
                //    }
                //}
                //else
                //{
                //    msg = "{'err':'验证码错误！'}";
                //}
                //Response.Write(msg); 
                #endregion

                
                CheckUserInfo();
            }
            else
            {

                // 要跳转回去的地址通过一个参数传递到当前页面。  或者 refer来获取  这个也就是通过隐藏于来状态保持
                //这个也是 强调了好几遍的地方 。。这个是 get 方式 。。表单提交的值得时候 会把值传递回去
                HiddenReturnUrl = Request["returnUrl"];
                CheckCooliesInfo();
                //检查一下 是否自动登录。
                //登录之后跳转回到原来的页面 多去看看别人的功能是如何来实现的。。做一遍。



                
                

                

            }
        }

        /// <summary>
        /// 判断验证码是否正确
        /// </summary>
        /// <returns></returns>
        public bool CheckValidateCode()
        {
            bool isSuccess = false;
            if (Session["code"] != null)
            {
                string code = Request["code"];
                string sysCode = Session["code"].ToString();
                if (sysCode.Equals(code,StringComparison.InvariantCultureIgnoreCase))
                {
                    isSuccess = true;
                    //这里一定要记得清空验证码
                    Session["code"] = null;
                }
            }
            return isSuccess;
        }

        /// <summary>
        /// 校验cookie 的值来自动登录
        /// </summary>
        /// <returns></returns>
        public void CheckCooliesInfo()
        {
            if (Request.Cookies["cp1"] != null && Request.Cookies["cp2"] != null)
            {
                string userName = Request.Cookies["cp1"].Value;
                string userPwd = Request.Cookies["cp2"].Value;
                UserManager user = new UserManager();
                BookShop.Model.User userInfo = user.GetModel(userName);
                if (userInfo != null)
                {
                    //每次 比较一下 用户名 和两次加密的密码 是否相等 可以在加几个字符串 加密一下。。安全性要求很高的另外说
                    //这个是实现自动登录的一种方式。。

                    //  token 有效期。。accesstoken  jwt 其他的验证方式。。  数据库里面的密码本来就加密了一次再加密一次
                    if (userPwd == Common.WebCommon.GetMd5String(userInfo.LoginPwd))
                    {
                        Session["userInfo"] = userInfo;
                        if (!string.IsNullOrEmpty(Request["returnUrl"]))
                        {
                            Response.Redirect(Request["returnUrl"]);
                            //不会执行了，因为转到另一个页面中去了
                        }
                        else
                        {
                            Response.Redirect("/Index.aspx");
                        }
                    }
                }
                else
                {
                    Response.Cookies["cp1"].Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies["cp2"].Expires = DateTime.Now.AddDays(-1);
                }
                
            }
        }


        public bool CheckUserInfo()
        {   

            //测试密码都是123456
            string userName = Request["txtUsername"];
            string password = Request["txtPassword"];

            string vardateCode = Request["txtYzm"];
            //验证码

            if (!WebCommon.CheckValidateCode(vardateCode))
            {
                Msg = "验证码错误！";
                return false;
            }

            string msg = "";
            BookShop.Model.User user = null;
            UserManager userManager = new UserManager();
            bool isLogin = userManager.CheckUserInfo(userName, password, out msg,out user);
            if (isLogin)
            {
                //将每一个对象存储dao session中 。。（里面存储的是字符串类型 还是字符串 是的话如何转换）
                //如果自动登录 想消息记录的 cookie中
                //如果现在自动登录 就用用户名 和两次加密后的密码 存储到cookie中
                // 如果是使用web form 就不用考录请求 相应的东西。。就按钮点击了要怎么样。。发生一个什么什么事件了 又怎么样 这样来考虑 
                // 不要太混合起来考虑 容易弄混掉。

                if (!string.IsNullOrEmpty(Request["autoLogin"]))
                {
                    HttpCookie ck1 = new HttpCookie("cp1",userName);
                    password = WebCommon.GetMd5String(WebCommon.GetMd5String(password));
                    HttpCookie ck2 = new HttpCookie("cp2", password);
                    ck1.Expires.AddDays(7);
                    ck2.Expires.AddDays(7);
                    Response.Cookies.Add(ck1);
                    Response.Cookies.Add(ck2);


                }
                Session["userInfo"] = user;
                // 登录成功之后回到之前的页面
                if(string.IsNullOrEmpty(Request["HiddenReturnUrl"]))
                {
                    Response.Redirect("/Index.aspx");
                }
                else
                {
                    Response.Redirect(Request["HiddenReturnUrl"]);
                }
                
            }
            else
            {
                //跳转到提示页面给出提示
                //在页面的某一块位置显示一下消息。。
                //注册一个js 的方法 给出提示
                Msg = msg;
            }
            return true;
            //userInfo.g

        }
    }
}