using System.Web.Routing;
using Test;

[assembly: WebActivator.PreApplicationStartMethod(typeof(AppStart_RestRouteRegistration), "Start")]
namespace Test
{
    public static class AppStart_RestRouteRegistration
    {
        public static void Start() {
            RouteTable.Routes.Add(new RestRoute("Products"));
        }
    }
}
