using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace BookService.Models
{   
    /// <summary>
    /// 书籍
    /// </summary>
    public class Book
    {   
        /// <summary>
        /// 书籍ID
        /// </summary>
        public int Id { get; set; }
        /// <summary>
        /// 书的标题
        /// </summary>
        [Required]
        public string Title { get; set; }
        /// <summary>
        /// 出版时间
        /// </summary>
        public int Year { get; set; }

        /// <summary>
        /// 价格
        /// </summary>
        public decimal Price { get; set; }

        /// <summary>
        /// 流派
        /// </summary>
        public string Genre { get; set; }

        // Foreign Key
        public int AuthorId { get; set; }

        /// <summary>
        /// 导航熟悉 不是一定要加个标记的
        /// 
        /// 使用延迟加载，EF 会自动加载相关的实体时取消引用该实体的导航属性。 若要启用延迟加载，使导航属性虚拟方法
        /// 延迟加载会多次查询数据库  
        /// 
        /// 用 Dto，我在下一节中介绍。 或者，可以配置 JSON 和 XML 格式化程序用于处理关系图  data transfer object 
        /// 
        /// 官方的文档 是机器翻译的  有的时候 看的 真的是恶心 .. 那个语言逻辑 翻译的完全的是混乱的呀 
        /// 
        /// 那个知识点 如果 理解 还好..当作回顾一下啊..如果 是第一次 看 根本就不知道 用在什么地方 会出现问题.
        /// </summary>
        // Navigation property
        public virtual Author Author { get; set; }
    }
}