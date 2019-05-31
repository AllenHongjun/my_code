using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpringNetWin
{
    public class UserInfoService:IUserInfoService
    {   

        //老师都一步一步的教你怎么做了你还不去做 那还能怎么办呢？？
        //那不多操作就没有办法了。就是要做去操作才行呀
        //public void ShowMsg()
        //{

        //}

        
        //属性的值是通过依赖注入的方式   属性的值通过注入的方式来实现

        //听起来很高大上的名字 东西 都是在使用别人 写好的一些组建和功能 都不知道源码怎么东西是什么样子的
        public string Name { get; set; }
        public Person Person { get; set; }
        public string ShowMsg()
        {
            //return "zhangsan ";

            return "姓名是：  " + Name + "年龄： " + Person.Age;
        }
    }
}
