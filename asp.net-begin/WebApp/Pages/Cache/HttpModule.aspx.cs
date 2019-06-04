using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class HttpModule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            //请求管道的事件。。httpContext 是在 请求管道中往下面传递。。。

            //使用请求管道中事件 来完成session校验。。之前一直搞不懂。。其实是一个比较简单的东西 你理解了。
        }
    }
}