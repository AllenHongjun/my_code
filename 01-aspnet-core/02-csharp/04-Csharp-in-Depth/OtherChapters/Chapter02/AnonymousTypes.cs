﻿using System;
using System.ComponentModel;

namespace Chapter02
{
    [Description("Listing 2.6")]
    class AnonymousTypes
    {
        static void Main()
        {
            var jon = new { Name = "Jon", Age = 36 };
            var tom = new { Name = "Tom", Age = 9 };
            Console.WriteLine("{0} is {1}", jon.Name, jon.Age);
            Console.WriteLine("{0} is {1}", tom.Name, tom.Age);
        }
    }
}
