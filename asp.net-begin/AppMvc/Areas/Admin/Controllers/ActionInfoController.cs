using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;
using MVC.Model;

namespace AppMvc.Areas.Admin.Controllers
{
    public class ActionInfoController : Controller
    {
        private IActionInfoService ActionInfoService { get; set; }
        // GET: Admin/ActionInfo
        public ActionResult Index()
        {
            
            return View();
        }


        /// <summary>
        /// 分页获取权限列表数据
        /// </summary>
        /// <returns></returns>
        public ActionResult GetActionList()
        {
            #region 控制器中方法通用的步骤逻辑 
            /*
             * 验证数据的合法性
             * 是否需要登陆
             *
                 *接受参数
                 *判断参数的合法性
                 *调用服务层的方法
                 *返回的数据组装成我们需要的格式
                 *客户端调用
             *    缓存中数据读取
             *
                 *
                 * lambda表单是的参数类型 泛型委托
                 * 实体类型 实体类型的集合
                 */ 
            #endregion

            int pageIndex = Request["page"] != null ? Convert.ToInt32(Request["page"]) : 1;
            int pageSize = Request["rows"] != null ? Convert.ToInt32(Request["rows"]) : 10;
            int total = 0;
            var pageList = ActionInfoService.LoadPageEntities(pageIndex, pageSize, out total, x => x.ID > 1, x => x.ID, true)
                .Select( x => new
                {
                    x.ID,
                    x.ActionInfoName,
                    x.IsMenu,
                    x.SubTime,
                    x.Url
                }).ToList();
            return Json(new {rows = pageList, total = total},JsonRequestBehavior.AllowGet);
        }

        // GET: Admin/ActionInfo/Details/5
        public ActionResult Details(int id)
        {
            var action = ActionInfoService.LoadEntities(x => x.ID == id).FirstOrDefault();
            return Json(new {code = 1, data = action},JsonRequestBehavior.AllowGet);
        }


        // POST: Admin/ActionInfo/Create
        [HttpPost]
        public ActionResult Create(ActionInfo actionInfo)
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


        // POST: Admin/ActionInfo/Edit/5
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

        // POST: Admin/ActionInfo/Delete/5
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
