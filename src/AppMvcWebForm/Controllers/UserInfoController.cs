using AppMvcWebForm.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace AppMvcWebForm.Controllers
{
    /// <summary>
    /// 用户信息增加修改删除 基本的套路
    /// </summary>
    public class UserInfoController : Controller
    {
        // GET: UserInfo
        public ActionResult Index()
        {

            #region 注释
            //如何建立控制器 如何建立控制器？？？
            // ActionResult 
            //这个方法 是找视图 

            //约定大约配置  就在 这里 做。
            //方法的名称 要和视图的名称一致 视图 要放在 Views 文件下的当前 控制器下的 所在的文件夹下 
            //这个代码没有 就照着视频 自己代码 和比较敲一遍就可以了

            //和做webform 是一个套路  先一张表的测试和实验。。做一些内容。然后再是 一个项目的 
            //稍微有一点 怪怪的 但是不影响 使用  列表  删除  分页  

            //mvc 会自动把你的html代码Encode 编码 

            //StringBuilder sb = new StringBuilder();

            //foreach (var u in users)
            //{
            //    sb.AppendFormat(@"<tr><td>{0}</td> <td>{1}</td> <td>{2}</td></tr>",
            //        u.UserName, u.UserPass, u.RegTime);
            //}

            //ViewData["userInfoList"] =   sb.ToString();

            //数据是如何传递给 视图的原理 ？？？


            //ViewState 已经没有了 是WebForm里面的东西

            //视图 和 控制器是弱的耦合关系 
            //主要专注自己一块的内容的东西 。。视图展示的数据内容。。

            //从控制器 向 视图 数据是如何传递过去。。 看看源码的分析。理解

            //继承了Controller  这个类 就可以 使用这个类里面全部的方法 和数据 一定要自己操作一遍
            //不是知识看视频就行的。

            #endregion

            int index;
            int pageSize = 5;
            if (!int.TryParse(Request["pageIndex"], out index))
            {
                index = 1;
            }

            EFUserModelMVC db = new EFUserModelMVC();
            int rowCount = db.UserInfo.Count();
            int pageCount = Convert.ToInt32(Math.Ceiling((double)rowCount / pageSize));

            index = index < 1 ? 1 : index;
            index = index > pageCount ? pageCount : index;
            //会从第0条数据开始取数据 就是数据库里面的调过0条数据 就是一条也不跳过 完美
            //这个就很简单 都不需要写一个分页类 
            var users = db.UserInfo.Where(u => true).OrderBy(u => u.ID).Skip((index - 1) * pageSize).Take(pageSize);
            ViewData["userInfoList"] = users;
            ViewData["pageIndex"] = index;
            ViewData["pageCount"] = pageCount;
            return View();
        }


        /// <summary>
        /// 显示用户详细信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult ShowDetial(int id)
        {

            //可以直接接受请求中的参数 不能自动 填充的时候 ?id = 12&name =33
            EFUserModelMVC db = new EFUserModelMVC();
            UserInfo user = db.UserInfo.Where(u => u.ID == id).FirstOrDefault();
            ViewData["userInfo"] = user;


            //ViewData是一个动态类型的变量  设置与视图数据管理的Model
            ViewData.Model = user;
            return View();
        }


        /// <summary>
        /// 显示编辑页面
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult ShowEdit(int id)
        {
            EFUserModelMVC db = new EFUserModelMVC();

            var user = db.UserInfo.Where(u => u.ID == id).FirstOrDefault();
            ViewData["userInfo"] = user;

            return View();
        }

        /// <summary>
        /// 编辑用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userName"></param>
        /// <param name="userPwd"></param>
        /// <param name="Email"></param>
        /// <returns></returns>
        public ActionResult Edit(int id, string userName, string userPwd, string Email)
        {
            EFUserModelMVC db = new EFUserModelMVC();
            var user = db.UserInfo.Where(u => u.ID == id).FirstOrDefault();
            user.UserName = userName;
            user.UserPass = userPwd;
            user.Email = Email;
            user.RegTime = DateTime.Now.AddMonths(-2);
            //添加 修改删除 都是可以使用这个办法
            db.Entry<UserInfo>(user).State = System.Data.Entity.EntityState.Modified;
            if (db.SaveChanges() > 0)
            {
                return Content("修改成功");
            }
            else
            {
                return Content("修改失败");
            }


        }


        /// <summary>
        /// 删除用户
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Delete(int id)
        {
            EFUserModelMVC db = new EFUserModelMVC();
            var user = db.UserInfo.Where(u => u.ID == id).FirstOrDefault();
            db.UserInfo.Remove(user);
            if (db.SaveChanges() > 0)
            {
                return RedirectToAction("Index");
                //return Content("删除成功！");
            }
            else
            {
                return Content("删除失败！");
            }

        }


        public ActionResult About()
        {
            return View();
        }
    }
}