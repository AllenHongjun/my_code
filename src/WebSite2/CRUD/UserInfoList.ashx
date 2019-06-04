<%@ WebHandler Language="C#" Class="UserInfoList" %>

using System;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;

public class UserInfoList : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        // 那是一个目标文件 可以直接请求这个动态文件
        // 执行的顺序就很关键

        context.Response.ContentType = "text/html";
        //读取数据库的数据。
        //替换模板文件。 
        //判断是否有无数据

        //数据创建连接字符串  
        //有几个固定的对象可以使用
        //调试模式 影响性能。。




        string connStr = ConfigurationManager
                .ConnectionStrings["connStr"].ConnectionString;
        //只要实现了那个类的就可以直接制动释放
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            using(SqlDataAdapter atper = new SqlDataAdapter("select top 30 * from UserInfo ", conn))
            {
                DataTable da = new DataTable();
                atper.Fill(da);
                if (da.Rows.Count > 0)
                {
                    StringBuilder sb = new StringBuilder();
                    foreach (DataRow row in da.Rows)
                    {   
                        //把所有的html字符串转化为单引号好就可以了。
                        //添加一个@就可以换行
                        sb.AppendFormat(@"<tr>
                                <td>{0}</td>
                                <td>{1}</td>
                                <td>{2}</td>
                                <td>{3}</td>
                                <td>{4}</td>
                                <td><a href='ShowDetail.ashx?id={0}'>详细</a></td>
                                <td><a href='DeleteUser.ashx?id={0}' class='deletes'>删除</a></td>
                                <td ><a href='ShowEdit.ashx?id={0}'>编辑</a></td>
                                </tr>",
                                row["ID"].ToString(),
                                row["UserName"].ToString(),
                                row["UserPass"].ToString(),
                                row["Email"].ToString(),
                                row["RegTime"].ToString()
                                );
                    }

                    //获取一个文件的路径。 根据该路径读取所有的数据
                    // 返回替换后的内容。响应字符串
                    // vs的快捷键。
                    // 赋值当前行  @符号的使用 
                    //数据库建立表。。 
                    //do di  去做。去做 去做。 
                    // 不是看视频。。看视频 是次要的。
                    //利用好现有的资源 去做。
                    string filePath = context.Request.MapPath("UserInfoList.html");
                    string fileContent = File.ReadAllText(filePath);
                    fileContent = fileContent.Replace("@tbody", sb.ToString());
                    context.Response.Write(fileContent);


                }
                else
                {
                    context.Response.Write("暂无数据！！");
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