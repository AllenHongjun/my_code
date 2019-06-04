using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lamda
{
    class Program
    {

        //定义一个委托的类型
        public delegate int AddSum(int a, int b);


        //public delegate Func<int,int,int, int>(int a, int b, int c, int d  );
        static void Main(string[] args)
        {

            //lamda  对象初始化器 集合初始化器 扩展方法 

            //定义一个委托类型的变量 里面传递一个方法进去
            //直接匿名方法赋值 前面使用一个delegate关键字就是修饰一下

            /////////////第一种方式  在类的内部可以实例化自己
            ///这也可以 很少用呀
            /// ///////////////////
            //Program p = new Program();
            //AddSum addSum = new AddSum(p.Add);


            ////////////=====简化版2========///////////////////
            //AddSum addSum = delegate (int a, int b)
            //{
            //    return a + b;
            //};

            //////////////一个匿名的方法/////////////////////
            //AddSum addSum = (int a, int b) =>
            //{
            //    return a + b;
            //};



            ////////////////==最终简化版本 Lamd表达式
            ///其实就是把一个方法传递一个了一个委托类型的变量
            /// ////////////////////
            //AddSum addSum = (a, b) =>
            //{   
            //    //不需要return的 lamda表达式是什么样子的
            //    //没有返回值的委托
            //    return a + b + 3;
            //};

            ///////////////使用系统自定一个的委托类型 更加的简单//////
            ///
            /// ///////////////////
            Func<int, int, int> addSum = (a, b) => { return a + b; };


            int sum = addSum(11, 88);
            Console.WriteLine(sum);
            Console.ReadKey();


        }

    //    public int Add(int a,int b)
    //    {
    //        return a + b;
    //    }
    }
}
