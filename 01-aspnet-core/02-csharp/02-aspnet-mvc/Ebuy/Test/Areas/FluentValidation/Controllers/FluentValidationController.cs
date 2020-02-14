using System.Web.Mvc;
using Test.Areas.FluentValidation.Models;

namespace Test.Areas.FluentValidation.Controllers
{
    public class FluentValidationController : Controller
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
