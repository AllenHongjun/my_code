using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _01_sqlConnection
{
    class Program
    {
        static void Main(string[] args)
        {

            // 就建立一个项目让后抄起来 。找博客个。。数据库也是可以一样饿的
            //string strConn = "server=212.64.105.97;database=Hotel;uid=sa;pwd=I^OlRIE5deuaIS";
            // 写一个软件 可以让用户点点就可以很方便的操作数据库。。  sql 执行计划如何看 如何看的懂  分析一下数据库执行的计划。。
            // 如何看懂数据库执行的计划。。
            // ado.net 微软一组操作 数据库的 类库。

            /*
             *SqlConnection sql连接的分装。  SqlCommand sql命令的分装  SqlPrivder
             *
             *
             * DataSet DataTable    
             *
             *
             */
            string strConn = "server=.;database=Hotel;uid=sa;pwd=a123456";

            #region MyRegion


            using (SqlConnection conn = new SqlConnection(strConn))
            {
                //创建一个Sql命令对象  注意一下 重点掌握 sqlCommand 的几个重要属性和方法
                //想敲代码 就在建立一个敲代码的地方。。建立一个解决方法的什么的
                using (SqlCommand cmd = new SqlCommand())
                {
                    //给命令对象指定 连接对象。
                    cmd.Connection = conn;

                    conn.Open(); //一定要在执行命令之前打开就可以了。

                    //此属性放我们的sql脚本
                    cmd.CommandText = "insert into DboUserInfo(Name,DelFlag,Demo,cons)values('4444448888',0,'sss',0)";

                    cmd.ExecuteNonQuery(); //执行一个非查询sql语句，返回受影响的行数。 

                    //cmd.CommandText = "sel";
                    //cmd.ExecuteNonQuery()。。。。
                }
            }


            #endregion

            Console.ReadKey();

        }
    }
}
