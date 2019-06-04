using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;

namespace Common
{
   public static class WebCommon
    {   
        //为什么在别的层里面 页数可以访问配置文件

        //发布出来其实就是一个DLL  其实就是可以调用这个类文件。。
        //这个也是类执行一个访问。。都是在.net  CLR里面来执行的。。

        //一个请求 其实就是开启一个线程。。就好像是执行了一个mail 函数一样的。。
        //换了一层其实 也就是在 调用了另外一个命名控件下的类型。。
        //添加了引用之后 就可以理解为关联在了一起。。

       /// <summary>
       /// 线程内唯一对象  CallContext
       /// </summary>
       public static void GetFilePath(object obj)
       {    

            //验证 HttpContext是一个线程内唯一 另外开启一个线程的时候 。要重新传递景区
            //HttpContext.Current.context  主线程里面是可以使用的。 HttpContext是不允许跨线程访问的。
            //搜索 。。
           HttpContext context = (HttpContext)obj;
           string filePath = context.Request.MapPath("/Images/body.jpg");

          // string filePath = HostingEnvironment.MapPath("/Images/body.jpg");
           //string filePath=
          // return "";
       }
       /// <summary>
       /// 完成验证码校验
       /// </summary>
       /// <returns></returns>
       public static bool CheckValidateCode(string validateCode)
       {
           bool isSucess = false;
           //这个地方用户session是NUll
           if (HttpContext.Current.Session["vCode"] != null)
           {
              // string txtCode = HttpContext.Current.Request["txtCode"];
               string sysCode =HttpContext.Current.Session["vCode"].ToString();
               if (sysCode.Equals(validateCode, StringComparison.InvariantCultureIgnoreCase))
               {
                   isSucess = true;
                   HttpContext.Current.Session["vCode"] = null;
               }

           }
           return isSucess;
       }


        /// <summary>
        /// 对字符串进行MD5运算
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string GetMd5String(string str)
        {   
            //需要一个这个对象
            MD5 md5 = MD5.Create();
            //将字符串转化为字节数组
            byte[] buffer = Encoding.UTF8.GetBytes(str);
            //计算指定字节数组的hash值
            byte[] md5Buffer = md5.ComputeHash(buffer);
            StringBuilder sb = new StringBuilder();
            foreach (byte b in md5Buffer)
            {   
                //将每一个字节数组转换 拼接回去一个字符串然后返回。。
                sb.Append(b.ToString("x2"));
            }
            return sb.ToString();
        }

        /// <summary>
        /// 跳转页面带上当前页面的地址 
        /// 
        /// </summary>
        public static void RedirectPage()
        {
            HttpContext.Current.Response.Redirect("/Pages/Account/Login.aspx?returnUrl=" + HttpContext.Current.Request.Url);
        }



    }
}
