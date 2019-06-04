using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace AppMvcWebForm.Models
{
    public class StudentInfo
    {

        public int Id { get; set; }



        //这个特性标签 是数据库生成 的时候 会用  表单验证的时候 也是都是可以使用的
        [Required(ErrorMessage ="用户名不能为空")]
        public string Name { get; set; }

        //用一个验证邮箱的正则表达式
        [RegularExpression(@"   ")]
        public string Email { get; set; }

        public DateTime RegTime { get; set; }
    }
}