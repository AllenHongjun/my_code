using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using MVC.IDAL;
using MVC.Model;
using System.Data.Entity;

namespace MVC.DAL
{   

    /// <summary>
    /// 数据层基础类 没有实现 哪个接口 
    /// 
    /// 为什么没有实现 IBaseDal这个接口 
    /// 因为子类会实现 IBaseDal定义的方法 能够有一样的效果 。实现一下也是没有问题的
    /// 再实现一步已经没有必要了。  有的时候所起来吃力 写代码其实是挺简单的
    /// 
    /// 数据层 业务成 表现层
    /// 数据抽象程  
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class BaseDal<T> where T :class,new()
    {

        //Db  saveChange 是要线程内唯一的
        //book_shop3Entities Db = new book_shop3Entities();
        //因为这里 用使用了 CreateDbContext的方法 所以 吧创建Dbcontext对象的方法 放在在这这一层
        //其实 放在那里是问题不大的 注意 这个对象可以通过类的属性的方式 注入 然后 注意线程内是唯一的问题
        //下面类中的方法 要使用这个属性Db的时候 就都会调用 DBContextFactory.CreateDbContext() 来获取这个对象了
        private DbContext Db = DBContextFactory.CreateDbContext();


        public T AddEntity(T Entity)
        {
            Db.Set<T>().Add(Entity);

            //数据层里面只是在内存当中标记一下 只有EF标记一下 才会 只要调用SaveChange() 才会执行

            //Db.SaveChanges();
            return Entity;
        }

        public bool DeleteEntity(T Entity)
        {
             Db.Entry<T>(Entity).State = EntityState.Deleted;
            //return Db.SaveChanges() > 0;

            return true;
        }

        public bool EditEntity(T Entity)
        {
            Db.Entry<T>(Entity).State = EntityState.Modified;
            //return Db.SaveChanges() > 0;
            return true;
        }

        public IQueryable<T> LoadEntities(Expression<Func<T, bool>> whereLambda)
        {   
            //返回一个DBSet的是实例 然后查询 数据库 数据表 然后是查询
            return Db.Set<T>().Where(whereLambda);
        }


        ///这里返回的是IQueryable 都是延迟加载 在数据层才会去考虑什么时候来加载数据
        /// <summary>
        /// 分页加载数据
        /// </summary>
        /// <typeparam name="s"></typeparam>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="pageCount"></param>
        /// <param name="whereLambda"></param>
        /// <param name="orderLambda"></param>
        /// <param name="isAsc"></param>
        /// <returns></returns>
        public IQueryable<T> LoadPageEntities<s>(int pageIndex, int pageSize, out int pageCount, Expression<Func<T, bool>> whereLambda, Expression<Func<T, s>> orderLambda, bool isAsc)
        {
            var temp = Db.Set<T>().Where(whereLambda);
            pageCount = temp.Count();

            if (isAsc)
            {
                temp = temp.OrderBy<T, s>(orderLambda).Skip((pageIndex - 1) * pageSize)
                    .Take(pageSize);
            }
            else
            {
                temp = temp.OrderByDescending(orderLambda).Skip((pageIndex - 1) * pageSize)
                    .Take(pageSize);
            }
            return temp;
        }


    }
}
