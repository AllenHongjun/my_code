using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.SpringNet
{
   public class UserInfoService:IUserInfoService
    {
       public string UserName { get; set; }
       public Person Person { get; set; }
        public string ShowMsg()
        {
            return "Hello World:"+UserName+":年龄是:"+Person.Age;
        }
    }
}
