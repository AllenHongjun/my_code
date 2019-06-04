using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVCTwo.MVC
{   


    /// <summary>
    /// 控制器 视图 返回的几个对象 都是很重要的 要多研究 核心的掌握 
    /// 吧这个完整的 将的东西 都好好的实践 做一遍。。一点一点的来做
    /// 
    /// 抽象类是不能 new的 一般是做为一基类  当中一个类型 来使用 实现这个类 都必须要实现的一些方法
    /// </summary>
    public abstract class ActionResult
    {


        public abstract void Execute(HttpContext context);
        //这MVC其实就是一个和很小型 的MVC的框架 学习 这个也是为了 了解这个是如何来实现的
        //更加好的来使用。。
        //不是为了挣钱。。为了工作  为了写代码 而写代码 就是要写代码
    }
}