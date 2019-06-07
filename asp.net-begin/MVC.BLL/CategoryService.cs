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
    /// 商品分类
    /// </summary>
    public class CategoryService : BaseService<Categories>, ICategoryService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = this.CurrentDBSession.CategoryDal;
        }
    }
}
