using System;
namespace BookShop.Model
{
	/// <summary>
	/// 实体类Users 。(属性说明自动提取数据库字段的描述信息)
	/// </summary>
	[Serializable]
	public class User
	{
		public User()
		{}
		#region Model
		private int _id;
		private string _loginid;
		private string _loginpwd;
		private string _name;
		private string _address;
		private string _phone;
		private string _mail;
        //private int _userroleid;
        //private int _userstateid;
        
        private UserState _userState = new UserState();


		/// <summary>
		/// 
		/// </summary>
		public int Id
		{
			set{ _id=value;}
			get{return _id;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string LoginId
		{
			set{ _loginid=value;}
			get{return _loginid;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string LoginPwd
		{
			set{ _loginpwd=value;}
			get{return _loginpwd;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string Name
		{
			set{ _name=value;}
			get{return _name;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string Address
		{
			set{ _address=value;}
			get{return _address;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string Phone
		{
			set{ _phone=value;}
			get{return _phone;}
		}
		/// <summary>
		/// 
		/// </summary>
		public string Mail
		{
			set{ _mail=value;}
			get{return _mail;}
		}
		/// <summary>
		/// 
		/// </summary>
        //public int UserRoleId
        //{
        //    set{ _userroleid=value;}
        //    get{return _userroleid;}
        //}
        ///// <summary>
        ///// 
        ///// </summary>
        //public int UserStateId
        //{
        //    set{ _userstateid=value;}
        //    get{return _userstateid;}
        //}
  
        // 一个用户 对应有多个想购买的商品 中的数据 
        //一个商品 也可以被加入多个购物车
        // 有的表自己也是一个关系表。。一个用户有多个想购买的商品
        // 一个商品也可以被多个用户加入购物车 
        // 用户和商品 是多对多的关系 在购物车中 。一条线中。。一个条线可以有 多个关系
        // 数据中的关系 是重要的一个概念
        public UserState UserState
        {
            get { return _userState; }
            set { _userState = value; }
        }
		#endregion Model

	}
}

