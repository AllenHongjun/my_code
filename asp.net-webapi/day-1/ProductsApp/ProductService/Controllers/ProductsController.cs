using Microsoft.AspNet.OData;
using ProductService.Models;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
//using System.Web.OData;


namespace ProductService.Controllers
{
    public class ProductsController : ODataController
    {
        ProductsContext db = new ProductsContext();

        /// <summary>
        /// 查询某一个条数据是否存在
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        private bool ProductExists(int key)
        {
            return db.Products.Any(p => p.Id == key);
        }

        /// <summary>
        /// 获取所有的产品  就尽量使用 英文的 锻炼一下自己
        /// 逼一下自己
        /// </summary>
        /// <returns></returns>
        [EnableQuery]
        public IQueryable<Product> Get()
        {
            return db.Products;
        }

        /// <summary>
        /// 查询某一个产品是否存在
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        [EnableQuery]
        public SingleResult<Product> Get([FromODataUri] int key)
        {
            IQueryable<Product> result = db.Products.Where(p => p.Id == key);
            return SingleResult.Create(result);
        }


        /// <summary>
        /// 添加一个产品
        /// </summary>
        /// <param name="product"></param>
        /// <returns></returns>
        public async Task<IHttpActionResult> Post(Product product)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            db.Products.Add(product);
            await db.SaveChangesAsync();
            return Created(product);
        }


        public async Task<IHttpActionResult> Patch([FromODataUri] int key, Delta<Product> product)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var entity = await db.Products.FindAsync(key);
            if (entity == null)
            {
                return NotFound();
            }
            product.Patch(entity);
            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Updated(entity);
        }
        public async Task<IHttpActionResult> Put([FromODataUri] int key, Product update)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if (key != update.Id)
            {
                return BadRequest();
            }
            db.Entry(update).State = EntityState.Modified;
            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductExists(key))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Updated(update);
        }

        /// <summary>
        /// 异步为什么还要等待他做完这件事情
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public async Task<IHttpActionResult> Delete([FromODataUri] int key)
        {
            var product = await db.Products.FindAsync(key);
            if (product == null)
            {
                return NotFound();
            }
            db.Products.Remove(product);
            await db.SaveChangesAsync();
            return StatusCode(HttpStatusCode.NoContent);
        }


        protected override void Dispose(bool disposing)
        {
            //每次释放资源的的时候 db连接释放
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}