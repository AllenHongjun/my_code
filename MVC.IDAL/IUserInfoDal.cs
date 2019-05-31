using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVC.IDAL
{
    public interface IUserInfoDal:IBaseDal<UserInfo> 
    {
        //定义这类数据层 自己单独的处理的方法 除了基本的增删改查之外的

        //只是考虑一些基本的操作 
        //其他具体的放啊 具体的业务 有哪些业务是要操作的

        //
    }
}
