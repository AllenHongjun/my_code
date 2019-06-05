﻿using CZBK.ItcastOA.IDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.DALFactory
{
    /// <summary>
    /// 通过反射的形式创建类的实例
    /// </summary>
   public partial class AbstractFactory
    {
       private static readonly string AssemblyPath = ConfigurationManager.AppSettings["AssemblyPath"];
       private static readonly string NameSpace = ConfigurationManager.AppSettings["NameSpace"];
       //public static IUserInfoDal CreateUserInfoDal()
       //{
       //    string fullClassName = NameSpace + ".UserInfoDal";
       //   return CreateInstance(fullClassName) as IUserInfoDal;
       //}
       private static object CreateInstance(string className)
       {
          var assembly= Assembly.Load(AssemblyPath);
          return assembly.CreateInstance(className);
       }
    }
}
