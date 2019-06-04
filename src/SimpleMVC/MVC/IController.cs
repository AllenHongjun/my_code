using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace SimpleMVC.MVC
{   
    /// <summary>
    /// 约束了所有的这个类都具有处理请求的能力
    /// 很多东西 都是直接别人弄好的话 很多都是会不知道
    /// </summary>
    public interface IController
    {
        void Execute(HttpContext context);

    }
}
