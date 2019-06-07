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
    /// 热词统计服务
    /// </summary>
    public class KeyWordRankService : BaseService<keyWordsRank>, IKeyWorkRankService
    {
        public override void SetCurrentDal()
        {
            CurrentDal = this.CurrentDBSession.KeyWordRank;
        }
    }
}
