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
    /// 会员管理
    /// </summary>
    public class UserService : BaseService<Users>, IUserService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = CurrentDBSession.UserDal;
        }
    }
}
