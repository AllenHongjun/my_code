using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RedisDemo
{
    class Program
    {
        static void Main(string[] args)
        {   
            //将强类型的对象序列化未 字符串 让后将redis的对象 反序列化为我们需要的对象。。
            //我们知道那么多内容。。要是到如何使用不是所有的内容都是记住  。。而是用到时候 知道在哪里 能够找的到。。

            //缓存中使用的方法

            RedisCacheHelper.Set("TestKey", 15, new { name = "Allen", age = 18, school = "Tshqinhua" });

            Console.WriteLine("TestKey设置成功,点击获取内容");

            Console.ReadKey();

            string abc = RedisCacheHelper.GetStringKey("TestKey");

            Console.WriteLine(abc);

            Console.ReadKey();
        }
    }
}
