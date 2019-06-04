using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Configuration;

using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class SqlHelper
    {
        //为什么静态的只读的 常用的了。  新版的类库可能没有这个方法了
        //需要引用类库 System.Configuration 
        private static readonly string connStr = ConfigurationManager.ConnectionStrings["connStr"].ConnectionString;

        /// <summary>
        /// (1)、使用 params关键字可以指定一个方法参数,该方法参数的数目可变。

        //(2)、可以发送参数声明中所指定类型的逗号分隔的参数列表或指定类型的参数数组。 还可以不发送参数。 如果未发送任何参数，则 params 列表的长度为零。

//(3)、在方法声明中的 params 关键字之后不允许任何其他参数，并且在方法声明中只允许一个 params 关键字。
        ///执行一条查询的sql语句 或者存储过程
        /// 封装一下就所有的查询的sql语句都能够调用
        /// 僵硬的是 一个查询 一个功能 都要封装 
        /// 还都有很多层。。业务逻辑乱的一塌糊涂
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="type"></param>
        /// <param name="pars"></param>
        /// <returns></returns>
        public static DataTable GetDataTable(string sql, CommandType type,params SqlParameter[] pars)
        {   
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlDataAdapter apter = new SqlDataAdapter(sql,conn))
                {
                    if (pars != null)
                    {
                        apter.SelectCommand.Parameters.AddRange(pars);
                    }
                    apter.SelectCommand.CommandType = type;
                    DataTable da = new DataTable();
                    apter.Fill(da);
                    return da;
                }
            }
        }


        /// <summary>
        /// 不执行查询 就是执行 delete insert update
        /// tcp 链接 发送数据 接收数据。数据库服务器 会自动处理tcp的请求
        /// update userinfo set username = 'allen'
        /// delete from userinfo where 'id' = 1;
        /// insert into userinfo (username,password) values('allen','a123')
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="type"></param>
        /// <param name="pars"></param>
        /// <returns></returns>
        public static int ExcuteNonQuery(string sql,CommandType type,
            params SqlParameter[] pars)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(sql,conn))
                {
                    if (pars !=null)
                    {
                        cmd.Parameters.AddRange(pars);
                    }
                    cmd.CommandType = type;
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
                
            }
        }

        /// <summary>
        /// 执行查询 并且返回查询结果集中的第一行 第一列
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="type"></param>
        /// <param name="pars"></param>
        /// <returns></returns>
        public static object  ExecuteScalar(string sql, CommandType type , params SqlParameter[] pars)
        {
            using(SqlConnection conn = new SqlConnection(connStr))
            {
                using(SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (pars !=null)
                    {
                        cmd.Parameters.AddRange(pars);
                    }
                    cmd.CommandType = type;
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
        }

    }
}
