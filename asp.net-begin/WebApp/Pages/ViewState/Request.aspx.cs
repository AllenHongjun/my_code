using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.ViewState
{
    public partial class Request : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   
            //当前的url地址  当前请求的url的地址
            string url = Request.Url.ToString();
            //跳转过来的地址  上次请求的url地址  该请求链接到当前的请求
            string urlReferrer = Request.UrlReferrer.ToString();
            
            Response.Write(url);

            Response.Write("<hr>");
            //可以用来放置偷盗链接     别人访问的网站的图片 盗取的是我服务器上图片  加个水印。
            // 图片请求到当前页面 之前的url地址
            Response.Write(urlReferrer);

            //获得远程客户端的IP的地址
            Response.Write("<hr>");
            string host = Request.UserHostAddress.ToString();
            Response.Write(host+"</br>");

            //清空缓冲区的所有内容  Clear() 之前的内容 就不会输出了。 内容就是 在缓冲区 然后才会输出的。 
            //Response.Clear();
            Response.Write(Request.UserAgent + "<br>");

            Response.Buffer = true;


            //将缓冲区的数据 全部输出给用户  了解下有这些类
            Response.Flush();



            Response.End();
            //会停止改页的执行。出发ENDRequest事件的执行 
            //这个后面的内容就不会执行了

        }
    }
}