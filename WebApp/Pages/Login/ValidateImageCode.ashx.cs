using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Pages.Login
{
    /// <summary>
    /// ValidateImageCode1 的摘要说明
    /// </summary>
    public class ValidateImageCode1 : IHttpHandler,
        //其实这个接口中没有任何内容就是一种标记说明 
        // 一个接口 什么内容都没有 .net freamwork 会为我这个文件
        //创建一个session对象 page类已经帮我们实现了

        //标记 是告诉编译器 告诉 .netfreamwork clr 运行时
        //需要 做些哪些东西
        System.Web.SessionState.IRequiresSessionState
    {


        ////在一般处理程序中如果要使用Session必须实现
        //.IRequiresSessionState接口.
        //为什么要实现这个接口 实现了这个接口微软 肯定会给你做很多事情
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";


            Common.ValidateCode validateCode = new Common.ValidateCode();

            //验证码有两个内容 一个是验证码的字符 一个验证码的 图片 
            //每一次请求的时候 这个sessionID的 的用户 key value的值 就会修改
            //相对安全。。但是 企业基本的有其他更加 安全的设置
            //了解其中的原理就可以 知道如何来使用
            string code = validateCode.CreateValidateCode(4);

            //什么时候存储数据 什么时候获取数据
            //如何区分不同的用户  自动会判断 这个用户SessionID下的数据
            //设置session的值。同时会把sessionid 通过cookie asp.net自动设置好
            //将sessionid 设置到用户的cookie中
            //如果cookie被禁用了 那就要提示了。
            context.Session["validateCode"] = code;
            validateCode.CreateValidateGraphic(code, context);

            //ASP.NET_SessionId=0hda1xnqk3geoavdhrv0yqcq

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