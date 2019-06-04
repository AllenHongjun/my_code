using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Common;
using Common.BaseClass;
using Model;

namespace WebApp.Pages.Login
{
    public partial class UserLogin : System.Web.UI.Page
    {   
        public string Msg { get; set; }
        public string UserName { get; set; }



        protected void Page_Load(object sender, EventArgs e)
        {
            #region session解释
            //是这个页面的session属性 
            //和你自己创建 session对象不一样的
            //自己要通过获取SessionID 来获取用户
            // 坑爹的时候 很多封装好了 直接使用有些东西就搞不明白
            //Response.Write(Session.SessionID+"<br>");
            //Response.Write(Session.Timeout + "<br>");
            //Response.Write(Session.IsNewSession + "<br>");

            // HttpContext.Current.Session[strSessionName] = strValue;
            //Current 就会自动查找SessionID查找 不用自己去写
            //公共方法的调用和使用
            //不是在aspx页面中使用

            //每一个sessionID都是有一个SessionID
            //sessionID都是以
            //SessionHelper2.Add("UserName", "AllenHong");
            //string sessionId = HttpContext.Current.Session.SessionID;
            //Response.Write(sessionId);


            //string userName = SessionHelper2.Get("UserName");
            //Response.Write("<br>");
            //Response.Write(userName);

            // 已经封装好的对象的属性的理解和使用 
            //就是对这个对象和属性 深刻的理解

            //Session 简介 来理解
            // 没一个用户有一个单独的Session对象 如何来获取
            //HttpContext.Current.Session 
            //Current 这个很重要 根据每个用户自己来获取
            //设置的时候 获取的时候 就可以获取当前用户用的session对象

            #endregion


            #region 自动登陆
            //第一步先判断什么
            //第二步再判断什么
            //第三部再判断什么
            // 判断验证码 就了放置暴力破解
            // 减少查询数据库次数

            //如果 持久化登陆应该怎么做
            //使用特性标记 来做做标记。接口的标记是以前的做法
            // 实际开发中的 各种业务判断 就会复杂的很多 各种字段的判断
            // 各种乱七八糟的东西 

            //自动登陆 把用户名和密码保存到cookie中 检查一下可以的话就自动登陆
            //cookie使用 虽然正式不能直接使用。但是
            //这个效果 有一定的可以借鉴性
            #endregion

            if (IsPostBack)
            {
                //先判断验证码是否正确
                if (CheckValidateCode())
                {
                    CheckUserInfo();
                }
                else
                {
                    Msg = "验证码错误！！";
                }
            }
            else
            {
                //第一次打开页面 会执行这里的方法
                CheckCookieInfo();
            }


        }


        protected void CheckUserInfo()
        {   
            //session存储在内存中
            //不要将过大的数据复制给session
            //session要判断是否为空
            string userName = Request.Form["txtName"];
            UserName = userName;
            string userPwd = Request.Form["txtPwd"];
            BLL.UserInfoService userInfoService = new BLL.UserInfoService();
            string msg = string.Empty;
            UserInfo userInfo = null;

            bool isLogin = userInfoService.ValidateUserInfo(userName,
                userPwd, out msg, out userInfo);
            //判断用户名密码是否正确
            if (isLogin)
            {
                //页面上如果有多个复选框时，只能将选中复选框的的值提交到服务端。
                if (!string.IsNullOrEmpty(Request.Form["autoLogin"]))
                {
                    string pwd = "";
                    //可以一种算法加密好几次 别人破解不了的那种

                    //第一次登陆的时候 加密之后保存到 cookie当中 
                    // 第一次加载页面的 根据cookie的值来判断一下 
                    pwd = WebCommon.GetMd5(WebCommon.GetMd5(userPwd));
                    HttpCookie cookie1 = new HttpCookie("cp1", userName);
                    HttpCookie cookie2 = new HttpCookie("cp2", pwd);
                    cookie1.Expires = DateTime.Now.AddDays(7);
                    cookie2.Expires = DateTime.Now.AddDays(7);
                    Response.Cookies.Add(cookie1);
                    Response.Cookies.Add(cookie2);
                }


                //Session过期了之后 就访问不打的
                //是滑动过期时间。再次访问的时候 时间 会往后延长
                //赋值几个页面 不要把所有的页面全部都复制过去
                Session["userInfo"] = userInfo;
                Response.Redirect("UserInfoList.aspx");

            }
            else
            {
                Msg = msg;
            }


        }

        /// <summary>
        /// 通过检查cookie信息 来自动登录
        /// </summary>
        protected void CheckCookieInfo()
        {
            if (Request.Cookies["cp1"] != null && Request.Cookies["cp2"] != null)
            {
                string userName = Request.Cookies["cp1"].Value;
                string userPwd = Request.Cookies["cp2"].Value;


                BLL.UserInfoService userInfoService = new BLL.UserInfoService();
                UserInfo userInfo = userInfoService.GetUserInfo(userName);
                if (userInfo != null)
                {
                    //注意：在添加用户或注册用户时一定要将用户输入的密码加密以后在存储到数据库中。
                    string localPwd = WebCommon.GetMd5(WebCommon.GetMd5(userInfo.UserPass));
                    if (localPwd == userPwd)
                    {
                        Session["userInfo"] = userInfo;
                        Response.Redirect("UserInfoList.aspx");
                    }
                }
                else
                {   
                    //数据库 数据别人盗取了。 
                    // cookie当中数据如果错误了 cookie中的数据 清空
                    Response.Cookies["cp1"].Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies["cp2"].Expires = DateTime.Now.AddDays(-1);
                }

            }
            else
            {
                //这里就直接出现登陆页面 不用其他的处理
            }
        }



        /// <summary>
        /// 判断验证码是否正确
        /// </summary>
        /// <returns></returns>
        public bool CheckValidateCode()
        {
            bool isSuccess = false;
            //一定要验证一下Session是否非空  如果是空的 还使用的话 就会抛出异常了
            if (Session["validatecode"] != null)
            {
                string txtCode = Request.Form["txtCode"];
                string sysCode = Session["validateCode"].ToString();
                if (sysCode.Equals(txtCode,StringComparison.InvariantCultureIgnoreCase))
                {
                    isSuccess = true;
                    //为什么要清空一下 不清空会有什么效果
                    //如果不清空 是会有一个安全隐患  下次可以测试验证别人 的密码 多测试了
                    //不清空 20分钟内 验证码 是不会丢的。。就可以暴力的测试 用户名和密码了。
                    //验证码 验证一次就失效了。
                    Session["validateCode"] = null;
                }
            }
            return isSuccess;

        }
    }
}