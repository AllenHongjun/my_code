using AppMvc.Filter;
using log4net;
using Spring.Web.Mvc;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace AppMvc
{
    public class MvcApplication : SpringMvcApplication // System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            //一定要在这里加上这句初始化。。不然无法记录

            //这些组件的使用 你就想是和别人在和做开发一样。。别人都已经是做好这些东西。然后你和做开发就可以了
            //
            log4net.Config.XmlConfigurator.Configure();


            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);


            //异常统一的处理 就在程序运行的时候就会一直处理
            //开启一个线程来扫描异常队列中的信息  没过几秒钟就将队列中的数据记录到日志的文件当中

            string filePath = Server.MapPath("/Log/");
            //从线程池取出一个线程来使用

            //一个组件 一个东东的使用 花两个小时 其实就能搞明白一些东西了
            //就是动手去做 去测试就可以了
            ThreadPool.QueueUserWorkItem(x =>
            {
                //这里的 x 其实就是 filePath 
                while (true)
                {
                    if (MyExceptionAttribute.ExceptionQueue.Count() > 0)
                    {
                        Exception ex = MyExceptionAttribute.ExceptionQueue.Dequeue();
                        if (ex != null)
                        {
                            //开启一个线程来专门的记录日志文件的信息 线程池这一块的内容还详细的拓展一下使用
                            //string fileName = DateTime.Now.ToString("yyyy-MM-dd");
                            //File.AppendAllText(filePath + fileName + ".txt", x.ToString(), Encoding.UTF8);
                            //读写文件通常需要一些权限 没有权限的时候就会无法执行
                            //File.AppendAllText(filePath + fileName + ".txt", ex.ToString(), Encoding.UTF8);

                            //同时强调 网上浙中开源的好用的组件 有很多 花点时间 找一下 研究一下 测试一下 用用看

                            //区分 异常的记录文件夹 接口测试的数据文件夹 区分不同的 不要所有的和异常的混和在一起
                            ILog logger = LogManager.GetLogger("errorMsg");
                            logger.Error(ex.ToString());
                            logger.Info("这个是测试日志，查看是是否可以记录接口的数据");

                        }
                        else
                        {
                            Thread.Sleep(3000);
                        }
                    }
                    else
                    {
                        //如果队列中没有数据 暂定线程的执行 这一步一定不能少
                        Thread.Sleep(3000);
                    }


                }



            },filePath);




        }
    }
}
