using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.ViewState
{
    public partial class ViewState : System.Web.UI.Page
    {
        public int Count { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            int count = 0;

            //ViewState["count"] 这里赋值之后。直接会在请求当中 接受viewState隐藏域当中的值

            //状态保持 获取上一次请求的结果 讲求的结果保存到 隐藏域当中 可以获取上一次请求的结果

            // cookie 客户端状态保持
            if (ViewState["count"] != null)
            {
                count = Convert.ToInt32(ViewState["count"]);
                count++;
                Count = count;
            }

            //整型变量没有初始化 默认值是0 
            ViewState["count"] = Count;

            //当我们把数据给了ViewState对象以后，该对象会将数据进行编码，然后存到__VIEWSTATE隐藏域中，然后返回给浏览器。
            //当用户通过浏览器单击“提交”按钮，会向服务端发送一个POST请求那么__VIEWSTATE隐藏域的值也会提交到服务端，
            //那么服务端自动接收__VIEWSTATE隐藏域的值，并且再反编码，重新赋值给ViewState对象。
            //ViewState 可以接收到上一次请求结果值

            //很多东西不分析一下 不知道他的原理。 
        


        }
    }
}