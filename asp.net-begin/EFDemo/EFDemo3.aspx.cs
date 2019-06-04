using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EFDemo
{
    public partial class EFDemo3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            ///项目架构使用的什么技术 主要是的是什么
            ///业务有多复杂 如何让我尽快的熟悉业务
            ///我能有哪些权限 能让我做哪些事情
            book_shop3Entities db = null;

            //一次请求不是就结束了吗 这个对象设置了有用什么用的？？？
            if (HttpContext.Current.Items["db"] == null)
            {
                db = new book_shop3Entities();
            }
            else
            {   
                //is 是判断是不是某个类型 as  是尝试转化  不能会怎么样
                //线程内唯一 看着一行代码 有很多内容 单例模式 工厂模式
                //其他的设计模式 理解 不难
                db = HttpContext.Current.Items["db"] as book_shop3Entities;
            }

            //昨天私活不行 景天就可以创建匿名对象了 不知道哪里写错了
            var users = from u in db.Users
                        where u.Id == 153
                        select new
                        {
                            u.Name,
                            u.Phone
                        };
            //哪个是集合 哪个 是类 对应的关系 这个是操作集合 
            //不是操作数据库 又是有不一样的地方的

            foreach (var u in users)
            {
                Response.Write(u.Name + ":" + u.Phone);
            }

            //使用扩展方法来查询 分页查询数据
            //group by 这个使用 -- 自己多思考 多调试 
            //不要被那么长的 注释 下去 分组 一块一块的查看




        }


        //Where 查询所有用户的数据
        protected void Button3_Click(object sender, EventArgs e)
        {

            book_shop3Entities db = new book_shop3Entities();

            //编译器可以根据前面查询的集合的数据
            //推断出 u 参数变量的类型 自己分析一下他的结构你就会有一些体会
            //都是一些集合数据的操作 这个是常用的 也是必须要掌握的
            //作为.net 开发的话
            var users = db.Users.Where(u => u.Id > 0);

            int count = users.Count<Users>();
            Response.Write(count);
            for (int i = 0; i < users.Count(); i++)
            {
                // Response.Write(users.ElementAt(i).Orders.FirstOrDefault());
                //有些方法 LINQ to Entity是不能使用的。
                //Response.Write(users.ElementAt(i).Name);
            }


        }


        //对某一个类型经常操作的内容 扩展一个方法 。以后这一个类型就可以. 出来这样就比较的方便
        //IQualable Lamdba 这个类型 李曼添加了很多的扩展方法 重新 听一遍 感觉就不一样了

        protected void Button2_Click(object sender, EventArgs e)
        {
            book_shop3Entities db = new book_shop3Entities();
            //方法的第一参数类型 和返回值类型
            //编译器能够推断出你的类型
            //Func<Users, bool> whereLamda = (Users u) => { return u.Id == 3; };

            //表达式数 这个内容要回头去看。。没有看完的视频都是要看的  表达式树 数据结构的知识 知道是这么一个东西
            // 视频播放的比较快 速度慢一点。。用到的东西 多看看 这个方法的定义 和使用。  自己做一遍 能做出来就OK
            //
            //给委托类型的变量赋值  委托类型已经是定义好了 直接赋值一个lambda表达式就能使用了
            //Func<Users, bool> whereLamda2 = u => { return  u.Id == 3; };

            //为什么包装了一个Express还是一个委托的类型 这个就看不懂了
            //var users = db.Users.Where<Users>(u => u.Id == 12);

            int pageIndex = 2;
            int pageSize = 10;
            var usersPage = db.Users.Where(u => true)
                .OrderBy(u => u.Id)
                .OrderByDescending(u => u.Name)
                //分页的公式 先记住这么使用 具体怎么推导出来的 有兴趣再去研究 
                //分页从第几条数据开始获取
                //其实很简单 第一页 是 从第0条开始
                //第二页是从 第 10条开始 不然 就
                //第一页 第10条开始了 不想第0条就加个1 轻松搞定
                //不是难 是有那么一点心理阴影 知道吗 有心理阴影其实挺可怕的
                //有信仰 就真的听好 。
                .Skip((pageIndex - 1) * pageSize)
                .Take(pageSize);

            foreach (var u in usersPage)
            {
                Response.Write(u.Name + "<br/>");
            }


            //分页的公式 (pageIndex - 1) * pageSize

            //1-10  11-20  21-30 
            /*
             1  0---9
             2 (2-1)* 10 = 10 -19
             3    20-29
             4

             */

        }

        //---
        //IQuealable IEnuermable  区别 都可以 循环变量 IQuealable的延迟加载机制

        //IEnuermable  toList() 会立马查询数据库 统计的时候 是会在集合中的数据进行查询

        // EF 数据 数据多的时候 缓存中的数据 可以马上toList 
        //数据层 尽量不要返回 toList() 
        //EF 返回IQuearyAble 
        // 业务层成使用数据时候 在去调用数据。。。  看什么情况 数据层返回IQuableAble 业务层层再去区分
        //尽量使用 延迟加载 机制 数据层 都是使用 IQualeable 


        //项目层 文件很多 每一层 都是要操作 EF的类。。

        //每一个请求的时候 用的都是同一个 EF DbContext 对象 。重复使用
        // 服务器返回请求 给用户之后 请求结束 。  一个请求 会new 多个EF的操作类 EF 缓存哪个数据是最新的
        // 每一个请求 EF的对象是唯一的。。但是不同的请求 是不一样的。
        //单例模式 这个对象 在应用程序的生命周期过程中是唯一的。。
        //工厂模式 知识一个概念 可以多了解一下  
        // 应用程序关闭之后 单例模式的类 被销毁

        //C# Using 文件 数据库操作 
        //每一个请求  使用的资源 用完之后就释放

        //线程内是唯一的。。he APPlicationContext 每一个用户 也是一个ApplicationContext 的内容返回给用户

        //如果操作。。使用起来就简单的。。要分装代码
    }
}