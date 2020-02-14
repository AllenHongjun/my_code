using System.Web.Mvc;
using Test.Areas.FluentMetadata.Models;

namespace Test.Areas.FluentMetadata.Controllers
{
    public class FluentMetadataController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(Contact contact)
        {
            return View(contact);
        }
    }
}
