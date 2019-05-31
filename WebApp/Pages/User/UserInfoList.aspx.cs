using BLL;
using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages
{   
    //重名的时候要给 类名 继承的类名 designer不用改 两个文件改了就可以了
    public partial class UserInfoList : System.Web.UI.Page
    {   
        //这就是一个 list类型的变量 复制好之后 子类可以使用 这个变量
        // 先执行 父类中Page_Load的方法 然后才会执行 页面中的方法
        public List<UserInfo> UserList { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

            UserInfoService userInfoService = new UserInfoService();
            List<UserInfo> list = userInfoService.GetList().ToList();
            UserList = list;


            // 业务层获取数据 绑定到 控件上。然后绑定一下数据 就好了。
            this.GridView1.DataSource = list;
            this.GridView1.DataBind();
            //这个就是好处 相当于已经有了一个模板引擎 成熟的可以直接使用
            //方便呀既然在使用了肯定有他的好处 好好利用他的好处
            //StringBuilder sb = new StringBuilder();
            //foreach (UserInfo userInfo in list)
            //{
            //    sb.AppendFormat("<tr><td>{0}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td></tr>",userInfo.Id,userInfo.UserName,userInfo.UserPass,userInfo.Email,userInfo.RegTime.ToShortDateString());
            //}
            //StrHtml = sb.ToString();

        }
    }
}