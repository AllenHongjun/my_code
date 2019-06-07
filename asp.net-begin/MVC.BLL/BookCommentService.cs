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
    /// 书籍商品评论
    /// </summary>
    public class BookCommentService : BaseService<BookComment>, IBookCommetService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = CurrentDBSession.BookCommentDal;
        }
    }
}
