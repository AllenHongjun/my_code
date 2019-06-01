using System;
namespace BookShop.Model
{
	/// <summary>
	/// 实体类Cart 。(属性说明自动提取数据库字段的描述信息)
	/// </summary>
	[Serializable]
	public class Cart
	{
		public Cart()
		{}
		#region Model
		private int _id;
        //private int _userid;
        //private int _bookid;
        private User _user = new User();

        private Book _book =  new Book();



		private int _count;

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

        
        public User User
        {
            get { return _user; }
            set { _user = value; }
        }
        // 一条购物车里面 可以放一种数据  
        public Book Book
        {
            get { return _book; }
            set { _book = value; }
        }
		/// <summary>
		/// 
		/// </summary>
		public int Count
		{
			set{ _count=value;}
			get{return _count;}
		}

		#endregion Model

	}
}

