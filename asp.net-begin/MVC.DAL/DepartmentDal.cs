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
    /// 部门
    /// </summary>
    public class DepartmentDal:BaseDal<Department>,IDepartmentDal
    {

        //世界访问数据的 通过 EF已经可以了 还要封装了好几层 
    }
}
