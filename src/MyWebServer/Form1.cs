using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
//using System.Web;
using System.Windows.Forms;

namespace MyWebServer
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            TextBox.CheckForIllegalCrossThreadCalls = false;
        }


        Socket listenSocket = null;

        /// <summary>
        /// 开启服务器 创建一个一个负责监听的  创建一个复杂处理的
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            listenSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            IPAddress ipAddress = IPAddress.Parse(this.txtIpAddress.Text);
            IPEndPoint iPEndPoint = new IPEndPoint(ipAddress,Convert.ToInt32( this.txtPort.Text));

            //监听的Socket绑定了一个通信的节点
            listenSocket.Bind(iPEndPoint);
            listenSocket.Listen(10);

            Thread myThread = new Thread(BeginAccept);
            myThread.IsBackground = true;
            myThread.Start();

        }


        private void BeginAccept()
        {
            //浏览器 就可以向我自己的写的web 服务器发送请求了 好流弊的样子呀
            //简化版的 先理解一下 还真的是好玩
            
            //死循环：负责监听的Socket一致要等待客户端数据。

            //每一个请求过来 方法不能退出 继续处理
            while (true)
            {   
                //这 个创建 socket的代码会阻塞主线程
                Socket newSocket = listenSocket.Accept();
                HttpApplication httpApplication = new HttpApplication(newSocket,ShowMsg);
            }

        }

        private void ShowMsg(string msg)
        {
            this.txtContent.AppendText(msg + "\r\n");
        }


        //理解 浏览器 和 服务器这个之间通行也是走的socket
        //TCP socket 双向通行 企业级使用的 api  可以使用哪些代码

        //SignalR
        //sta 注意线程的问题
        //
    }
}
