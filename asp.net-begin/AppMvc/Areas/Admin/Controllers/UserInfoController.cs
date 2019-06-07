
using MVC.IBLL;
using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class UserInfoController : Controller
    {
        // GET: Admin/UserInfo

        //MVC.IBLL.IUserInfoService UserInfoService = new UserInfoService();

        //就是为了解耦才没有引用那一层。。为了学习这个方式 企业里面可以使用什么组件 可以如何来使用
        //public UserInfoService UserInfoService { get; set; }
        public IUserInfoService UserInfoService { get; set; }
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





        public ActionResult Test()
        {
            return View();
        }

        public ActionResult TestEasyUI()
        {

            return View();
        }



        // GET: Admin/UserInfo/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Admin/UserInfo/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/UserInfo/Create
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

        // GET: Admin/UserInfo/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Admin/UserInfo/Edit/5
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

        // GET: Admin/UserInfo/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Admin/UserInfo/Delete/5
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
