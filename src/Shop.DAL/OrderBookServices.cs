using System;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using Maticsoft.DBUtility;//请先添加引用
namespace BookShop.DAL
{
	/// <summary>
	/// 数据访问类OrderBookServices。
	/// </summary>
	public class OrderBookServices
	{
        BookServices bookServices = new BookServices();

		public OrderBookServices()
		{}
		#region  成员方法

		/// <summary>
		/// 得到最大ID
		/// </summary>
		public int GetMaxId()
		{
		return DbHelperSQL.GetMaxID("Id", "OrderBook"); 
		}

		/// <summary>
		/// 是否存在该记录
		/// </summary>
		public bool Exists(int Id)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select count(1) from OrderBook");
			strSql.Append(" where Id=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.Int,4)};
			parameters[0].Value = Id;

			return DbHelperSQL.Exists(strSql.ToString(),parameters);
		}


		/// <summary>
		/// 增加一条数据
		/// </summary>
		public int Add(BookShop.Model.OrderBook model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("insert into OrderBook(");
			strSql.Append("OrderID,BookID,Quantity,UnitPrice)");
			strSql.Append(" values (");
			strSql.Append("@OrderID,@BookID,@Quantity,@UnitPrice)");
			strSql.Append(";select @@IDENTITY");
			SqlParameter[] parameters = {
					new SqlParameter("@OrderID", SqlDbType.Int,4),
					new SqlParameter("@BookID", SqlDbType.Int,4),
					new SqlParameter("@Quantity", SqlDbType.Int,4),
					new SqlParameter("@UnitPrice", SqlDbType.Decimal,9)};
			parameters[0].Value = model.OrderID;
			parameters[1].Value = model.Book.Id;
			parameters[2].Value = model.Quantity;
			parameters[3].Value = model.UnitPrice;

			object obj = DbHelperSQL.GetSingle(strSql.ToString(),parameters);
			if (obj == null)
			{
				return 1;
			}
			else
			{
				return Convert.ToInt32(obj);
			}
		}
		/// <summary>
		/// 更新一条数据
		/// </summary>
		public void Update(BookShop.Model.OrderBook model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("update OrderBook set ");
			strSql.Append("OrderID=@OrderID,");
			strSql.Append("BookID=@BookID,");
			strSql.Append("Quantity=@Quantity,");
			strSql.Append("UnitPrice=@UnitPrice");
			strSql.Append(" where Id=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.Int,4),
					new SqlParameter("@OrderID", SqlDbType.Int,4),
					new SqlParameter("@BookID", SqlDbType.Int,4),
					new SqlParameter("@Quantity", SqlDbType.Int,4),
					new SqlParameter("@UnitPrice", SqlDbType.Decimal,9)};
			parameters[0].Value = model.Id;
			parameters[1].Value = model.OrderID;
			parameters[2].Value = model.Book.Id;
			parameters[3].Value = model.Quantity;
			parameters[4].Value = model.UnitPrice;

			DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public void Delete(int Id)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("delete from OrderBook ");
			strSql.Append(" where Id=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.Int,4)};
			parameters[0].Value = Id;

			DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
		}


		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public BookShop.Model.OrderBook GetModel(int Id)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select  top 1 Id,OrderID,BookID,Quantity,UnitPrice from OrderBook ");
			strSql.Append(" where Id=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.Int,4)};
			parameters[0].Value = Id;

			BookShop.Model.OrderBook model=new BookShop.Model.OrderBook();
			DataSet ds=DbHelperSQL.Query(strSql.ToString(),parameters);
			if(ds.Tables[0].Rows.Count>0)
			{
				if(ds.Tables[0].Rows[0]["Id"].ToString()!="")
				{
					model.Id=int.Parse(ds.Tables[0].Rows[0]["Id"].ToString());
				}
				if(ds.Tables[0].Rows[0]["OrderID"].ToString()!="")
				{
					model.OrderID=ds.Tables[0].Rows[0]["OrderID"].ToString();
				}
				if(ds.Tables[0].Rows[0]["BookID"].ToString()!="")
				{
					 int BookID=int.Parse(ds.Tables[0].Rows[0]["BookID"].ToString());
                     model.Book = bookServices.GetModel(BookID);
				}
				if(ds.Tables[0].Rows[0]["Quantity"].ToString()!="")
				{
					model.Quantity=int.Parse(ds.Tables[0].Rows[0]["Quantity"].ToString());
				}
				if(ds.Tables[0].Rows[0]["UnitPrice"].ToString()!="")
				{
					model.UnitPrice=decimal.Parse(ds.Tables[0].Rows[0]["UnitPrice"].ToString());
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
			strSql.Append("select Id,OrderID,BookID,Quantity,UnitPrice ");
			strSql.Append(" FROM OrderBook ");
			if(strWhere!=null && strWhere.Trim()!="")
			{
				strSql.Append(" where "+strWhere);
			}
			return DbHelperSQL.Query(strSql.ToString());
		}

        /// <summary>
        /// 获得数据列表
        /// </summary>
        public DataSet GetListByOrderId(string orderId)
        {
            StringBuilder strSql = new StringBuilder();
            strSql.Append("select Id,OrderID,BookID,Quantity,UnitPrice ");
            strSql.Append(" FROM OrderBook ");
            strSql.Append(" WHERE orderid=@orderid ");


            SqlParameter[] parameters = {
					new SqlParameter("@orderid",orderId)};
            
    
            return DbHelperSQL.Query(strSql.ToString(),parameters);
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
			strSql.Append(" Id,OrderID,BookID,Quantity,UnitPrice ");
			strSql.Append(" FROM OrderBook ");
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
			parameters[0].Value = "OrderBook";
			parameters[1].Value = "ID";
			parameters[2].Value = PageSize;
			parameters[3].Value = PageIndex;
			parameters[4].Value = 0;
			parameters[5].Value = 0;
			parameters[6].Value = strWhere;	
			return DbHelperSQL.RunProcedure("UP_GetRecordByPage",parameters,"ds");
		}*/

		#endregion  成员方法
	}
}

