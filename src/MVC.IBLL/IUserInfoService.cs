using MVC.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVC.IBLL
{   
    //业务层调用的是 数据层的接口(也就是数据会话层)   表现层调用的是 业务层的接口  Model层里面基本上都是会用到的。
    
    //开发效率是很关键的。。。。滴滴半天做不了什么事情 还是挺着急的。
    //各个层的应用关系 用到在应用一下吧 。。里面的逻辑 然后自己慢慢再理一理
    // 有些会做错的好事情还不如少做一点 不要做的。
    //这个继承了之后 这个接口 也就要实现这个类的接口 也就都要实现基本的增删改查的功能了。。
    //有些东西  你真的懂了吗 我看是未必吧。。  接口 抽象类 什么的这些东西 其实是挺抽象的
    // 一定要 实际的操作 写一写代码 才会有感觉  知道是一个什么东西
    //不是所有的功能 都是重新写一个方法。。而是封装方法。可以继续封装 来调用方法。
    /// <summary>
    /// 用户操作接口
    /// </summary>
    public interface IUserInfoService:IBaseService<UserInfo>
    {   
        /// <summary>
        /// 批量删除用户数据
        /// </summary>
        /// <param name="list">删除用户的ID集合</param>
        /// <returns></returns>
        bool DeleteEntities(List<int> list);
    }
}
