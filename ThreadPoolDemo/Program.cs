using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ThreadPoolDemo
{
    class Program
    {
        static void Main(string[] args)
        {

            //一个对象 经常被创建 但是又比较的消耗的资源

            //就是 放一个 池 可以用到的时候 直接拿来使用就可以I
            //可以节省时间
            //Stop watch 监视程序运行的时间


            //用于是准确测量运行时间

            //可以测试一下 运行的时间
            Stopwatch sw = new Stopwatch();

            sw.Start();


            for (int i = 0; i < 1000; i++)
            {
                //创建一个线程的实例对象 里面放一个方法 要执行的事情

                //线程里面 放一个委托 

                //public delegate void ThreadStart();
                // ThreadStart 就是一个委托 里面就是放一个方法就可以
                new Thread(() =>
                {

                    //1 + 1 操作简单 时间非常短可以忽略不计
                    int j = 1 + 1;
                }).Start();
            }


            sw.Stop();

            //每一个版本都有一个对应的中文语言包 
            //一共多少毫秒
            Console.WriteLine(sw.Elapsed.TotalMilliseconds);


            sw.Reset();

            sw.Restart();


            for (int i = 0; i < 100000; i++)
            {
                //使用线程池
                //ThreadPool.GetMaxThreads
                //这个事件就大大的减少了 
                //从 线程池中取出一个线程 然后 线程执行一个委托来掉 一个方法  后面是传递参数
                //public delegate void WaitCallback(object state);

                //我这个电脑的性能 和 老师的相比好不知道多少倍

                //这么好的电脑 好好的利用 好好的写代码


                //双向通行  全双工 。。类库使用

                ThreadPool.QueueUserWorkItem(new WaitCallback(PoolCallBack), "SSSS" + i);
            }


            sw.Stop();
            Console.WriteLine(sw.Elapsed.TotalMilliseconds);
            Console.ReadKey();

        }


        // 这个回调函数里面就是执行 1+1
        private static void PoolCallBack(object state)
        {

            int i = 1 + 1;

        }
    }
}
