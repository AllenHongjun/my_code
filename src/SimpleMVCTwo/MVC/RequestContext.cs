using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVCTwo.MVC
{   
    /// <summary>
    /// 将路由数据和请求的上下文打包
    /// </summary>
    public class RequestContext
    {

        public HttpContext HttpContext { get; set; }

        public IDictionary<string ,object> RouteData { get; set; }
    }
}