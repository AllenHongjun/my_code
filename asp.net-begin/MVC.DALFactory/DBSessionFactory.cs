using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;

namespace MVC.DALFactory
{   

    
    /// <summary>
    /// 创建 DBSessionFacotry的类型 这个是给业务层注入对象的时候使用的。
    /// </summary>
    public class DBSessionFactory
    {
        public static IDAL.IDBSession CreateDBSession()
        {
            IDAL.IDBSession DbSession = (IDAL.IDBSession)CallContext.GetData("dbSession");
            //判断一下EF的对象是否已经闯将 这个请求  如果已经创建了 就直接使用
            //这个DBsessionFactory还木有用到  
            //这个和DbContext是一个道理
            //服务端校验。 数据映射
            if (DbSession == null)
            {
                DbSession = new DALFactory.DBSession();
                CallContext.SetData("dbSession", DbSession);
            }
            return DbSession;
        }

    }
}
