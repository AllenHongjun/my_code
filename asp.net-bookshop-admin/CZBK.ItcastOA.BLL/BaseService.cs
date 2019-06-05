using CZBK.ItcastOA.DALFactory;
using CZBK.ItcastOA.IDAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.BLL
{
   public abstract class BaseService<T> where T:class,new()
    {
       public IDBSession CurrentDBSession
       {
           get
           {
              // return new DBSession();//暂时
               return DBSessionFactory.CreateDBSession();
           }
       }
       public IDAL.IBaseDal<T> CurrentDal { get; set; }
       public abstract void SetCurrentDal();
       public BaseService()
       {
           SetCurrentDal();//子类一定要实现抽象方法。
       }
       public IQueryable<T> LoadEntities(System.Linq.Expressions.Expression<Func<T, bool>> whereLambda)
       {
         
           return CurrentDal.LoadEntities(whereLambda);
       }

       public IQueryable<T> LoadPageEntities<s>(int pageIndex, int pageSize, out int totalCount, System.Linq.Expressions.Expression<Func<T, bool>> whereLambda, System.Linq.Expressions.Expression<Func<T, s>> orderbyLambda, bool isAsc)
       {
           return CurrentDal.LoadPageEntities<s>(pageIndex, pageSize, out totalCount, whereLambda, orderbyLambda, isAsc);
       }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
       public bool DeleteEntity(T entity)
       {
           CurrentDal.DeleteEntity(entity);
           return CurrentDBSession.SaveChanges();
       }
        /// <summary>
        /// 更新
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
       public bool EditEntity(T entity)
       {
           CurrentDal.EditEntity(entity);
           return CurrentDBSession.SaveChanges();
       }
        /// <summary>
        /// 添加数据
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
       public T AddEntity(T entity)
       {
           CurrentDal.AddEntity(entity);
           CurrentDBSession.SaveChanges();
           return entity;
       }
    }
}
