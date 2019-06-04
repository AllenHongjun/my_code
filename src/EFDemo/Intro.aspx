<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Intro.aspx.cs" Inherits="EFDemo.Intro" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <h2>
                EF的使用 
                数据实体框架模型
                连接数据库 


                实体数据模型  

                code first 数据迁移 

                关键是表里面的管理 操作 

                筛选出自己想要的数据 

                一般是database  first
                code first


                tt  微软的T4模板生成 工具 了解 里面的代码生成工具 不用自己去写 去修改。。使用里面的类 属性和方法就可以 
                

                项目的目录 不要放在有中文命名的地方 
                第三方的包
                nuget 
                版本升级 可以和您方便的管理  有一个包的管理工具
                自己的项目 可以很方便的使用
            </h2>


            <p>
                object relation mapping
                对象 关系 建立对应的关系  
                这个表 里的关系 也是可以映射的

                底层 还是 使用ado.net 的技术来访问数据
                会把我们写的 linq 语句 转化成了 sql语句

                没有那个数据库 就用别的数据库
                学习这个框架的使用就可以了 
                搞清楚那个框架的使用 
                控制台 winform 设计连接 数据的操作 都可以使用这个框架 
                dapper 还有其他的框架

                其他的框架 要比EF的 要简单。搭建几个框架 使用一下 就可以在简历上写上。
                难的会了。就可以写几个简单点的框架 就可以加工资了。。流弊呀


            </p>   
        </div>
    </form>
</body>
</html>
