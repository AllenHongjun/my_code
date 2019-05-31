using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyWebServer
{
    public class HttpRequest
    {

        public HttpRequest(string msg)
        {

            //按照请求报文中的回撤换行符号进行分割
            string[] msgs = msg.Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            FilePath = msgs[0].Split(' ')[1];
            //获取用户请求的文件的名称

        }

        public string FilePath { get; set; }


    }
}
