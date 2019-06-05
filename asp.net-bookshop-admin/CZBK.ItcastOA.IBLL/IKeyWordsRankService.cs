using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.IBLL
{
   public partial interface IKeyWordsRankService:IBaseService<Model.KeyWordsRank>
    {
       bool DeleteAllKeyWordsRank();
       bool InsertKeyWordsRank();
       List<string> GetSearchMsg(string term);
    }
}
