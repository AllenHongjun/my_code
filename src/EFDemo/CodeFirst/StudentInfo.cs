using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace EFDemo.CodeFirst
{   
    /// <summary>
    /// 学生信息
    /// </summary>
    public class StudentInfo
    {   
        [Key]
        public int Id { get; set; }
        /// <summary>
        /// 学生姓名
        /// </summary>
        public string StuName { get; set; }
        [Required]
        public DateTime SubTime { get; set; }

        public virtual ClassInfo ClassInfo { get; set; }
    }
}