using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class FileCacheDep : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {   

            //文件缓存依赖 了解一下 面试。。 之后的内容是重点 

            /*
             session 进程外存储
             session 存储到数据
             错误页面配置
             网站发布到数据
             httpmodule的使用。
             
             
             */
            string filePath = Request.MapPath("File.txt");
            if (Cache["fileContent"] == null)
            {   
                //将文件中内容添加到缓存当中
                //会监视文件中的数据 如果文件中数据修改了那么缓存中的数据就会是失效了。。重新从文件中来读取数据

                //当缓存中 文件中常用操作 读取文件中数据。。xml 文件 日志 

                //修改了 文件内容。把 缓存清理一下。。。定时轮询机制。查看文件的数据有没有变化
                //那性能可能就会  损失。。。   有些别人能做的事情。。就让别人去做。。
                //自己  有做的事情。。就做好自己的事情就好了。。兼职赚点以外快。。什么的。。
                //
                CacheDependency cDep = new CacheDependency(filePath);
                string fileContent = File.ReadAllText(filePath);
                Cache.Insert("fileContent", fileContent, cDep);
                Response.Write("数据来自文件");

            }
            else
            {
                Response.Write("数据来自缓存:" + Cache["fileContent"].ToString());
            }


        }
    }
}