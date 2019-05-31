using System;
using System.Data;
using System.Collections.Generic;
using LTP.Common;
using BookShop.Model;
using BookShop.DAL;
using System.Web;
using System.IO;

namespace BookShop.BLL
{
	/// <summary>
	/// 业务逻辑类BooksManager 的摘要说明。
	/// </summary>
	public class BookManager
	{
        PublisherServices publisherServices = new PublisherServices();
        CategoryServices categoryServices = new CategoryServices();
		private readonly BookShop.DAL.BookServices dal=new BookShop.DAL.BookServices();
		public BookManager()
		{}
		#region  成员方法

		/// <summary>
		/// 得到最大ID
		/// </summary>
		public int GetMaxId()
		{
			return dal.GetMaxId();
		}

		/// <summary>
		/// 是否存在该记录
		/// </summary>
		public bool Exists(int Id)
		{
			return dal.Exists(Id);
		}

		/// <summary>
		/// 增加一条数据
		/// </summary>
		public int  Add(BookShop.Model.Book model)
		{
			return dal.Add(model);
		}

		/// <summary>
		/// 更新一条数据
		/// </summary>
		public void Update(BookShop.Model.Book model)
		{
			dal.Update(model);
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public void Delete(int Id)
		{
			
			dal.Delete(Id);
		}

		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public BookShop.Model.Book GetModel(int Id)
		{
			
			return dal.GetModel(Id);
		}

		/// <summary>
		/// 得到一个对象实体，从缓存中。
		/// </summary>
		public BookShop.Model.Book GetModelByCache(int Id)
		{
			
			string CacheKey = "BooksModel-" + Id;
			object objModel = LTP.Common.DataCache.GetCache(CacheKey);
			if (objModel == null)
			{
				try
				{
					objModel = dal.GetModel(Id);
					if (objModel != null)
					{
						int ModelCache = LTP.Common.ConfigHelper.GetConfigInt("ModelCache");
						LTP.Common.DataCache.SetCache(CacheKey, objModel, DateTime.Now.AddMinutes(ModelCache), TimeSpan.Zero);
					}
				}
				catch{}
			}
			return (BookShop.Model.Book)objModel;
		}

		/// <summary>
		/// 获得数据列表
		/// </summary>
		public DataSet GetList(string strWhere)
		{
			return dal.GetList(strWhere);
		}
		/// <summary>
		/// 获得前几行数据
		/// </summary>
		public DataSet GetList(int Top,string strWhere,string filedOrder)
		{
			return dal.GetList(Top,strWhere,filedOrder);
		}
		/// <summary>
		/// 获得数据列表
		/// </summary>
		public List<BookShop.Model.Book> GetModelList(string strWhere)
		{
			DataSet ds = dal.GetList(strWhere);
			return DataTableToList(ds.Tables[0]);
		}
		/// <summary>
		/// 获得数据列表
		/// </summary>
		public List<BookShop.Model.Book> DataTableToList(DataTable dt)
		{
			List<BookShop.Model.Book> modelList = new List<BookShop.Model.Book>();
			int rowsCount = dt.Rows.Count;
			if (rowsCount > 0)
			{
				BookShop.Model.Book model;
				for (int n = 0; n < rowsCount; n++)
				{
					model = new BookShop.Model.Book();
					if(dt.Rows[n]["Id"].ToString()!="")
					{
						model.Id=int.Parse(dt.Rows[n]["Id"].ToString());
					}
					model.Title=dt.Rows[n]["Title"].ToString();
					model.Author=dt.Rows[n]["Author"].ToString();
					if(dt.Rows[n]["PublisherId"].ToString()!="")
					{
						int PublisherId=int.Parse(dt.Rows[n]["PublisherId"].ToString());
                        model.Publisher = publisherServices.GetModel(PublisherId);
					}
					if(dt.Rows[n]["PublishDate"].ToString()!="")
					{
						model.PublishDate=DateTime.Parse(dt.Rows[n]["PublishDate"].ToString());
					}
					model.ISBN=dt.Rows[n]["ISBN"].ToString();
					if(dt.Rows[n]["WordsCount"].ToString()!="")
					{
						model.WordsCount=int.Parse(dt.Rows[n]["WordsCount"].ToString());
					}
					if(dt.Rows[n]["UnitPrice"].ToString()!="")
					{
						model.UnitPrice=decimal.Parse(dt.Rows[n]["UnitPrice"].ToString());
					}
					model.ContentDescription=dt.Rows[n]["ContentDescription"].ToString();
					model.AurhorDescription=dt.Rows[n]["AurhorDescription"].ToString();
					model.EditorComment=dt.Rows[n]["EditorComment"].ToString();
					model.TOC=dt.Rows[n]["TOC"].ToString();
					if(dt.Rows[n]["CategoryId"].ToString()!="")
					{
						 int CategoryId=int.Parse(dt.Rows[n]["CategoryId"].ToString());
                         model.Category = categoryServices.GetModel(CategoryId);
					}
					if(dt.Rows[n]["Clicks"].ToString()!="")
					{
						model.Clicks=int.Parse(dt.Rows[n]["Clicks"].ToString());
					}
					modelList.Add(model);
				}
			}
			return modelList;
		}

		/// <summary>
		/// 获得数据列表
		/// </summary>
		public DataSet GetAllList()
		{
			return GetList("");
		}

		/// <summary>
		/// 获得数据列表
        /// 
        /// dal分装组装sql语句 。
        /// sql语句需要的参数
        /// 
        /// 业务层 根据数据查询的结果
        /// 返回计算 需要的结果
        /// 不需要在这里参数过多的判断
        /// 
        /// 表现层 接受参数 判断是否为空
        /// 将参数传递给业务层
		/// </summary>
		//public DataSet GetList(int PageSize,int PageIndex,string strWhere)
		//{
			//return dal.GetList(PageSize,PageIndex,strWhere);
		//}

        public int GetPageCount(int pageSize)
        {
            double recordCount = (double)dal.GetRecordCount();
            int pageCount = Convert.ToInt32(Math.Ceiling(recordCount / pageSize));
            return pageCount;
        }

        /// <summary>
        /// 很多东西东西 都是前人那么多年开发经验的总结
        /// 学习如何使用。不是系统说有功能 都要你一步一步的开发
        /// 那也是不可能的。但是要理解
        /// </summary>
        /// <param name="pageIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public List<Book> GetPageList(int pageIndex,int pageSize)
        {   
            //这个一个分页计算的公式推导出来。记住这么使用就可以
            //
            int start = (pageIndex - 1) * pageSize + 1;
            int end = pageIndex * pageSize;

            DataSet ds = dal.GetPageList(start, end);

            // 循环遍历 转化一下这个对象 
            return DataTableToList(ds.Tables[0]);

        }


        /// <summary>
        /// 将商品的信息生成静态页面
        /// </summary>
        public void CreateHtmlPage(int id)
        {   

            //根据每一本书的 内容生成一个 静态页面。
            Model.Book model = dal.GetModel(id);
            //获取模板文件
            string template = HttpContext.Current.Request.MapPath("/Template/BookTemplate.html");
            string fileContent = File.ReadAllText(template);
            fileContent = fileContent.Replace("$title", model.Title)
                .Replace("$author", model.Author)
                .Replace("$unitprice", model.UnitPrice.ToString("0.00"))
                .Replace("$isbn", model.ISBN)
                .Replace("$content", model.ContentDescription.Substring(0,15))
                .Replace("$bookId", model.Id.ToString());
            string dir = "/HtmlPage/" + model.PublishDate.Year + "/" + model.PublishDate.Month + "/" + model.PublishDate.Day + "/";
            Directory.CreateDirectory(Path.GetDirectoryName(HttpContext.Current.Request.MapPath(dir)));
            string fullDir = dir + model.Id + ".html";
            File.WriteAllText(HttpContext.Current.Request.MapPath(fullDir), fileContent, System.Text.Encoding.UTF8);

        }


        #endregion  成员方法
    }
}

