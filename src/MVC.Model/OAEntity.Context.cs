﻿//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace MVC.Model
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class book_shop3Entities : DbContext
    {
        public book_shop3Entities()
            : base("name=book_shop3Entities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<ActionGroup> ActionGroup { get; set; }
        public virtual DbSet<ActionInfo> ActionInfo { get; set; }
        public virtual DbSet<Articel_Words> Articel_Words { get; set; }
        public virtual DbSet<BookComment> BookComment { get; set; }
        public virtual DbSet<Books> Books { get; set; }
        public virtual DbSet<Cart> Cart { get; set; }
        public virtual DbSet<Categories> Categories { get; set; }
        public virtual DbSet<CheckEmail> CheckEmail { get; set; }
        public virtual DbSet<Department> Department { get; set; }
        public virtual DbSet<keyWordsRank> keyWordsRank { get; set; }
        public virtual DbSet<OrderBook> OrderBook { get; set; }
        public virtual DbSet<Orders> Orders { get; set; }
        public virtual DbSet<Publishers> Publishers { get; set; }
        public virtual DbSet<R_UserInfo_ActionInfo> R_UserInfo_ActionInfo { get; set; }
        public virtual DbSet<Role> Role { get; set; }
        public virtual DbSet<SearchDetails> SearchDetails { get; set; }
        public virtual DbSet<Settings> Settings { get; set; }
        public virtual DbSet<sysdiagrams> sysdiagrams { get; set; }
        public virtual DbSet<SysFun> SysFun { get; set; }
        public virtual DbSet<UserInfo> UserInfo { get; set; }
        public virtual DbSet<Users> Users { get; set; }
        public virtual DbSet<UserStates> UserStates { get; set; }
        public virtual DbSet<VidoFile> VidoFile { get; set; }
    }
}