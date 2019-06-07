using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IDAL
{
    /// <summary>
    /// 用户角色关系表（如果没有其他字段 EF自动会帮你更新 如果有其他的字段 就建立一个类来管理 ）
    /// DATA Access Layer
    /// Business   Logic   Layer
    /// Servcie
    /// Repository 
    ///
    /// 这个多对多的关系 EF里面 还没有直接对应的实体
    /// 
    /// </summary>
    //public interface IUserInfoRoleDal:IBaseDal<UserInfoRol>
    //{
    //    //比如 订单 关注商品 购物车 这些本事就是一张关系的表。
    //    //一个表里面如果有 两个外键的字段 关联其他的
    //    //完善 做好这个项目 
    //}
}
