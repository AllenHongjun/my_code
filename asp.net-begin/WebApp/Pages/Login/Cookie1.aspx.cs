using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Login
{
    public partial class Cookie1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Cookie:是一个客户端状态保持机制，（网站的数据是存在客户端），
            // 与隐藏域与ViewState对象都属于这种客户端状态保持，Cookie中存储的是关于网站相关的文本字符串数据
            // 。Cookie的存储方式有两种，如果不指定过期时间，那么存储在客户端浏览器内存中，
            // 如果指定了过期时间，那么存储在客户端的磁盘上。Cookie是与具体的网站有关的，
            // 如果我们将Cookie设置了过期时间，那么当用户在指定时间内访问我们的网站，
            // 那么属于我们网站的Cookie数据会放在请求报文中发送过来，其它网站的Cookie不会发送。

            //创建cookie  在响应头当中会加上 Set-Cookie属性 浏览器在请求服务器的时候会自动带上 这个cookie的值
            //每一个

            //Response.Cookies["Name"].Value = "AllenHong";

            //Cookie: Name=AllenHong; Sex=男 女 不是人妖  请求头里面会把网站的cookie的数据发送给服务端

            //value的值里面就可以 序列为一个对象。任意的来设置 了
            //可以设置某一个页面的 也可以设置 整个网站的 path路径来设置

            // 创建cookie并且指定过期时间 指定过期时间3天
            //Response.Cookies["Sex"].Value = "男 女 不是人妖";
            //Response.Cookies["Sex"].Expires = DateTime.Now.AddDays(3);
            //2019-05-14T00:45:16.822Z

            //设置这个cookie值过期了
            Response.Cookies["Sex"].Expires = DateTime.Now.AddDays(-1);
            //Set-Cookie: Sex=; expires=Fri, 10-May-2019 00:49:38 GMT; path=/
            //会把这个响应的内容发送给服务端
            //删除cookie设置过期时间


            //设置cookie的有效路径  跨域  结合请求头 响应头来查看  cookie 跨域的处理

            //如果 sessionID不返回的话 肯定就无法 判断是哪个单独的用户了。
            //很多工作都已经 做好了 直接拿来使用 能知道其中的原理 能用的更加的顺手
            Response.Cookies["cp9"].Value = "设置某个路径的cookie2323";
            //cookie设置 可以和哪个域名 关联 和哪个页面关联
            //只有设置主域名才可以 已经域名都换了是不可以的
            //Response.Cookies["cp9"].Domain = "http://www.baidu.com";   记住结论 不能测试。 其实用的也不太多
            Response.Cookies["cp9"].Expires = DateTime.Now.AddDays(7);

            //让浏览器 只有在这个页面请求的时候 才会发送cookie数据过来 
            //在例子中使用 cookie 记住用户名
            Response.Cookies["cp9"].Path = "/Pages/Login";



            //Cookie的域：浏览器往后台发送数据时候，要把cookie放到请求报文里面去，发送到后台。
            //那么有个问题：请求是子域的网页，那么主域的cookie会不会发送到后台呢？
            //答案：是的。一块发送。如果请求时主域页面，子域的cookie是不会发送到后台的。
            //如果子域想让请求主域页面的时候也一块发送到后台，设置当前Cookie的域为主域可以了。


            //自己对cookie的理解
            //Response.Cookies["cp3"].Value = "这个是设置了路径的cookie";
            //Response.Cookies["cp4"].Value = "把用户浏览商品的数据返回给用户 每个用户就不同了 根据返回的数据下次 返回的时候就可以查询了";
            //Response.Cookies["cp5"].Value = @"把SessionID 返回给用户 那一个SessionId就代表一个用户 然后就可以根据
            //    SessionID来获取用户 保存在服务端的数据 单独的数据了 asp.net 默认会创建一个sessionID返回保存到用户的cookie当中";


        }
    }
}