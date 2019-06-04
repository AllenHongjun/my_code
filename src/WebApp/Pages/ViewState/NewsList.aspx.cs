using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp.Pages.ViewState
{
    public partial class NewsList : System.Web.UI.Page
    {   
        public int PageIndex { get; set; }
        public int PageCount { get; set; }
        public List<UserInfo> user { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {   

            //主要是分页的内容
            UserInfoService userService = new UserInfoService();
            //user = userService.GetList().ToList();

            //习惯这种不是通过ajax发送请求 链接发送请求
            // 跳转页面 表单提交来发送请求的方式。
            //习惯习惯 知道那个点就会做了

            //根据现有的功能  找到哪个代码 然后就是调试调试 改造改造就变成自己的了

            //显示一个分页的页面条
            //上一页 下一页 首页 尾页 反正需要的功能 都希望能快速较好的完成
            int index ;
            int pageSize = 5;
            var res =int.TryParse(Request.QueryString["page"],out index);
            if (!res)
            {
                index = 0;
            }

            //最后一页 第一页。第几天记录的判断 看着很简单的是一个事情。你要实现好的话还是有很多细节的问题的
            //你真正能做出来 做好的 又有多少个。。自己做一遍的感觉 体验完全是不一样的
            // 这些代码可以自己随便怎么玩。。当然还是不能直接应用到工作当中的。  工作中 就是 更加成熟的 具体的代码的使用。看一看 调试一下 基本就会使用了
            int pageCount = userService.GetPageCount(pageSize);
            PageCount = pageCount;
            PageIndex = index;
            index = index < 1 ? 1 : index;
            index = index > pageCount ? pageCount : index;
            user = userService.GetPageList(index * pageSize, index * pageSize+pageSize);

        }
    }
}