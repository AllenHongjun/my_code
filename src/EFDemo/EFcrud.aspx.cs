using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EFDemo
{
    public partial class EFcrud : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            #region EF简单使用
            ////先简单使用 是可以很简单的 
            //UserInfo user = new UserInfo();
            //user.Email = "652971723@163.com";
            //user.RegTime = DateTime.Now.AddDays(-6);
            //user.UserName = "Alan";
            //user.UserPass = "a123456";

            ////会调用 父类的 构造方法 把数据库连接字符串的名字传递给 EF的构造方法 帮我们访问数据库连接字符串
            ////配置文件中数据库 配置 会自动生成 不需要来修改  主要是code First 如何来使用
            //book_shop3Entities bkContext = new book_shop3Entities();

            ////帮我们生成的 sql 语句是什么样子 如何查看

            ////sqlserver porfile 是很重要的一个工具 可以监视 所有访问数据的sql语句 
            ////一定要会使用
            //bkContext.UserInfo.Add(user);
            //bkContext.SaveChanges();

            ////使用框架 更加一脸的懵逼了 这个对象传递进去 引用类型。。执行一个方法只会。这个对象 的属性修改了。你还是可从这个变量
            ////里面访问到这个对象的属性的值 

            //// 把一个对象 传递给一个方法 应用类型的变量 方法处理之后 不用返回 还是可以拿到这个对象的属性 的改变 
            ////这个是哪个知识点？？？？要找到这个点再看看 先记住这个结果 这么使用就可以了。

            ////

            //Response.Write(user.ID);
            #endregion



        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            book_shop3Entities bkDBContext = new book_shop3Entities();

            //即使是有where 条件判断 也是一个集合 注意一下 linq表达式的写法
            //多写写 linq 多 写写 sql 语句 习惯了就好了

            //使用profile 就能够捕获 查询的语句
            var userInfo = from user in bkDBContext.UserInfo
                            where user.ID > 123
                            select user;

            //打一个断点 看一下 什么时候执行  小套路 小技巧

            //公司的数据库 还不能够追踪 。。那就算了 自己的数据库 查询 多玩玩就可以了

            //lazing loading  提前加载 有3中方式 选择自己合适的
            //代码里面没有错误 就是连警告都是没有的。
            //把需要的数据库文件 也配置到 APP_Data里面 。
            //int a = 9;

            foreach (var user in userInfo)
            {
                Response.Write(user.UserName);
            }
            
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            book_shop3Entities db = new book_shop3Entities();

            //先查询想删除的数据 然后执行删除
            //var userInfoList = from u in db.UserInfo
            //                   where u.ID == 127
            //                   select u;

            ////使用First的话 如果没有数据化 是会抛出异常
            //// FirstOrSingal  如果该序列中有多个元素 是会抛出异常的
            ////

            ////如果没有数据的话就会 返回null一般就用这个方法就可以了

            ////每次刷新又会重新提交表单
            //UserInfo userInfo = userInfoList.FirstOrDefault();

            //if (userInfo != null)
            //{
            //    db.UserInfo.Remove(userInfo);
            //    db.SaveChanges();
            //    Response.Write("删除数据成功");
            //}
            //else
            //{
            //    Response.Write("要删除的数据不存在");
            //}

            //如果知道主键ID就可以直接删除数据
            UserInfo user = new UserInfo() { ID = 110 };

            //存储区更新、插入或删除语句影响到了意外的行数(0)。实体在加载后可能被修改或删除。有关了解和处理乐观并发异常的信息，

            //先让EF 找到这个对象 EF管理数据数据的对象 也都是在缓存当中的

            //传入一个对象 对象的类型 然后 添加一个状态的标记 
            db.Entry<UserInfo>(user).State = EntityState.Deleted;
            db.SaveChanges();


        }
        //着一天的内容只是一个简单的了解 关键还是要 后面项目当中的应用

            //数据的培训设置联系 还是要敲很多的代码 来实践 和联系 使用

            //这他妈的我自己想改一点东西 都不能成功 我也是日了狗了

        protected void Button4_Click(object sender, EventArgs e)
        {
            book_shop3Entities db = new book_shop3Entities();
            var userInfoList = from u in db.UserInfo
                               where u.ID == 93
                               select u;
                               
                               
                               //new List<UserInfo>
                               //{
                               //    u.ID,
                               //    u.UserName,
                               //    u.UserPass,
                               //    u.RegTime,
                               //    u.Email
                               //};

            //修改数据 没有找到 Edit 的方法  连接查询 其他 重要的 但是不太天天使用的方法
            //大的方向要努力 要加油
            UserInfo user = userInfoList.FirstOrDefault();
            user.UserPass = "666666";
            db.Entry(user).State = EntityState.Modified;
            db.SaveChanges();



        }




        //zuo一个 CRUD 这个就简单了呀


        ///==========
        ///CSDL  定义的概念模型 
        /// SSDL content
        /// 
        /// DBContext  CurD  ==>  DBContext ( 读取 mapping 操作数据库  返回结果 )
        /// 我们只要操作这个类操作 这个属性就可以了。 这就牛逼了呀 就轻松了呀
        /// 
        /// 
        /// 
        /// 
        /// 
        /// C  _S  mapping 关心的映射 
        /// ///
        ///




    }
}