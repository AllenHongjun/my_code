<%@ WebHandler Language="C#" Class="EditUser" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;

public class EditUser : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string userName = context.Request.Form["txtName"];
        string userPwd = context.Request.Form["txtPwd"];
        string userMail = context.Request.Form["txtMail"];
        //接受隐藏域当中的值
        //需要判断接受的参数的值
        //分层封装 就可以重用很多的东西
        int id = Convert.ToInt32(context.Request.Form["txtId"]);

        string connStr = ConfigurationManager.ConnectionStrings["connStr"]
                .ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand())
            {

                cmd.Connection = conn;
                cmd.CommandText = @"update UserInfo set UserName=@UserName,UserPass=@UserPass,Email=@Email where ID=@ID";
                SqlParameter[] pars =
                    {
                        new SqlParameter("@UserName",SqlDbType.NVarChar,32),
                        new SqlParameter("@UserPass",SqlDbType.NVarChar,32),
                        new SqlParameter("@Email",SqlDbType.NVarChar,32),
                        new SqlParameter("@ID",SqlDbType.Int),
                    };
                pars[0].Value = userName;
                pars[1].Value = userPwd;
                pars[2].Value = userMail;
                pars[3].Value = id;

                /*
                 创建数据库连接对象
                 sqlConnection sqlCommand sqlParameter
                 连接数据库 创建sql语句 连接数据库
                 添加查询的参数 这一步不能忘记
                 打开数据库连接 执行查询
                 返回查询的结果
                 using自动关闭数据库连接
                 执行业务逻辑
                     
                     */
                cmd.Parameters.AddRange(pars);
                conn.Open();
                if (cmd.ExecuteNonQuery() > 0)
                {
                    context.Response.Redirect("UserInfoList.ashx");

                }
                else
                {
                    context.Response.Redirect("Error.html");
                }

            }
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}