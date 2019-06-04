using Quartz.Impl;
using Quartz.Logging;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Quartz.NET
{   



    class Program
    {

        /// <summary>
        /// 官方的demo 电商网站 这个一般使用在什么地方
        /// 
        /// https://www.cnblogs.com/jys509/p/4628926.html  定时发送邮件  定时轮询同步数据   定时处理数据 
        /// 
        /// https://www.cnblogs.com/jys509/p/4628926.html#!comments  Quartz.NET 入门
        /// 
        /// 分享一个源码 然后 收一点币 这个耶听不错的.. 
        /// </summary>
        private class ConsoleLogProvider : ILogProvider
        {
            public Logger GetLogger(string name)
            {
                return (level, func, exception, parameters) =>
                {
                    if (level >= LogLevel.Info && func != null)
                    {
                        Console.WriteLine("[" + DateTime.Now.ToLongTimeString() + "] [" + level + "] " + func(), parameters);
                    }
                    return true;
                };
            }

            public IDisposable OpenNestedContext(string message)
            {
                throw new NotImplementedException();
            }

            public IDisposable OpenMappedContext(string key, string value)
            {
                throw new NotImplementedException();
            }
        }

       

        static void Main(string[] args)
        {

            //http://hao.jobbole.com/quartz-net/  quartz.net 一些组件的使用 使用的深度和广度 ..

            //而不是就把一个包下载下来就完事了.
            /*
             https://www.cnblogs.com/shanyou/archive/2012/01/15/2323011.html
             https://www.quartz-scheduler.net/documentation/quartz-3.x/quick-start.html   quick-start 

            Install-Package Quartz

             */

            LogProvider.SetCurrentLogProvider(new ConsoleLogProvider());


            // trigger async evaluation
            RunProgram().GetAwaiter().GetResult();
        }


        private static async Task RunProgram()
        {
            try
            {
                // Grab the Scheduler instance from the Factory
                NameValueCollection props = new NameValueCollection
                {
                    { "quartz.serializer.type", "binary" }
                };
                StdSchedulerFactory factory = new StdSchedulerFactory(props);
                IScheduler scheduler = await factory.GetScheduler();

                // and start it off
                await scheduler.Start();

                // define the job and tie it to our HelloJob class
                IJobDetail job = JobBuilder.Create<HelloJob>()
                    .WithIdentity("job1", "group1")
                    .Build();

                // Trigger the job to run now, and then repeat every 10 seconds
                ITrigger trigger = TriggerBuilder.Create()
                    .WithIdentity("trigger1", "group1")
                    .StartNow()
                    .WithSimpleSchedule(x => x
                        .WithIntervalInSeconds(10)
                        .RepeatForever())
                    .Build();

                // Tell quartz to schedule the job using our trigger
                await scheduler.ScheduleJob(job, trigger);



                // some sleep to show what's happening
                await Task.Delay(TimeSpan.FromSeconds(60));

                // and last shut down the scheduler when you are ready to close your program
                await scheduler.Shutdown();
            }
            catch (SchedulerException se)
            {
                await Console.Error.WriteLineAsync(se.ToString());
            }
        }
    }


    //await asysc 的用法.
    public class HelloJob : IJob
    {
        public async Task Execute(IJobExecutionContext context)
        {
            await Console.Out.WriteLineAsync("Greetings from HelloJob!");
        }
    }
}
