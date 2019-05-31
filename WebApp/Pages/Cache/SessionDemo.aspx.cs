using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class SessionDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   

            //设置session的值 给每一个用户 都会设置
            //session id 自动创建 和返回对象
            Session["str"] = "itcast.com";
            Response.Redirect("ReadSessionDemo.aspx");


            //session 存储到数据库 。。。如果是多台机器。。。就

            //请求分发。。两台机器上 部署相同一个网站。。负载均衡。。。分发是很快
            //但是出来请求 执行程序的过程 就会比较慢了。。

            //response.Rediret 302  

            //网站分布式部署。。负载均衡。。多台服务器集群。。 什么样子的规模。。。
            // 数据库集群 。。如何搭建web服务器的集群  也就是 负载均衡。。。。

            //有一台机器专门 作为请求分发的服务器。。。服务器的配置。。专门作为 session存储。。

            // 了解 微软的方案 性能太差。 session存储到数据 经常要查询数据。。session ID存储到数据 。

            //将session 存储到缓存当中。。3台4台服务器。。其实就是这么一回事。。。 
            // 微软自带的功能 了解就可以 将对象 JSON.net序列话存储到 缓存当中。。

            //项目中的解决方案。。如果呀配置。。各种东西。。项目的原理。。实际执行。。的效果 没有真实的项目执行。。
            //web服务器集群 有哪些问题 需要解决。。。 为了 面试的 

            //错误页面配置 

            // httpmodule 的使用 

        }
    }
}