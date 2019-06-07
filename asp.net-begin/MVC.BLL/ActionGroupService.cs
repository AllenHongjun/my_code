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
    /// 权限组
    /// </summary>
    public class ActionGroupService : BaseService<ActionGroup>, IActionGroupService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = CurrentDBSession.ActionGroupDal;
        }
    }
}
