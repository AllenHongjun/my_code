using MVC.IDAL;
using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.DAL
{   
    /// <summary>
    /// 用户数据层的 类 继承基础了 然后要实现 数据层的访问接口 
    /// </summary>
    public class UserInfoDal :BaseDal<UserInfo>,IUserInfoDal
    {

        //EF 两个dll 的文件引用 版本不能够应用错误 
        //可以显示   每一个层应用的第三方的 都是要一致的。。
        // 使用Nupage 来应用包  配置文件当中也是 要应用的。。
        //为了避免出现问题 版本还是要一直 

        
    }
}
