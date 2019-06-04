using Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace WebApp.Pages.Cache
{
    public partial class CacheDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //asp.net自带的缓存机制的使用
            //可以使用memcache 了解一下 机制
            //判断缓存中是否有数据 
            //也是会帮你把每一用户创建一个单独的缓存数据
            //有些数据是共用的
            //根据一个key value 来直接过去数据就可以
            //哪些数据存放到缓存当中
            //放在cache是可以大家共享的 session中的数据 是大家共享的 一定完整的做完。 sessionID 美一个用户
            //有的资料没有 有的视频 也是很奇怪 会打不开 。。也是很蛋疼


            //判断缓存中是否有数据
            if (Cache["userInfoList"] == null)
            {
                UserInfoService UserInfoService = new UserInfoService();
                List<UserInfo> list = UserInfoService.GetList().Where(x=>x.Id<200).ToList();

                //将数据存储到缓存中
                Cache["userInfoList"] = list;
               // Cache.Remove("userInfoList");

                //写代码 永远都比看别人的代码简单
                //结构紊乱 自己都搞不清楚 为什么那么写
                //Cache.Insert("userInfoList2", list, null, DateTime.Now.AddHours(3), TimeSpan.Zero, CacheItemPriority.Normal, RemoveCache);
                Response.Write("数据来自数据库");

            }
            else
            {
                List<UserInfo> list = (List<UserInfo>)Cache["userInfoList"];

                //将对象 序列化 然后输出 序列化 和发序列化
                Response.Write(list.ToString());
                Response.Write("数据来自缓存");
            }

        }


        protected void RemoveCache(string key,object value, CacheItemRemovedReason reason)
        {
            if (reason == CacheItemRemovedReason.Expired)
            {
                //记录日志 缓存已经过期了
            }
        }
    }
}