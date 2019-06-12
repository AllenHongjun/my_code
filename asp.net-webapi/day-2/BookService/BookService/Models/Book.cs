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
        /// </summary>
        // Navigation property
        public Author Author { get; set; }
    }
}