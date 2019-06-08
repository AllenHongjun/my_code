using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVC.Model
{
    public enum DeleteEnumType
    {   
        /// <summary>
        /// 正常 未删除
        /// </summary>
        Normal  = 0,

        /// <summary>
        /// 逻辑删除
        /// </summary>
        LogicDelete = 1
    }
}
