using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace swaggerUIdemo1.Controllers
{
    public class TestController : ApiController
    {
        //swaggerui 的页面是放在了哪里。。  有哪些常用的配置 使用  如何配置  安装

        //如何来显示注释 显示中文。。 技术性的点 知道如何啦I使用。。学习 使用。。

        /*
         * 
         * 
         * 有一个  答案  也有一部一步一步实现的教程 ..
         * 然后还要自己也要去实现一遍答案..
         * 
            Swagger使用方法详解（WebApi）——看完不会用你打我
         * 就喜欢这种一步一步叫你如何使用的教程..
         * https://blog.csdn.net/xiaouncle/article/details/83995809
         * 
         
         */

        /// <summary>
        /// 获取完整的用户信息
        /// </summary>
        /// <param name="age">年龄</param>
        /// <param name="name">姓名</param>
        /// <returns>完整的用户信息</returns>
        public string GetMessage(int age, string name)
        {
            return string.Format("age={0}，name={1}", age, name);
        }

    }
}
