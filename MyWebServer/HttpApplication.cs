using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace MyWebServer
{

    public delegate void DGShowMsg(string msg);
    /// <summary>
    /// 完成客户端发送过来的数据处理
    /// </summary>
    public class HttpApplication
    {
        Socket newSocket = null;
        DGShowMsg dgShowMsg = null;
        public HttpApplication(Socket newSocket,DGShowMsg dgShowMsg)
        {
            this.newSocket = newSocket;
            this.dgShowMsg = dgShowMsg;

            //接受客户端发送过来的数据
            byte[] buffer = new byte[1024 * 1024 * 2];
            int receiveLength;

            //接受客户端发送过来的数据 返回数据世界的长度
            receiveLength = newSocket.Receive(buffer);

            if (receiveLength > 0)
            {
                string msg = Encoding.UTF8.GetString(buffer, 0, receiveLength);
                HttpRequest request = new HttpRequest(msg);
                ProcessRequest(request);
                dgShowMsg(msg);

            }



        }

        public void ProcessRequest(HttpRequest request)
        {
            string filePath = request.FilePath;
            //获取当前服务器程序运行的目录
            string dataDir = AppDomain.CurrentDomain.BaseDirectory;
            if (dataDir.EndsWith(@"\bin\Debug\") || dataDir.EndsWith(@"\bin\Release\"))
            {
                dataDir = System.IO.Directory.GetParent(dataDir).Parent.Parent.FullName;
            }
            //获取文件的完整的路径
            string fullDir = dataDir + filePath;
            using(FileStream fileStream  = new FileStream(fullDir, FileMode.Open, FileAccess.Read))
            {
                byte[] buffer = new byte[fileStream.Length];
                fileStream.Read(buffer, 0, buffer.Length);

                //构建响应报文 
                HttpResponse response = new HttpResponse(buffer, filePath);
                newSocket.Send(response.GetHeaderResponse());
                newSocket.Send(buffer);


            }

        }


    }
}
