using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{
    /// <summary>
    /// 书籍管理
    /// </summary>
    public class BookService : BaseService<Books>, IBookService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = CurrentDBSession.BookDal;
        }
    }
}
