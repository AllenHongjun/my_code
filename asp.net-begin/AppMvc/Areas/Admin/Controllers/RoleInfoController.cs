using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MVC.IBLL;
using MVC.Model;

namespace AppMvc.Areas.Admin.Controllers
{
    public class RoleInfoController : BaseController
    {   
        public IRoleService RoleService { get; set; }
        public IActionInfoService ActionInfoService { get; set; }
        // GET: Admin/RoleInfo
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// 获取所有的角色列表
        /// </summary>
        /// <returns></returns>
        public ActionResult GetRoleInfoList(int page=1,int rows=10,string name=""
            )
        {
            DateTime beginTime = !string.IsNullOrEmpty(Request["beginTime"])
                ? Convert.ToDateTime(Request["beginTime"])
                : DateTime.Now.AddYears(-30);
            DateTime endTime = !string.IsNullOrEmpty(Request["endTime"])
                ? Convert.ToDateTime(Request["endTime"])
                : DateTime.Now;

            short delFlag = (short)DeleteEnumType.Normal;
            var roleList = RoleService.LoadPageEntities(page, rows, out int total,
                x => x.DelFlag == delFlag && x.RoleName.Contains(name) 
                                          && x.SubTime > beginTime && x.SubTime < endTime,
                x => x.ID,
                false).Select(
                role => new
                {
                    role.ID,
                    role.RoleName,
                    role.SubTime,
                    RoleType = role.RoleType == 2 ? "普通":"管理员",
                    role.Remark
                });
            return Json(new { rows = roleList, total = total }, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 展示添加的表单
        /// </summary>
        /// <returns></returns>
        public ActionResult ShowAddInfo()
        {
            return View();
        }

        /// <summary>
        /// 添加角色
        /// </summary>
        /// <param name="role"></param>
        /// <returns></returns>
        public ActionResult AddInfo(Role role)
        {
            role.DelFlag = (short)DeleteEnumType.Normal;
            role.SubTime = DateTime.Now;
            var roleEntity = RoleService.AddEntity(role);
            if (roleEntity!=null)
            {
                return Json(new Result() {code = 1, msg = "添加成功!"});
            }
            else
            {
                return Json(new Result() {code = -1, msg = "参数错误!"});
            }
        }

        /// <summary>
        /// 获取一条角色信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Detail(int id)
        {
            var role = RoleService.LoadEntities(x => x.ID == id).FirstOrDefault();
            return Json(new Result {code = 1,data=role, msg = "获取成功"});
        }

        /// <summary>
        /// 修改一条角色记录
        /// </summary>
        /// <param name="role"></param>
        /// <returns></returns>
        public ActionResult EditInfo(Role role)
        {
            role.SubTime = DateTime.Now;
            var res = RoleService.EditEntity(role);
            if (res)
            {
                return Json(new Result {code = 1, msg = "修改成功!"});
            }
            else
            {
                return Json(new Result {code = -1, msg = "修改失败"});
            }
        }

        /// <summary>
        /// 删除一条角色
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Delete(int id)
        {
            var role = RoleService.LoadEntities(x => x.ID == id).FirstOrDefault();
            var res = RoleService.DeleteEntity(role);
            if (res)
            {
                return Json(new Result {code = 1, msg = "删除成功!"});
            }
            else
            {
                return Json(new Result {code = -1, msg = "删除失败！"});
            }
        }

        //显示要分配的权限 
        public ActionResult ShowRoleAction(int id)
        {
            //获取所有权限
            var actionInfoList = ActionInfoService.LoadEntities(x => x.DelFalg == (short)DeleteEnumType.Normal)
                .ToList();
            //获取该角色已经分配的权限
            var roleInfo = RoleService.LoadEntities(r => r.ID == id).FirstOrDefault();
            var roleIds  = roleInfo.ActionInfo.Select(x => new {x.ID}).ToList();

            ViewBag.RoleInfo = roleInfo;
            ViewBag.ActionInfoList = actionInfoList;
            ViewBag.RoleIds = roleIds;
            return View();
        }


        // 为角色分配权限 这个也算是一个难点吧。



    }
}