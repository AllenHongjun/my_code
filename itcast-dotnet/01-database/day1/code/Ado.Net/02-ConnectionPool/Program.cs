using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _02_ConnectionPool
{
    class Program
    {
        static void Main(string[] args)
        {
            /*
             *https://www.cnblogs.com/liuhaorain/archive/2012/02/19/2353110.html
             *https://cloud.tencent.com/developer/article/1082887
             *https://www.cnblogs.com/1zhk/articles/5075700.html
             *
             * ctrl + K ctrl + b sublime 切换左侧菜单快捷键
             */
            string connStrPool =
                "Data Source=.;Initial Catalog=Hotel;User ID=sa;Password=a123456;Pooling=true;Min Pool Size=4";
            string connStr = "Data Source=.;Initial Catalog= Hotel;User ID =sa; Password=a123456;Pooling=false";
            int i = 0;
            Stopwatch sw = new Stopwatch();
            sw.Start();
            while (i < 10000)
            {   
                //循环一次 创建一个连接对象 打开一次新的链接。模拟高并发的情况
                using (SqlConnection conn = new SqlConnection(connStrPool))
                {
                    conn.Open();
                }

                i++;
            }
            sw.Stop();
            //获取毫秒数量
            Console.WriteLine(sw.Elapsed.Milliseconds);
            sw.Reset();
            sw.Restart();

            i = 0;
            while (i < 10000)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                }

                i++;
            }
            sw.Stop();

            // 明明都等了 5-6秒钟 他考试 这个时间  只有1秒钟不到。这个也是奇怪了。
            // 
            Console.WriteLine(sw.Elapsed.Milliseconds);
            Console.ReadKey();

        }
    }
}
