using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{   
    /// <summary>
    /// 权限
    /// </summary>
    public class ActionInfoService : BaseService<ActionInfo>, IActionInfoService
    {
        public ActionInfoService():base()
        {

        }

        public override void SetCurrentDal()
        {   
            //在子类中确定使用哪个数据会话层的实例对象
            /*
             前端html cssjs rest
             mvc表现层 webform wcf webservice webapi 
             业务接口层 
             业务层 
             数据会话接口层 
             数据会话层   .net .net core 
             数据接口层 
             数据层
             EF模型层
             核心公共基础类库
             数据库
            */
            CurrentDal = CurrentDBSession.ActionInfoDal;
        }


        /// <summary>
        /// 批量删除数据
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public bool DeleteEntities(List<int> list)
        {
            
            var actionInfoList = this.CurrentDBSession.ActionInfoDal.LoadEntities(u => list.Contains(u.ID));
            foreach (var action in actionInfoList)
            {
                CurrentDBSession.ActionInfoDal.DeleteEntity(action);
            }
            bool res = CurrentDBSession.SaveChange();
            return res;
        }
    }
}
