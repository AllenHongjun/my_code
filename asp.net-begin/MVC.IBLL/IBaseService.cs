using MVC.IDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace MVC.IBLL
{

    #region 说明
    /// 自己想搭建一个项目的架构
    /// 工厂类  数据层
    /// 数据会话层 
    /// 就是抄的话 可能问题会更加的多
    /// 参数类型是类  new() 是一个什么意思
    /// where T：new()指明了创建T的实例时应该具有构造函数。 比如创建一个UserInfo的类 应该具有构造方法   默认也是有一个构造方法的
    /// 这个是对类型参数的约束  IBaseService 是一个类型 T 也是一个类型 都是Model层里面的实体类 
    /// T 可能是一个UserInfo User Role Action Permission Order Category Shop 
    /// 就是一个一个的实体 类型 然后传递过来处理。
    /// 代码多给注释 尽量都给注释  
    /// 数据库 和代码都要放到服务端 这样要方便开发
    /// 这个是父类 子类对象 也都是会有 父类中 中方法 和属性 可以直接使用
    /// 这个思考了之后 写的代码 这个也是预习了。
    /// 
    /// 
    /// 接口的继承 这个接口 主要是给别的代码 继承来使用的。
    /// 集合这个接口的子类  其他的类 也就都要实现 子类接口要实现的方法
    /// 接口都是给上一层 的内容来访问   接口的实现都是要访问 底层的内容
    /// 在表现层依赖注入对象的时候 就可以了 
    #endregion


    /// <summary>
    /// 基础业务接口
    /// </summary>
    public interface IBaseService<T> where T : class, new()
    {
        //IDBSession
        //数据会话层 数据操作仓库   着两个的作用
        /// 根据条件加载数据 这个 lambda表达式参数的类型有没有其他的写法 有些抽象 而且 
        /// 还要和 每一方法的类型对应  这个是 要传递lamdba 表达式的类型 
        /// 这个表达式树 的类型  感觉还是有些抽象 见先这么记住吧 这个就是传递一个 lambda表达式 
        /// 他的类型 就是这样的 

        //数据会话层的接口 要访问的数据层的接口 是必须的 不然不知道访问哪个数据层的对象
        //当前请求 当前线程中 的数据会话层的实例
        IDBSession CurrentDBSession { get; }

        //当前业务要操作的数据访问层中的对象
        IDAL.IBaseDal<T> CurrentDal { get; set; }

        /// <summary>
        /// </summary>
        /// <param name="whereLambda">lambda表达式</param>
        /// <returns></returns>
        IQueryable<T> LoadEntities(Expression<Func<T,bool>> whereLambda);


        /// <summary>
        /// 分页加载数据
        /// </summary>
        /// <typeparam name="s"></typeparam>
        /// <param name="pageIndex">第几页</param>
        /// <param name="pageSize">每页的数据大小</param>
        /// <param name="total">总记录数量</param>
        /// <param name="whereLambda">where条件</param>
        /// <param name="orderLambda">排序条件  这个S参数定义的有点抽象 到时候调用的时候要理解一下</param>
        /// <param name="isAsc">是否升序</param>
        /// <returns></returns>
        IQueryable<T> LoadPageEntities<s>(int pageIndex,int pageSize,out int total,Expression<Func<T,bool>> whereLambda,Expression<Func<T,s>> orderLambda,bool isAsc);

        /// <summary>
        /// 删除一条数据
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        bool DeleteEntity(T entity);

        /// <summary>
        /// 修改一条数据
        /// </summary>
        /// <param name="entity">实体类的实例</param>
        /// <returns></returns>
        bool EditEntity(T entity);

        /// <summary>
        /// 添加一条数据
        /// </summary>
        /// <param name="entity">实体类的实例</param>
        /// <returns></returns>
        T AddEntity(T entity);


    }
}
