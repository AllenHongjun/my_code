using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SimpleMVCTwo.MVC
{
    public class ContentResult : ActionResult
    {   


        private string content;
        private string contentType;

        public ContentResult(string content,string contentType)
        {
            this.content = content;
            this.contentType = contentType;
        }

        //这个执行的方法什么时候使用

        //现在代码敲的比较的慢 没有关系 多敲代码一步一步的敲 是会越来越熟悉 
        //越类越熟练的。

        //有些东西 为了不和mvc里面的一样的命名 就有了一些自己的东西
        public override void Execute(HttpContext context)
        {
            context.Response.ContentType = contentType;
            context.Response.Write(content);
            //这里内容 其实 也是有一个池 是不会马上就全部写出来。。
            //有很多经验 和很多的内容 会分享。。好好学习。
            

        }
    }
}