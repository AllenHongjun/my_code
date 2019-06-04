using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop
{
    public partial class ShowMsg : System.Web.UI.Page
    {

        public string Msg { get; set; }
        public string Title { get; set; }
        public string Url { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

            //提示消息的内容 通过url传递到一个提示页面 来做。
            ////用户体验不好的地方 如果用户点击返回 验证码是要重新刷新一下的。
            Msg = string.IsNullOrEmpty(Request["msg"]) ? "暂无信息" : Request["msg"];

            Title = string.IsNullOrEmpty(Request["txt"]) ? "商品列表页面" : Request["txt"];
            Url = string.IsNullOrEmpty(Request["url"]) ? "/BookList.aspx" : Request["url"];


        }
    }
}