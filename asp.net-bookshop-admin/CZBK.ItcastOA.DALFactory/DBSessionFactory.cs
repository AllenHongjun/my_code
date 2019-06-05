using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.DALFactory
{
  public  class DBSessionFactory
    {
      public static IDAL.IDBSession CreateDBSession()
      {
          IDAL.IDBSession DbSession = (IDAL.IDBSession)CallContext.GetData("dbSession");
          if (DbSession == null)
          {
              DbSession = new DALFactory.DBSession();
              CallContext.SetData("dbSession",DbSession);
          }
          return DbSession;
      }
    }
}
