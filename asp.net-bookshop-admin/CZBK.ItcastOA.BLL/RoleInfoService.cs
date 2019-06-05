using CZBK.ItcastOA.IBLL;
using CZBK.ItcastOA.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.BLL
{
    public partial class RoleInfoService : BaseService<RoleInfo>, IRoleInfoService
    {
        /// <summary>
        /// 为角色分配权限
        /// </summary>
        /// <param name="roleId">角色编号</param>
        /// <param name="actionIdList">权限编号列表</param>
        /// <returns></returns>
        public bool SetRoleActionInfo(int roleId, List<int> actionIdList)
        {
           //获取角色信息.
            var roleInfo = this.CurrentDBSession.RoleInfoDal.LoadEntities(r=>r.ID==roleId).FirstOrDefault();
            if (roleInfo != null)
            {
                roleInfo.ActionInfo.Clear();
                foreach (int actionId in actionIdList)
                {
                    var actionInfo = this.CurrentDBSession.ActionInfoDal.LoadEntities(a=>a.ID==actionId).FirstOrDefault();
                    roleInfo.ActionInfo.Add(actionInfo);
                }
               return this.CurrentDBSession.SaveChanges();
            }
            return false;
        }
    }
}
