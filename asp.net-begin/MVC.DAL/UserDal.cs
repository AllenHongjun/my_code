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
    /// 会员数据访问层
    /// </summary>
    public class UserDal:BaseDal<Users>,IUserDal
    {

    }
}
