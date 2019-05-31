using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EFDemo
{
    public partial class EFDemo2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        //通过导航属性来添加数据
        protected void Unnamed1_Click(object sender, EventArgs e)
        {
            //给一个用户添加两条订单信息
            book_shop3Entities db = new book_shop3Entities();
            Users user = new Users()
            {
                Address = "江苏南京",
                LoginId = "13",
                LoginPwd = "3434",
                Mail = "652971723@163.com",
                Name = "Allen",
                Phone = "15258456864",
                UserStateId = 1
            };
            Orders order1 = new Orders()
            {
                Users = user,
                OrderDate = DateTime.Now,
                OrderId = Guid.NewGuid().ToString(),
                PostAddress = "这个是订单的某一个地址",
                state = 1,
                TotalPrice = 99.8m,

                //这个插入的 生成的sql数据是怎么样子的 为什么 会没有用 为什么能够关联上？？？
                //这个是新添加一个用户 及时你添加了UserId 也是没有用的
                //UserId = 88

            };

            Orders order2 = new Orders()
            {
                Users = user,
                OrderDate = DateTime.Now,
                OrderId = Guid.NewGuid().ToString(),
                PostAddress = "这个是订单的某一个地址",
                state = 1,
                TotalPrice = 99.8m,
                //UserId = 88

            };

            db.Users.Add(user);
            db.Orders.Add(order1);
            db.Orders.Add(order2);
            db.SaveChanges();


        }

        //查询每一个用户的 订单 其实 join在EF里面用的都是比较的少 都是导航属性 TOdictionay tolist  分组的方法 多用
        //用习惯了就一样
        //查询所有用户
        protected void Unnamed2_Click(object sender, EventArgs e)
        {
            book_shop3Entities db = new book_shop3Entities();
            var users = from u in db.Users
                        select u;
            foreach (var u in users)
            {
                Response.Write(u.Name+"    ");
                foreach (var o in u.Orders)
                {
                    Response.Write(o.OrderId);
                    Response.Write("    " + o.TotalPrice);
                    Response.Write("<br/>");
                }
                Response.Write("<br/>");
                Response.Write("<br/>");
                Response.Write("<hr/>");
            }
        }

        //查询某一个用户的订单信息
        protected void Unnamed3_Click(object sender, EventArgs e)
        {   
            //这个查询就很写的就很easy 让你少些了很多的代码 会使用之后就会感觉很方便
            book_shop3Entities db = new book_shop3Entities();
            var queryOrder = from o in db.Orders
                             where o.UserId == 91
                             select o;
            foreach (var o in queryOrder)
            {
                Response.Write(o.OrderId + "<br/>");
            }
        }

        // 反过来是 1对 1的关系 关系是双向的  1个订单 是一个用户 根据订单还可以反过来查询 用户的信息
        protected void Unnamed4_Click(object sender, EventArgs e)
        {
            book_shop3Entities db = new book_shop3Entities();
            var query = (from o in db.Orders
                        where o.OrderId == "2012021309541370391"
                        select o).FirstOrDefault();

            // 只要是一个类 就可以一直的往下去点 去使用 就真的比较的方便了。。、。
            Response.Write(query.Users.Address);
        }

        protected void Unnamed5_Click(object sender, EventArgs e)
        {
            // 有一个用户ID就可以删除该用户的所有的订单的信息
            //实际工作中的字段 乱七八糟的东西比这个要复杂的多了。而且还要 又快有好的完成 也是没有那么简单的
            //复杂的东西 可以简单化  

            //知道有东西 暂时不会是没有关系 常用的东西 多学习 马上学会才是要紧的。

            book_shop3Entities db = new book_shop3Entities();

            //注意下 使用的时候 这个select  投影出来的数据 始终是一个集合。
            var query = (from u in db.Users
                        where u.Id == 216
                        select u).FirstOrDefault();
            while (query.Orders.Count() > 0)
            {
                var order = query.Orders.FirstOrDefault();
                db.Entry<Orders>(order).State = System.Data.Entity.EntityState.Deleted;
            }
            db.SaveChanges();






        }
    }
}