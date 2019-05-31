using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.User
{
    /// <summary>
    /// Thumb 的摘要说明
    /// </summary>
    public class Thumb : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //创建缩略图。定义一个小的画布，将图片画到该画布上，最后保存。
            string filePath = context.Request.MapPath("/ImageUpload/mm.jpg");
            //using (Bitmap map = new Bitmap(50, 50))
            //{
            //    using (Image img = Image.FromFile(filePath))
            //    {
            //        using (Graphics g = Graphics.FromImage(map))
            //        {
            //            g.DrawImage(img,0,0,map.Width,map.Height);
            //            string fileName = Guid.NewGuid().ToString();
            //            map.Save(context.Request.MapPath("/ImageUpload/"+fileName+".jpg"),System.Drawing.Imaging.ImageFormat.Jpeg);

            //        }
            //    }
            //}
            string thumb = context.Request.MapPath("/ImageUpload/" + Guid.NewGuid().ToString() + ".jpg");
            Common.ImageClass.MakeThumbnail(filePath, thumb, 50, 50, "W");
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