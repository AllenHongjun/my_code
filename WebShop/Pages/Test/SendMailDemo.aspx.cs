using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebShop.Pages.Test
{
    public partial class SendMailDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {


            //企业里面有自己的 邮件服务器 。。可以群发邮件 。或者购买

            //都有限制 最基本的 一封邮件都不然发送了。。
            MailMessage mailMsg = new MailMessage();//两个类，别混了，要引入System.Net这个Assembly
            mailMsg.From = new MailAddress("652971723@qq.com", "Allen");//源邮件地址 
            mailMsg.To.Add(new MailAddress("652971723@163.com", "HONGjunyu"));//目的邮件地址。可以有多个收件人
            mailMsg.Subject = "Hello,大家好!这个是邮件发送测试";//发送邮件的标题 
            mailMsg.Body = "Tai Xie E le！";//发送邮件的内容 
            SmtpClient client = new SmtpClient("smtp.qq.com");//smtp.163.com，smtp.qq.com
            client.Credentials = new NetworkCredential("652971723@qq.com", "HONGjunyu999");
            client.Send(mailMsg);


        }
    }
}