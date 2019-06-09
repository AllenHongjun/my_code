using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;
using MVC.Model;

namespace AppMvc.Areas.Admin.Controllers
{
    public class CategoryController : BaseController
    {   
        public ICategoryService CategoryService { get; set; }
        // GET: Admin/Category
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// 获取分类数据列表
        /// </summary>
        /// <param name="pages"></param>
        /// <param name="rows"></param>
        /// <returns></returns>
        public ActionResult GetCategoryList(int page = 1,int rows = 5,string name="")
        {
            var pageList = CategoryService.LoadPageEntities(page, rows,
                    out int total, x => x.Id > 0 && x.Name.Contains(name), x => x.Id, false)
                .Select(x => new
                {
                    x.Id,
                    x.Name
                }).ToList();
            if (string.IsNullOrEmpty(name))
            {

            }
            return Json(new {rows = pageList, total = total},JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 添加分类数据
        /// </summary>
        /// <param name="categories"></param>
        /// <returns></returns>
        public ActionResult Create(Categories categories)
        {
            if (categories != null)
            {
                CategoryService.AddEntity(categories);
                return Json(new Result { code = 1,msg = "添加成功!"});
            }

            return Json(new Result {code = -1, msg = "参数错误！"});
        }

        /// <summary>
        /// 获取一条分类数据
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Detail(int id)
        {
            var category = CategoryService.LoadEntities(x => x.Id == id).FirstOrDefault();
            return Json(
                new Result()
                {
                    code = 1,
                    data = category,
                    msg = "获取成功"
                });
        }

        /// <summary>
        /// 修改分类
        /// </summary>
        /// <param name="categories"></param>
        /// <returns></returns>
        public ActionResult Edit(Categories categories)
        {
            var res = CategoryService.EditEntity(categories);
            if (res)
            {
                return Json(new Result {code = 1, msg = "修改成功！"});
            }
            return Json(new Result { code = -1, msg = "参数错误！" });
        }

        /// <summary>
        /// 删除分类
        /// </summary>
        /// <param name="categories"></param>
        /// <returns></returns>
        public ActionResult DeleteByID(int id)
        {
            var cat = CategoryService.LoadEntities(c => c.Id == id).FirstOrDefault();
            var res = CategoryService.DeleteEntity(cat);
            if (res)
            {
                return Json(new Result {code = 1, msg = "删除成功！"});
            }
            else
            {
                return Json(new Result() {code = -1, msg = "参数错误！"});
            }
        }

        /// <summary>
        /// 删除分类
        /// </summary>
        /// <param name="categories"></param>
        /// <returns></returns>
        public ActionResult Delete(string ids)
        {
            var catList = ids.Split(',').Select(x => Convert.ToInt32(x)).ToList();
            var res = CategoryService.DeleteEntities(catList);
            if (res)
            {
                return Json(new Result { code = 1, msg = "删除成功！" });
            }
            else
            {
                return Json(new Result() { code = -1, msg = "参数错误！" });
            }
        }
    }
}