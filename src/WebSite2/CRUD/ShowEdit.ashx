<%@ WebHandler Language="C#" Class="ShowEdit" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public class ShowEdit : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";
        int id;
        if (int.TryParse(context.Request.QueryString["id"],out id))
        {
            string connStr = ConfigurationManager.ConnectionStrings["connStr"]
                    .ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "select * from UserInfo where ID = @ID";
                using (SqlDataAdapter apter = new SqlDataAdapter(query,conn))
                {
                    SqlParameter per = new SqlParameter("@ID", SqlDbType.Int);
                    per.Value = id;
                    apter.SelectCommand.Parameters.Add(per);
                    DataTable da = new DataTable();
                    apter.Fill(da);
                    if (da.Rows.Count > 0)
                    {
                        string filePath = context.Request.MapPath("ShowEditUser.html");
                        string fileContent = File.ReadAllText(filePath);
                        fileContent = fileContent.Replace("$name", da.Rows[0]["UserName"].ToString())
                                .Replace("$pwd",da.Rows[0]["UserPass"].ToString())
                                .Replace("$email",da.Rows[0]["Email"].ToString())
                                .Replace("$id",da.Rows[0]["ID"].ToString());
                        context.Response.Write(fileContent);

                    }
                    else
                    {
                        context.Response.Write("查无此人!!");
                    }

                }


            }
        }
        else
        {
            context.Response.Write("参数异常！！");
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}