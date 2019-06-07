using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;

namespace MVC.IDAL
{   
    /// <summary>
    /// 视频文件管理接口
    /// </summary>
    public interface IVideoFileDal:IBaseDal<VidoFile>
    {
        //中间的关系表如何建立维护
    }
}
