using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebShop
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }


        //修改缓存中的值的收 remove 一下 缓存中的值。。

        //接受请求过来的地址  然后将地址 替换一下 转化层带参数的地址 有一点路由的意思

        // 在什么地方转化。。  

        /// <summary>
        /// 
        /// 只要在page 类创建之前就可以了。。IIS isapi_begin . ,,
        /// 一看到 请求的 aspx..或者 golable 就会 将请求的内容 给clr 运行时来处理。。
        /// 当中当然是有很多一系列复杂的过程。。应该是请求 先处理 。然后看 最后要执行
        /// 的是什么页面。。然后执行渲染里面的代码 然后将请求的内容 返回回去。。
        /// 
        /// mvc wabapi 
        /// 
        /// 请求管道中第一个事件触发以后调用的方法，完成URL重写。
        /// URL重写。
        ///带参数的URL地址进行改写。改写成不带参数的。
        //BookDetail.aspx?id=2;   BookDetail_2.aspx

        //为什么将带参数的URL地址改成不带参数的？URL重写的目的就是SEO。

        //SEO.

        //怎样进行URL重写？

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            //请求过来的地址 
            string url = Request.AppRelativeCurrentExecutionFilePath;//~/BookDetail_4976.aspx

            //@"~/Pages/Shop/ShopDetail_(\d+).aspx"  必须是格式的url地址 才能匹配上。。不然就不转化

            // ~/Pages/Shop/ShopDetail_(\d+).jsp  iis限制了。
            Match match = Regex.Match(url, @"~/Pages/Shop/ShopDetail_(\d+).aspx");
            if (match.Success)
            {   
                //第1个开始特殊的 和list string 数组从0开始不一样  第0个是整个正则表达式的内容
                //内容转换 要访问的地址。
                Context.RewritePath("/Pages/Shop/ShopDetail.aspx?id=" + match.Groups[1].Value);
            }

            //Match match = Regex.Match(url, @"~/BookDetail_(\d+).aspx");
            //if (match.Success)
            //{
            //    Context.RewritePath("/BookDetail.aspx?id=" + match.Groups[1].Value);
            //}



        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}