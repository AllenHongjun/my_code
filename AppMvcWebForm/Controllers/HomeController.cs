using EFDemo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvcWebForm.Controllers
{
    public class HomeController : Controller
    {

        /*
         全部都是开源的 
         System.Web.Mvc 是关键 类库项目 
         MVC4 
         如果之间使用的话 操作相对简单。
         但是理解他的原理。很多东西 就是比较的复杂了。

             
             
             */


        //ActionResult 是一个操作结果 的返回 慢慢学习 不要着急 不要着急 不要着急
        //这个是一个父类  ViewResult  

        // 不要找路径 会按照定义的规则 帮你找到文件的路径渲染 视图 
        // 你想一下 如果 你不做 mvc的框架 会帮你找到对应的视图的文件
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View("about");
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }


        public ActionResult Register()
        {   
            //使用asp.net 做一个最基本的增删改查 
            //自动都帮你引入一些模板页面 很多东东都做好了 开发效率 那还不是杠杠的吗 
            //很 一些方法的使用 知道如何来使用 这久好玩了呀 。 webapi 和这个也是有类似的东东 

            //

            return View();
        }

        //表单的name名称 和 实体类的名称一致  才会一致 

            //很多东西都是一样的。。约定大于配置 
        public ContentResult AddUserInfo()
        {

            //对一个或多个实体的验证失败
            //明明是一个字段为空抛出这么一个错误 。。我也是 我勒个去呀

            //请求处理的过程 页面的传值  写一个代码测试 实验一下 
            //这个是最基本的 弄一个页面测试一下 
            //学一个最基本的 增删改查 测试一下效果  
            //多表连接查询 测试一下 效果  

            UserInfo user = new UserInfo();
            user.Email = Request["txtEmail"];
            user.UserName = Request["txtUserName"];
            user.UserPass = Request["txtPassword"];
            user.RegTime = DateTime.Now;
            book_shop3Entities db = new book_shop3Entities();
            db.UserInfo.Add(user);
            

            //这个会返回一个手影响的函数 
            //这个 请求的内容 也全部都会封装到一个 Controller 类的Request的属性当中
            //要想数量的使用 那你就要要用呀 你都不用 怎么熟练 就是去操作 去使用
            if (db.SaveChanges() > 0)
            {
                return Content("添加成功");
            }
            else
            {
                return Content("添加失败");
            }
            
        }
    }
}