using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.BLL
{
   public partial class KeyWordsRankService:BaseService<Model.KeyWordsRank>,IBLL.IKeyWordsRankService
    {
       /// <summary>
       /// 将统计的明细表的数据插入。
       /// </summary>
       /// <returns></returns>
        public bool InsertKeyWordsRank()
        {
            string sql = "insert into KeyWordsRank(Id,KeyWords,SearchCount) select newid(),KeyWords,count(*)  from SearchDetails where DateDiff(day,SearchDetails.SearchDateTime,getdate())<=7 group by SearchDetails.KeyWords";
            return this.CurrentDBSession.ExecuteSql(sql)>0;
        }
       /// <summary>
       /// 删除汇总中的数据。
       /// </summary>
       /// <returns></returns>
        public bool DeleteAllKeyWordsRank()
        {
            string sql = "truncate table KeyWordsRank";
           return this.CurrentDBSession.ExecuteSql(sql)>0;
        }
        public List<string> GetSearchMsg(string term)
        {
           //KeyWords like term%
            string sql = "select KeyWords from KeyWordsRank where KeyWords like @term";
           return this.CurrentDBSession.ExecuteQuery<string>(sql, new SqlParameter("@term",term+"%" ));
        }
    }
}
