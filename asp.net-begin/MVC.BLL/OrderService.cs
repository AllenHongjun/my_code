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
    /// 订单
    /// </summary>
    public class OrderService : BaseService<Orders>, IOrderService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = this.CurrentDBSession.OrderDal;
        }
    }
}
