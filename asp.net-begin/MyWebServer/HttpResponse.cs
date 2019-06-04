using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyWebServer
{
    public class HttpResponse
    {
        byte[] buffer = null;

        public string Context_Type { get; set; }

        public HttpResponse(byte[] buffer,string filePath)
        {
            this.buffer = buffer;
            string fileExt = Path.GetExtension(filePath);
            switch (fileExt)
            {
                case ".html":
                case ".htm":
                    Context_Type = "text/html";
                    break;
            }

        }

        public byte[] GetHeaderResponse()
        {
            StringBuilder builder = new StringBuilder();

            builder.Append("HTTP/1.1 200 ok\r\n");
            builder.Append("Content-Type:" + Context_Type + ";charset=uft-8\r\n");
            builder.Append("Content-Length:" + buffer.Length + "\r\n\r\n");
            return Encoding.UTF8.GetBytes(builder.ToString());


        }


    }
}
