using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Test
{
    public partial class ThreadUnique : System.Web.UI.Page
    {   

        //线程内唯一的对象。。。 点开详细的信息 message
        protected void Page_Load(object sender, EventArgs e)
        {   

            //CallContext线程内唯一的内容  使用对象的时候 类的实例没有创建成功
            // Path.Combine(
            // HttpRuntime.AppDomainAppPath
            //Request.MapPath();

            //  string filePath = HttpContext.Current.Request.MapPath("/Images/body.jpg");
            ParameterizedThreadStart par = new
            ParameterizedThreadStart(GetFilePath);
            Thread thread1 = new Thread(par);
            thread1.IsBackground = true;
            thread1.Start(HttpContext.Current);
            // GetFilePath();
        }

        protected void GetFilePath(object context)
        {
            Common.WebCommon.GetFilePath(context);
        }


    }
}