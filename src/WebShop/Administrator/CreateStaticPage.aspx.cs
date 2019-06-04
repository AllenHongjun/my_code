using BookShop.BLL;
using BookShop.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Administrator
{
    public partial class CreateStaticPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            BookManager bll = new BookManager();
            List<Book> list = bll.GetModelList("Id < 5000");
            foreach (Book bookModel in list)
            {
                bll.CreateHtmlPage(bookModel.Id);
            }

        }
    }
}