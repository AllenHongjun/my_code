using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WnformDemo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            //是否检查 跨线程访问 禁用了 不建议使用
            TextBox.CheckForIllegalCrossThreadCalls = false;
        }


        //进程 一个webform应用程序 运行起来就相当于是一个进程
        /*
         一个进程式默认是不能访问 另一个进程的内容的。。 

         两个不同的应用程序 互相要通信  WCF webapi 
         
         
         */

        public void TestProcess()
        {

            Process[] ps = Process.GetProcesses();
            foreach (Process p1 in ps)
            {
                Console.WriteLine(p1.ProcessName);
                //p.Kill() 关闭进程
            }


            //获取当前运行程序进程

            //.net 的功能 是非常多的。。提过了很多操作
            //操作系统 文件 各种的类库 和功能

            //不是说你 用到的才是好的
            //视频播放模块 

            //要有自信 就是会如何使用
            //10天 半个月 就会使用了。 


            Process p = Process.GetCurrentProcess();
            Console.WriteLine(p.ProcessName);

            Process.Start("nodepad.exe");
            Console.ReadKey();

        }

        public void TestThread()
        {
            /*
             写的代码的执行 由线程来执行

             一个项目开发代码 文档 图片 比喻以及进程
             写代码的人  比喻一个线程

            一个代码流  代码的执行者

            线程比较小。。CPU 切换的时候 就会比较快

            单线程   一个应用程序 最少有一个线程

            主线程  演示单线程的问题

             
             
             */


        }

        /// <summary>
        /// 单线程的问题 演示
        /// 1. 如果操作很复杂。然后 ui界面 又会被阻塞   这个和并行任务 异步开发 有什么的区别
        /// 2. 希望更多的操作系统的资源 来操作我们的业务 来缩短我们的处理时间  比如下单订单 先生成订单 支付 
        ///    要发邮件 修改库存 发短信 记录统计  后台程序里面处理的功能是很多 。
        ///    可以将任务分开 创建单独线程来处理我们的任务。  线程主要的应用场景
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {


            //点击一个按钮
            //必须要执行所有的加法运行 
            //才能 显示弹出框

            //线程对象 线程创建 属性 方法 概念
            //注意的问题 如何使用线程

            //基础班就这个方便的概念  回顾学习 
            int a = 0;
            for (int i = 0; i < 600000000; i++)
            {
                a = i;
            }

            MessageBox.Show(a.ToString());

            /*
             360 是多线程的
             客户端程序 和 web应用程序还是有很大的区别的

             一个任务可以交由一个新的线程来执行
             

             
             */

        }

        /// <summary>
        /// 线程的创建 和 方法使用
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button2_Click(object sender, EventArgs e)
        {
            //创建一个子线程 来操作运行  这里代码还是主线程来执行
            //传入一个要执行的方法 方法运行结束之后 这个线程也就自动停止了
            ThreadStart threadStart = new ThreadStart(StartCaul);
            Thread myThread = new Thread(threadStart);

            //建议操作系统将我们创建的线程设置为最高 普通的线程优先级
            //myThread.Priority = ThreadPriority.Highest;
            //设置线程的名字
            //myThread.Name = "";
            //终止线程  但是尽量不要使用 但是暴力
            //myThread.Abort();
            //设置为后台线程

            //如果主线程关闭的 子线程不会关闭 这个设置  暂时就当做一个文件处理的类 来处理。 设置后台线程 是会关闭的
            // 执行线程的方法 希望 方法 能带参数
            myThread.IsBackground = true;
            //把我们的线程标记为可以执行的状态 具体执行又操作系统决定
            myThread.Start();

            //阻止主线程 1000毫秒   需要注意一下 关于 线程的属性和方法
            myThread.Join(1000);

            //这里就可以 继续执行主线程里面的代码
        }

        private void StartCaul()
        {
            //子线程运行的代码
            int a = 0;
            for (int i = 0; i < 60000000; i++)
            {
                a = i;
            }

            this.textBox1.Text = a.ToString();
            //MessageBox.Show(a.ToString());
            //this.textBox1.Show();

        }

        private void button3_Click(object sender, EventArgs e)
        {   
            //创建一个开始线程的对象
            List<int> list = new List<int>() { 1, 2, 3, 4, 5, 6 };
            ParameterizedThreadStart parThreadStart = new ParameterizedThreadStart(Show);

            Thread thread1 = new Thread(parThreadStart);
            thread1.IsBackground = true;
            //把参数通过Start方法传入进去
            thread1.Start(list);


        }

        private void Show( object obj)
        {
            List<int> list = obj as List<int>;
            foreach (int  i in list)
            {   
                //挨个答应 线程中的数字 数据
                MessageBox.Show(i.ToString());
            }
        }

        //跨线程访问
        private void button4_Click(object sender, EventArgs e)
        {
            Thread thread1 = new Thread(ShowResult);
            thread1.IsBackground = true;
            thread1.Start();
        }

        private void ShowResult()
        {
            int a = 0;
            for (int i = 0; i < 6000000; i++)
            {
                a = i;
            }

            // 是否要对文本框进行跨线程访问。

            //winform里面 UI线程是主线程
            if (this.textBox1.InvokeRequired)
            {
                //约束 Action所传递方法的参数
                //Invoke：去找创建TextBox的线程（主线程（UI线程）），由主线程完成委托方法的调用。
                this.textBox1.Invoke(new Action<TextBox, string>(ShowTextBoxValue), this.textBox1, a.ToString());
            }
            else
            {
                this.textBox1.Text = a.ToString();
            }


        }

        private void ShowTextBoxValue(TextBox txt,string value)
        {
            txt.Text = value;
        }

        private void button5_Click(object sender, EventArgs e)
        {   

            //一个线程执行完了 执行另外一个线程
            // 线程安全 需要加锁  不能两个线程同时进行计算


            Thread thread1 = new Thread(AddSum);
            thread1.IsBackground = true;
            thread1.Start();

            Thread thread2 = new Thread(AddSum);
            thread2.IsBackground = true;
            thread2.Start();
        }


        //🔒一个公共的对象 
        private static readonly object obj = new object();


        //当多个资源访问统一文件的会出现文件并发的问题
        //如何加锁 服务器要处理并发 请求
        //IIS 服务器是多线程 .net CLR 多线程处理我们的程序

       //开发多线程的应用程序 性能要块很多。。
        private void AddSum()
        {
            lock (obj)
            {
                for (int i = 0; i < 200000; i++)
                {
                    int a = Convert.ToInt32(this.textBox1.Text);
                    a++;
                    this.textBox1.Text = a.ToString();
                }


                // 1000个人一个请求 对应一个线程吗

                //如何请求分发 两台服务器 

                //服务器集群 服务器集群要处理的问题 

                //google windows server 负载平衡、群集、故障转移

            }


        }
    }
}
