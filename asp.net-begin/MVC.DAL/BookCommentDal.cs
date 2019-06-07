using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IDAL;
using MVC.Model;

namespace MVC.DAL
{   
    /// <summary>
    /// 书籍评论
    /// </summary>
    public class BookCommentDal:BaseDal<BookComment>,IBookCommentDal
    {
        //基类已经把基类接口全部都实现了。父类 子类 基类 父类接口 子类接口 基类接口
    }
}
