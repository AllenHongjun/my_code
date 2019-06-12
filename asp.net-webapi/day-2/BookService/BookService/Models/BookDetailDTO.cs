using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BookService.Models
{   
    /// <summary>
    /// 详细的书籍信息
    /// </summary>
    public class BookDetailDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int Year { get; set; }
        public decimal Price { get; set; }
        public string AuthorName { get; set; }
        public string Genre { get; set; }
    }
}