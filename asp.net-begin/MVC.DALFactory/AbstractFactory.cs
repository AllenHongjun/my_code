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
    /// 为了解耦使用抽象工厂和反射 使用autofac的就更加容易
    /// </summary>
    public class AbstractFactory
    {

        //创建类的实例的时候 不是直接new 直接new的话就是直接耦合在一起了

        private static readonly string AssemblyPath = ConfigurationManager.AppSettings["AssemblyPath"];
        private static readonly string NameSpace = ConfigurationManager.AppSettings["NameSpace"];

        //通过反射来创建
        private static object CreateInstance(string className)
        {
            
            var assembly = Assembly.Load(AssemblyPath);

            //命名空间的名字 + 类的名字 
            return assembly.CreateInstance(className);
        }

        //传进一个具体的类的实例
        public static IUserInfoDal CreateUserInfoDal()
        {
            string fullClassName = NameSpace + ".UserInfoDal";
            //把需要的类型 转换
            return CreateInstance(fullClassName) as IUserInfoDal;
        }

        /// <summary>
        /// 创建权限信息数据层实例
        /// </summary>
        /// <returns>返回的是接口类型给业务层调用</returns>
        public static IActionInfoDal CreateActionInfoDal()
        {   
            //命名空间加上类名通过反射就可以创建出这个类的实例
            string fullClassName = NameSpace + ".ActionInfo";
            return CreateInstance(fullClassName) as IActionInfoDal;
        }
        /// <summary>
        /// 创建权限组的数据层实例
        /// </summary>
        /// <returns></returns>
        public static IActionGroupDal CreateActionGroupDal()
        {
            string fullClassName = NameSpace + ".ActionGroupDal";
            return CreateInstance(fullClassName) as IActionGroupDal;
        }

        /// <summary>
        /// 创建角色数据层实例
        /// </summary>
        /// <returns></returns>
        public static IRoleDal CreateRoleDal()
        {
            string fullClassName = NameSpace + ".RoleDal";
            return CreateInstance(fullClassName) as IRoleDal;
        }

        /// <summary>
        /// 创建部门数据层实例
        /// </summary>
        /// <returns></returns>
        public static IDepartmentDal CreateDepartmentDal()
        {
            string fullClassName = NameSpace + ".DepartmentDal";
            return CreateInstance(fullClassName) as IDepartmentDal;
        }


        /// <summary>
        /// 站点设置
        /// </summary>
        /// <returns></returns>
        public static ISettingsDal CreateSettingsDal()
        {
            string fullClassName = NameSpace + ".SettingDal";
            return CreateInstance(fullClassName) as ISettingsDal;
        }


        /// <summary>
        /// 书籍数据层实例创建
        /// </summary>
        /// <returns>返回数据数据层对应的接口</returns>
        public static IBookDal CreateBookDal()
        {
            string fullClassName = NameSpace + ".BookDal";
            return CreateInstance(fullClassName) as IBookDal;
        }

        public static ICategoryDal CretaeCategoryDal()
        {
            string fullClassName = NameSpace + ".CategoryDal";
            return CreateInstance(fullClassName) as ICategoryDal;
        }

        public static ICartDal CreateCartDal()
        {
            string fullClassName = NameSpace + ".CartDal";
            return CreateInstance(fullClassName) as ICartDal;
        }

        public static IOrderDal CreateOrderDal()
        {
            string fullClassName = NameSpace + ".OrderDal";
            return CreateInstance(fullClassName) as IOrderDal;
        }

        public static IOrderBooksDal CreateOrderBooksDal()
        {
            string fullClassName = NameSpace + ".OrderBookDal";
            return CreateInstance(fullClassName) as IOrderBooksDal;
        }

        /// <summary>
        /// 创建出版设对象的实例
        /// </summary>
        /// <returns></returns>
        public static IPublishDal CreatePublishDal()
        {
            string fullClassName = NameSpace + ".PublishDal";
            return CreateInstance(fullClassName) as IPublishDal;
        }

    }
}
