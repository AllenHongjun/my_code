using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace MVC.IDAL
{   
    /// <summary>
    /// 数据接口层基础接口
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IBaseDal<T> where T:class,new()
    {


        //注意这里使用 IQueryable 这里会延迟加载  Func<T,bool> 这个T 是和 接口类型参数是一致的
        //业务层来调用这个方法的时候 会使用一个lambda表达式 这个就是Lambda 表达式的类 就是一个委托的类型
        //扩展方法 需要的类型。
        /// <summary>
        /// 显示几条数据 
        /// </summary>
        /// <param name="whereLambda"></param>
        /// <returns></returns>
        IQueryable<T> LoadEntities(Expression<Func<T, bool>> whereLambda);


        /// <summary>
        /// 分页显示数据
        /// </summary>
        /// <typeparam name="s"> 类型参数 排序显示条件 排序的输出类型T.price T.dateTime T.ID 就是这个类型
        /// 这个约束 只要对排序的方法 有一个约束就可以 方法的方法使用
        /// </typeparam>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <param name="pageCount"></param>
        /// <param name="whereLambda">whereLamda条件</param>
        /// <param name="orderLambda">排序条件</param>
        /// <param name="isAsc">是否升序</param>
        /// <returns></returns>
        IQueryable<T> LoadPageEntities<s>(int pageIndex,int pageSize,out int pageCount,Expression<Func<T,bool>> whereLambda,Expression<Func<T,s>> orderLambda,bool isAsc);



        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="Entity"></param>
        /// <returns></returns>
        bool DeleteEntity(T Entity);

        /// <summary>
        /// 修改数据
        /// </summary>
        /// <param name="Entity">一个数据实体</param>
        /// <returns></returns>
        bool EditEntity(T Entity);

        /// <summary>
        /// 添加一条数据 这个返回的类型 可以根据自己的需求来返回一个类型
        /// </summary>
        /// <param name="Entity">一个数据是实体</param>
        /// <returns></returns>
        T AddEntity(T Entity);


    }
}
