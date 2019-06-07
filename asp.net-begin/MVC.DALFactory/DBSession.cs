using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;
using MVC.DAL;
using MVC.IDAL;
using System.Data.Entity;

namespace MVC.DALFactory
{
    /// <summary>
    /// 数据会话层  DALFactory   业务层 是直接调用业务会话层 数据会话层调用数据层 调用的时候 是通过抽象工厂
    /// 模式是好的。但是 使用的时候还是有一些问题。。 其实是可以不用new的 就是自己不知道怎么来写
    /// </summary>
    public class DBSession:IDBSession
    {
        #region 解释
        /// 数据会话层：就是一个工厂类，负责完成所有数据操作类实例的创建，然后业务层通过数据会话层来获取要操作数据类的实例。所以数据会话层将业务层与数据层解耦。
        /// 在数据会话层中提供一个方法：完成所有数据的保存。
        //复杂数据操作类的创建  
        //工厂类 就是创建 类的实例   这个就是一个好听一点的名字 业务层通过这一层来掉数据会话层的实例 
        //将业务层 与 数据层解耦 
        // 提供了一个数据访问的统一访问点  
        //后期 就可以使用依赖注入来实现  
        //全部学习完了 才会有一个比较深刻的体会 
        //起了一个比较好听的名字 但是其实没有什么花头 但是看着简单的一行代码 其实 又很深的含义

        //每一层多了 写的稍微麻烦一些 。 其实也还好。。
        #endregion

        #region 作用说明
        //每一次都是new一下 是不同的对象  表现层调用数据层 必须是同一个对象 每次请求必须保证是同一个EF对象
        //项目架构的设计 数据库架构的设计 项目的内容比较的庞大的时候就需要设计了

        //这个数据会话层的方法感觉写的有一些乱的 创建对象的的方法 又要放到另外的层里面
        //摁一下 F12  就能够搞定了。
        //通过一个工厂类来创建 对象 主要是判断要保证线程内是唯一的。  住线程 子线程 一个程序运行的
        //如何来保证验证内容唯一  都是接口的实现 。使用反射的方式  创建的类放在什么那一层比较的合理 
        //每一层的作用 以及要引用的DLL 的文件。
        //设计数据操作 和业务的都是封装了一个方法
        //合理的设计 的好处 有一个架构 


        //book_shop3Entities Db2 = new book_shop3Entities(); 
        #endregion

        public DbContext Db
        {
            get
            {
                return DBContextFactory.CreateDbContext();
            }
        }


        /// <summary>
        ///  一个业务中经常涉及到对多张操作，我们希望链接一次数据库，完成对张表数据的操作。提高性能。 工作单元模式。
        ///  就是一个事务 可以连接一次数据库 sql语句提前都拼接好。
        ///  这个也要引入EF
        ///  
        /// 工作单元的设计模式  工厂模式  单例模式 
        /// </summary>
        /// <returns></returns>
        public bool SaveChange()
        {
            return Db.SaveChanges() > 0;
        }


        #region 用户权限模块
        private IUserInfoDal _UserInfoDal;

        /// <summary>
        /// 业务成要使用UserInfoDal的时候 直接通过这个属性 来获得
        /// </summary>
        public IUserInfoDal UserInfoDal
        {
            get
            {
                if (_UserInfoDal == null)
                {
                    //这个来创建 一个UserInfodal的对象实例 
                    //这个是一个工厂模式的  的一种设计模式
                    //_UserInfoDal = new UserInfoDal();
                    //通过反射的方式来创建类的实例  //很多工作都是有一些组建来完成的。
                    _UserInfoDal = AbstractFactory.CreateUserInfoDal();

                }
                return _UserInfoDal;
            }
            set { _UserInfoDal = value; }
        }

        /// <summary>
        /// 权限
        /// </summary>
        private IActionInfoDal _ActionInfoDal;
        public IActionInfoDal ActionInfoDal
        {
            get
            {
                if (_ActionInfoDal == null)
                {
                    _ActionInfoDal = AbstractFactory.CreateActionInfoDal();
                }

                return _ActionInfoDal;
            }
            set { _ActionInfoDal = value; }
        }

        /// <summary>
        /// 权限组
        /// </summary>
        private IActionGroupDal _actionGroupDal;

        public IActionGroupDal ActionGroupDal
        {
            get
            {
                if (_actionGroupDal == null)
                {
                    _actionGroupDal = AbstractFactory.CreateActionGroupDal();
                }

                return _actionGroupDal;
            }
            set { _actionGroupDal = value; }
        }

        /// <summary>
        /// 角色
        /// </summary>
        private IRoleDal _roleDal;

        public IRoleDal RoleDal
        {
            get
            {
                if (_roleDal == null)
                {
                    _roleDal = AbstractFactory.CreateRoleDal();
                }

                return _roleDal;
            }
            set { _roleDal = value; }
        }

        /// <summary>
        /// 站点设置
        /// </summary>
        private ISettingsDal _settingsDal;

        public ISettingsDal SettingsDal
        {
            get
            {
                if (_settingsDal == null)
                {
                    _settingsDal = AbstractFactory.CreateSettingsDal();
                }

                return _settingsDal;
            }
            set { _settingsDal = value; }
        }

        private IDepartmentDal _departmentDal;

        public IDepartmentDal DepartmentDal
        {
            get
            {
                if (_departmentDal == null)
                {
                    _departmentDal = AbstractFactory.CreateDepartmentDal();
                }

                return _departmentDal;
            }
            set { _departmentDal = value; }
        }

        #endregion


    }
}
