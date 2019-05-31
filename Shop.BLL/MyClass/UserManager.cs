using BookShop.Model;
using Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

//注意定义部分类的时候 要和原来的 命名空间一致  
// 因为使用代码生成器来生成的 所以 使用部分类会好一些
namespace BookShop.BLL
{
    public partial class UserManager
    {

        /// <summary>
        /// 增加一条数据
        /// </summary>
        public int Add(BookShop.Model.User model, out string msg)
        {
            int isSuccess = -1;
            if (Exists(model.LoginId))
            {
                msg = "此用户名已经注册!!";
            }
            else
            {
                isSuccess = dal.Add(model);
                msg = "注册成功!!";

            }
            return isSuccess;

        }
        /// <summary>
        /// 完成用户名检查
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public bool ValidateUserName(string userName)
        {


            return dal.GetModel(userName) != null ? true : false;
        }




        /// <summary>
        /// 得到一个对象实体
        /// </summary>
        public BookShop.Model.User GetModel(string LoginId)
        {

            return dal.GetModel(LoginId);
        }


        /// <summary>
		/// 是否存在该记录
		/// </summary>
		public bool Exists(string LoginId)
        {
            return dal.Exists(LoginId);
        }


        /// <summary>
        /// 根据邮箱找信息
        /// </summary>
        /// <param name="mail"></param>
        /// <returns></returns>
        public bool CheckUserMail(string mail)
        {
            return dal.CheckUserMail(mail) > 0 ? true : false;
        }


        //验证用户名密码(说的一个功能都是一个小的模块里面的功能点有很多)
        //先理解 这个功能  要包含哪些功能 模块 功能点。。数据表的结构 。业务的流程是什么样子的。。然乎就是一点一点的做了
        // 别人是怎么做的。。学习 模仿。。自己实际动手做一遍。。不会的再去看看。。参数一下  但是 不是复制粘贴过来就完事了。

        /// <summary>
        /// 登录的时候校验用户名或者密码
        /// </summary>
        /// <param name="userName">用户名</param>
        /// <param name="password">密码</param>
        /// <param name="msg">消息提示</param>
        /// <returns></returns>
        public bool CheckUserInfo(string userName, string password, out string msg, out User user)
        {

            if (dal.Exists(userName))
            {
                user = dal.GetModel(userName);
                password = WebCommon.GetMd5String(password);
                if (user.LoginPwd.Equals(password, StringComparison.CurrentCultureIgnoreCase))
                {
                    msg = "用户登录成功！";
                    return true;
                }
                else
                {
                    msg = "用户名或者密码错误！";
                    return false;
                }
            }
            else
            {
                msg = "用户不存在";
                user = null;
                return false;
            }

        }


        public bool ValidateUserLogin()
        {
            /*
             验证用户是否已经登陆 
             验证session中是否有值 有的话就已经登陆了

             验证cookie是否有值 ，，就是自动登陆是否生效
             是的 话也就直接登录了
             */

            var current = HttpContext.Current;
            bool isSuccess = true;
            if (current.Session["userInfo"] != null)
            {
                isSuccess = true;
            }
            else
            {
                if (current.Request.Cookies["cp1"] != null && current.Request.Cookies["cp2"] != null)
                {
                    string userName = current.Request.Cookies["cp1"].Value;
                    string userPwd = current.Request.Cookies["cp2"].Value;
                    User userInfo = GetModel(userName);
                    if (userInfo != null)
                    {
                        var p = WebCommon.GetMd5String(WebCommon.GetMd5String(userInfo.LoginPwd));
                        if (userPwd == p)
                        {
                            current.Session["userInfo"] = userInfo;
                            isSuccess = true;
                        }
                    }
                    else
                    {
                        //如果没有次用户 但是cookie值还有 那就要清空了
                        current.Response.Cookies["cp1"].Expires = DateTime.Now.AddDays(-1);
                        current.Response.Cookies["cp2"].Expires = DateTime.Now.AddDays(-1);
                        isSuccess = false;
                    }
                }
                else
                {
                    isSuccess = false;
                }
            }
            //没有cookie 查不到用户的时候 都是没有登陆的两个合并到一起返回了就是
            return isSuccess;
        }


    }
}
