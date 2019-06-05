using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.QuartzNet
{
    /// <summary>
    /// 完成工作任务的定义。
    /// </summary>
   public class IndexJob:IJob
    {
       /// <summary>
       /// 将明细表中的数据插入到汇总表中。
       /// </summary>
       /// <param name="context"></param>
       IBLL.IKeyWordsRankService bll = new BLL.KeyWordsRankService();
       public void Execute(JobExecutionContext context)
        {
            bll.DeleteAllKeyWordsRank();
            bll.InsertKeyWordsRank();
        }
    }
}
