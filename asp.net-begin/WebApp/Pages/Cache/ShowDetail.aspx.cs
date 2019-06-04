using BLL;
using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.Cache
{
    public partial class ShowDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request["id"]);

            UserInfoService UserInfoService = new UserInfoService();
            UserInfo userInfo = UserInfoService.GetUserInfo(id);

            List<UserInfo> list = new List<UserInfo>();
            list.Add(userInfo);


            //拖了一个空间 就帮你在这个类中创建好了一个对象

            //微软会帮你做很多的事情 。但是 你自己琢磨
            //你也搞不明白 他帮你做了哪些事情
            //控件整的是牛逼 你只要按要求绑定上一个 对象
            //他什么都帮你显示出来了  webform毕竟是很早就出来了。人家都玩了很多年了。。能不熟悉吗
            this.DetailsView1.DataSource = list;
            this.DetailsView1.DataBind();
        }
    }
}