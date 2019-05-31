using SimpleMVC.MVC;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVC.Controller
{
    public class ProductController : IController
    {

        //东西少的时候 测试一下 就能知道错误在哪里了。
        public void Execute(HttpContext context)
        {
            throw new NotImplementedException();
        }
    }
}