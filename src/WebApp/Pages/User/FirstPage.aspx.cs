using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages
{
    public partial class FirstPage : System.Web.UI.Page
    {

        public string strHtml = "Hello FirstPage!!";


        //这是一个事件 。已经被框架注册了 
        //先执行 Page_Load的方法 然后才会 执行页面当中的代码
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}