using System;
using System.Data;
using System.Collections.Generic;
using LTP.Common;
using BookShop.Model;
namespace BookShop.BLL
{
	/// <summary>
	/// SysFunManager
	/// </summary>
	public partial class SysFunManager
	{
		private readonly BookShop.DAL.SysFunServices dal=new BookShop.DAL.SysFunServices();
		public SysFunManager()
		{}
		#region  Method

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
		public bool Exists(int NodeId)
		{
			return dal.Exists(NodeId);
		}

		/// <summary>
		/// 增加一条数据
		/// </summary>
		public void Add(BookShop.Model.SysFun model)
		{
			dal.Add(model);
		}

		/// <summary>
		/// 更新一条数据
		/// </summary>
		public bool Update(BookShop.Model.SysFun model)
		{
			return dal.Update(model);
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public bool Delete(int NodeId)
		{
			
			return dal.Delete(NodeId);
		}
		/// <summary>
		/// 删除一条数据
		/// </summary>
		public bool DeleteList(string NodeIdlist )
		{
			return dal.DeleteList(NodeIdlist );
		}

		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public BookShop.Model.SysFun GetModel(int NodeId)
		{
			
			return dal.GetModel(NodeId);
		}

		/// <summary>
		/// 得到一个对象实体，从缓存中
		/// </summary>
		//public BookShop.Model.SysFun GetModelByCache(int NodeId)
		//{
			
		//	string CacheKey = "SysFunModel-" + NodeId;
		//	object objModel = Maticsoft.Common.DataCache.GetCache(CacheKey);
		//	if (objModel == null)
		//	{
		//		try
		//		{
		//			objModel = dal.GetModel(NodeId);
		//			if (objModel != null)
		//			{
		//				int ModelCache = Maticsoft.Common.ConfigHelper.GetConfigInt("ModelCache");
		//				Maticsoft.Common.DataCache.SetCache(CacheKey, objModel, DateTime.Now.AddMinutes(ModelCache), TimeSpan.Zero);
		//			}
		//		}
		//		catch{}
		//	}
		//	return (BookShop.Model.SysFun)objModel;
		//}


     

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
		public List<BookShop.Model.SysFun> GetModelList(string strWhere)
		{
			DataSet ds = dal.GetList(strWhere);
			return DataTableToList(ds.Tables[0]);
		}
		/// <summary>
		/// 获得数据列表
		/// </summary>
		public List<BookShop.Model.SysFun> DataTableToList(DataTable dt)
		{
			List<BookShop.Model.SysFun> modelList = new List<BookShop.Model.SysFun>();
			int rowsCount = dt.Rows.Count;
			if (rowsCount > 0)
			{
				BookShop.Model.SysFun model;
				for (int n = 0; n < rowsCount; n++)
				{
					model = new BookShop.Model.SysFun();
					if(dt.Rows[n]["NodeId"].ToString()!="")
					{
						model.NodeId=int.Parse(dt.Rows[n]["NodeId"].ToString());
					}
					model.DisplayName=dt.Rows[n]["DisplayName"].ToString();
					model.NodeURL=dt.Rows[n]["NodeURL"].ToString();
					if(dt.Rows[n]["DisplayOrder"].ToString()!="")
					{
						model.DisplayOrder=int.Parse(dt.Rows[n]["DisplayOrder"].ToString());
					}
					if(dt.Rows[n]["ParentNodeId"].ToString()!="")
					{
						model.ParentNodeId=int.Parse(dt.Rows[n]["ParentNodeId"].ToString());
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
		/// 分页获取数据列表
		/// </summary>
		//public DataSet GetList(int PageSize,int PageIndex,string strWhere)
		//{
			//return dal.GetList(PageSize,PageIndex,strWhere);
		//}

		#endregion  Method
	}
}

