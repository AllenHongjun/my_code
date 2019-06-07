using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IBLL
{   
    /// <summary>
    /// 权限组业务层接口
    /// </summary>
    public interface IActionGroupService:IBaseService<ActionGroup>
    {
        //有新的业务在添加新的接口。数据层基本上都不是吗用添加。主要是业务层
        // 关联表的数据更新如何更加方便 更加容易维护 有导航属性 有管理 
    }
}
