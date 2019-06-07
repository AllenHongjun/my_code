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
    /// 订单详情
    /// </summary>
    public class OrderBookService : BaseService<OrderBook>, IOrderBookService
    {   
        //在父类的构造方法中会调用 创建类的实例的时候 会被自动的调用
        public override void SetCurrentDal()
        {
            CurrentDal = CurrentDBSession.OrderBooksDal;
        }
    }
}
