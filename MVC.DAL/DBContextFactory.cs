using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.DAL
{   

    /// <summary>
    /// 复杂EF数据库上下文操作类实例的创建 保证线程内唯一 
    /// 也就是 一个请求使用EF数据库操作上下文都必须是同一个的。
    /// </summary>
    public class DBContextFactory
    {
        public static DbContext CreateDbContext()
        {
            //可以理解为从这个请求的上下文对象中获取 dbContext的值 如果没有设置过就 创建这个对象
            //否则就直接返回
            //CallContext 这个和HttpContext是一个意思 通过这个类 来保证线程内是唯一的。
            DbContext dbContext = (DbContext)CallContext.GetData("dbContext");
            if (dbContext == null)
            {
                dbContext = new book_shop3Entities();
                CallContext.SetData("dbContext", dbContext);
            }
            return dbContext;
        }


    }
}
