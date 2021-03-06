﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IBLL
{   
    /// <summary>
    /// 权限信息业务接口
    /// </summary>
    public interface IActionInfoService:IBaseService<ActionInfo>
    {   
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        bool DeleteEntities(List<int> list);
    }
}
