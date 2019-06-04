using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EFDemo.CodeFirst
{
    public partial class CreateDatebase : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            try
            {   
                //其实所有的东西都可以放在一个项目里面
                //其实放在一起 自己看起还方便一点。
                //多建立几个 项目 有的时候知识为了看得清楚一点
                //点击按钮 创建一个数据库 这个开发起来就是so easy 的感觉
                CodeFirstDbContext dbContext = new CodeFirstDbContext();
                //如果不存在 就创建数据库
                dbContext.Database.CreateIfNotExists();
                ClassInfo classInfo = new ClassInfo();
                classInfo.ClassName = "高三14班";
                classInfo.CreateTime = DateTime.Now;

                //xml 一个属性 一个值  key value 就是使用为主 
                //学了一大堆理论 不知道有怎么用 用在哪里 也是白搭

                //这就创建了一个数据库 没滋滋的感觉
                dbContext.ClassInfo.Add(classInfo);
                dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                //异常的错误信息 就能够看的懂一些。
                Response.Write(ex.Message);
            }
           


        }
    }
}