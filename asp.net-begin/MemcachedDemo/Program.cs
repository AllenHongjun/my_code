using Memcached.ClientLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MemcachedDemo
{
    class Program
    {
        static void Main(string[] args)
        {   

            //就是构建了一个集群 安装memcached 的使用 我们是一个客户端使用 
            //在实际项目中使用 可以在哪些地方使用 有一个唯一的KeyValue 来获取一个单独的数据 
            //项目中玩耍的东西。。
            string[] serverlist = { "127.0.0.1:11211", "10.0.0.132:11211" };

            //初始化池
            SockIOPool pool = SockIOPool.GetInstance();
            pool.SetServers(serverlist);

            pool.InitConnections = 3;
            pool.MinConnections = 3;
            pool.MaxConnections = 5;

            pool.SocketConnectTimeout = 1000;
            pool.SocketTimeout = 3000;

            pool.MaintenanceSleep = 30;
            pool.Failover = true;

            pool.Nagle = false;
            pool.Initialize();

            // 获得客户端实例
            MemcachedClient mc = new MemcachedClient();
            mc.EnableCompression = false;

            Console.WriteLine("------------测  试-----------");
            mc.Set("test", "my value");  //存储数据到缓存服务器，这里将字符串"my value"缓存，key 是"test"

            if (mc.KeyExists("test"))   //测试缓存存在key为test的项目
            {
                Console.WriteLine("test is Exists");
                Console.WriteLine(mc.Get("test").ToString());  //在缓存中获取key为test的项目
            }
            else
            {
                Console.WriteLine("test not Exists");
            }

            Console.ReadLine();

            mc.Delete("test");  //移除缓存中key为test的项目

            if (mc.KeyExists("test"))
            {
                Console.WriteLine("test is Exists");
                Console.WriteLine(mc.Get("test").ToString());
            }
            else
            {
                Console.WriteLine("test not Exists");
            }
            Console.ReadLine();

            SockIOPool.GetInstance().Shutdown();  //关闭池， 关闭sockets



        }
    }
}
