using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Test
{
    public static class SqlLiteHelper
    {

        private static string connStr =
            ConfigurationManager.ConnectionStrings["Cater"].ConnectionString;

        //执行命令的方法：insert,update,delete
        //params：可变参数，目的是省略了手动构造数组的过程，直接指定对象，编译器会帮助我们构造数组，并将对象加入数组中，传递过来
        private static int ExecuteNonQuery(string sql,params SQLiteParameter[] ps)
        {   
            //建立来连接 数据库操作对象 添加参数 打开连接 执行命令返回受影响的行数
            //就是着么一个流程
            using (SQLiteConnection conn = new SQLiteConnection(connStr))
            {
                SQLiteCommand cmd = new SQLiteCommand(sql, conn);
                cmd.Parameters.AddRange(ps);
                conn.Open();
                return cmd.ExecuteNonQuery();
            }

        }

        //返回首行首列
        public static object ExcuteScalar(string sql,params SQLiteParameter[] ps)
        {
            using (SQLiteConnection conn = new SQLiteConnection(connStr))
            {
                SQLiteCommand cmd = new SQLiteCommand(sql, conn);
                cmd.Parameters.AddRange(ps);
                conn.Open();
                //执行命令，获取查询结果集中的首行首列的值，返回
                return cmd.ExecuteScalar();

            }

        }

        //获取结果集
        public static DataTable GetDataTable(string sql,params SQLiteParameter[] ps)
        {
            using (SQLiteConnection conn = new SQLiteConnection(connStr))
            {
                //创建一个适配器对象
                SQLiteDataAdapter adapter = new SQLiteDataAdapter(sql, conn);
                //这种方式 直接执行sql语句性能是最高的
                //你一个系统里面完全这种方式也都是可以集合在里面的
                //不然怎么叫系统的 适合的技术 都再里面
                DataTable dt = new DataTable();
                adapter.SelectCommand.Parameters.AddRange(ps);
                //执行结果
                adapter.Fill(dt);
                return dt;

            }


        }


    }
}
