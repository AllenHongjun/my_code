using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TestLinq
{
    class Teacher
    {
        public string Name { get; set; }

        public List<Student> Students;

        public Teacher(string order,List<Student> students)
        {
            this.Name = order;

            this.Students = students;
        }
    }
}
