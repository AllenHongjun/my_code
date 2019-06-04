using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Topshelf;

namespace QuartzDemo
{
    class Program
    {

        /*
         https://www.cnblogs.com/jys509/p/4628926.html  快速搭建一个Quartz

         搭建一个定时的任务 并且作为一个服务启动

        安装不同版本的时候依赖项的问题
             
         */

        static void Main(string[] args)
        {
            log4net.Config.XmlConfigurator.ConfigureAndWatch(new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "log4net.config"));
            HostFactory.Run(x =>
            {
                //x.UseLog4Net();

                x.Service<ServiceRunner>();

                x.SetDescription("QuartzDemo服务描述");
                x.SetDisplayName("QuartzDemo服务显示名称");
                x.SetServiceName("QuartzDemo服务名称");

                x.EnablePauseAndContinue();
            });

        }
    }
}
