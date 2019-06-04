using BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Pages.Ajax
{
    /// <summary>
    /// CheckUserName 的摘要说明
    /// </summary>
    public class CheckUserName : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //接受请求的格式 响应内容的格式 html img json text xml

            // json xml-from-urlencoded  post get 
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            // 如果你之前有遇到过这些问题 就会很容易就解决
            //如果这些问题 都没有见过 那效率当然也就会很低了

            //存储过程 哪些地方有这个依赖。哪些地方能修改
            //哪些不能修改
            //json对象的反序列化

            //添加用户 删除用户 修改用户 用户列表 一个页面所有的功能
            //都在这个上面完成

            //先来学习控件的使用 
            //然后是 结合ajax 一个控件对应的是什么输入框 然后
            //组装成那个结构 加上class来就可以了
            //ajax两天 要回头来学习
            string userName = context.Request["name"];
            UserInfoService userInfoService = new
                UserInfoService();
            bool isReg = userInfoService.GetUserInfo(userName) !=null;
            if (isReg)
            {
                context.Response.Write("此用户已经存在!!");
            }
            else
            {
                context.Response.Write("此用户可以注册！！！");
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