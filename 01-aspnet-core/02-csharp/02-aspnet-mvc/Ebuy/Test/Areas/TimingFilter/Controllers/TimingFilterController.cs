using System.Threading;
using System.Web.Mvc;
using Test.Areas.TimingFilter.Utility;

namespace Test.Areas.TimingFilter.Controllers
{
    public class TimingFilterController : Controller
    {
        [ExecutionTiming]
        public ActionResult Index()
        {
            Thread.Sleep(100);
            return View();
        }
    }
}
