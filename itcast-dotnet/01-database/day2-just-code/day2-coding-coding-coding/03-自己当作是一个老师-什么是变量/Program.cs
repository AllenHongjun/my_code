using System;
using System.Linq;
using System.Xml;

namespace _03_自己当作是一个老师_什么是变量
{
    class Program
    {
        static void Main(string[] args)
        {
            /*
             *变量 字符类型
             *
             * 数字类型
             *
             * 数据类型
             *
             *值类型 的处理方法
             *
             *https://www.cnblogs.com/wywnet/p/3523941.html
             *
             * https://docs.microsoft.com/zh-cn/dotnet/csharp/tour-of-csharp/types-and-variables
             *
             *https://docs.microsoft.com/zh-cn/dotnet/csharp/language-reference/keywords/char
             *
             */


            /*
             *.net core 与 .net 有哪些不同。。要补充学习哪些知识。。
             *
             *变量的类型  可以是 接口类型 class类型 值类型 int bool string char
             *
             * 也可以是引用的类型。。
             *
             * 语法知识点复习。。泛型 字典类型 其实也是一个类的类型
             *
             * 专门定义一些系统的类型来使用。。
             *
             * C#是一门强类型的语言。。
             *
             *
             */
            //Console.WriteLine("Hello World!");

            //// 类型的转化 
            ////int n = 3.14;
            //double n = 3.14;
            ////long n1 = 3.123;

            //decimal n2 = 99.99m;

            //// 动态类型 和 十进制类型 这个有些类似的要注意区别
            //dynamic abc;

            //// https://www.cnblogs.com/JustRun1983/p/3163350.html   理解C# 4 dynamic(1) - var, object, dynamic的区别以及dynamic的使用

            //// 使用goole 都能很好的找到这些知识点。。 baidu 就是垃圾 烦的的要死


            //int a = (int)3.141512;

            ////resharp  https://www.jetbrains.com/resharper/  这个扩展还是听好用的。要下载一个下来
            //Console.WriteLine(a);

            //// long 就是64位的整数
            //long b = Convert.ToInt64(3.14151515);

            //int c = Convert.ToInt32(3.15151515);

            //Console.WriteLine(a);

            //Console.WriteLine(b);

            //Console.WriteLine(d);

            //Console.ReadKey();


            // 相当于借助 这个平台 就直接 操作 操作系统  

            //string zsName = "张三";

            //// 着s 里面存放的是什么东西。。 这个就当做是个 null 但是 又不是null 又看不到里面存放的是什么东西

            ////https://stackoverflow.com/questions/31500618/difference-between-string-s-and-string-s-null
            //string s = "";
            //string s1 = " ";
            //if (s == s1)
            //{
            //    Console.WriteLine("s 和s1是相等的");
            //}

            //if (s == null)
            //{
            //    Console.WriteLine("s 里面存放的是null");
            //}

            //Console.WriteLine("这个就是这样子结束了");

            ////char gender = '男女';

            ////char c = '';

            //// 一个字符 一个汉字 也是一个字符 
            //char c = 'a';


            //char b = '8';

            //char z = 'L';

            //char d = '.';

            //char e = '\t';

            //char f = '\n';

            //char g = '\\';


            //// 从计算机的角度来思考一下 这个问题

            //char m = ' ';

            ////char n = '   ';

            //string testString = "15958456864";

            //string w = "这个是一个W";

            //string address = "这个是诗和远方";

            ////着是简单的代码 就当做是练习手感了。。再回顾一遍。。

            //// 还有一些薄弱的点 需要重点回顾 强化的 就是要多敲 。。看不懂 还要结合视频看看。。

            //// 看起来 你好像又了很多东西。。其实都是没有什么用的。。


            //// 2
            //// 注意 第一位还是 符号位 。。  int 类型 一共只有10位
            //Console.WriteLine(Math.Pow(2,31));

            ////2147483648

            //Console.WriteLine(Math.Pow(2, 63));

            ////9.22337203685478E+18

            //testString.IndexOf('c');

            //// 这个就是一个对象的实例。。当然可以调用 这个类 他自己的方法。

            //// 排序之后 。。。在返回一个字符串。。。
            //string testStringOrder =  testString.OrderBy(x => x).ToString();
            //Console.WriteLine(testStringOrder);


            //// 这么多的工具方法 可以调用 。。如何利用起来  调用其起来。。

            //// 哪些代码 都要能够敲的出来。。
            //bool isUpper = Char.IsUpper('d');

            /*
             *十进制数 表示金额
             *
             * 整数int 无符号整数uint
             *
             * byte
             *
             * short  ushort
             *
             * long  ulong
             *
             * float 浮点数
             *
             * double 浮点数 
             *
             *
             *为什么浮点数 不精确
             *
             * https://www.zhihu.com/question/25457573
             */

            //decimal salery = 1000m;
            //int month = 6;

            //decimal a = salery / month;
            ////333.3333333333  四色五入 保留几位小数
            //Console.WriteLine(a);

            ////https://blog.csdn.net/youanyyou/article/details/78990100  用decimal 来表示精度
            //// 有更高的精度 和更小的范围
            ////https://blog.csdn.net/u010771437/article/details/40867831/

            ////  计算出来 再保留 两位小数就可以了。

            //Console.WriteLine( Char.IsDigit('1'));

            //Console.WriteLine( Char.MaxValue);

            //Console.WriteLine( Char.IsLetter('d'));

            //Console.WriteLine( Char.IsLetterOrDigit('d'));

            //Console.WriteLine( Char.IsLower( 'D'));

            //Console.WriteLine( Char.IsUpper('a'));

            //Console.WriteLine( Char.IsPunctuation('.'));

            //Console.WriteLine( Char.IsSeparator('\n'));

            //Console.WriteLine( Char.IsSeparator('|'));

            //Console.WriteLine( Char.IsWhiteSpace(' '));

            //Console.ReadKey();


            //char[] chars = new char[4];

            //chars[0] = 'X';        // Character literal
            //chars[1] = '\x0058';   // Hexadecimal
            //chars[2] = (char)88;   // Cast from integral type
            //chars[3] = '\u0058';   // Unicode

            //foreach (char c in chars)
            //{
            //    Console.Write(c + " ");
            //}
            //// Output: X X X X

            // 字符串格式化。。

            // https://www.cnblogs.com/FlyingBread/archive/2007/01/18/620287.html  字符串格式

            // decimal 数据类型 个金额的格式 （保留两位小数、）

            // 个人征信报告 官方查询 最近5年内 交通 和 招商 个又预期的记录。。
            // 其他没有激活的信用卡 要取消掉。。

            // 每次贷款 都是会有记录 的  你以为那个钱是随便就给你的呀。。

            // 看着好的东西 都是坑。。

            decimal x = 0.999m;
            decimal y = 9999999999999999999999999999m;
            Console.WriteLine("My amount = {0:C}", x);
            Console.WriteLine("Your amount = {0:C}", y);
        }
    }
}
