using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Common
{   
    //继承真的是牛逼
    public class CheckSession:System.Web.UI.Page
    {   
        //这个Init 事件 ： aspx初始化触发
        //在load之间之前
        // session统一验证和校验  一种写法和做法
        public void Page_Init(object sender, EventArgs e)
        {
            if (Session["userInfo"] == null)
            {
                Response.Redirect("UserLogin.aspx");
            }
            else
            {
                Response.Write("欢迎" + ((UserInfo)Session["userInfo"]).UserName + "登录本系统");
            }
        }
    }
}
