using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp.Pages.webform
{
    public partial class DropDownList : System.Web.UI.Page
    {
        public int PageIndex { get; set; }
        public int PageCount { get; set; }
        public List<UserInfo> user { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {

            //主要是分页的内容
            UserInfoService userService = new UserInfoService();
            //user = userService.GetList().ToList();
            int index;
            int pageSize = 18;
            var res = int.TryParse(Request.QueryString["page"], out index);
            if (!res)
            {
                index = 0;
            }

            int pageCount = userService.GetPageCount(pageSize);
            PageCount = pageCount;
            PageIndex = index;
            index = index < 1 ? 1 : index;
            index = index > pageCount ? pageCount : index;


            UserInfoService userList = new UserInfoService();
            //直接可以设置默认是哪一个被选中 这个里面的控件 和方法
            this.DropDownList2.SelectedIndex = 2;
            this.DropDownList2.DataSource = userList.GetList();
            this.DropDownList2.DataTextField = "userName";
            this.DropDownList2.DataValueField = "ID";
            this.DropDownList2.DataBind();

            this.Repeater1.DataSource = userService.GetPageList(index * pageSize, index * pageSize + pageSize);
            this.Repeater1.DataBind();
        }


        //ItemCommand:只要是Repeater其它的服务端控件的事件被触发，
        //那么Repetar的ItemCommand事件也会被触发。
          //  在ItemCommand事件中可以完成Repeater其它服务端控件事件的处理。
          //可以完成 其他服务端 其他空间的处理
        protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
        {   

            //用户点击的删除按钮
            if (e.CommandName == "BtnEditUser")//表示删除按钮事件触发了.
            {
                Response.Write(Convert.ToInt32(e.CommandArgument));
            }
            if (e.CommandName == "BtnDeleteUser")
            {
                Response.Write(Convert.ToInt32(e.CommandArgument)+"删除按钮");
            }
        }
    }
}