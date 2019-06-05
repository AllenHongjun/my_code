using CZBK.ItcastOA.WebApp.Models;
using System.Web;
using System.Web.Mvc;

namespace CZBK.ItcastOA.WebApp
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
           // filters.Add(new HandleErrorAttribute());
            filters.Add(new MyExceptionAttribute());
        }
    }
}