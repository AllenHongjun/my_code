using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//只有引用了当前的类库 才能调用里面的方法 
// 不是引用了这一层 引用的上一层的 类 你是用不了的
//只有你实践操作过 之后 你才会明白 不然你是不会明白的

//想多操作一下数据库。
using Model;
using DAL;

namespace BLL
{
    public class UserInfoService
    {
        //为什么要分层 好处是重用 业务清晰
        // 业务层各种 乱七八糟的 业务判断 查询数据 什么
        // 参数接受的判断 和表现层 页面相关的代码 接受数据什么的
        //当然还是没有解耦的
        //可以直接给这个类的属性赋值 或者是在构造方法中赋值
        //当一坨代码 挤在了一起的时候 你是搞不明白情况的
        private UserInfoDal UserInfoDal = new UserInfoDal();

        /// <summary>
        /// 使用IList是自己挖的坑 注意下就好
        /// </summary>
        /// <returns></returns>
        public IList<UserInfo> GetList()
        {
            return UserInfoDal.GetList();
        }

        /// <summary>
        /// 分页获取数据
        /// </summary>
        /// <param name="start">开始页数</param>
        /// <param name="end">结束数据条数</param>
        /// <returns></returns>
        public List<UserInfo> GetPageList(int start,int end)
        {
            return UserInfoDal.GetPageList(start, end);
        }

        /// <summary>
        /// 获取总页数
        /// 
        /// 如何计算放在了业务成 
        /// 只是计算这个页数
        /// 哪些内容放在那一层 这个思想也挺重要的
        /// 着样的代码容易维护
        /// 这一层也就做这一件事件 
        /// 
        /// </summary>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public int GetPageCount(int pageSize)
        {
            int recordCount = UserInfoDal.GetRecordCount();
            int count = Convert.ToInt32(Math.Ceiling((double)recordCount / pageSize));
            return count;
        }

        /// <summary>
        /// 添加用户
        /// </summary>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public bool AddUserInfo(UserInfo userInfo)
        {
            bool res = UserInfoDal.AddUserInfo(userInfo) > 0;
            return res;
        }

        /// <summary>
        /// 删除用户  还有全部都是在存储过程里面 工作也真的是奇葩
        /// 数据层只负责构建sql语句 执行sql
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteUserInfo(int id)
        {
            return UserInfoDal.DeleteUserInfo(id) > 0;
        }

        /// <summary>
        /// 获取一条用户信息
        /// 使用listview控件的话 可视化编程 点一点 妥妥
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteUserInfo(UserInfo userinfo)
        {

            return UserInfoDal.DeleteUserInfo(userinfo.Id ) > 0;
        }

        /// <summary>
        /// 获取一条用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public UserInfo GetUserInfo(int id)
        {
            return UserInfoDal.GetUserInfo(id);
        }

       



        /// <summary>
        /// 获取一条用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public UserInfo GetUserInfo(string name)
        {
            return UserInfoDal.GetUserInfo(name);
        }

        /// <summary>
        /// 修改用户信息
        /// 设置 sessionID在浏览器中过期的事件
        /// 默认服务器上是安全的
        /// </summary>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public bool EditUserInfo(UserInfo userInfo)
        {
            return UserInfoDal.EditUserInfo(userInfo) > 0;
        }

        /// <summary>
        /// 完成用户登录
        /// </summary>
        /// <param name="userName">用户名</param>
        /// <param name="userPwd">密码</param>
        /// <param name="msg">登录信息</param>
        /// <param name="userInfo">登录用户信息</param>
        /// <returns></returns>
        public bool ValidateUserInfo(string userName,string userPwd,
            out string msg, out UserInfo userInfo)
        {
            userInfo = UserInfoDal.GetUserInfo(userName);
            if (userInfo != null)
            {
                if (userInfo.UserPass == userPwd)
                {   

                    //查询一下 数据库存储的密码 和用户输入的密码
                    //是否一致 是的话就登录成功

                    //就是各种业务逻辑判断 功能更加的多一点
                    msg = "登录成功！！";
                    return true;
                }
                else
                {
                    msg = "用户名或者密码错误！！！";
                    return false;
                }

            }
            else
            {
                msg = "没有此用户！";
                return false;
            }
        }

    }
}
