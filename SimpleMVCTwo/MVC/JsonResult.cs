using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace SimpleMVCTwo.MVC
{
    public class JsonResult : ActionResult
    {
        private object p;

        public JsonResult(object p)
        {
            this.p = p;
        }


        //有智能提示还是要好好的利用。能把代码敲出来就是好的。
        //有很多的对象在里面 多用用多敲敲 自然就会有感觉了。
        //你不去敲 。不去用。有100年的经验其实也是白搭
        public override void Execute(HttpContext context)
        {

            JavaScriptSerializer js = new JavaScriptSerializer();
            var json = js.Serialize(p);
            context.Response.Write(json);
            context.Response.ContentType = "appliction/json";


        }
    }
}