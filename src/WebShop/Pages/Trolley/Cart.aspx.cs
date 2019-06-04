using BookShop.BLL;
using BookShop.Model;
using Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Trolley
{
    public partial class Cart : System.Web.UI.Page
    {   
        public List<BookShop.Model.Cart> CartList { get; set; }

        public User user { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //做到这一点的 时候 就把之间没有晚上的做做完整
                //关键的是要自己一点一点代码写出来。
                UserManager userManager = new UserManager();
                if (userManager.ValidateUserLogin())
                {
                    user = (User)Session["userInfo"];
                    BindCartList();
                }
                else
                {

                    //f59bd65f7edafb087a81d4dca06c4910    md5加密算法 大小写出来的结果是不一样的。
                    //f59bd65f7edafb087a81d4dca06c4910
                    //跳转到登陆页面带上当前的地址

                    //  HttpContext.Current.Response.Write("/Pages/Account/Login.aspx?returnUrl=" + HttpContext.Current.Request.Url);
                    WebCommon.RedirectPage();
                }

            }

        }


        protected void BindCartList()
        {
            CartManager cartManager = new CartManager();
            string where = "UserId=" + ((User)Session["userInfo"]).Id;
            DataSet ds = cartManager.GetList(where);
            CartList = cartManager.DataTableToList(ds.Tables[0]);

        }
    }
}