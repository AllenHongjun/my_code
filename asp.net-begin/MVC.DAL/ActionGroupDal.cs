using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IDAL;
using MVC.Model;

namespace MVC.DAL
{   
    /// <summary>
    /// 权限组数据访问层
    /// </summary>
    public class ActionGroupDal:BaseDal<ActionGroup>,IActionGroupDal
    {
        /// 继承基类的方法。实现自己的接口给业务层调用
        /// 创建这个自己这个类 context 这些都给抽象工厂的方法(通过反射)来创建
    }
}
