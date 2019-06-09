using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC.Model;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

namespace MVC.IDAL
{   
    /// <summary>
    /// 数据会话层接口  业务层调用 这个就是DBSession这一个层创建的目的 引用了那一层 被那一层来调用
    /// 各个层之间的访问都是通过接口
    /// </summary>
    public interface IDBSession
    {

        /// <summary>
        /// 这个属性是只读的 EF  Context对象
        /// </summary>
        DbContext Db { get;  }

        /// <summary>
        /// 保存EFsql 的操作
        /// </summary>
        /// <returns></returns>
        bool SaveChange();

        /// <summary>
        /// 数据层的接口进一步封装 业务层调用的是这里
        /// </summary>
        IUserInfoDal UserInfoDal { get; set; }

        IUserInfoActionDal UserInfoActionDal { get; set; }

        /// <summary>
        /// 角色
        /// </summary>
        IRoleDal RoleDal { get; set; }

        /// <summary>
        /// 权限组
        /// </summary>
        IActionGroupDal ActionGroupDal { get; set; }

        /// <summary>
        /// 权限
        /// </summary>
        IActionInfoDal ActionInfoDal { get; set; }

        /// <summary>
        /// 部门
        /// </summary>
        IDepartmentDal DepartmentDal { get; set; }

        /// <summary>
        /// 热词统计
        /// </summary>
        IKeyWordRank KeyWordRank { get; set; }

        /// <summary>
        /// 站点设置
        /// </summary>
        ISettingsDal SettingsDal { get; set; }

        /// <summary>
        /// 书籍
        /// </summary>
        IBookDal BookDal { get; set; }

        /// <summary>
        /// 书籍评论
        /// </summary>
        IBookCommentDal BookCommentDal { get; set; }

        /// <summary>
        /// 商品分类
        /// </summary>
        ICategoryDal CategoryDal { get; set; }

        /// <summary>
        /// 购物车
        /// </summary>
        ICartDal CartDal { get; set; }

        /// <summary>
        /// 订单
        /// </summary>
        IOrderDal OrderDal { get; set; }

        /// <summary>
        /// 订单详情
        /// </summary>
        IOrderBooksDal OrderBooksDal { get; set; }

        /// <summary>
        /// 热词统计
        /// </summary>
        IUserDal UserDal { get; set; }

        /// <summary>
        /// 视频文件
        /// </summary>
        IVideoFileDal VideoFileDal { get; set; }

        /// <summary>
        /// 邮箱验证码
        /// </summary>
        ICheckEmailDal CheckEmailDal { get; set; }

        /// <summary>
        /// 出版社
        /// </summary>
        IPublishDal PublishDal { get; set; }

    }
}
