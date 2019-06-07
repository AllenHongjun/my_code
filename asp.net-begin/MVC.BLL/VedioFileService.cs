using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.IBLL;
using MVC.Model;

namespace MVC.BLL
{
    /// <summary>
    /// 视频文件管理服务
    /// </summary>
    public class VedioFileService : BaseService<VidoFile>, IVedioFileService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = this.CurrentDBSession.VideoFileDal;
        }
    }
}
