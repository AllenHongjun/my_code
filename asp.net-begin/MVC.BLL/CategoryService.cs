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

        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public bool DeleteEntities(List<int> list)
        {

            var categoriyEntities = this.CurrentDBSession.CategoryDal.LoadEntities(u => list.Contains(u.Id));
            foreach (var categoriy in categoriyEntities)
            {
                CurrentDBSession.CategoryDal.DeleteEntity(categoriy);
            }

            bool res = CurrentDBSession.SaveChange();
            return res;
        }
    }
}
