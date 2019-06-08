using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;
using MVC.Model;

namespace AppMvc.Areas.Admin.Controllers
{
    public class ActionInfoController : BaseController
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

            //搜索条件 只有条件有值的时候才把条件拼接上去
            string actionInfoName = Request["name"] !=null? Request["name"] : "";

            bool isMenu = !string.IsNullOrEmpty(Request["isMenu"]) ? Convert.ToBoolean(Request["isMenu"]) : true;
            


            DateTime beginTime = !string.IsNullOrEmpty(Request["beginTime"])
                ? Convert.ToDateTime(Request["beginTime"])
                : DateTime.Now.AddYears(-30);
            DateTime endTime = !string.IsNullOrEmpty(Request["endTime"])
                ? Convert.ToDateTime(Request["endTime"])
                : DateTime.Now;

            //int total ;
            var pageList = ActionInfoService.LoadPageEntities(pageIndex, pageSize, out int total, 
                    x => x.DelFalg == (int)DeleteEnumType.Normal && x.ActionInfoName.Contains(actionInfoName)
                    &&( x.IsMenu == isMenu) && x.SubTime > beginTime && x.SubTime < endTime, x => x.ID, false)
                .Select( x => new
                {
                    x.ID,
                    x.ActionInfoName,
                    Menu =  x.IsMenu ? "是":"不是",
                    x.SubTime,
                    HttpMethod = x.HttpMethod == 1?"POST":"GET",
                    x.Url
                }).ToList();
            return Json(new {rows = pageList, total = total},JsonRequestBehavior.AllowGet);
        }


        // POST: Admin/ActionInfo/Create
        [HttpPost]
        public ActionResult Create(ActionInfo actionInfo)
        {
            try
            {   
                /*接收参数判断 调用service 返回结果*/
                // TODO: Add insert logic here
                if (actionInfo != null)
                {   
                    actionInfo.SubTime = DateTime.Now;
                    actionInfo.DelFalg = 0;
                    actionInfo.Url = actionInfo.Url.ToLower();
                    var action = ActionInfoService.AddEntity(actionInfo);
                    return Json(new Result() { code = 1, msg = "添加陈工" });

                }
                else
                {
                    return Json(new Result() {code = -1, msg = "参数错误!"});
                }

            }
            catch(Exception exception)
            {
                return Json(new Result() { code = -1, msg = exception.ToString() });
            }
        }


        /// <summary>
        /// 显示要修改的数据
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Detail(int id)
        {
            var actionInfo = ActionInfoService.LoadEntities(x => x.ID == id).FirstOrDefault();
            return Json(new Result { code = 1, data = actionInfo }, JsonRequestBehavior.AllowGet);
        }

        // POST: Admin/ActionInfo/Edit/5
        [HttpPost]
        public ActionResult Edit(ActionInfo actionInfo)
        {
           actionInfo.SubTime = DateTime.Now;
           bool res = ActionInfoService.EditEntity(actionInfo);
           if (res)
           {
               return Json(new Result {code = 1, msg = "修改成功!"});
            }
           else
           {
               return Json(new Result {code = -1, msg = "修改失败"});
           }
        }



        // POST: Admin/ActionInfo/Delete/5
        /// <summary>
        /// 批量删除用户
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult Delete(string ids)
        {
            var actionIds = ids.Split(',').Select(x => Convert.ToInt32(x)).ToList();
            bool res = ActionInfoService.DeleteEntities(actionIds);
            if (res)
            {
                return Json(new Result() {code = 1, msg = "批量删除成功"});
            }
            else
            {
                return Json(new Result() {code = -1, msg = "删除失败"});
            }
        }
    }
}
