using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;

namespace MVC.BLL
{
    /// <summary>
    /// 应用就是这一层要使用那一层里面的定义的方法
    /// 着个架构弄熟悉公司项目的架构也就能理解更加的透彻了。
    /// 处理日志
    /// 登陆
    /// 搭建项目的架子 每一个项目都有的功能
    /// </summary>
    public class UserInfoService : BaseService<UserInfo>,IUserInfoService
    {
        public override void SetCurrentDal()
        {
            ///throw new NotImplementedException();
            //从子类里面来确定 CurrentDal的属性是什么 
            CurrentDal = this.CurrentDBSession.UserInfoDal;
        }

        #region 批量操作数据 调用多个数据层的方法
        //如果请求不是和复杂 知识单纯的添加一条数据 就不能在表现层 处理 
        //在业务层里面在添加响应的方法 批量数据更新 链接一次数据库 完成多掉数据的更新 重要重要 
        //public void SetUserInfo(UserInfo userInfo)
        //{
        //    this.CurrentDBSession.UserInfoDal.AddEntity(userInfo);
        //    this.CurrentDBSession.UserInfoDal.DeleteEntity(userInfo);
        //    this.CurrentDBSession.UserInfoDal.EditEntity(userInfo);
        //    this.CurrentDBSession.SaveChanges();
        //} 
        #endregion

        /// <summary>
        /// 批量删除多条用户数据
        /// </summary>
        /// <param name="list">存放要删除数据主键ID集合</param>
        /// <returns></returns>
        public bool DeleteEntities(List<int> list)
        {   
            //分装多不操作一起执行  这里其实是where和 Contain两个方法一起调用
            //UserID 在 list集合中就返回true where里面也是一个循环遍历 每一条数据 循环判断 是的话就取出来
            //看一下视频只有有一个印象 关键还是要自己来写 
            //也不是说写了一遍就结束了
            //数据会话层 是获取 Dal的对象 然后就可以调用DAL里面的方法了
            var userInfoList = this.CurrentDBSession.UserInfoDal.LoadEntities( u => list.Contains(u.ID));
            foreach (var user in userInfoList)
            {
                CurrentDBSession.UserInfoDal.DeleteEntity(user);
            }
            bool res = CurrentDBSession.SaveChange();
            return res;
        }
    }
}
