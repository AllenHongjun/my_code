using MVC.IDAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace MVC.DALFactory
{   

    /// <summary>
    /// 通过反射的形式来创建类的实例 UserInfo 
    /// 通过访问程序集元数据当中数据  
    /// </summary>
    public class AbstractFactory
    {

        //创建类的实例的时候 不是直接new 直接new的话就是直接耦合在一起了

        //程序集的名字 方法的名字 反射 有些点 还是要回过头去重新完成以下 完成我们这个具体的项目

        //一点一点的完成自己的项目
        private static readonly string AssemblyPath = ConfigurationManager.AppSettings["AssemblyPath"];
        private static readonly string NameSpace = ConfigurationManager.AppSettings["NameSpace"];

        //传进一个具体的类的实例
        public static IUserInfoDal CreateUserInfoDal()
        {
            string fullClassName = NameSpace + ".UserInfoDal";
            //把需要的类型 转换
            return CreateInstance(fullClassName) as IUserInfoDal;
        }

        //通过反射来创建
        private static object CreateInstance(string className)
        {   
            //通过反射来加载程序集  程序集的位置webconfig里面设置
            //要加载类 都是在DAL里面 一点一点的功能集合寄来就是一个系统一个小系统 一个大系统
            var assembly = Assembly.Load(AssemblyPath);

            //命名空间的名字 + 类的名字 
            return assembly.CreateInstance(className);
        }
    }
}
