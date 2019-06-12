using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace BookService.Models
{   
    /// <summary>
    /// 作者
    /// </summary>
    public class Author
    {

        /// <summary>
        /// 作者ID
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// 作者的名字
        /// </summary>
        [Required]
        public string Name { get; set; }
    }
}