using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{   
    /// <summary>
    /// 出版社
    /// </summary>
    public class PublishService : BaseService<Publishers>, IPublishService
    {
        public override void SetCurrentDal()
        {
            throw new NotImplementedException();
        }
    }
}
