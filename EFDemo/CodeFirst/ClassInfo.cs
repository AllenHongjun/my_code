using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace EFDemo.CodeFirst
{
    public class ClassInfo
    {   
        //标记这就是一个主键
        // 一个班级有多个学生 一个学生对应一个班级
        // 就是一条班级的表的数据 对应 多个学生 可以组合一张大的表
        // 一个 学生反过来查询 班级表  只能查询一个班级的信息
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(32)]
        public string ClassName { get; set; }

        // 非空 字符串的长度
        [Required]
        public DateTime CreateTime { get; set; }

        //就是表示一个班级是有多个学生的 注意 virtual 记住这么使用的就可以了
        //程序里面的代码 和数据库里面有一个对应的关系
        public virtual ICollection<StudentInfo> StudentInfos { get; set; }
    }
}