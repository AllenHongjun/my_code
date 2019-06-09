using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IBLL
{   
    /// <summary>
    /// 商品分类
    /// </summary>
    public interface ICategoryService:IBaseService<Categories>
    {
        bool DeleteEntities(List<int> list);
    }
}
