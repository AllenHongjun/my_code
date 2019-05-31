using BookShop.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Shop
{
    public partial class ShopList : System.Web.UI.Page
    {   

        public int PageIndex { get; set; }

        public int PageCount { get; set; }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindBookList();
            }
        }

        protected void BindBookList()
        {   
            //这里做一些接收参数的判断
            int pageIndex;
            if (!int.TryParse(Request["pageIndex"],out pageIndex))
            {
                pageIndex = 1;
            }
            int pageSize = 10;
            BookManager bookManager = new BookManager();
            int pageCount = bookManager.GetPageCount(pageSize);
            PageCount = pageCount;

            pageIndex = pageIndex < 1 ? 1 : pageIndex;
            pageIndex = pageIndex > pageCount ? pageCount : pageIndex;
            PageIndex = pageIndex;
            var bookList = bookManager.GetPageList(pageIndex, pageSize);
            BookRepeater.DataSource = bookList;
            BookRepeater.DataBind();

        }


        /// <summary>
        /// 太长的话就做一个字符串截取 
        /// 就这么简单 
        /// 有时候看起来很复杂 很烦的问题 其实是很好解决的
        /// 不要一直纠结
        /// </summary>
        /// <param name="str"></param>
        /// <param name="length"></param>
        /// <returns></returns>
        protected string CutString(string str,int length)
        {

            return str.Length > length ? str.Substring(0, length) + "..." : str;
        }


        /// <summary>
        /// 将出版日期的 生成 对应页面的路径。。英文生成 页面的时候 路径就是更加一个出版日期来生成的。
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public string GetString(object obj)
        {
            DateTime t = Convert.ToDateTime(obj);
            return "/HtmlPage/" + t.Year + "/" + t.Month + "/" + t.Day + "/";
        }
    }
}