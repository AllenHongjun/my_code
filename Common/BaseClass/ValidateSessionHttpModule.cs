using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Common.BaseClass
{
    class ValidateSessionHttpModule: IHttpModule
    {

        public void Dispose()
        {
            throw new NotImplementedException();
        }

        public void Init(HttpApplication context)
        {
            context.AcquireRequestState += context_AcquireRequestState;
        }



       
        //web config里面要加配置 
        // 执行请求管道中 这个第9个事件 触发的时候 这个方法 是会 自动被调用 这个执行的。。
        //  根据请求的 url地址来判断。。  企业版本的时候 很多时候 要注意的点

        //HttpModule 其实就是请求管道中事件。。就可以 写事件 来执行请求管道中的事件的方法。。自己来定义

        //请求管道的事件 。。一步一步周 asp.net 11天基本完成。。最好是再用两天的事件 强化复习一下里面的内容
        //然后再来做图书商城的小项目 


        public void context_AcquireRequestState(object sender, EventArgs e)
        {
            HttpApplication application = sender as HttpApplication;
            HttpContext context = application.Context;//获取当前的HttpContext
            string url = context.Request.Url.ToString();//获取用户请求的URL地址。

            //有些页面不需要判断  就可以过滤一下。。。这个是统一的过滤的
            if (url.Contains("Admin"))
            {
                if (context.Session["userInfo"] == null)
                {
                    context.Response.Redirect("/Login.aspx");
                }
            }

        }


        ////
        //// 摘要:
        ////     ASP.NET 将 HTTP 标头发送到客户端之前发生。
        //public event EventHandler PreSendRequestHeaders;
        ////
        //// 摘要:
        ////     在选择该处理程序对请求作出响应时发生。
        //public event EventHandler MapRequestHandler;
        ////
        //// 摘要:
        ////     释放应用程序时发生。
        //public event EventHandler Disposed;
        ////
        //// 摘要:
        ////     作为执行的 HTTP 管道链中的第一个事件发生，当 ASP.NET 的请求做出响应。
        //public event EventHandler BeginRequest;
        ////
        //// 摘要:
        ////     当安全模块已建立的用户标识时出现。
        //public event EventHandler AuthenticateRequest;
        ////
        //// 摘要:
        ////     当安全模块已建立的用户标识时出现。
        //public event EventHandler PostAuthenticateRequest;
        ////
        //// 摘要:
        ////     安全模块已验证用户身份验证时发生。
        //public event EventHandler AuthorizeRequest;
        ////
        //// 摘要:
        ////     当前请求的用户已被授权时发生。
        //public event EventHandler PostAuthorizeRequest;
        ////
        //// 摘要:
        ////     当 ASP.NET 完成授权事件以便从缓存中，跳过的事件处理程序 （例如，一个页面或 XML Web 服务） 执行的请求提供服务的缓存模块时发生。
        //public event EventHandler ResolveRequestCache;
        ////
        //// 摘要:
        ////     ASP.NET 将绕过当前事件处理程序的执行，并允许缓存模块以处理从缓存请求时发生。
        //public event EventHandler PostResolveRequestCache;
        ////
        //// 摘要:
        ////     ASP.NET 将内容发送到客户端之前发生。
        //public event EventHandler PreSendRequestContent;
        ////
        //// 摘要:
        ////     当 ASP.NET 已映射到相应的事件处理程序的当前请求时出现。
        //public event EventHandler PostMapRequestHandler;
        ////
        //// 摘要:
        ////     当 ASP.NET 已完成处理的事件处理程序时发生 System.Web.HttpApplication.LogRequest 事件。
        //public event EventHandler PostLogRequest;
        ////
        //// 摘要:
        ////     已释放与请求相关联的托管的对象时发生。
        //public event EventHandler RequestCompleted;
        ////
        //// 摘要:
        ////     获取与当前的请求相关联的请求状态 （例如，会话状态） 时发生。
        //public event EventHandler PostAcquireRequestState;
        ////
        //// 摘要:
        ////     ASP.NET 开始执行事件处理程序 （例如，一个页面或 XML Web 服务） 之前发生。
        //public event EventHandler PreRequestHandlerExecute;
        ////
        //// 摘要:
        ////     当 ASP.NET 事件处理程序 （例如，一个页面或 XML Web 服务） 完成执行时发生。
        //public event EventHandler PostRequestHandlerExecute;
        ////
        //// 摘要:
        ////     ASP.NET 完成执行所有请求事件处理程序后发生。 此事件会导致状态模块保存当前的状态数据。
        //public event EventHandler ReleaseRequestState;
        ////
        //// 摘要:
        ////     当 ASP.NET 已完成执行所有请求事件处理程序和存储数据的请求状态时发生。
        //public event EventHandler PostReleaseRequestState;
        ////
        //// 摘要:
        ////     当 ASP.NET 完成执行事件处理程序，以便让缓存模块存储将用于为从缓存中的后续请求提供服务的响应时发生。
        //public event EventHandler UpdateRequestCache;
        ////
        //// 摘要:
        ////     当 ASP.NET 完成更新的缓存模块和存储用于为从缓存中的后续请求提供服务的响应时发生。
        //public event EventHandler PostUpdateRequestCache;
        ////
        //// 摘要:
        ////     ASP.NET 执行当前请求的任何日志记录之前发生。
        //public event EventHandler LogRequest;
        ////
        //// 摘要:
        ////     当 ASP.NET 获取与当前的请求相关联的当前状态 （例如，会话状态）。
        //public event EventHandler AcquireRequestState;
        ////
        //// 摘要:
        ////     作为执行的 HTTP 管道链中的最后一个事件发生，当 ASP.NET 的请求做出响应。
        //public event EventHandler EndRequest;
        ////
        //// 摘要:
        ////     当引发未处理的异常时发生。
        //public event EventHandler Error;


    }
}
