using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{
    public class RoleService : BaseService<Role>, IRoleService
    {
        //public RoleService():base()
        //{
        //}

        public override void SetCurrentDal()
        {
            this.CurrentDal = this.CurrentDBSession.RoleDal;
        }

        /// <summary>
        /// 为角色分配权限
        /// </summary>
        /// <param name="roleId">要分配的角色ID</param>
        /// <param name="actionIdList">要分配的权限集合</param>
        /// <returns></returns>
        public bool SetRoleAction(int roleId, List<int> actionIdList)
        {
            //获取要分配的角色实体 给角色分配权限
            //就是通过导航属性给关联表添加数据
            

            var roleInfo = this.CurrentDBSession.RoleDal.LoadEntities(r => r.ID == roleId).FirstOrDefault();
            if (roleInfo != null)
            {
                //这个Clear 会把之前的关系都 清除掉吗 看一下生成的sql语句 ?
                roleInfo.ActionInfo.Clear();
                foreach (int actionId in actionIdList)
                {
                    var actionInfo = this.CurrentDBSession.ActionInfoDal
                        .LoadEntities(a => a.ID == actionId).FirstOrDefault();
                    roleInfo.ActionInfo.Add(actionInfo);
                }

                return this.CurrentDBSession.SaveChange();
            }
            else
            {
                return false;
            }


        }


    }
}
