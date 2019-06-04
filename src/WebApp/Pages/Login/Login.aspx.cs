using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class Login : System.Web.UI.Page
    {   

        //每个用户自己的用户名字写到他自己的电脑上
        //每一个不同的用户就是一个不同的端

        //并发处理请求的问题
        //不同用户请求过来的问题
        public string LoginUserName { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            //通过cookie将用户登陆的用户名自动赋值给输入框
            if (IsPostBack)
            {
                string userName = Request.Form["txtName"];

                //写入Cookie中
                Response.Cookies["userName"].Value = Server.UrlEncode(userName);
                Response.Cookies["userName"].Expires = DateTime.Now.AddDays(7);
            }
            else
            {   
                //只有第一次请求页面的时候才会执行这个里面的方法
                if (Request.Cookies["userName"].Value != null)
                {   
                    //读取cookie
                    string name = Server.UrlDecode(Request.Cookies["userName"].Value);
                    LoginUserName = name;

                    //重新写一遍
                    Response.Cookies["userName"].Value = Server.UrlEncode(name);
                    Response.Cookies["userName"].Expires = DateTime.Now.AddDays(3);

                }


            }



        }
    }
}