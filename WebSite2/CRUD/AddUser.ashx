<%@ WebHandler Language="C#" Class="AddUser" %>

using System;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public class AddUser : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        string userName = context.Request.Form["username"];
        string password = context.Request.Form["password"];
        string email = context.Request.Form["email"];

        string conStr = ConfigurationManager.ConnectionStrings["connStr"].ConnectionString;

        //写一遍 就会感觉还是挺有成就感的。就是要多动手多时间。。一张表的增删改查。实践一般。。。
        //完成了一张表的正删改查 接下去就是准备分层。好牛逼呀。数据库 。前端代码 全部都是一体的。都是我的资源 好好的保存
        using (SqlConnection conn = new SqlConnection(conStr))
        {
            using (SqlCommand cmd = new SqlCommand())
            {   

                //参数 有@可以防止 sql注入。。使用EF框架 使用分层的架构。能把东西弄出来就可以了。
                //还是需要动手呀。。 
                cmd.Connection = conn;
                cmd.CommandText = @"insert into UserInfo(UserName,UserPass,RegTime,Email)" +
                    "values(@UserName,@UserPass,@RegTime,@Email)";
                SqlParameter[] pars =
                    {
                        new SqlParameter("@UserName",SqlDbType.NVarChar,32),
                        new SqlParameter("@UserPass",SqlDbType.NVarChar,32),
                        new SqlParameter("@RegTime",SqlDbType.DateTime),
                        new SqlParameter("@Email",SqlDbType.NVarChar,32)
                    };
                pars[0].Value = userName;
                pars[1].Value = password;
                pars[2].Value = DateTime.Now;
                pars[3].Value = email;
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