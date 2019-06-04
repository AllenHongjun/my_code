using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Filter
{   

    /// <summary>
    /// 这是一个特性标记的类 也是可以当中一个正常的类来使用
    /// 也可以 当中打上标记来使用。 这里主要是在请求管道当中过滤使用
    /// </summary>
    public class MyExceptionAttribute:HandleErrorAttribute
    {


        public static Queue<Exception> ExceptionQueue = new Queue<Exception>();

        /// <summary>
        /// 重写一下父类的方法 然后又重新执行一下父类的方法
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnException(ExceptionContext filterContext)
        {
            base.OnException(filterContext);

            //filterContext 就是封装了当前请求的一个类 这个就很方便了很多东西都可以拿来使用了

            //父类默认的构造方法会执行 有其他参数的构造方法会执行 

            //记录接口调试的数据 记录异常错误的时候   log4net是和记录接口的调试数据吗

//            App_Data是ASP.NET专用于存储应用程序本地数据库的保留文件夹...此文件夹受ASP.NET保护，禁止直接访问和运行...也就是说不可以通过URI浏览或下载文件夹中的文件...

//由于这种保护是通过IIS的安全机制进行的，WinForm是不可能有的...而且Windows客户端都是在用户计算机上运行，实际上也不需要这种功能...

            Exception ex = filterContext.Exception;
            ExceptionQueue.Enqueue(ex);
            //filterContext.HttpContext.Response.Redirect("/Admin/Error/Index");
            filterContext.HttpContext.Response.Write(ex.Message);

            //通过一个线程日志 的形式 将所有全局错误信息记录到日志的文件当中。
            //已经都有一些很功能做好了 你就是要会使用 要多去使用。






        }
    }
}