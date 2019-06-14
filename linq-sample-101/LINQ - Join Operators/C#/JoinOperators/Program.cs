﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Xml.Linq;

namespace JoinOperators
{
    class Program
    {
        static void Main(string[] args)
        {
            LinqSamples samples = new LinqSamples();

            //Comment or uncomment the method calls below to run or not

            // samples.Linq102(); // This sample shows how to perform a simple inner equijoin of two sequences to produce 
            // a flat  result set  that consists  of each  element in suppliers that has a matching 
            // element in customers

            //samples.Linq103(); // A group join produces a hierarchical sequence.  The following query is an inner join 
            // that produces a sequence of objects, each of which has a key and an inner sequence of 
            // all matching elements

            samples.Linq104(); // The group join operator is more general than join, as this slightly more verbose 
                               // version of the cross join sample shows

            //samples.Linq105(); // For each customer in the table of customers, this query returns all the suppliers from 
            // that same country,  or else a string  indicating  that no suppliers  from that country 
            // were found

            //samples.Linq106(); // For each customer in the table of customers, this query returns all the suppliers from 
            // that same country,  or else a string  indicating  that no suppliers  from that country 
            // were found

            //samples.Linq107(); // For each supplier in the table of suppliers, this query returns all the customers from 
            // the same city and country,  or else a string  indicating  that no customers  from that 
            // city/country were found.  Note the use of anonymous  types to encapsulate the multiple 
            // key values
        }

        public class Product
        {
            public int ProductID { get; set; }
            public string ProductName { get; set; }
            public string Category { get; set; }
            public decimal UnitPrice { get; set; }
            public int UnitsInStock { get; set; }
        }

        public class Order
        {
            public int OrderID { get; set; }
            public DateTime OrderDate { get; set; }
            public decimal Total { get; set; }
        }

        public class Supplier
        {   
            /// <summary>
            /// 供应商的名字 
            /// </summary>
            public string SupplierName { get; set; }
            /// <summary>
            /// 供应商的地址
            /// </summary>
            public string Address { get; set; }
            /// <summary>
            /// 供应商的城市
            /// </summary>
            public string City { get; set; }
            /// <summary>
            /// 供应商的国家
            /// </summary>
            public string Country { get; set; }
        }

        public class Customer
        {
            public string CustomerID { get; set; }
            public string CompanyName { get; set; }
            public string Address { get; set; }
            public string City { get; set; }
            public string Region { get; set; }
            public string PostalCode { get; set; }
            public string Country { get; set; }
            public string Phone { get; set; }
            public string Fax { get; set; }
            public Order[] Orders { get; set; }
        }

        class LinqSamples
        {
            private List<Product> productList;
            private List<Customer> customerList;
            private List<Supplier> supplierList;

            [Category("Join Operators")]
            [Description("This sample shows how to perform a simple inner equijoin of two sequences to " +
                "produce a flat result set that consists of each element in suppliers that has a matching element " +
                "in customers.")]
            public void Linq102()
            {

                List<Customer> customers = GetCustomerList();
                List<Supplier> suppliers = GetSupplierList();

                var custSupJoin =
                    from sup in suppliers
                    join cust in customers on sup.Country equals cust.Country
                    select new { Country = sup.Country, SupplierName = sup.SupplierName, CustomerName = cust.CompanyName };

                foreach (var item in custSupJoin)
                {
                    Console.WriteLine("Country = {0}, Supplier = {1}, Customer = {2}", item.Country, item.SupplierName, item.CustomerName);
                }
            }

            //组联接等效于左外部联接，它返回第一个（左侧）数据源的每个元素（即使其他数据源中没有关联元素）。
            [Category("Join Operators")]
            [Description("A group join produces a hierarchical sequence. The following query is an inner join " +
                        " that produces a sequence of objects, each of which has a key and an inner sequence of all matching elements.")]
            public void Linq103()
            {


                List<Customer> customers = GetCustomerList();
                List<Supplier> suppliers = GetSupplierList();

                var custSupQuery =
                    from sup in suppliers
                    join cust in customers on sup.Country equals cust.Country into cs
                    select new { Key = sup.Country, Items = cs };


                foreach (var item in custSupQuery)
                {
                    Console.WriteLine(item.Key + ":");
                    foreach (var element in item.Items)
                    {
                        Console.WriteLine("   " + element.CompanyName);
                    }
                }
            }

            [Category("Join Operators")]
            [Description("The group join operator is more general than join, as this slightly more verbose " +
                "version of the cross join sample shows.")]
            public void Linq104()
            {   
                //分类集合的数据都是从数据库当中获取  产品集合的数据也是数据库中获取
                string[] categories = new string[]{ 
                "Beverages", 
                "Condiments", 
                "Vegetables", 
                "Dairy Products", 
                "Seafood" };

                List<Product> products = GetProductList();


                // linq 这种写法 帮你组合成sql语句 join  又分为 查询表达式 和 为 null 的情况。。 into ps 就是 帮你 把 所有组合的情况 
                //有导航属性的写法 没有导航属性的写法  是什么样子的。。 1对多 的关联 如果我要左链接 应该如何 写 如果有导航属性 这个又应该怎么来写？？、
                // 这个from  后面又接上一个 from这个如何来理解》》》  具体是想要一个什么样子的需求 要理解清楚 理解透彻 


                var prodByCategory =
                    from cat in categories
                    join prod in products on cat equals prod.Category into ps

                    // 这里链接的时候 ps是一个集合 在from p in ps 重新查询一下 问题就解决了。。 注意 这个ps 是一个产品集合 当 某一个分类相等的 集合数据
                    from p in ps
                    select new
                    {
                        Category = cat,
                        p.ProductName,
                        catLength = cat.Length,
                        Count = ps.Count(),
                        p.UnitPrice,
                        pCategory = p.Category,
                        p.ProductID,
                        p.UnitsInStock
                    };

                //这边就 使用viewmodel 的类型 然后 可以从这个集合中 在分页获取一下数据 然后 toList 再去查询一下数据库 
                foreach (var item in prodByCategory)
                {
                    Console.WriteLine(item.ProductName + ": " + item.Category +":"+item.catLength+":"+item.Count);
                }
            }
            [Category("Join Operators")]
            [Description("A left outer join produces a result set that includes all the left hand side elements at " +
                "least once, even if they don't match any right hand side elements.")]
            public void Linq105()
            {
                List<Customer> customers = GetCustomerList();
                List<Supplier> suppliers = GetSupplierList();

                var supplierCusts =
                    from sup in suppliers
                    join cust in customers on sup.Country equals cust.Country into cs
                    from c in cs.DefaultIfEmpty()  // DefaultIfEmpty preserves left-hand elements that have no matches on the right side 
                    orderby sup.SupplierName
                    select new
                    {
                        Country = sup.Country,
                        CompanyName = c == null ? "(No customers)" : c.CompanyName,
                        SupplierName = sup.SupplierName
                    };

                foreach (var item in supplierCusts)
                {
                    Console.WriteLine("{0} ({1}): {2}", item.SupplierName, item.Country, item.CompanyName);
                }
            }

            // 遍历每一个客户 返回同一个国家 的所有供应商  和客户同一个国家的所有供应商 或者 返回 这个国家 没有找到供应商。。 JOIN GroupJoin的例子没有呀。。。
            // 我日的。。  LINQ 投 entity  要安装 sqlserver 2017 安装 adventurework 然后才能调试。。 他要的就是 每一个渠道 每一个 站点 的左外链接 全部的 
            // 使用sql 也会 只出来一条呀。。没有数据了 那还不是只有一条。。。1对1的连接 可以select 1对多的链接 如何投影 。。

                //还没哟组合查询。。
            [Category("Join Operators")]
            [Description("For each customer in the table of customers, this query returns all the suppliers " +
                         "from that same country, or else a string indicating that no suppliers from that country were found.")]
            public void Linq106()
            {

                List<Customer> customers = GetCustomerList();
                List<Supplier> suppliers = GetSupplierList();

                var custSuppliers =
                    from cust in customers
                    join sup in suppliers on cust.Country equals sup.Country into ss
                    from s in ss.DefaultIfEmpty()
                    orderby cust.CompanyName
                    select new
                    {
                        Country = cust.Country,
                        CompanyName = cust.CompanyName,
                        SupplierName = s == null ? "(No suppliers)" : s.SupplierName
                    };

                foreach (var item in custSuppliers)
                {
                    Console.WriteLine("{0} ({1}): {2}", item.CompanyName, item.Country, item.SupplierName);
                }
            }

            //请注意使用匿名类型来封装多个键值。
            [Category("Join Operators")]
            [Description("For each supplier in the table of suppliers, this query returns all the customers " +
                         "from the same city and country, or else a string indicating that no customers from that city/country were found. " +
                         "Note the use of anonymous types to encapsulate the multiple key values.")]
            public void Linq107()
            {
                List<Customer> customers = GetCustomerList();
                List<Supplier> suppliers = GetSupplierList();

                // 可使用 into 上下文关键字创建临时标识符，将 group、join 或 select 子句的结果存储至新标识符。 此标识符本身可以是附加查询命令的生成器。 有时称在 group 或 select 子句中使用新标识符为“延续”。 它这里de  join 智慧把 join 字句后面的对象存放懂啊临时的变量当中来使用

                // 左外全部连接的效果 还是没有达到  左外连接 就是 一对一 才可以 1对多 左外连接 没法连接吗？？ 如果右边数据 为空肯定也只返回一条呀。

                // 就这个 DeFaultIfEmpty()  然后就是要过滤一下条件  但是 返回 一个集合 你就要配合selectManay 
                var supplierCusts =
                    from sup in suppliers
                    join cust in customers on new { sup.City, sup.Country } equals new { cust.City, cust.Country } into cs
                    from c in cs.DefaultIfEmpty() //Remove DefaultIfEmpty method call to make this an inner join
                    orderby sup.SupplierName
                    select new
                    {
                        Country = sup.Country,
                        City = sup.City,
                        SupplierName = sup.SupplierName,
                        CompanyName = c == null ? "(No customers)" : c.CompanyName
                    };

                foreach (var item in supplierCusts)
                {
                    Console.WriteLine("{0} ({1}, {2}):{3}", item.SupplierName, item.City, item.Country, item.CompanyName);
                }
            }

            public List<Customer> GetCustomerList()
            {
                if (customerList == null)
                    createLists();

                return customerList;
            }

            public List<Supplier> GetSupplierList()
            {
                if (supplierList == null)
                    createLists();

                return supplierList;
            }

            public List<Product> GetProductList()
            {
                if (productList == null)
                    createLists();

                return productList;
            }

            private void createLists()
            {
                // Product data created in-memory using collection initializer:
                productList =
                    new List<Product> {
                    new Product { ProductID = 1, ProductName = "Chai", Category = "Beverages", UnitPrice = 18.0000M, UnitsInStock = 39 },
                    new Product { ProductID = 2, ProductName = "Chang", Category = "Beverages", UnitPrice = 19.0000M, UnitsInStock = 17 },
                    new Product { ProductID = 3, ProductName = "Aniseed Syrup", Category = "Condiments", UnitPrice = 10.0000M, UnitsInStock = 13 },
                    new Product { ProductID = 4, ProductName = "Chef Anton's Cajun Seasoning", Category = "Condiments", UnitPrice = 22.0000M, UnitsInStock = 53 },
                    new Product { ProductID = 5, ProductName = "Chef Anton's Gumbo Mix", Category = "Condiments", UnitPrice = 21.3500M, UnitsInStock = 0 },
                    new Product { ProductID = 6, ProductName = "Grandma's Boysenberry Spread", Category = "Condiments", UnitPrice = 25.0000M, UnitsInStock = 120 },
                    new Product { ProductID = 7, ProductName = "Uncle Bob's Organic Dried Pears", Category = "Produce", UnitPrice = 30.0000M, UnitsInStock = 15 },
                    new Product { ProductID = 8, ProductName = "Northwoods Cranberry Sauce", Category = "Condiments", UnitPrice = 40.0000M, UnitsInStock = 6 },
                    new Product { ProductID = 9, ProductName = "Mishi Kobe Niku", Category = "Meat/Poultry", UnitPrice = 97.0000M, UnitsInStock = 29 },
                    new Product { ProductID = 10, ProductName = "Ikura", Category = "Seafood", UnitPrice = 31.0000M, UnitsInStock = 31 },
                    new Product { ProductID = 11, ProductName = "Queso Cabrales", Category = "Dairy Products", UnitPrice = 21.0000M, UnitsInStock = 22 },
                    new Product { ProductID = 12, ProductName = "Queso Manchego La Pastora", Category = "Dairy Products", UnitPrice = 38.0000M, UnitsInStock = 86 },
                    new Product { ProductID = 13, ProductName = "Konbu", Category = "Seafood", UnitPrice = 6.0000M, UnitsInStock = 24 },
                    new Product { ProductID = 14, ProductName = "Tofu", Category = "Produce", UnitPrice = 23.2500M, UnitsInStock = 35 },
                    new Product { ProductID = 15, ProductName = "Genen Shouyu", Category = "Condiments", UnitPrice = 15.5000M, UnitsInStock = 39 },
                    new Product { ProductID = 16, ProductName = "Pavlova", Category = "Confections", UnitPrice = 17.4500M, UnitsInStock = 29 },
                    new Product { ProductID = 17, ProductName = "Alice Mutton", Category = "Meat/Poultry", UnitPrice = 39.0000M, UnitsInStock = 0 },
                    new Product { ProductID = 18, ProductName = "Carnarvon Tigers", Category = "Seafood", UnitPrice = 62.5000M, UnitsInStock = 42 },
                    new Product { ProductID = 19, ProductName = "Teatime Chocolate Biscuits", Category = "Confections", UnitPrice = 9.2000M, UnitsInStock = 25 },
                    new Product { ProductID = 20, ProductName = "Sir Rodney's Marmalade", Category = "Confections", UnitPrice = 81.0000M, UnitsInStock = 40 },
                    new Product { ProductID = 21, ProductName = "Sir Rodney's Scones", Category = "Confections", UnitPrice = 10.0000M, UnitsInStock = 3 },
                    new Product { ProductID = 22, ProductName = "Gustaf's Knäckebröd", Category = "Grains/Cereals", UnitPrice = 21.0000M, UnitsInStock = 104 },
                    new Product { ProductID = 23, ProductName = "Tunnbröd", Category = "Grains/Cereals", UnitPrice = 9.0000M, UnitsInStock = 61 },
                    new Product { ProductID = 24, ProductName = "Guaraná Fantástica", Category = "Beverages", UnitPrice = 4.5000M, UnitsInStock = 20 },
                    new Product { ProductID = 25, ProductName = "NuNuCa Nuß-Nougat-Creme", Category = "Confections", UnitPrice = 14.0000M, UnitsInStock = 76 },
                    new Product { ProductID = 26, ProductName = "Gumbär Gummibärchen", Category = "Confections", UnitPrice = 31.2300M, UnitsInStock = 15 },
                    new Product { ProductID = 27, ProductName = "Schoggi Schokolade", Category = "Confections", UnitPrice = 43.9000M, UnitsInStock = 49 },
                    new Product { ProductID = 28, ProductName = "Rössle Sauerkraut", Category = "Produce", UnitPrice = 45.6000M, UnitsInStock = 26 },
                    new Product { ProductID = 29, ProductName = "Thüringer Rostbratwurst", Category = "Meat/Poultry", UnitPrice = 123.7900M, UnitsInStock = 0 },
                    new Product { ProductID = 30, ProductName = "Nord-Ost Matjeshering", Category = "Seafood", UnitPrice = 25.8900M, UnitsInStock = 10 },
                    new Product { ProductID = 31, ProductName = "Gorgonzola Telino", Category = "Dairy Products", UnitPrice = 12.5000M, UnitsInStock = 0 },
                    new Product { ProductID = 32, ProductName = "Mascarpone Fabioli", Category = "Dairy Products", UnitPrice = 32.0000M, UnitsInStock = 9 },
                    new Product { ProductID = 33, ProductName = "Geitost", Category = "Dairy Products", UnitPrice = 2.5000M, UnitsInStock = 112 },
                    new Product { ProductID = 34, ProductName = "Sasquatch Ale", Category = "Beverages", UnitPrice = 14.0000M, UnitsInStock = 111 },
                    new Product { ProductID = 35, ProductName = "Steeleye Stout", Category = "Beverages", UnitPrice = 18.0000M, UnitsInStock = 20 },
                    new Product { ProductID = 36, ProductName = "Inlagd Sill", Category = "Seafood", UnitPrice = 19.0000M, UnitsInStock = 112 },
                    new Product { ProductID = 37, ProductName = "Gravad lax", Category = "Seafood", UnitPrice = 26.0000M, UnitsInStock = 11 },
                    new Product { ProductID = 38, ProductName = "Côte de Blaye", Category = "Beverages", UnitPrice = 263.5000M, UnitsInStock = 17 },
                    new Product { ProductID = 39, ProductName = "Chartreuse verte", Category = "Beverages", UnitPrice = 18.0000M, UnitsInStock = 69 },
                    new Product { ProductID = 40, ProductName = "Boston Crab Meat", Category = "Seafood", UnitPrice = 18.4000M, UnitsInStock = 123 },
                    new Product { ProductID = 41, ProductName = "Jack's New England Clam Chowder", Category = "Seafood", UnitPrice = 9.6500M, UnitsInStock = 85 },
                    new Product { ProductID = 42, ProductName = "Singaporean Hokkien Fried Mee", Category = "Grains/Cereals", UnitPrice = 14.0000M, UnitsInStock = 26 },
                    new Product { ProductID = 43, ProductName = "Ipoh Coffee", Category = "Beverages", UnitPrice = 46.0000M, UnitsInStock = 17 },
                    new Product { ProductID = 44, ProductName = "Gula Malacca", Category = "Condiments", UnitPrice = 19.4500M, UnitsInStock = 27 },
                    new Product { ProductID = 45, ProductName = "Rogede sild", Category = "Seafood", UnitPrice = 9.5000M, UnitsInStock = 5 },
                    new Product { ProductID = 46, ProductName = "Spegesild", Category = "Seafood", UnitPrice = 12.0000M, UnitsInStock = 95 },
                    new Product { ProductID = 47, ProductName = "Zaanse koeken", Category = "Confections", UnitPrice = 9.5000M, UnitsInStock = 36 },
                    new Product { ProductID = 48, ProductName = "Chocolade", Category = "Confections", UnitPrice = 12.7500M, UnitsInStock = 15 },
                    new Product { ProductID = 49, ProductName = "Maxilaku", Category = "Confections", UnitPrice = 20.0000M, UnitsInStock = 10 },
                    new Product { ProductID = 50, ProductName = "Valkoinen suklaa", Category = "Confections", UnitPrice = 16.2500M, UnitsInStock = 65 },
                    new Product { ProductID = 51, ProductName = "Manjimup Dried Apples", Category = "Produce", UnitPrice = 53.0000M, UnitsInStock = 20 },
                    new Product { ProductID = 52, ProductName = "Filo Mix", Category = "Grains/Cereals", UnitPrice = 7.0000M, UnitsInStock = 38 },
                    new Product { ProductID = 53, ProductName = "Perth Pasties", Category = "Meat/Poultry", UnitPrice = 32.8000M, UnitsInStock = 0 },
                    new Product { ProductID = 54, ProductName = "Tourtière", Category = "Meat/Poultry", UnitPrice = 7.4500M, UnitsInStock = 21 },
                    new Product { ProductID = 55, ProductName = "Pâté chinois", Category = "Meat/Poultry", UnitPrice = 24.0000M, UnitsInStock = 115 },
                    new Product { ProductID = 56, ProductName = "Gnocchi di nonna Alice", Category = "Grains/Cereals", UnitPrice = 38.0000M, UnitsInStock = 21 },
                    new Product { ProductID = 57, ProductName = "Ravioli Angelo", Category = "Grains/Cereals", UnitPrice = 19.5000M, UnitsInStock = 36 },
                    new Product { ProductID = 58, ProductName = "Escargots de Bourgogne", Category = "Seafood", UnitPrice = 13.2500M, UnitsInStock = 62 },
                    new Product { ProductID = 59, ProductName = "Raclette Courdavault", Category = "Dairy Products", UnitPrice = 55.0000M, UnitsInStock = 79 },
                    new Product { ProductID = 60, ProductName = "Camembert Pierrot", Category = "Dairy Products", UnitPrice = 34.0000M, UnitsInStock = 19 },
                    new Product { ProductID = 61, ProductName = "Sirop d'érable", Category = "Condiments", UnitPrice = 28.5000M, UnitsInStock = 113 },
                    new Product { ProductID = 62, ProductName = "Tarte au sucre", Category = "Confections", UnitPrice = 49.3000M, UnitsInStock = 17 },
                    new Product { ProductID = 63, ProductName = "Vegie-spread", Category = "Condiments", UnitPrice = 43.9000M, UnitsInStock = 24 },
                    new Product { ProductID = 64, ProductName = "Wimmers gute Semmelknödel", Category = "Grains/Cereals", UnitPrice = 33.2500M, UnitsInStock = 22 },
                    new Product { ProductID = 65, ProductName = "Louisiana Fiery Hot Pepper Sauce", Category = "Condiments", UnitPrice = 21.0500M, UnitsInStock = 76 },
                    new Product { ProductID = 66, ProductName = "Louisiana Hot Spiced Okra", Category = "Condiments", UnitPrice = 17.0000M, UnitsInStock = 4 },
                    new Product { ProductID = 67, ProductName = "Laughing Lumberjack Lager", Category = "Beverages", UnitPrice = 14.0000M, UnitsInStock = 52 },
                    new Product { ProductID = 68, ProductName = "Scottish Longbreads", Category = "Confections", UnitPrice = 12.5000M, UnitsInStock = 6 },
                    new Product { ProductID = 69, ProductName = "Gudbrandsdalsost", Category = "Dairy Products", UnitPrice = 36.0000M, UnitsInStock = 26 },
                    new Product { ProductID = 70, ProductName = "Outback Lager", Category = "Beverages", UnitPrice = 15.0000M, UnitsInStock = 15 },
                    new Product { ProductID = 71, ProductName = "Flotemysost", Category = "Dairy Products", UnitPrice = 21.5000M, UnitsInStock = 26 },
                    new Product { ProductID = 72, ProductName = "Mozzarella di Giovanni", Category = "Dairy Products", UnitPrice = 34.8000M, UnitsInStock = 14 },
                    new Product { ProductID = 73, ProductName = "Röd Kaviar", Category = "Seafood", UnitPrice = 15.0000M, UnitsInStock = 101 },
                    new Product { ProductID = 74, ProductName = "Longlife Tofu", Category = "Produce", UnitPrice = 10.0000M, UnitsInStock = 4 },
                    new Product { ProductID = 75, ProductName = "Rhönbräu Klosterbier", Category = "Beverages", UnitPrice = 7.7500M, UnitsInStock = 125 },
                    new Product { ProductID = 76, ProductName = "Lakkalikööri", Category = "Beverages", UnitPrice = 18.0000M, UnitsInStock = 57 },
                    new Product { ProductID = 77, ProductName = "Original Frankfurter grüne Soße", Category = "Condiments", UnitPrice = 13.0000M, UnitsInStock = 32 }
                };

                supplierList = new List<Supplier>(){
                    new Supplier {SupplierName = "Exotic Liquids", Address = "49 Gilbert St.", City = "London", Country = "UK"},
                    new Supplier {SupplierName = "New Orleans Cajun Delights", Address = "P.O. Box 78934", City = "New Orleans", Country = "USA"},
                    new Supplier {SupplierName = "Grandma Kelly's Homestead", Address = "707 Oxford Rd.", City = "Ann Arbor", Country = "USA"},
                    new Supplier {SupplierName = "Tokyo Traders", Address = "9-8 Sekimai Musashino-shi", City = "Tokyo", Country = "Japan"},
                    new Supplier {SupplierName = "Cooperativa de Quesos 'Las Cabras'", Address = "Calle del Rosal 4", City = "Oviedo", Country = "Spain"},
                    new Supplier {SupplierName = "Mayumi's", Address = "92 Setsuko Chuo-ku", City = "Osaka", Country = "Japan"},
                    new Supplier {SupplierName = "Pavlova, Ltd.", Address = "74 Rose St. Moonie Ponds", City = "Melbourne", Country = "Australia"},
                    new Supplier {SupplierName = "Specialty Biscuits, Ltd.", Address = "29 King's Way", City = "Manchester", Country = "UK"},
                    new Supplier {SupplierName = "PB Knäckebröd AB", Address = "Kaloadagatan 13", City = "Göteborg", Country = "Sweden"},
                    new Supplier {SupplierName = "Refrescos Americanas LTDA", Address = "Av. das Americanas 12.890", City = "Sao Paulo", Country = "Brazil"},
                    new Supplier {SupplierName = "Heli Süßwaren GmbH & Co. KG", Address = "Tiergartenstraße 5", City = "Berlin", Country = "Germany"},
                    new Supplier {SupplierName = "Plutzer Lebensmittelgroßmärkte AG", Address = "Bogenallee 51", City = "Frankfurt", Country = "Germany"},
                    new Supplier {SupplierName = "Nord-Ost-Fisch Handelsgesellschaft mbH", Address = "Frahmredder 112a", City = "Cuxhaven", Country = "Germany"},
                    new Supplier {SupplierName = "Formaggi Fortini s.r.l.", Address = "Viale Dante, 75", City = "Ravenna", Country = "Italy"},
                    new Supplier {SupplierName = "Norske Meierier", Address = "Hatlevegen 5", City = "Sandvika", Country = "Norway"},
                    new Supplier {SupplierName = "Bigfoot Breweries", Address = "3400 - 8th Avenue Suite 210", City = "Bend", Country = "USA"},
                    new Supplier {SupplierName = "Svensk Sjöföda AB", Address = "Brovallavägen 231", City = "Stockholm", Country = "Sweden"},
                    new Supplier {SupplierName = "Aux joyeux ecclésiastiques", Address = "203, Rue des Francs-Bourgeois", City = "Paris", Country = "France"},
                    new Supplier {SupplierName = "New England Seafood Cannery", Address = "Order Processing Dept. 2100 Paul Revere Blvd.", City = "Boston", Country = "USA"},
                    new Supplier {SupplierName = "Leka Trading", Address = "471 Serangoon Loop, Suite #402", City = "Singapore", Country = "Singapore"},
                    new Supplier {SupplierName = "Lyngbysild", Address = "Lyngbysild Fiskebakken 10", City = "Lyngby", Country = "Denmark"},
                    new Supplier {SupplierName = "Zaanse Snoepfabriek", Address = "Verkoop Rijnweg 22", City = "Zaandam", Country = "Netherlands"},
                    new Supplier {SupplierName = "Karkki Oy", Address = "Valtakatu 12", City = "Lappeenranta", Country = "Finland"},
                    new Supplier {SupplierName = "G'day, Mate", Address = "170 Prince Edward Parade Hunter's Hill", City = "Sydney", Country = "Australia"},
                    new Supplier {SupplierName = "Ma Maison", Address = "2960 Rue St. Laurent", City = "Montréal", Country = "Canada"},
                    new Supplier {SupplierName = "Pasta Buttini s.r.l.", Address = "Via dei Gelsomini, 153", City = "Salerno", Country = "Italy"},
                    new Supplier {SupplierName = "Escargots Nouveaux", Address = "22, rue H. Voiron", City = "Montceau", Country = "France"},
                    new Supplier {SupplierName = "Gai pâturage", Address = "Bat. B 3, rue des Alpes", City = "Annecy", Country = "France"},
                    new Supplier {SupplierName = "Forêts d'érables", Address = "148 rue Chasseur", City = "Ste-Hyacinthe", Country = "Canada"},
                };

                // Customer/Order data read into memory from XML file using XLinq:
                customerList = (
                    from e in XDocument.Load("Customers.xml").
                              Root.Elements("customer")
                    select new Customer
                    {
                        CustomerID = (string)e.Element("id"),
                        CompanyName = (string)e.Element("name"),
                        Address = (string)e.Element("address"),
                        City = (string)e.Element("city"),
                        Region = (string)e.Element("region"),
                        PostalCode = (string)e.Element("postalcode"),
                        Country = (string)e.Element("country"),
                        Phone = (string)e.Element("phone"),
                        Fax = (string)e.Element("fax"),
                        Orders = (
                            from o in e.Elements("orders").Elements("order")
                            select new Order
                            {
                                OrderID = (int)o.Element("id"),
                                OrderDate = (DateTime)o.Element("orderdate"),
                                Total = (decimal)o.Element("total")
                            })
                            .ToArray()
                    })
                    .ToList();
            }
        }
    }
}
