using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace AppMvcWebForm.Models
{
    public class UserInfoValidate
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "用户名不能为空")]
        public string UserName { get; set; }
        public string UserPass { get; set; }
        public Nullable<System.DateTime> RegTime { get; set; }
        [RegularExpression(@"   ")]
        public string Email { get; set; }

    }

    /// <summary>
    /// 命名空间要一样 变成一个部分类
    /// </summary>
    /// 

    //这个特性标签 会关联 UserInfoValidate  属性是必须一模一样的

    //项目中使用的比较少 了解为主 还是写个脚本验证比较多。。
    //ajax mvc使用 现在请求的是一个 contrller的方法 

    //使用 这个关联之后 也就可以来 验证字段了 
    [MetadataType(typeof(UserInfoValidate))]
    public partial class UserInfo
    {

    }
}