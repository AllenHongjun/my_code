using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace WebApp
{   
    //这个文件的名称是不能修改的 并且 放在网站的根目录下
    public class Global : System.Web.HttpApplication
    {

        //就是我们说过的 请求管道事件
        protected void Application_Start(object sender, EventArgs e)
        {
            //应用程序启动的时候 会被自动会调用
            //只会调用一次。 其他请求的时候 是不会调用这个方法的
            // Web应用程序的入口
            //winform 应用程序的 main函数
            //后台已经帮你 做了很多事情  
            //所以你即使 不写代码 应用程序也能够完整的很好的执行


            //完成 应用程序的初始化工作。

            //OA B2C 
            //大数据的统计  表中数据量大的时候 
            //分组统计 是非常耗时间的。 即时应用程序

            //当到达某个时间的时候 自动执行

            //qunzen.net  .NET Freamwork 
            //不要只局限于 web的类库 放到net. freamwork 下来思考

            // 可以在这里启动一个 定时任务的程序

            //这个是应用程序运行

            //其他是请求管道


        }

        protected void Session_Start(object sender, EventArgs e)
        {

            //Application:服务端的状态保持机制。
            //放在该对象中的数据是共享的

            //这个方法也是通过 SessionId 来判断 
            //建立session的时候 会在请求响应的时候返回sessionID
            //你是几个访客 

            //有些对象是全局共享的。cache 所有用户从缓存中获取的数据
            //是一样的 需要加锁和解锁  这个是在内存中的

            //别的页面中 需要的时候就可以调用了
            Application.Lock();
            int count = Convert.ToInt32(Application["count"]);
            count++;
            Application["count"] = count;
            Application.UnLock();

        }

        //在请求管道事件中处理一些事情。 
        // 请求开始的时候 

        //请求管道中PreLoad Init 请求管道中事件对应的方法
        //每一个请求 过来的时候 统一的处理 
        //session 统一验证和判断
        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        //protected void Application_

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }


        //全局的异常处理点。 全局 把我 再到细节

        
        protected void Application_Error(object sender, EventArgs e)
        {
            try
            {

            }
            catch (Exception)
            {
                Exception ex = HttpContext.Current.Server.GetLastError();
                string msg = ex.Message;
                // 将异常信息 记录到日志
                // 无论那个页面抛出异常了 都会到这个方法里面来执行。
                //写入日志 对文件加锁  一个一个人写  或者 队列

                //数据先先写到队列中 多线程 写入队列之后 请求继续
                // 之后将队列中的数据 写入 文件中 
                //数据写入文件中的并发请求的时候会非常慢的
                //Log4Net 生产者 消费者

                //直接操作数据库。数据非常慢 不断加锁解锁 

                //下单订 12306 买票 要买票一个一个的来。
            }
        }


        //session 就是一个会话  交流
        /// <summary>
        /// （用户通过浏览器第一次访问我们的网站中某个页面的时候,
        /// 这个时候简历会话 给每一个用户创建一个单独的会话,但是当
        /// 改用户通过浏览器再次访问其他页面的时候。改方法不会被执行
        /// 程序会判断 如果已经建立了会话 就不会再执行这个方法
        /// SessionID）
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Session_End(object sender, EventArgs e)
        {
            //session 过期的时候 一个session过期的时候
            // 多个人同时调用一个方法的时候 会出现的问题

            //当前在线人数  你是第几个访客 

            //你看到一个效果 功能是如何实现的

            //要更新一下数据库 持久化存储数据。



            Application.Lock();
            int count = Convert.ToInt32(Application["count"]);
            count--;
            Application["count"] = count;
            Application.UnLock();

        }

        /// <summary>
        /// 会话结束
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Application_End(object sender, EventArgs e)
        {
            
            //应用程序结束 退出的时候  
            //

        }
    }
}