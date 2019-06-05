using CZBK.ItcastOA.WebApp.Models;
using log4net;
using Spring.Web.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace CZBK.ItcastOA.WebApp
{
    // 注意: 有关启用 IIS6 或 IIS7 经典模式的说明，
    // 请访问 http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : SpringMvcApplication //System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            log4net.Config.XmlConfigurator.Configure();//读取了配置文件中关于Log4Net配置信息.
            IndexManager.GetInstance().StartThread();//开始线程扫描LuceneNet对应的数据队列。

            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            //开启一个线程，扫描异常信息队列。
            string filePath = Server.MapPath("/Log/");
            ThreadPool.QueueUserWorkItem((a) => {
                while (true)
                {
                    //判断一下队列中是否有数据
                    if (MyExceptionAttribute.ExecptionQueue.Count() > 0)
                    {
                        Exception ex=MyExceptionAttribute.ExecptionQueue.Dequeue();
                        if (ex != null)
                        {
                            //将异常信息写到日志文件中。
                            //string fileName = DateTime.Now.ToString("yyyy-MM-dd");
                            //File.AppendAllText(filePath+fileName+".txt",ex.ToString(),System.Text.Encoding.UTF8);
                            ILog logger = LogManager.GetLogger("errorMsg");
                            logger.Error(ex.ToString());
                        }
                        else
                        {
                            //如果队列中没有数据，休息
                            Thread.Sleep(3000);
                        }
                    }
                    else
                    {
                        //如果队列中没有数据，休息
                        Thread.Sleep(3000);
                    }
                }
            
            
            },filePath);

        }
       //异常处理的过滤器。
    }
}