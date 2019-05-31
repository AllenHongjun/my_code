
using AppMvc.Filter;
using System.Web;
using System.Web.Mvc;

namespace AppMvc
{   

    /// <summary>
    /// 这个是过滤器的配置 几个配置文件其实都是很重要 很好玩的
    /// 全局的东西 整一个应用程序的东东都是在这里
    /// </summary>
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            //filters.Add(new HandleErrorAttribute());  注册了子类 这里父类就没有必要了 构造方法也是只有一个
            filters.Add(new MyExceptionAttribute());
        }
    }
}
