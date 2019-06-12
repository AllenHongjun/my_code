using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProductsApp.Models
{   

    /// <summary>
    /// 产品的模型类
    /// </summary>
    public class Product
    {   
        /// <summary>
        /// 产品名字
        /// </summary>
        public int Id { get; set; }
        /// <summary>
        /// 产品名字
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 产品分类
        /// </summary>
        public string Category { get; set; }

        /// <summary>
        /// 产品价格
        /// </summary>
        public decimal Price { get; set; }

    }
}