using System;
using System.Data;
using System.Text;
using System.Data.SqlClient;
using Maticsoft.DBUtility;//请先添加引用
namespace BookShop.DAL
{
	/// <summary>
	/// 数据访问类OrdersServices。
	/// </summary>
	public class OrdersServices
	{
        UserServices userServices = new UserServices();
		public OrdersServices()
		{}
		#region  成员方法






		/// <summary>
		/// 增加一条数据
		/// </summary>
		public int Add(BookShop.Model.Orders model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("insert into Orders(");
			strSql.Append("OrderId,OrderDate,UserId,TotalPrice,State)");
			strSql.Append(" values (");
			strSql.Append("@OrderId,@OrderDate,@UserId,@TotalPrice,@State)");
			strSql.Append(";select @@IDENTITY");
			SqlParameter[] parameters = {
					new SqlParameter("@OrderDate", SqlDbType.DateTime),
					new SqlParameter("@UserId", SqlDbType.Int,4),
					new SqlParameter("@TotalPrice", SqlDbType.Decimal,9),
                  new SqlParameter("@State", SqlDbType.Int,4),
                  new SqlParameter("@OrderId",SqlDbType.NVarChar,50)   
                                        };
			parameters[0].Value = model.OrderDate;
			parameters[1].Value = model.User.Id;
			parameters[2].Value = model.TotalPrice;
            parameters[3].Value = model.State;
            parameters[4].Value = model.OrderId;

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
		public void Update(BookShop.Model.Orders model)
		{
			StringBuilder strSql=new StringBuilder();
			strSql.Append("update Orders set ");
			strSql.Append("OrderDate=@OrderDate,");
			strSql.Append("UserId=@UserId,");
			strSql.Append("TotalPrice=@TotalPrice,");
            strSql.Append("PostAddress=@PostAddress,");
            strSql.Append("State=@State");
			strSql.Append(" where OrderId=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.NVarChar,50),
					new SqlParameter("@OrderDate", SqlDbType.DateTime),
					new SqlParameter("@UserId", SqlDbType.Int,4),
					new SqlParameter("@TotalPrice", SqlDbType.Decimal,9),
                    new SqlParameter("@PostAddress",SqlDbType.NVarChar,255),
                                          new SqlParameter("@State", SqlDbType.Int,4)  
                                        };
			parameters[0].Value = model.OrderId;
			parameters[1].Value = model.OrderDate;
			parameters[2].Value = model.User.Id;
			parameters[3].Value = model.TotalPrice;
            parameters[4].Value = model.PostAddress;
            parameters[5].Value = model.State;
			DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public void Delete(string orderId)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("delete from Orders ");
			strSql.Append(" where OrderId=@OrderId ");
			SqlParameter[] parameters = {
					new SqlParameter("@OrderId", SqlDbType.NVarChar,50)};
            parameters[0].Value = orderId;

			DbHelperSQL.ExecuteSql(strSql.ToString(),parameters);
		}


		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public BookShop.Model.Orders GetModel(string  orderId)
		{
			
			StringBuilder strSql=new StringBuilder();
			strSql.Append("select  top 1 OrderId,OrderDate,UserId,TotalPrice,PostAddress,State from Orders ");
			strSql.Append(" where OrderId=@Id ");
			SqlParameter[] parameters = {
					new SqlParameter("@Id", SqlDbType.NVarChar,50)};
			parameters[0].Value = orderId;

			BookShop.Model.Orders model=new BookShop.Model.Orders();
			DataSet ds=DbHelperSQL.Query(strSql.ToString(),parameters);
			if(ds.Tables[0].Rows.Count>0)
			{
				if(ds.Tables[0].Rows[0]["OrderId"].ToString()!="")
				{
                    model.OrderId = ds.Tables[0].Rows[0]["OrderId"].ToString();
				}
				if(ds.Tables[0].Rows[0]["OrderDate"].ToString()!="")
				{
					model.OrderDate=DateTime.Parse(ds.Tables[0].Rows[0]["OrderDate"].ToString());
				}
				if(ds.Tables[0].Rows[0]["UserId"].ToString()!="")
				{
					int UserId=int.Parse(ds.Tables[0].Rows[0]["UserId"].ToString());
                    model.User = userServices.GetModel(UserId);

				}
				if(ds.Tables[0].Rows[0]["TotalPrice"].ToString()!="")
				{
					model.TotalPrice=decimal.Parse(ds.Tables[0].Rows[0]["TotalPrice"].ToString());
                }
                if (ds.Tables[0].Rows[0]["PostAddress"].ToString() != "")
                {
                    model.PostAddress = (ds.Tables[0].Rows[0]["PostAddress"].ToString());
                }
                
                if (ds.Tables[0].Rows[0]["State"].ToString() != "")
                {
                    model.State = int.Parse(ds.Tables[0].Rows[0]["State"].ToString());
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
			strSql.Append("select OrderId,OrderDate,UserId,TotalPrice,PostAddress,State  ");
			strSql.Append(" FROM Orders ");
			if(strWhere!=null && strWhere.Trim()!="")
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
            strSql.Append(" OrderId,OrderDate,UserId,TotalPrice,PostAddress,State  ");
			strSql.Append(" FROM Orders ");
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
			parameters[0].Value = "Orders";
			parameters[1].Value = "ID";
			parameters[2].Value = PageSize;
			parameters[3].Value = PageIndex;
			parameters[4].Value = 0;
			parameters[5].Value = 0;
			parameters[6].Value = strWhere;	
			return DbHelperSQL.RunProcedure("UP_GetRecordByPage",parameters,"ds");
		}*/

        public decimal CreateOrder(int userId, string number, string address)
        {
            SqlParameter[] parameters = {
					new SqlParameter("@UserId", SqlDbType.Int),
					new SqlParameter("@OrderNumber", SqlDbType.NVarChar, 50),
					new SqlParameter("@PostAddress", SqlDbType.NVarChar,255),
					new SqlParameter("@TotalPrice", SqlDbType.Money)
		
					};
            parameters[0].Value = userId;
            parameters[1].Value = number;
            parameters[2].Value = address;
            parameters[3].Direction = ParameterDirection.Output;

            DbHelperSQL.RunProcedure("Pro_CreateOrder", parameters);
            return Convert.ToDecimal(parameters[3].Value);
        }

		#endregion  成员方法
	}
}

