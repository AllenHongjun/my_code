using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp.Pages.webform
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {   

            //这是一个集合 生成的属性名  属性值
            this.Button2.Attributes["onclick"] = "onclikeshidh";
            this.Button2.Attributes["data-test"] = "{data:123,name:allen}";
        }

        protected void TextBox4_TextChanged(object sender, EventArgs e)
        {   
            //asp  开发 淘汰了。小地方 小公司
            Response.Write("文本框内容修改了"+Guid.NewGuid().ToString());
        }

        protected void DropDownList1_TextChanged(object sender, EventArgs e)
        {
            Response.Write("下拉框的内容修改ile" + Guid.NewGuid().ToString());
        }

        //每一个控件都是当前这个类的属性 就可以调用这个类的实例的 属性 和方法
        // 然后顶一个这个控件的事件 。。会帮您 自动的注册这个事件。就可以在事件里面处理响应的事情
        //他妈的太多的封装了。。只知道 可以这么注册 。但是不知道为什么可以这么注册

        //pageload事件 控件的事件 事件的执行顺序 事件驱动。。

        protected void RadioButton3_CheckedChanged(object sender, EventArgs e)
        {
            this.Button1.Text = "点击单选按钮可以修改Button的值";
        }
    }
}