using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Shop
{
    public partial class ShopDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // seo想了解 的课程视频考过来学习下
            //打一个招呼 认识  认识。。


            string id = Request["id"];
            Response.Write(id);

        }
    }
}