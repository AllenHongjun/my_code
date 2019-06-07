using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IDAL
{   
    /// <summary>
    /// 购物车管理接口
    /// </summary>
    public interface ICartDal:IBaseDal<Cart>
    {
        //一张表的数据 关联两张表的数据都是要增删改查的就 这些就都是需要实现。
        //购物车 其实就是一张多对多的关系表。。关联用户和 想购买的商品 然后还有一些自己其他的字段。 
        //用户和商品就是 没有建立外键 可能 所以其他的关系表 如果有其他的字段 也都是要 见一个类的。不然不好管理。
    }


}
