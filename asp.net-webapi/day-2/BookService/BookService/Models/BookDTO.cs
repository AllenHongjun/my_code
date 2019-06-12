using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BookService.Models
{   
    /// <summary>
    /// 这个就相当于是view-model 
    /// </summary>
    public class BookDTO
    {

        public int Id { get; set; }
        public string Title { get; set; }
        public string AuthorName { get; set; }
    }
}