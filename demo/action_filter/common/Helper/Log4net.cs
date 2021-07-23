using log4net;
using log4net.Config;
using Newtonsoft.Json;

using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace action_filter_api.common.Helper
{
    public static class Log4net
    {
        //private static ILog log;
        /// <summary>
        /// 静态只读实体对象info信息
        /// </summary>
        public static readonly log4net.ILog log = log4net.LogManager.GetLogger("loginfo");
        /// <summary>
        ///  静态只读实体对象error信息
        /// </summary>
        public static readonly log4net.ILog Logerror = log4net.LogManager.GetLogger("logerror");

        static Log4net()
        {

            var path = AppDomain.CurrentDomain.SetupInformation.ApplicationBase +
                           ConfigurationManager.AppSettings["log4net"];
            var fi = new System.IO.FileInfo(path);
            log4net.Config.XmlConfigurator.Configure(fi);

            //LogHelper.WriteLog("holle world");

            //XmlConfigurator.ConfigureAndWatch(new FileInfo(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile));
            //log = LogManager.GetLogger(typeof(Log4net));
        }

        public static void Debug(object message)
        {
            log.Debug(JsonConvert.SerializeObject(message));
        }

        public static void DebugFormatted(string format, params object[] args)
        {
            log.DebugFormat(format, args);
        }

        public static void Info(object message)
        {
            log.Info(JsonConvert.SerializeObject(message));
        }

        public static void InfoFormatted(string format, params object[] args)
        {
            log.InfoFormat(format, args);
        }

        public static void Warn(object message)
        {
            log.Warn(JsonConvert.SerializeObject(message));
        }

        public static void Warn(object message, Exception exception)
        {
            log.Warn(JsonConvert.SerializeObject(message), exception);
        }

        public static void WarnFormatted(string format, params object[] args)
        {
            log.WarnFormat(format, args);
        }

        public static void Error(object message)
        {
            log.Error(JsonConvert.SerializeObject(message));
        }

        public static void Error(object message, Exception exception)
        {
            log.Error(JsonConvert.SerializeObject(message), exception);
        }

        public static void ErrorFormatted(string format, params object[] args)
        {
            log.ErrorFormat(format, args);
        }

        public static void Fatal(object message)
        {
            log.Fatal(JsonConvert.SerializeObject(message));
        }

        public static void Fatal(object message, Exception exception)
        {
            log.Fatal(JsonConvert.SerializeObject(message), exception);
        }

        public static void FatalFormatted(string format, params object[] args)
        {
            log.FatalFormat(format, args);
        }
    }

}
