using ProductsApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ProductsApp.Controllers
{
    public class ProductsController : ApiController
    {

        /// <summary>
        /// 新建的是一点测试的数据  模拟从数据库中获取
        /// </summary>
        Product[] products = new Product[]
        {
            new Product { Id = 1, Name = "Tomato Soup", Category = "Groceries", Price = 1 },
            new Product { Id = 2, Name = "Yo-yo", Category = "Toys", Price = 3.75M },
            new Product { Id = 3, Name = "Hammer", Category = "Hardware", Price = 16.99M }
        };

        /// <summary>
        /// 获取所有的产品 几个一个
        /// </summary>
        /// <returns></returns>
        ///
        /// /api/products
        public IEnumerable<Product> GetAllProducts()
        {
            return products;
        }

        /// <summary>
        /// 获取一个产品
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        ///
        ///没有了中间 的服务层 不是这些东西 不对 不好。。只不多 是有些东西 没有讲到 。。
        /// 项目中用到 没有讲 。。还需要学习其他的东西而已
        /// 
        /// /api/products/id
        public IHttpActionResult GetProduct(int id)
        {   

            // 从 产品的集合当中查找 产品p.id == id 的第一条数据 或者 返回null 这个方法就是返回满足条件的第一条数据
            //自带过滤的功能  都是可以不用 where 看起来好像一个简单的东西。。其实 你不理解。。


            var product = products.FirstOrDefault((p) => p.Id == id);
            if (product == null)
            {
                return NotFound();
            }
            return Ok(product);
        }
    }
}
