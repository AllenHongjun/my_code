using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

namespace MVC.IDAL
{   
    /// <summary>
    /// 数据会话层接口  业务层调用 这个就是DBSession这一个层创建的目的 引用了那一层 被那一层来调用
    /// 各个层之间的访问都是通过接口
    /// </summary>
    public interface IDBSession
    {

        /// <summary>
        /// 这个属性是只读的 EF  Context对象
        /// </summary>
        DbContext Db { get;  }


        /// <summary>
        /// 数据层的接口进一步封装 业务层调用的是这里
        /// </summary>
        IUserInfoDal UserInfoDal { get; set; }
        /// <summary>
        /// 保存EFsql 的操作
        /// </summary>
        /// <returns></returns>
        bool SaveChange();
    }
}
