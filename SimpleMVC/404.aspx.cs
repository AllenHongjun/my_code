using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SimpleMVC
{
    public partial class _404 : System.Web.UI.Page
    {   

        //自己一点一点研究 虽然是慢了一点  但是影响 会更加的深刻
        //一定要坚持 全部都学习 结束才会有感觉 
        //学一点 学一般 。学一些。。都是不行的。。
        //全部学习完了 才是一个新的开始
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.StatusCode = 404;
            Response.StatusDescription = "Not Found";
            Response.ContentType = "text/html";

            Response.Write("<h2>木有找到</h2>");
        }
    }
}