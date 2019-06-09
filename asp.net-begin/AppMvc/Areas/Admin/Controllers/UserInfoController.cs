
using MVC.IBLL;
using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class UserInfoController : BaseController
    {
        // GET: Admin/UserInfo

        //MVC.IBLL.IUserInfoService UserInfoService = new UserInfoService();

        //就是为了解耦才没有引用那一层。。为了学习这个方式 企业里面可以使用什么组件 可以如何来使用
        //只要效果能够做出来为主 优先 不管是什么方式
        //public UserInfoService UserInfoService { get; set; }
        public IUserInfoService UserInfoService { get; set; }
        public  IRoleService RoleService { get; set; }
        public  IActionInfoService ActionInfoService { get; set; }

        public ActionResult Index()
        {

            //if (Session["UserInfo"] == null)
            //{
            //    return Redirect("/Admin/Login/Index");
            //}

            return View();
        }

        #region 获取用户列表
        public ActionResult GetUserInfoList()
        {   
            //当前第几页 每一页的大小
            int pageIndex = Request["page"] != null ? int.Parse(Request["page"]) : 1;
            int pageSize = Request["rows"] != null ? int.Parse(Request["rows"]) : 5;

            //搜索的条件
            string userName = Request["name"];
            string userRemark = Request["remark"];
            int totalCount = 0;

            //筛选出逻辑删除 正常删除的数据
            short delFlag = (short)DeleteEnumType.Normal;
            var userInfoList = UserInfoService.LoadPageEntities(pageIndex, pageSize, out totalCount,
                u => u.ID > 0, u => u.ID, false);


            //根据数据库查询的数据 构建出我们需要的格式
            var temp = from u in userInfoList
                       select new
                       {
                           ID=u.ID,
                           UName = u.UserName,
                           UPwd = u.UserPass,
                           Remark = u.Email,
                           SubTime = u.RegTime
                       };

            return Json(new { rows = temp, total = totalCount }, JsonRequestBehavior.AllowGet);



        }
        #endregion

        ///表单元素name属性的值 要和 UserInfo Model属性的名字保存一次 会自动填充
        ///可以不用自动填充  项目做完了 要维护 
        ///添加表单 和 删除表单 不建议同一个
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userinfo"></param>
        /// <returns></returns>
        public ActionResult AddUserInfo(UserInfo userinfo)
        {
            userinfo.RegTime = DateTime.Now;
            try
            {
                UserInfoService.AddEntity(userinfo);
                if (userinfo.ID > 0)
                {
                    return Content("ok");
                }
                else
                {
                    return Content("fail");
                }
            }
            catch (Exception)
            {

                return Content("fail");
            }
        }

        /// <summary>
        /// 删除用户数据
        /// </summary>
        /// <param name="strId"></param>
        /// <returns></returns>
        public ActionResult DeleteUserInfo(string strId)
        {
            //string[] ids = strId.Split(',');
            //可以使用多个字符来分割 也可以使用单个字符来分割
            string[] ids = strId.Split(new char[] { ',' });
            var list = ids.Select(x => Convert.ToInt32(x)).ToList();
            // 这里将要操作的数据传递到业务层 

            bool res = UserInfoService.DeleteEntities(list);
            ActionResult actionResult;
            if (res)
            {
                actionResult = Content("ok");
            }
            else
            {
                actionResult = Content("fail");
            }
            return actionResult;
        }

        
        public ActionResult ShowEditInfo(int id)
        {
            var userinfo = UserInfoService.LoadEntities(u => u.ID == id)
                .Select(u=>new {
                    u.UserName,
                    u.UserPass,
                    u.RegTime,
                    u.ID,
                    u.Email
                }).FirstOrDefault();
            if (userinfo !=null)
            {   
                return Json(userinfo, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { msg = "用户获取失败", code = -1 });
            }
            
        }

        /// <summary>
        /// 修改用户记录
        /// </summary>
        /// <param name="userinfo"></param>
        /// <returns></returns>
        public ActionResult EditUserInfo(UserInfo userinfo)
        {
            userinfo.RegTime = DateTime.Now;
            if (UserInfoService.EditEntity(userinfo))
            {
                return Content("ok");
            }
            else
            {
                return Content("err");
            }
        }


        public ActionResult GetRoleInfo()
        {
            var roleList = RoleService.LoadEntities(x => x.DelFlag == (short) DeleteEnumType.Normal)
                .Select( x => new
                {
                    x.ID,
                    x.RoleName
                }).ToList();
            return Json(roleList, JsonRequestBehavior.AllowGet);
        }


        #region 为用户分配角色
        /// <summary>
        /// 展示用户已经有的角色信息
        /// </summary>
        /// <returns></returns>
        public ActionResult ShowUserRoleInfo(int id)
        {
            /// 获取所有角色  用户已经有的角色都返回
            /// 让已经有的角色打钩
            /// 公司项目 每一个权限还有增加修改删除 增加了复杂度。
            var userInfo = UserInfoService.LoadEntities(u => u.ID == id).FirstOrDefault();
            short delFlag = (short)DeleteEnumType.Normal;
            var allRoleList = RoleService.LoadEntities(r => r.DelFlag == delFlag)
                .ToList();
            var allUserRoleIdList = userInfo.Role.Select(r => r.ID).ToList();
            ViewBag.AllRoleList = allRoleList;
            ViewBag.AllUserRoleIdList = allUserRoleIdList;
            ViewBag.UserInfo = userInfo;
            return View();

        }

        /// <summary>
        /// 为用户分配角色
        /// </summary>
        /// <returns></returns>
        public ActionResult SetUserRole(int userId)
        {
            //从提交的数据中 整合获得一个 角色的ID的数组
            //循环一下 查询一下 导航一下 判断一下 返回一下 就可以了。
            //获取所有表单元素name的属性值
            string[] allKeys = Request.Form.AllKeys;
            var roleIdList = new List<int>();
            foreach (string key in allKeys)
            {
                if (key.StartsWith("cba_")
                {
                    string k = key.Replace("cba_", "");
                    roleIdList.Add(Convert.ToInt32(k));
                }
            }

            //为用户分配权限
            var res = UserInfoService.SetUserRoleInfo(userId, roleIdList);
            if (res)
            {
                return Json(new Result { code = 1, msg = "修改成功!" });
            }
            else
            {
                return Json(new Result { code = -1, msg = "修改失败!" });
            }
        } 
        #endregion


        /// <summary>
        /// 展示用户的权限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public ActionResult ShowUserAction(int userId)
        {
            var userInfo = UserInfoService.LoadEntities(u => u.ID == userId)
                .FirstOrDefault();
            short delFlag = (short) DeleteEnumType.Normal;
            var allActionList = ActionInfoService.LoadEntities(x => x.DelFalg == delFlag).ToList();
            var allUserActionList = (from action in userInfo.R_UserInfo_ActionInfo
                select action).ToList();
            //这里不需要通过角色过滤 只有验证的时候需要 合并去重复
            ViewBag.UserInfo = userInfo;
            ViewBag.AllActionList = allActionList;
            ViewBag.AllUserActionList = allUserActionList;
            return View();
        }


        /*分配权限有两种做法 没点击一次就分配一次
          或者所有的一起 保存
        */

        /// <summary>
        /// 每次打钩都为用户设置上权限
        /// </summary>
        /// <param name="actionId"></param>
        /// <param name="userId"></param>
        /// <param name="isPass"></param>
        /// <returns></returns>
        public ActionResult SetUserAction(int actionId,int userId,short isPass)
        {
            if (UserInfoService.SetUserActionInfo(actionId,userId,isPass))
            {
                return Json(new {code = 1, msg = "修改成功"});
            }
            else
            {
                return Json(new {code = -1, msg = "系统错误!"});
            }
        }

        /// <summary>
        /// 删除用户直接管理的权限
        /// </summary>
        /// <returns></returns>
        //public ActionResult ClearActionResult(int actionId, int userId)
        //{
        //    var r_userInfo_actionInfo = R_UserInfo_ActionInfoService.LoadEntities(r => r.ActionInfoID == actionId && r.UserInfoID == userId).FirstOrDefault();
        //    if (r_userInfo_actionInfo != null)
        //    {
        //        if (R_UserInfo_ActionInfoService.DeleteEntity(r_userInfo_actionInfo))
        //        {
        //            return Content("ok:删除成功!!");
        //        }
        //        else
        //        {
        //            return Content("ok:删除失败!!");
        //        }
        //    }
        //    else
        //    {
        //        return Content("no:数据不存在!!");
        //    }

        //}
        





        public ActionResult Test()
        {
            return View();
        }

        public ActionResult TestEasyUI()
        {

            return View();
        }



        
    }
}
