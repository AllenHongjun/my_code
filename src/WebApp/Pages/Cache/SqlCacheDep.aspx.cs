using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;

namespace WebApp.Pages.Cache
{
    public partial class SqlCacheDep : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Cache["userInfoList"] == null)
            {
                //无法在配置中找到“connStr”数据库。 使用这个
                //数据库如何配置

                //这就是一个系统了 
                //乱七八糟的东西 就很多了。



                SqlCacheDependency cDep =  new SqlCacheDependency("connStr", "UserInfo");

                string sql = "select top 10 * from UserInfo";
                DataTable da = SqlHelper.GetDataTable(sql, CommandType.Text);
                Cache.Insert("userInfoList", da, cDep);
                Response.Write("数据来自数据库");


            }
            else
            {
                Response.Write("数据来自缓存");
            }

        }
    }
}