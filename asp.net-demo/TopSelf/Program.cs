using log4net;
using log4net.Config;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

using System.Threading.Tasks;
using System.Timers;
using Topshelf;

namespace TopSelf
{

    /*
     https://www.cnblogs.com/jys509/p/4614975.html#autoid-0-0-0  TopShelf 让程序作为服务运行 


    安装：TopshelfDemo.exe install
    启动：TopshelfDemo.exe start
    卸载：TopshelfDemo.exe uninstall
         
         */

    public class TownCrier
    {
        private Timer _timer = null;
        readonly ILog _log = LogManager.GetLogger(
                                         typeof(TownCrier));
        public TownCrier()
        {
            _timer = new Timer(1000) { AutoReset = true };
            _timer.Elapsed += (sender, eventArgs) => _log.Info(DateTime.Now);
        }
        public void Start() { _timer.Start(); }
        public void Stop() { _timer.Stop(); }
    }

    class Program
    {
        public static void Main(string[] args)
        {
            var logCfg = new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "log4net.config");
            XmlConfigurator.ConfigureAndWatch(logCfg);

            HostFactory.Run(x =>
            {
                x.Service<TownCrier>(s =>
                {
                    s.ConstructUsing(name => new TownCrier());
                    s.WhenStarted(tc => tc.Start());
                    s.WhenStopped(tc => tc.Stop());
                });
                x.RunAsLocalSystem();

                x.SetDescription("Sample Topshelf Host服务的描述");
                x.SetDisplayName("Stuff显示名称");
                x.SetServiceName("Stuff服务名称");
            });
        }
    }







    //// 最基本的 服务测试 使用.
    //public class TownCrier
    //{
    //    readonly Timer _timer;
    //    public TownCrier()
    //    {
    //        _timer = new Timer(1000) { AutoReset = true };
    //        _timer.Elapsed += (sender, eventArgs) => Console.WriteLine("It is {0} and all is well", DateTime.Now);
    //    }
    //    public void Start() { _timer.Start(); }
    //    public void Stop() { _timer.Stop(); }
    //}

    //public class Program
    //{
    //    public static void Main()
    //    {
    //        var rc = HostFactory.Run(x =>                                 //1
    //        {
    //            x.Service<TownCrier>(s =>                        //2
    //            {
    //                s.ConstructUsing(name => new TownCrier());     //配置一个完全定制的服务,对Topshelf没有依赖关系。常用的方式。
    //                                                               //the start and stop methods for the service
    //                s.WhenStarted(tc => tc.Start());              //4
    //                s.WhenStopped(tc => tc.Stop());               //5
    //            });
    //            x.RunAsLocalSystem();                            // 服务使用NETWORK_SERVICE内置帐户运行。身份标识，有好几种方式，如：x.RunAs("username", "password");  x.RunAsPrompt(); x.RunAsNetworkService(); 等

    //            x.SetDescription("Sample Topshelf Host服务的描述");        //安装服务后，服务的描述
    //            x.SetDisplayName("Stuff显示名称");                       //显示名称
    //            x.SetServiceName("Stuff服务名称");                       //服务名称
    //        });                                 //10

    //        var exitCode = (int)Convert.ChangeType(rc, rc.GetTypeCode());  //11
    //        Environment.ExitCode = exitCode;
    //    }
    //}
}
