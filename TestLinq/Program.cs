using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestLinq
{
    class Program
    {
        static void Main(string[] args)
        {
            // Class1.SelectManyEx3();
			
			//https://www.cnblogs.com/manupstairs/archive/2012/11/27/2790114.html  博客地址


            List<Teacher> teachers = new List<Teacher>
            {
                new Teacher("a",new List<Student>{ new Student(100),new Student(90),new Student(30) }),
                new Teacher("b",new List<Student>{ new Student(100),new Student(90),new Student(60) }),
                new Teacher("c",new List<Student>{ new Student(100),new Student(90),new Student(40) }),
                new Teacher("d",new List<Student>{ new Student(100),new Student(90),new Student(60) }),
                new Teacher("e",new List<Student>{ new Student(100),new Student(90),new Student(50) }),
                new Teacher("f",new List<Student>{ new Student(100),new Student(90),new Student(60) }),
                new Teacher("g",new List<Student>{ new Student(100),new Student(90),new Student(60) })
            };

            List<Student> studentList = new List<Student>();
            foreach (var t in teachers)
            {
                foreach (var s in t.Students)
                {
                    if (s.Score < 60)
                    {
                        studentList.Add(s);
                    }
                }
            }

            studentList.ForEach(s => Console.WriteLine(s.Score));



            var list1 = from t in teachers
                        from s in t.Students
                        where s.Score < 60
                        select s;
            foreach (var item in list1)
            {
                Console.WriteLine(item.Score);
            }


            var list2 = teachers.SelectMany(t => t.Students).Where(s => s.Score < 60);

            foreach (var item in list2)
            {
                Console.WriteLine(item.Score);
            }

            // 又成长了一点。。  这些方法的调用 看着稍微有些别扭 参数 也有点容易混淆。。但是 仔细分析下 还是那么一回事。。
            // 就是 根据 输入的一个 参数 和 这就很好配合 Group Join 来使用了。。 这样也就连得通了。。TCollection TStudent TSource 
            // 这些类型分别对应的是什么歌意思 。。  哇 终于 有了一点豁然开朗的感觉 。。
            // 官方 这几个函数的代码 再 多研究 研究 多调试胰腺癌。。
            var list3 = teachers.SelectMany(
                t => t.Students,
                (t, s) => new { t.Name, s.Score })
                ;

            foreach (var item in list3)
            {
                Console.WriteLine(item.Name + item.Score);
            }
        }
    }
}
