using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace action_filter.Models
{
    public class LogEntity
    {
        /// <summary>
        /// 控制器名称
        /// </summary>
        public string ControllerName { get; set; }

        /// <summary>
        /// Action方法名称
        /// </summary>
        public string ActionName { get; set; }

        /// <summary>
        /// 操作用户id
        /// </summary>
        public string OperationUserId { get; set; }

        /// <summary>
        /// 操作时间
        /// </summary>
        public DateTime OperationTime { get; set; }
    }
}