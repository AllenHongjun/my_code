using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using MVC.IDAL;
using MVC.Model;

namespace MVC.DAL
{   
    /// <summary>
    ///  书籍数据访问层
    /// </summary>
    public class BookDal :BaseDal<Books>, IBookDal
    {   
        //通过继承父类 来实现 接口中的方法 
        //public Books AddEntity(Books Entity)
        //{
        //    throw new NotImplementedException();
        //}

        //public bool DeleteEntity(Books Entity)
        //{
        //    throw new NotImplementedException();
        //}

        //public bool EditEntity(Books Entity)
        //{
        //    throw new NotImplementedException();
        //}

        //public IQueryable<Books> LoadEntities(Expression<Func<Books, bool>> whereLambda)
        //{
        //    throw new NotImplementedException();
        //}

        //public IQueryable<Books> LoadPageEntities<s>(int pageIndex, int pageSize, out int pageCount, Expression<Func<Books, bool>> whereLambda, Expression<Func<Books, s>> orderLambda, bool isAsc)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
