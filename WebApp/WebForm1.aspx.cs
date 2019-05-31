using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class WebForm1 : System.Web.UI.Page
    {   

        //修改一下 整理成一个完整的项目
        /*
         完成 crud 
         文件上传 验证码 缩略图
         分页
         cookie session
         请求处理过程
         aspnet 的控件使用
         结合ui空间的使用
         代码生成器生成 3层
         wei mvc webapi 做准备
         为 面向对象程序设计做准备
         继续玩 C#程序设计里面的内容。
         文件上传 session redis 

         自己弄了一个项目搞起来 就是要稍微的爽一些呀。
             
             */
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["connStr"].ConnectionString;
            Response.Write(connStr);
        }
    }
}