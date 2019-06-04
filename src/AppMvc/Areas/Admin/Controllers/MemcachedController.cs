using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppMvc.Areas.Admin.Controllers
{
    public class MemcachedController : Controller
    {
        // GET: Admin/Memcached
        public ActionResult Index()
        {
            return View();
        }

        #region 介绍
        /*
         使用多。入门简单。
         redis类似  
         分布式
         读写性能非常到。
         速度非常快
         IO性能非常快


         没有提供容灾功能
         缓存什么时候使用。

         提供主从复制  写输入写到主复数句库 然后查数据都是在 从服务器查询
         主要是查询
         构建集群比较的简单。。
         客户端配置  随机的选择一台机器 将内容 存到一太机器上。。指定IP地址 和端口号。


         nigix web服务器的使用。
         请求分发。。很多新的好的软件的配合使用。

         什么是memecached  为什么要只用。
         缓存优化 。。提高读写性能。。为什么要使用。？？扯淡吹牛逼。。

         底层通过socket通行 
         hash值 内存中数据是如何管理 
         key-value 哪些数据是要存放到内存当中。。 一次缓存的数据不能太大 <1mb 
         对内存随机分区 。。如果数据量比较的小。。


         .net 自带的缓存了解 检查缓存中内容过期的机制。  缓存依赖。。
         其实也都是有了解过的。。
         会产生内存碎片。。安装软件。了解是一个什么东西。
         哪些东西是和存放在缓存当中。如果只是使用其实是很简单的。没有什么好害怕的。
         当去去数据的时候 如果发现这个数据 已经过期了。。就会把这个数据删除掉。

         OA所有的内容 都是在一个文件夹里面 整理 整理 
         可以导入一些新的东西。。
         图片服务器。专门处理图片的服务器。5台图片服务器。。


         通过简单的几个命令 来查看 和管理 
         也可以通过一个客户端管理工具。
         作为一个windows服务来安装 。。

         操作系统对文件操作都是有权限限制的。。如果不是管理员的身份就会没有权限进行操作。


         下载Memcache：http://code.jellycan.com/Memcache/
            将服务程序拷贝到一个磁盘上的目录
            安装服务：cmd→Memcached.exe -d install 打开服务监控窗口可以查看服务是否启动。
            启动服务：cmd→Memcached.exe -d start（restart重启，stop关闭服务）
            检查服务是否启动：连接到Memcache控制台：telnet ServerIP 11211  输入命令：stats检查当前服务状态。
            卸载服务：Memcached.exe -d uninstall(先关闭服务)
            遇到问题：win8下安装服务。无法启动此程序，因为计算机中丢失 MSVCR71.dll。
            尝试重新安装该程序以解决此问题。下载dll地址：http://www.dll-files.com/dllindex/dll-files.shtml?msvcr71

         

         telnet  小功能 测试一下ip 或者端口号是否连通 是否能够使用。。

         telnet 127.0.0.1 11211 memcached 远程连接
         stats 服务器状态的信息 
         打一个命令 可以直接使用 
         可以通过一状态来查询 服务器运行的情况 

         知识安装运行 启用 其实非常的简单。。

         nuget 安装 组件 新建一个demo测试一下如何使用
         然后在项目中使用 引用过来使用。。
         
         */

        #endregion
    }
}