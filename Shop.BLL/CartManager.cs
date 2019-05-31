using System;
using System.Data;
using System.Collections.Generic;
using LTP.Common;
using BookShop.Model;
using BookShop.DAL;
namespace BookShop.BLL
{
	/// <summary>
	/// 业务逻辑类CartManager 的摘要说明。
	/// </summary>
	public class CartManager
	{
        
		private readonly BookShop.DAL.CartServices dal=new BookShop.DAL.CartServices();
        UserServices userServices = new UserServices();
        BookServices bookServices = new BookServices();

		public CartManager()
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
		public int  Add(BookShop.Model.Cart model)
		{
			return dal.Add(model);
		}

		/// <summary>
		/// 更新一条数据
		/// </summary>
		public void Update(BookShop.Model.Cart model)
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
		public BookShop.Model.Cart GetModel(int Id)
		{
			
			return dal.GetModel(Id);
		}

		/// <summary>
		/// 得到一个对象实体，从缓存中。
		/// </summary>
		public BookShop.Model.Cart GetModelByCache(int Id)
		{
			
			string CacheKey = "CartModel-" + Id;
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
			return (BookShop.Model.Cart)objModel;
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
		public List<BookShop.Model.Cart> GetModelList(string strWhere)
		{
			DataSet ds = dal.GetList(strWhere);
			return DataTableToList(ds.Tables[0]);
		}
		/// <summary>
		/// 获得数据列表
		/// </summary>
		public List<BookShop.Model.Cart> DataTableToList(DataTable dt)
		{
			List<BookShop.Model.Cart> modelList = new List<BookShop.Model.Cart>();
			int rowsCount = dt.Rows.Count;
			if (rowsCount > 0)
			{
				BookShop.Model.Cart model;
				for (int n = 0; n < rowsCount; n++)
				{
					model = new BookShop.Model.Cart();
					if(dt.Rows[n]["Id"].ToString()!="")
					{
						model.Id=int.Parse(dt.Rows[n]["Id"].ToString());
					}
					if(dt.Rows[n]["UserId"].ToString()!="")
					{
						 int UserId=int.Parse(dt.Rows[n]["UserId"].ToString());
                         model.User = userServices.GetModel(UserId);
					}
					if(dt.Rows[n]["BookId"].ToString()!="")
					{
						int BookId=int.Parse(dt.Rows[n]["BookId"].ToString());
                        model.Book = bookServices.GetModel(BookId);
					}
					if(dt.Rows[n]["Count"].ToString()!="")
					{
						model.Count=int.Parse(dt.Rows[n]["Count"].ToString());
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
		/// </summary>
		//public DataSet GetList(int PageSize,int PageIndex,string strWhere)
		//{
			//return dal.GetList(PageSize,PageIndex,strWhere);
		//}

		#endregion  成员方法
	}
}

