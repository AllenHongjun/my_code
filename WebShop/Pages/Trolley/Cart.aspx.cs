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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //做到这一点的 时候 就把之间没有晚上的做做完整
                //关键的是要自己一点一点代码写出来。
                UserManager userManager = new UserManager();
                if (userManager.ValidateUserLogin())
                {
                    BindCartList();
                }
                else
                {   
                    //跳转到登陆页面带上当前的地址
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