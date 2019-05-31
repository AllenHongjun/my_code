using Memcached.ClientLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVC.Common
{
    public class MemcacheHelper
    {
        private static readonly MemcachedClient mc = null;

        static MemcacheHelper()
        {   

            //asp.net 之前 商城的哪个项目使用了解 哪些东西 哪些地方使用了缓存。
            //最好放在配置文件中  服务器中也是要安装一下 memcached 
            //还可以安装redis ngix 
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
            // 就是往缓存的服务器 发送请求读取数据 设置数据 。非常简单的使用。。
            mc = new MemcachedClient();
            mc.EnableCompression = false;
        }
        /// <summary>
        /// 存储数据
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool Set(string key, object value)
        {
            return mc.Set(key, value);
        }
        public static bool Set(string key, object value, DateTime time)
        {
            return mc.Set(key, value, time);
        }
        /// <summary>
        /// 获取数据
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static object Get(string key)
        {
            return mc.Get(key);
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static bool Delete(string key)
        {
            if (mc.KeyExists(key))
            {
                return mc.Delete(key);

            }
            return false;

        }
    }
}
