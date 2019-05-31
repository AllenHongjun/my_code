using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVCTwo.MVC
{   

    /// <summary>
    /// 约束所具备请求的能力 
    /// 他们所有的东西 都是自己在玩的。。。玩的还是比较大。
    /// 没一个人的玩法不一样。。
    /// 我现在玩的是什么 公司里面上班 玩的代码
    /// 自己代码 自己的服务器上玩的。
    /// </summary>
    public interface IController
    {   
        //接收一个请求 然后是处理这个请求 。。着样写代码就感觉还是挺轻松 。。有些问题。就是比较的纠结
        ActionResult Execute(RequestContext context);

    }
}