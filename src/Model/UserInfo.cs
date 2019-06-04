using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model
{   
    //没有使用Repository如果表结构经常更改 痛苦在哪里
    //ado.net是哪些类库 具体实现了哪些功能
    //在这个项目上面完善
    //可以使用代码生成器 直接生成3层 几层
    //很多代码都是类似的
    //项目就是有很多的这种类似的类 增删改查 真删除改查。。方法 控件的使用EF 

    /// <summary>
    /// 多敲代码就会有感觉 不敲代码 就永远都没有感觉
    /// </summary>
    public class UserInfo
    {
        public int Id { get; set; }
        public string UserName { get; set; }

        public string UserPass { get; set; }

        public DateTime RegTime { get; set; }

        public string Email { get; set; }
    }
}
