using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{
    public class CartService : BaseService<Cart>, ICartService
    {
        public override void SetCurrentDal()
        {
            this.CurrentDal = this.CurrentDBSession.CartDal;
        }
    }
}
