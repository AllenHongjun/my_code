using System;

namespace _05_变量的命名规范
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            #region 这个就是某一部分的内容
            /*

                 .net core 中文补丁  
                 .net freamwork 到 .net core 要学习哪些知识
                 多线程 异步什么的。。
                 之前的课程里面又哪些能容 要补充学习 要重点 学习 
                 看一下不太熟悉的重点的列出来。。
                 敲代码 敲代码 快乐的敲代码

                 使用翻墙什么的 什么的 是为了更加好的开发。。开发更加好的代码
                 写出更好的代码 来。。
                 敲代码 想敲什么代码就敲什么代码



                 有些东西 一下字 不需要知道的太多的细节 。
                 有很多的东西 只要知道 他是一个什么东西就可以了。

                 */
            Console.WriteLine("Hello World");
            Console.WriteLine("Hello World");

            Console.WriteLine("Womenshijiu shi ");
            Console.WriteLine("Hwwlw");
            // 敲代码的时候  只是需要敲一个符号就可以了
            /*
             林外的符号都是会自动不全的。。。
             这个就不需要来敲了。。
             看一下 如何省力的敲代码 而不是 一个一个都要自己敲。。
             那样容易敲错。。

            很多东西 还都是要 使用di三方的软件 组件 和插件 。。能够省力 很多。。

            
             
             */

            Console.WriteLine("这个是什么呀!"); 
            #endregion




        }


        /// <summary>
        /// 返回两个变量中的最大值
        /// </summary>
        /// <param name="n1"></param>
        /// <param name="n2"></param>
        /// <returns></returns>
        public static int GetMax(int n1, int n2)
        {   
            // 如果n1 > n2  就返回n1  ; 否者就返回n2 
            return n1 > n2 ? n1 : n2;
        }


        public class Person
        {

            // 直接给自动属性赋值
            public string Name
            {
                get;
                set;
            } = "zhangsan";

            /*
             就是给属性赋值的意识

             其实就是给这个类的属性附上初始值 。
             这个是C# 6.0 一种写法
             这个是定义一个类 的类型 。

             类的类型里面又这个方法 那个方法。

             定一个一个Class 的类型 
             定义一个Class的类型
             定一个一个Class的类型

             定一个一个Interface 的类型
             定义一个Interface 的类型
             https://www.cnblogs.com/gdpw/p/9463145.html
             */

            public string _Name2;

            public  string Name2
            {
                get
                {
                    return _Name2;
                }
                set
                {
                    value = "lisi";
                }
            }

        }

    }
}
