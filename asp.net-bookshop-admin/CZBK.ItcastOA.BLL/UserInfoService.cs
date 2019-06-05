﻿using CZBK.ItcastOA.IBLL;
using CZBK.ItcastOA.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.BLL
{
    public partial class UserInfoService : BaseService<UserInfo>,IUserInfoService
    {
       
        //public override void SetCurrentDal()
        //{
        //    CurrentDal = this.CurrentDBSession.UserInfoDal;
        //}
        //public void SetUserInfo(UserInfo userInfo)
        //{
        //    this.CurrentDBSession.UserInfoDal.AddEntity(userInfo);
        //    this.CurrentDBSession.UserInfoDal.DeleteEntity(userInfo);
        //    this.CurrentDBSession.UserInfoDal.EditEntity(userInfo);
        //    this.CurrentDBSession.SaveChanges();
        //}
        /// <summary>
        /// 批量删除多条用户数据
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public bool DeleteEntities(List<int> list)
        {
            var userInfoList = this.CurrentDBSession.UserInfoDal.LoadEntities(u=>list.Contains(u.ID));
            foreach (var userInfo in userInfoList)
            {
                this.CurrentDBSession.UserInfoDal.DeleteEntity(userInfo);
            }
           return this.CurrentDBSession.SaveChanges();
        }

        /// <summary>
        /// 完成用户信息的搜索
        /// </summary>
        /// <param name="userInfoSearch">封装的搜索条件数据</param>
        /// <returns></returns>
        public IQueryable<UserInfo> LoadSearchEntities(Model.Search.UserInfoSearch userInfoSearch,short delFlag)
        {
            var temp = this.CurrentDBSession.UserInfoDal.LoadEntities(c=>c.DelFlag==delFlag);
            //根据用户名来搜索
            if (!string.IsNullOrEmpty(userInfoSearch.UserName))
            {
                temp = temp.Where<UserInfo>(u=>u.UName.Contains(userInfoSearch.UserName));
            }
            if (!string.IsNullOrEmpty(userInfoSearch.UserRemark))
            {
                temp = temp.Where<UserInfo>(u=>u.Remark.Contains(userInfoSearch.UserRemark));
            }
            userInfoSearch.TotalCount = temp.Count();
            return temp.OrderBy<UserInfo, int>(u => u.ID).Skip<UserInfo>((userInfoSearch.PageIndex - 1) * userInfoSearch.PageSize).Take<UserInfo>(userInfoSearch.PageSize);
               
        }

        /// <summary>
        /// 为用户分配角色
        /// </summary>
        /// <param name="userId">用户编号</param>
        /// <param name="roleIdList">要分配的角色的编号</param>
        /// <returns></returns>
        public bool SetUserRoleInfo(int userId, List<int> roleIdList)
        {
            var userInfo = this.CurrentDBSession.UserInfoDal.LoadEntities(u=>u.ID==userId).FirstOrDefault();//根据用户的编号查找用户的信息
            if (userInfo != null)
            {
                userInfo.RoleInfo.Clear();
                foreach (int roleId in roleIdList)
                {
                    var roleInfo = this.CurrentDBSession.RoleInfoDal.LoadEntities(r=>r.ID==roleId).FirstOrDefault();
                    userInfo.RoleInfo.Add(roleInfo);
                }
               return this.CurrentDBSession.SaveChanges();
            }
            return false;

        }

        /// <summary>
        /// 完成用户权限的分配
        /// </summary>
        /// <param name="actionId"></param>
        /// <param name="userId"></param>
        /// <param name="isPass"></param>
        /// <returns></returns>
        public bool SetUserActionInfo(int actionId, int userId, bool isPass)
        {
           //判断userId以前是否有了该actionId,如果有了只需要修改isPass状态，否则插入。
            var r_userInfo_actionInfo = this.CurrentDBSession.R_UserInfo_ActionInfoDal.LoadEntities(a=>a.ActionInfoID==actionId&&a.UserInfoID==userId).FirstOrDefault();
            if (r_userInfo_actionInfo == null)
            {
                R_UserInfo_ActionInfo userInfoActionInfo = new R_UserInfo_ActionInfo();
                userInfoActionInfo.ActionInfoID = actionId;
                userInfoActionInfo.UserInfoID = userId;
                userInfoActionInfo.IsPass =isPass;
                this.CurrentDBSession.R_UserInfo_ActionInfoDal.AddEntity(userInfoActionInfo);
            }
            else
            {
                r_userInfo_actionInfo.IsPass = isPass;
                this.CurrentDBSession.R_UserInfo_ActionInfoDal.EditEntity(r_userInfo_actionInfo);
            }
           return this.CurrentDBSession.SaveChanges();

        }
    }
   
}
