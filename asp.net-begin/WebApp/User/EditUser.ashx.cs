
namespace WebApp.User
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using BLL;
    using Model;
    /// <summary>
    /// EditUser 的摘要说明
    /// </summary>
    public class EditUser : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            //先 学习下aspx 页面。 回头再来复习下 文件 目录 路径 图片的处理
            //编辑需要展示编辑的数据
            //所有的请求 可以放到一个地址里面处理
            //根据act 来判断一下 写不同 的方法来处理
            int id = Convert.ToInt32(context.Request.Form["txtId"]);


            //分层的好处 这里获取用户信息的方法就都可以重用了
            UserInfoService userInfoService = new UserInfoService();
            UserInfo user = userInfoService.GetUserInfo(id);
            user.UserName = context.Request.Form["txtName"];
            user.UserPass = context.Request.Form["txtPwd"];
            user.Email = context.Request.Form["txtMail"];
            //代码一会生 两回熟  多写几遍才会熟悉 
            //能敲 还是要多敲代码 而不是来复制

            if (userInfoService.EditUserInfo(user))
            {   

                //重定向 会向浏览器 发送302状态码 还会返回一个location 跳转的地址。浏览器 能够看到重定向的 请求。请求的内容 
                // 302 这些是在响应的内容中能够看到的。 也就让页面跳转 。C#就一句话。 其中的原理过程 你要是不分析一下。就弄不明白。window.location 页面直接调整
                //#address 页面直接跳转。

                context.Response.Redirect("UserInfoList.ashx");
            }
            else
            {
                context.Response.Redirect("Error.html");
            }



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