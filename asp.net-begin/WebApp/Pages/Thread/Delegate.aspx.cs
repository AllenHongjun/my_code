using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Thread
{
    public partial class Delegate : System.Web.UI.Page
    {   

        //事件 自动是当前这个类 里面定义的 使用。委托类型 
        public delegate int Test(int a,int b);

        public delegate int SumAdd(int a, int b);


        protected void Page_Load(object sender, EventArgs e)
        {

            // 使用系统定义好的委托 
           // Action<int> = new Action<int>();  //函数有返回值
           // Func<string> = x => x + 1;   // 函数没有返回值

            // 使用委托都要定义 而且 委托都是一样的。
            Test testDelegate = new Test(Sum);
            int sum = testDelegate(3,99);
            Response.Write(sum);

            //创建一个系统定义好的委托类型变量 
            //更多时候委托的类型 都已经定义好了。 只要传递放啊发就可以
            Action<int,int> actionDelegate = new Action<int,int>(( x,y) => Response.Write(12331));

            actionDelegate(12,33);


            //按照这个委托类型 方法的签名 传入方法就可以了。
            //Func<int, string, string> funcDelegate;
            //Func<int, int, int, int, int> funcDelegate2;

            //委托 安全的函数指针
            //指针变量  存放变量地址的变量 
            //函数指针 存放 函数的变量 
            // 通过变量名 变量地址  
            // 方法的签名 必须和 委托类型变量 签名一致  可以来调用方法 可以通过委托变量来调用方法

            // 事件 是委托类型的一个实例 是一个特殊的委托实例  定义事件 注册事件 注册事件的方法   
            //
        }


        public int Sum(int a,int b)
        {
            return a + b;
        }
    }
}