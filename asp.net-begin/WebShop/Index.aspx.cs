using BookShop.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bindCategory();
                bindBookJs();
            }
        }

        public void bindCategory()
        {
            CategoryManager cateManager = new CategoryManager();
            var cateDtset = cateManager.GetList(11, "Id > 1", "Id");
            var cateList = cateManager.DataTableToList(cateDtset.Tables[0]);
            this.CateReapter.DataSource = cateList;
            this.CateReapter.DataBind();
        }

        public void bindBookJs()
        {
            BookManager bookManager = new BookManager();
            var ds = bookManager.GetList(5, "CategoryId = 15", "Id desc");
            this.BookList.DataSource = bookManager.DataTableToList(ds.Tables[0]);
            this.BookList.DataBind();


        }

        protected string CutString(string str, int length)
        {

            return str.Length > length ? str.Substring(0, length) + "..." : str;
        }

        public string GetString(object obj)
        {
            DateTime t = Convert.ToDateTime(obj);
            return "/HtmlPage/" + t.Year + "/" + t.Month + "/" + t.Day + "/";
        }
    }
}