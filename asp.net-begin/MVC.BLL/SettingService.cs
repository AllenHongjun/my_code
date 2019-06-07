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
    /// 站点设置
    /// </summary>
    public class SettingService : BaseService<Settings>, ISettingService
    {
        public override void SetCurrentDal()
        {
            throw new NotImplementedException();
        }
    }
}
