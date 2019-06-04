using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Pages.Ajax
{
    /// <summary>
    /// GetDate 的摘要说明
    /// </summary>
    public class GetDate : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {   

            //记住用户名
            // 自动登陆 不用输入用户名密码 

            //请求的原理。每一个请求的事件 
            //如何执行 我们这些方法里面的代码

            // Process 哪个阶段被执行 反编译工具的使用

            // 后台开发 js  前端开发的东西 eijx  阿贾克斯


            //这里就是可以接受ajax请求。。post 其他客户端的请求
            // app 小程序 各种客户端的请求
            //只要是请求都能够接受
            //context.Request.Form  context.Request.QueryString才区分
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            //context.Response.Write(DateTime.Now);
            //返回的内容会在后面追加上去

            //先放一下 aspx如何接受json过来的数据 
            //之前应该有写过的方法
            //使用控件的方式实现。。学一下 如何实现
            // 能把功能实现就可以
            context.Response.Write(context.Request["name"]);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}