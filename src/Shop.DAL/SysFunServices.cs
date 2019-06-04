using System;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using Maticsoft.DBUtility;//Please add references
namespace BookShop.DAL
{
	/// <summary>
	/// 数据访问类:SysFunServices
	/// </summary>
	public partial class SysFunServices
	{
		public SysFunServices()
		{}
		#region  Method

		/// <summary>
		/// 得到最大ID
		/// </summary>
		public int GetMaxId()
		{
		return DbHelperSQL.GetMaxID("NodeId", "SysFun"); 
		}

		/// <summary>
		/// 是否存在该记录
		/// </summary>
		public bool Exists(int NodeId)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select count(1) from SysFun");
			strSql.Append(" where NodeId=@NodeId ");
			SqlParameter[] parameters = {
					new SqlParameter("@NodeId", SqlDbType.Int,4)};
			parameters[0].Value = NodeId;

			return DbHelperSQL.Exists(strSql.ToString(),parameters);
		}


		/// <summary>
		/// 增加一条数据
		/// </summary>
		public void Add(BookShop.Model.SysFun model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("insert into SysFun(");
			strSql.Append("NodeId,DisplayName,NodeURL,DisplayOrder,ParentNodeId)");
			strSql.Append(" values (");
			strSql.Append("@NodeId,@DisplayName,@NodeURL,@DisplayOrder,@ParentNodeId)");
			SqlParameter[] parameters = {
					new SqlParameter("@NodeId", SqlDbType.Int,4),
					new SqlParameter("@DisplayName", SqlDbType.NVarChar,50),
					new SqlParameter("@NodeURL", SqlDbType.NVarChar,50),
					new SqlParameter("@DisplayOrder", SqlDbType.Int,4),
					new SqlParameter("@ParentNodeId", SqlDbType.Int,4)};
			parameters[0].Value = model.NodeId;
			parameters[1].Value = model.DisplayName;
			parameters[2].Value = model.NodeURL;
			parameters[3].Value = model.DisplayOrder;
			parameters[4].Value = model.ParentNodeId;

			DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
		}
		/// <summary>
		/// 更新一条数据
		/// </summary>
		public bool Update(BookShop.Model.SysFun model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("update SysFun set ");
			strSql.Append("DisplayName=@DisplayName,");
			strSql.Append("NodeURL=@NodeURL,");
			strSql.Append("DisplayOrder=@DisplayOrder,");
			strSql.Append("ParentNodeId=@ParentNodeId");
			strSql.Append(" where NodeId=@NodeId ");
			SqlParameter[] parameters = {
					new SqlParameter("@DisplayName", SqlDbType.NVarChar,50),
					new SqlParameter("@NodeURL", SqlDbType.NVarChar,50),
					new SqlParameter("@DisplayOrder", SqlDbType.Int,4),
					new SqlParameter("@ParentNodeId", SqlDbType.Int,4),
					new SqlParameter("@NodeId", SqlDbType.Int,4)};
			parameters[0].Value = model.DisplayName;
			parameters[1].Value = model.NodeURL;
			parameters[2].Value = model.DisplayOrder;
			parameters[3].Value = model.ParentNodeId;
			parameters[4].Value = model.NodeId;

			int rows=DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
			if (rows > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public bool Delete(int NodeId)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("delete from SysFun ");
			strSql.Append(" where NodeId=@NodeId ");
			SqlParameter[] parameters = {
					new SqlParameter("@NodeId", SqlDbType.Int,4)};
			parameters[0].Value = NodeId;

			int rows=DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
			if (rows > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/// <summary>
		/// 删除一条数据
		/// </summary>
		public bool DeleteList(string NodeIdlist )
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("delete from SysFun ");
			strSql.Append(" where NodeId in ("+NodeIdlist + ")  ");
			int rows=DbHelperSQL.ExecuteSql(strSql.ToString());
			if (rows > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}


		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public BookShop.Model.SysFun GetModel(int NodeId)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select  top 1 NodeId,DisplayName,NodeURL,DisplayOrder,ParentNodeId from SysFun ");
			strSql.Append(" where NodeId=@NodeId ");
			SqlParameter[] parameters = {
					new SqlParameter("@NodeId", SqlDbType.Int,4)};
			parameters[0].Value = NodeId;

			BookShop.Model.SysFun model=new BookShop.Model.SysFun();
			DataSet ds=DbHelperSQL.Query(strSql.ToString(),parameters);
			if(ds.Tables[0].Rows.Count>0)
			{
				if(ds.Tables[0].Rows[0]["NodeId"].ToString()!="")
				{
					model.NodeId=int.Parse(ds.Tables[0].Rows[0]["NodeId"].ToString());
				}
				model.DisplayName=ds.Tables[0].Rows[0]["DisplayName"].ToString();
				model.NodeURL=ds.Tables[0].Rows[0]["NodeURL"].ToString();
				if(ds.Tables[0].Rows[0]["DisplayOrder"].ToString()!="")
				{
					model.DisplayOrder=int.Parse(ds.Tables[0].Rows[0]["DisplayOrder"].ToString());
				}
				if(ds.Tables[0].Rows[0]["ParentNodeId"].ToString()!="")
				{
					model.ParentNodeId=int.Parse(ds.Tables[0].Rows[0]["ParentNodeId"].ToString());
				}
				return model;
			}
			else
			{
				return null;
			}
		}

		/// <summary>
		/// 获得数据列表
		/// </summary>
		public DataSet GetList(string strWhere)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select NodeId,DisplayName,NodeURL,DisplayOrder,ParentNodeId ");
			strSql.Append(" FROM SysFun ");
			if(strWhere.Trim()!="")
			{
				strSql.Append(" where "+strWhere);
			}
			return DbHelperSQL.Query(strSql.ToString());
		}



		/// <summary>
		/// 获得前几行数据
		/// </summary>
		public DataSet GetList(int Top,string strWhere,string filedOrder)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select ");
			if(Top>0)
			{
				strSql.Append(" top "+Top.ToString());
			}
			strSql.Append(" NodeId,DisplayName,NodeURL,DisplayOrder,ParentNodeId ");
			strSql.Append(" FROM SysFun ");
			if(strWhere.Trim()!="")
			{
				strSql.Append(" where "+strWhere);
			}
			strSql.Append(" order by " + filedOrder);
			return DbHelperSQL.Query(strSql.ToString());
		}

		/*
		/// <summary>
		/// 分页获取数据列表
		/// </summary>
		public DataSet GetList(int PageSize,int PageIndex,string strWhere)
		{
			SqlParameter[] parameters = {
					new SqlParameter("@tblName", SqlDbType.VarChar, 255),
					new SqlParameter("@fldName", SqlDbType.VarChar, 255),
					new SqlParameter("@PageSize", SqlDbType.Int),
					new SqlParameter("@PageIndex", SqlDbType.Int),
					new SqlParameter("@IsReCount", SqlDbType.Bit),
					new SqlParameter("@OrderType", SqlDbType.Bit),
					new SqlParameter("@strWhere", SqlDbType.VarChar,1000),
					};
			parameters[0].Value = "SysFun";
			parameters[1].Value = "NodeId";
			parameters[2].Value = PageSize;
			parameters[3].Value = PageIndex;
			parameters[4].Value = 0;
			parameters[5].Value = 0;
			parameters[6].Value = strWhere;	
			return DbHelperSQL.RunProcedure("UP_GetRecordByPage",parameters,"ds");
		}*/

		#endregion  Method
	}
}

