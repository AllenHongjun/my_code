using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using DotNet.Utilities;

namespace WebApp.FileUp
{
    /// <summary>
    /// ProcessFileUp 的摘要说明
    /// </summary>
    public class ProcessFileUp : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            // file path dictionay  请求获取文件 HttpPostedFile 请求接受文件的类型。这些类还需要在熟悉下
            context.Response.ContentType = "text/html";
            HttpPostedFile file = context.Request.Files[0];
            if (file.ContentLength > 0)
            {
                ///获取上传文件的名称包含扩展名。
                string fileName = Path.GetFileName(file.FileName);
                string fileExt = Path.GetExtension(fileName);

                if (fileExt == ".jpg" || fileExt == "png")
                {
                    string newfileName = Guid.NewGuid().ToString();
                    string dir = "/ImageUpload/" + DateTime.Now.Year
                       + "/" + DateTime.Now.Month
                       + "/" + DateTime.Now.Day
                       + "/";
                    //目录相当于文件夹 文件 路径 有些是相同的
                    if (!Directory.Exists(context.Request.MapPath(dir)))
                    {
                        Directory.CreateDirectory(context.Request.MapPath(dir));
                    }

                    string fullDir = dir + newfileName + fileExt;
                    file.SaveAs(context.Request.MapPath(fullDir));
                    context.Response.Write(@"<html><body>
                    <img width='80%' src='"+fullDir+"' /></body></html>");
                    string filePath = context.Request.MapPath(fullDir);
                    //单线程的程序是一步一步执行。执行上面一步才会继续执行下一步 先保存图片然后生成缩略图所以这个是可行的
                    string thumb = context.Request.MapPath("/ImageUpload/thumb/" + Guid.NewGuid().ToString() + ".jpg");
                    Common.ImageClass.MakeThumbnail(filePath, thumb, 50, 50, "W");
                }

            }
            else
            {
                //项目中合适的开发的代码 
                context.Response.Write("请选择上传文件");
            }


        }

        public void SaveFile(HttpContext context)
        {
            //HttpPostedFile file = context.Request.Files[0];
            //DotNet.Utilities.FileUp fileUp = new DotNet.Utilities.FileUp();
            //fileUp.SaveFile(file.InputStream, "text.jpg", "jpg");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}