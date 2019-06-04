<%@ WebHandler Language="C#" Class="first" %>

using System;
using System.Web;
using System.IO;
using System.Text;


// 一般处理程序里面的方法 是谁来调用的。？？感觉是 .net freamwork 回来调用
public class first : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");

        //context.Response.ContentType = "text/html";//指定返回给浏览器的数据类型是文本字符串
        // http 不是长链接。 无状态行  
        // context.Response.Write("Hello World");//将字符串返回给浏览器。
        StringBuilder sb = new StringBuilder();
        sb.Append("<table border='1'><tr><td>用户名</td><td>itcast</td></tr>");
        sb.Append("<tr><td>密码</td><td>123</td></tr></table>");
        context.Response.Write(sb.ToString());
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}