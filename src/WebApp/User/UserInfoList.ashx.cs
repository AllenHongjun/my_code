using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using System.IO;
using BLL;
using System.Text;

namespace WebApp.User
{
    /// <summary>
    /// UserInfoList 的摘要说明
    /// </summary>
    public class UserInfoList : IHttpHandler
    {

        //被别人应用的类库。不能去引用 引用了他的类库 行尾符号

        //编辑器的 vs里面文件的编码格式 文件的换行符
        //需要判断一下数据是否为null 否则是会抛出异常的。

        //了解明天是要做什么？？
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/html";
            UserInfoService userInfoService = new UserInfoService();
            IList<UserInfo> list = userInfoService.GetList();
            StringBuilder sb = new StringBuilder();
            foreach (var userInfo in list)
            {
                sb.AppendFormat(
  @"<tr>
    <td>{0}</td>
    <td>{1}</td>
    <td>{2}</td>
    <td>{3}</td>
    <td>{4}</td>
    <td><a href='DeleteUser.ashx?id={0}' class='deletes'>删除</a></td>
    <td><a href='ShowDetail.ashx?uid={0}'>详细</a></td>
    <td><a href='ShowEdit.ashx?id={0}'>编辑</a></td>
</tr> ",
                    userInfo.Id,
                    userInfo.UserName,
                    userInfo.UserPass,
                    userInfo.Email,
                    userInfo.RegTime
                 );
            }
            //获取一个文件的物理路径。
            string filePath = context.Request.MapPath("UserInfoList.html");
            string fileContext = File.ReadAllText(filePath);
            fileContext = fileContext.Replace("@tbody", sb.ToString());
            context.Response.Write(fileContext);




            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}