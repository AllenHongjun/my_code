using action_filter.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace action_filter.Utils
{
    public class LogHelper
    {
        /// <summary>
        /// 记录操作日志
        /// 这里为了方便测试记录到txt文件里面，实际中应该是记录到数据库中
        /// 然后有界面可以显示这些操作记录
        /// </summary>
        /// <param name="entity"></param>
        public static void WriteOperRecore(LogEntity entity)
        {
            string strPath = @"D:\log.txt";
            using (StreamWriter sw = new StreamWriter(strPath, true))
            {
                sw.WriteLine("**************************");
                sw.WriteLine($"操作时间:{entity.OperationTime}");
                sw.WriteLine($"当前Controller名称:{entity.ControllerName}");
                sw.WriteLine($"当前Action名称:{entity.ActionName}");
                sw.WriteLine($"当前操作用户id:{entity.OperationUserId}");
                sw.Close();
            }
        }
    }
}