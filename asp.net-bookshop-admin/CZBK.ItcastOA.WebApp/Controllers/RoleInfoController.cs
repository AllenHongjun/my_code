using CZBK.ItcastOA.Model;
using CZBK.ItcastOA.Model.EnumType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CZBK.ItcastOA.WebApp.Controllers
{
    public class RoleInfoController :Controller // BaseController
    {
        //
        // GET: /RoleInfo/
        IBLL.IRoleInfoService RoleInfoService { get; set; }
        IBLL.IActionInfoService ActionInfoService { get; set; }
        public ActionResult Index()
        {
            return View();
        }
        #region 获取角色列表
        public ActionResult GetRoleInfoList()
        {
            int pageIndex = Request["page"] != null ? int.Parse(Request["page"]) : 1;
            int pageSize = Request["rows"] != null ? int.Parse(Request["rows"]) : 5;
            int totalCount;
             short delFlag=(short)DeleteEnumType.Normarl;
            var roleInfoList = RoleInfoService.LoadPageEntities<int>(pageIndex,pageSize,out totalCount,r=>r.DelFlag==delFlag,r=>r.ID,true);
            var temp = from r in roleInfoList
                       select new { ID = r.ID, RoleName = r.RoleName, Sort = r.Sort, SubTime = r.SubTime,Remark=r.Remark };
            return Json(new { rows=temp,total=totalCount},JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region 展示添加表单
        public ActionResult ShowAddInfo()
        {
            return View();
        }
        #endregion

        #region 完成角色信息添加
        public ActionResult AddRoleInfo(RoleInfo roleInfo)
        {
            roleInfo.ModifiedOn = DateTime.Now;
            roleInfo.SubTime = DateTime.Now;
            roleInfo.DelFlag = 0;
            RoleInfoService.AddEntity(roleInfo);
            return Content("ok");
        }
        #endregion

        #region 展示要分配的权限
        public ActionResult ShowRoleAction()
        {
            int id = int.Parse(Request["id"]);
            var roleInfo = RoleInfoService.LoadEntities(r=>r.ID==id).FirstOrDefault();//获取要分配的权限的角色信息。
            ViewBag.RoleInfo = roleInfo;
            //获取所有的权限。
            short delFlag = (short)DeleteEnumType.Normarl;
          var actionInfoList= ActionInfoService.LoadEntities(a=>a.DelFlag==delFlag).ToList();
            //要分配权限的角色以前有哪些权限。
          var actionIdList = (from a in roleInfo.ActionInfo
                              select a.ID).ToList();
          ViewBag.ActionInfoList = actionInfoList;
          ViewBag.ActionIdList = actionIdList;
          return View();
        }
        #endregion

        #region  完成角色权限的分配
        public ActionResult SetRoleAction()
        {
            int roleId = int.Parse(Request["roleId"]);//获取角色编号
            string[] allKeys = Request.Form.AllKeys;//获取所有表单元素name属性的值。
            List<int> list = new List<int>();
            foreach (string key in allKeys)
            {
                if (key.StartsWith("cba_"))
                {
                    string k = key.Replace("cba_","");
                    list.Add(Convert.ToInt32(k));
                }
            }
            if (RoleInfoService.SetRoleActionInfo(roleId, list))
            {
                return Content("ok");
            }
            else
            {
                return Content("no");
            }
        }
        

        #endregion

    }
}
