using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IBLL
{
    public interface IRoleService:IBaseService<Role>
    {

        /// <summary>
        /// 为角色分配权限
        /// </summary>
        /// <param name="roleId">角色ID</param>
        /// <param name="actionIdList">要分配的权限ID的集合</param>
        /// <returns></returns>
        bool SetRoleAction(int roleId, List<int> actionIdList);
    }
}
