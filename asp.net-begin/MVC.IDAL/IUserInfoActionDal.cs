using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IDAL
{   
    /// <summary>
    /// 用户权限关系接口
    /// 用户直接和权限关联(方便特殊情况简单操作。)
    /// 权限的功能可以设置的简单一些。
    /// </summary>
    public interface IUserInfoActionDal:IBaseDal<R_UserInfo_ActionInfo>
    {
        //每一个菜单链接 就对应一个权限 多个可以访问的就是一个菜单权限组  有次来限制 一个用户设置只有一个角色

        //现在是 可以有这个菜单 但是菜单里面如果没有权限 可能就不能修改 。或者只能查看。

        //有哪些实体使用使用 对应的哪些关系 如何来操作这些关系 这个是重点。
    }
}
