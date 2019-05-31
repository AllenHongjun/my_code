<%@ WebHandler Language="C#" Class="DeleteUser" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;

public class DeleteUser : IHttpHandler {

    public void ProcessRequest (HttpContext context) {

        //先从一张表开始。然后再一步一步 慢慢来做
        //context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        //想些一个循环直接插入100条数据

        context.Response.ContentType = "text/plain";
        int id;
        if (int.TryParse(context.Request.QueryString["id"],out id))
        {
            string connStr = ConfigurationManager
                    .ConnectionStrings["connStr"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = @"delete from UserInfo where ID=@ID";
                    SqlParameter par = new SqlParameter("@ID", SqlDbType.Int);
                    par.Value = id;
                    cmd.Parameters.Add(par);
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
        else
        {
            context.Response.Redirect("Error.html");
        }

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}