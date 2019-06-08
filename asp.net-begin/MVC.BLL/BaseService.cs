using MVC.IDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;
using MVC.DALFactory;
using System.Linq.Expressions;

namespace MVC.BLL
{   
    //这里必须是抽象的
    //你想引用那几层 就引用就可以了 不要循环引用就可以的

    //这个原理实现比公司好像还复杂了一层都是自己实现的。不过这个可以使用Spring.net来实现
    //这个好像是我看的的第三遍的吧。  字的方法父类调用  抽象方法 必须要实现 这个东东还是有些复杂 
    //有些点 。也不是所有的。简单的可以很简单。复杂的也就有他的复杂之处
    //从底层到数据层 数据访问层 业务层 表现层 每一层之间的访问都是通过接口来条用

    public abstract class BaseService<T> where T:class,new()
    {
        /*
         创建子类的时候 父类的够着方法也是会调用
         父类的够着方法被调用时候 会调用子类当中够着方法的实现
         如果有参数的话 构造方法需要base显示的调用一下
             */
        public BaseService()
        {
            SetCurrentDal();//子类一定要实现抽象方法。
        }

        /// <summary>
        /// 如果是实例化子类的话 就把子类和父类 合并成一个类来理解
        /// </summary>
        public abstract void SetCurrentDal();

        //这个构造方法中调用这个抽象方法 

        public IDBSession CurrentDBSession
        {
            get
            {   
                //先直接new以下  这个也是要线程中唯一 不能每次new一次 都是一个新的对象 这样就乱套了
                //return new DBSession();

                return DBSessionFactory.CreateDBSession();
            }
        }


        //父类不是到 DBSession 获取哪个数据操作类的实例 可以通过构造函数见实例传递给父类
        //有多中方法来实现
        //多态的使用 和实现
        //一般一个接口的实现方式也是只有一个。这个就方便很多 接口的实现 方法的定义 直接跳转一下就能够搞定了

        //这个属性通过子类来赋值 就可以获得 实例  多了一层之后 抽象程度就更加的高了一点

        // 最终这个 就是一个DAL数据层的 操作对象 类型是一个父类的类型 
        // 经过了一比较的复杂的操作之后 
        public IDAL.IBaseDal<T> CurrentDal { get; set; }

       

        


        /// <summary>
        /// 加载显示提交数据
        /// </summary>
        /// <param name="whereLambda"></param>
        /// <returns></returns>
        public IQueryable<T> LoadEntities(Expression<Func<T, bool>> whereLambda)
        {

            return CurrentDal.LoadEntities(whereLambda);
        }

        /// <summary>
        /// 分页加载显示数据
        /// </summary>
        /// <typeparam name="s"></typeparam>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="totalCount"></param>
        /// <param name="whereLambda"></param>
        /// <param name="orderbyLambda"></param>
        /// <param name="isAsc"></param>
        /// <returns></returns>
        public IQueryable<T> LoadPageEntities<s>(int pageIndex, int pageSize, out int totalCount,
            Expression<Func<T, bool>> whereLambda,
            Expression<Func<T, s>> orderbyLambda, bool isAsc)
        {
            return CurrentDal.LoadPageEntities<s>(pageIndex, pageSize, out totalCount, whereLambda, orderbyLambda, isAsc);
        }



        public bool DeleteEntity(T entity)
        {
            CurrentDal.DeleteEntity(entity);
            return CurrentDBSession.SaveChange();

        }


        ///// <summary>
        ///// 批量删除多条用户数据
        ///// </summary>
        ///// <param name="list">存放要删除数据主键ID集合</param>
        ///// <returns></returns>
        //public bool DeleteEntities(List<int> list)
        //{
        //    //分装多不操作一起执行  这里其实是where和 Contain两个方法一起调用
        //    //UserID 在 list集合中就返回true where里面也是一个循环遍历 每一条数据 循环判断 是的话就取出来
        //    //看一下视频只有有一个印象 关键还是要自己来写 
        //    //也不是说写了一遍就结束了
        //    //数据会话层 是获取 Dal的对象 然后就可以调用DAL里面的方法了
        //    var userInfoList = this.CurrentDal.LoadEntities(u => list.Contains(u.));
        //    foreach (var user in userInfoList)
        //    {
        //        CurrentDBSession.UserInfoDal.DeleteEntity(user);
        //    }
        //    bool res = CurrentDBSession.SaveChange();
        //    return res;
        //}



        public bool EditEntity(T entity)
        {
            CurrentDal.EditEntity(entity);
            return CurrentDBSession.SaveChange();
        }

        public T AddEntity(T entity)
        {
            CurrentDal.AddEntity(entity);
            CurrentDBSession.SaveChange();
            return entity;
        }
    }
}
