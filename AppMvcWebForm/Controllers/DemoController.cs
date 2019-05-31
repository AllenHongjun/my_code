using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AppMvcWebForm.Models;

namespace AppMvcWebForm.Controllers
{
    public class DemoController : Controller
    {
        // GET: Demo
        public ActionResult Index()
        {
            EFUserModelMVC db = new EFUserModelMVC();
            var userlist = db.UserInfo.Where(u => u.ID < 50);
            ViewData.Model = userlist;
            return View();
        }

        // GET: Demo/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Demo/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Demo/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Demo/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Demo/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Demo/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Demo/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
