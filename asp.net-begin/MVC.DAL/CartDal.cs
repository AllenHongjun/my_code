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
    /// 购物车
    /// 数据层的子类 具体有什么实现。好像也没有什么实现。。。
    /// 弄的这么复杂 具体实现的东西 没有看到。知识为了供业务层来调用。
    /// </summary>
    public class CartDal:BaseDal<Cart>,ICartDal
    {

    }
}
