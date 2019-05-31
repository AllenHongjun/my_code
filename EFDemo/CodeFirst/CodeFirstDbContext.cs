using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Linq;
using System.Web;

namespace EFDemo.CodeFirst
{
    public class CodeFirstDbContext:DbContext
    {
        //new  这个类的实例的实例的时候 是会调用父类的构造方法的
        //够着方法 就是给这个类的实例 的字段 赋值一些属性
        //计算机运行的时候 会做一些事情
        public CodeFirstDbContext()
            : base("name=connStr2")
        {

        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {   
            //生成数据表的时候名称会带复数的形式 注意下 把这个选项移出掉
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }


        /// <summary>
        /// 这个就对应一张表 框架里面固定的一些写法
        /// 
        /// 具体框架里面是如何实现的 最好是能够弄懂了
        /// 先知道 是这么使用
        /// </summary>
        public DbSet<ClassInfo> ClassInfo { get; set; }

        public DbSet<StudentInfo> StudentInfo { get; set; }
    }
}