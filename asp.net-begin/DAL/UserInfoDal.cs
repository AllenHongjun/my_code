using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Model;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class UserInfoDal
    {
        public UserInfoDal()
        {
        }

        /// <summary>
        /// 获取用户列表
        /// </summary>
        /// <returns></returns>
        public IList<UserInfo> GetList()
        {
            string sql = "select top 800 * from UserInfo order by ID desc";
            DataTable da = SqlHelper.GetDataTable(sql, CommandType.Text);
            List<UserInfo> list = null;
            if (da.Rows.Count > 0)
            {
                list = new List<UserInfo>();
                UserInfo userInfo = null;
                foreach (DataRow row in da.Rows)
                {   
                    //这里一个引用对象 传递到方法里面 可以在外面直接能用
                    //工厂模式 抽象工厂模式
                    userInfo = new UserInfo();
                    LoadEntity(userInfo, row);
                    list.Add(userInfo);
                }
            }
            return list;
        }

        /// <summary>
        /// 分页获取数据
        /// </summary>
        /// <param name="start">开始第几条数据</param>
        /// <param name="end">结束第几条数据</param>
        /// <returns></returns>
        public List<UserInfo> GetPageList(int start, int end)
        {
            /*
             * https://www.cnblogs.com/liuzhenlei/p/8026278.html
             row_number() OVER (PARTITION BY COL1 ORDER BY COL2) 
             表示根据COL1分组，在分组内部根据 COL2排序，
             而此函数计算的值就表示每组内部排序后的顺序编号
             （组内连续的唯一的)
             */
            string sql = @"select * from( select *, row_number() over
(order by id) as num from UserInfo) as t where t.num >=@start and
t.num < @end";
            SqlParameter[] pars =
            {
                new SqlParameter("@start",SqlDbType.Int),
                new SqlParameter("@end",SqlDbType.Int)
                
            };
            pars[0].Value = start;
            pars[1].Value = end;
            DataTable da = SqlHelper.GetDataTable(sql, CommandType.Text, pars);
            List<UserInfo> list = null;
            if (da.Rows.Count>0)
            {
                list = new List<UserInfo>();
                UserInfo userInfo = null;
                foreach (DataRow row in da.Rows)
                {
                    userInfo = new UserInfo();
                    LoadEntity(userInfo, row);
                    list.Add(userInfo);
                }
            }
            return list;
        }


        public int GetRecordCount()
        {
            string sql = "select count(1) from UserInfo";
            return Convert.ToInt32(SqlHelper.ExecuteScalar(sql, CommandType.Text));
        }

        /// <summary>
        /// 添加用户信息
        /// </summary>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public int AddUserInfo(UserInfo userInfo)
        {
            string sql = @"insert into UserInfo(UserName,UserPass,RegTime,Email)
            values(@UserName,@UserPass,@RegTime,@Email)";
            SqlParameter[] pars =
            {
                new SqlParameter("@UserName",SqlDbType.NVarChar,32),
                new SqlParameter("@UserPass",SqlDbType.NVarChar,32),
                new SqlParameter("@RegTime",SqlDbType.DateTime),
                new SqlParameter("@Email",SqlDbType.NVarChar,32),
            };
            pars[0].Value = userInfo.UserName;
            pars[1].Value = userInfo.UserPass;
            pars[2].Value = userInfo.RegTime;
            pars[3].Value = userInfo.Email;
            return SqlHelper.ExcuteNonQuery(sql, CommandType.Text, pars);
        }

        /// <summary>
        /// 根据ID删除用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int DeleteUserInfo(int id)
        {
            string sql = "delete from UserInfo where ID = @ID";
            SqlParameter[] pars =
            {
                new SqlParameter("@ID",SqlDbType.Int)
            };
            pars[0].Value = id;
            return SqlHelper.ExcuteNonQuery(sql, CommandType.Text, pars);
        }

        /// <summary>
        /// 根据用户编号查找用户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public UserInfo GetUserInfo(int id)
        {
            string sql = "select * from UserInfo where ID=@ID";
            SqlParameter[] pars =
            {
                new SqlParameter("@ID",SqlDbType.Int)
            };
            pars[0].Value = id;
            DataTable da = SqlHelper.GetDataTable(sql, CommandType.Text, pars);
            UserInfo userInfo = null;
            if (da.Rows.Count > 0)
            {
                userInfo = new UserInfo();
                LoadEntity(userInfo, da.Rows[0]);
            }
            return userInfo;
        }

        /// <summary>
        /// 根据用户名 来获取用户的信息
        /// 浏览器一关 sessionid就没有了
        /// sessionID是保存在浏览器的内存中的 
        /// 不能设置SessionID 在浏览器中的过期时间
        /// 主要就应用在浏览器后台的登陆的时候
        /// 记住已经用户登陆过的状态
        /// session 其他的应用场景
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public UserInfo GetUserInfo(string userName)
        {
            string sql = "select * from UserInfo where UserName = @UserName";
            SqlParameter[] pars =
            {
                new SqlParameter("@UserName",SqlDbType.NVarChar,32)
            };
            pars[0].Value = userName;
            DataTable da = SqlHelper.GetDataTable(sql, CommandType.Text, pars);
            UserInfo userInfo = null;
            if (da.Rows.Count > 0)
            {
                userInfo = new UserInfo();
                LoadEntity(userInfo, da.Rows[0]);
            }
            return userInfo;
        }


        /// <summary>
        /// 修改用户信息
        /// </summary>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public int EditUserInfo(UserInfo userInfo)
        {
            string sql = @"update UserInfo set UserName=@UserName,
UserPass=@UserPass,RegTime=@RegTime,Email=@Email where ID=@ID";
            SqlParameter[] pars = new SqlParameter[]
            {
                new SqlParameter("@UserName",SqlDbType.NVarChar,32),
                new SqlParameter("@UserPass",SqlDbType.NVarChar,32),
                new SqlParameter("@RegTime",SqlDbType.DateTime,32),
                new SqlParameter("@Email",SqlDbType.NVarChar,32),
                new SqlParameter("@ID",SqlDbType.NVarChar,32),
            };
            pars[0].Value = userInfo.UserName;
            pars[1].Value = userInfo.UserPass;
            pars[2].Value = userInfo.RegTime;
            pars[3].Value = userInfo.Email;
            pars[4].Value = userInfo.Id;
            return SqlHelper.ExcuteNonQuery(sql, CommandType.Text, pars);
        
        }



        /// <summary>
        /// 加载一条数据
        /// </summary>
        /// <param name="userinfo"></param>
        /// <param name="row"></param>
        private void LoadEntity(UserInfo userinfo, DataRow row)
        {
            userinfo.UserName = row["UserName"] != DBNull.Value ?
                row["UserName"].ToString() : string.Empty;
            userinfo.UserPass = row["UserPass"] != DBNull.Value ?
                row["UserPass"].ToString() : string.Empty;
            userinfo.Email = row["Email"] != DBNull.Value ?
                row["Email"].ToString() : string.Empty;
            userinfo.Id = Convert.ToInt32(row["ID"]);
            userinfo.RegTime = Convert.ToDateTime(row["RegTime"]!=DBNull.Value?
                row["RegTime"]:DateTime.Now);

        }

    }


    
}
