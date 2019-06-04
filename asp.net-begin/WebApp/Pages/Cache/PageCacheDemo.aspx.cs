using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class PageCacheDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //使用页面 缓存  通过页面配置  可以使用 浏览器 http请求的页面缓存 
            //知道这个原理 然后在响应的技术 找响应的方法 来执行就可以了

            Response.Write(DateTime.Now.ToString());
        }
    }
}