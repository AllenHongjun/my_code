USE [master]
GO
/****** Object:  Database [book_shop3]    Script Date: 2019/6/1 19:32:15 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'book_shop3')
BEGIN
CREATE DATABASE [book_shop3] ON  PRIMARY 
( NAME = N'bookshop', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\bookshop.mdf' , SIZE = 11264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bookshop_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\bookshop_log.ldf' , SIZE = 7616KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
END
GO
ALTER DATABASE [book_shop3] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [book_shop3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [book_shop3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [book_shop3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [book_shop3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [book_shop3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [book_shop3] SET ARITHABORT OFF 
GO
ALTER DATABASE [book_shop3] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [book_shop3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [book_shop3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [book_shop3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [book_shop3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [book_shop3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [book_shop3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [book_shop3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [book_shop3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [book_shop3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [book_shop3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [book_shop3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [book_shop3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [book_shop3] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [book_shop3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [book_shop3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [book_shop3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [book_shop3] SET RECOVERY FULL 
GO
ALTER DATABASE [book_shop3] SET  MULTI_USER 
GO
ALTER DATABASE [book_shop3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [book_shop3] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'book_shop3', N'ON'
GO
USE [book_shop3]
GO
/****** Object:  User [home]    Script Date: 2019/6/1 19:32:15 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'home')
CREATE USER [home] FOR LOGIN [home] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [bookuser1]    Script Date: 2019/6/1 19:32:15 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'bookuser1')
CREATE USER [bookuser1] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [bookuser]    Script Date: 2019/6/1 19:32:15 ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'bookuser')
CREATE USER [bookuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'home'
GO
/****** Object:  Table [dbo].[ActionGroup]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionGroup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](32) NOT NULL,
	[GroupType] [smallint] NOT NULL,
	[DelFlag] [nvarchar](max) NOT NULL,
	[Sort] [int] NOT NULL,
 CONSTRAINT [PK_ActionGroup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ActionGroupActionInfo]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionGroupActionInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionGroupActionInfo](
	[ActionGroup_ID] [int] NOT NULL,
	[ActionInfo_ID] [int] NOT NULL,
 CONSTRAINT [PK_ActionGroupActionInfo] PRIMARY KEY NONCLUSTERED 
(
	[ActionGroup_ID] ASC,
	[ActionInfo_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ActionInfo]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ActionInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ActionInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActionInfoName] [nvarchar](32) NOT NULL,
	[Url] [varchar](256) NOT NULL,
	[HttpMethod] [smallint] NOT NULL,
	[Remark] [nvarchar](256) NOT NULL,
	[DelFalg] [smallint] NOT NULL,
	[SubTime] [datetime] NOT NULL,
	[IsMenu] [bit] NOT NULL,
	[R_UserInfo_ActionInfoID] [int] NOT NULL,
 CONSTRAINT [PK_ActionInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Articel_Words]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Articel_Words]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Articel_Words](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WordPattern] [nvarchar](50) NOT NULL,
	[IsForbid] [bit] NOT NULL,
	[IsMod] [bit] NOT NULL,
	[ReplaceWord] [nvarchar](50) NULL,
 CONSTRAINT [PK_Articel_Words] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[BookComment]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BookComment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BookComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Msg] [nvarchar](max) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[BookId] [int] NOT NULL,
 CONSTRAINT [PK_BookComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Books]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Books]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Books](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Author] [nvarchar](200) NOT NULL,
	[PublisherId] [int] NOT NULL,
	[PublishDate] [datetime] NOT NULL,
	[ISBN] [nvarchar](50) NOT NULL,
	[WordsCount] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ContentDescription] [nvarchar](max) NULL,
	[AurhorDescription] [nvarchar](max) NULL,
	[EditorComment] [nvarchar](max) NULL,
	[TOC] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
	[Clicks] [int] NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Cart](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[BookId] [int] NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_Cart] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 2019/6/1 19:32:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categories]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_CATEGORY] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CheckEmail]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CheckEmail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CheckEmail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Actived] [bit] NULL,
	[ActiveCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_CheckEmail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Department]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Department]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DepName] [nvarchar](32) NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[keyWordsRank]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[keyWordsRank]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[keyWordsRank](
	[Id] [uniqueidentifier] NOT NULL,
	[KeyWords] [nvarchar](255) NULL,
	[SearchTimes] [int] NULL,
 CONSTRAINT [PK_keyWordsRank] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[OrderBook]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderBook]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OrderBook](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [nvarchar](50) NOT NULL,
	[BookID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrderBook] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Orders](
	[OrderId] [nvarchar](50) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[TotalPrice] [decimal](10, 2) NOT NULL,
	[PostAddress] [nvarchar](255) NULL,
	[state] [int] NOT NULL,
 CONSTRAINT [PK_ORDERS] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Publishers]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Publishers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Publishers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[R_UserInfo_ActionInfo]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[R_UserInfo_ActionInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IsPass] [smallint] NOT NULL,
	[ActionInfoID] [int] NOT NULL,
	[UserInfoID] [int] NOT NULL,
	[ActionInfo_ID] [int] NOT NULL,
 CONSTRAINT [PK_R_UserInfo_ActionInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Role]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Role](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](12) NOT NULL,
	[DelFlag] [smallint] NOT NULL,
	[RoleType] [smallint] NOT NULL,
	[SubTime] [datetime] NOT NULL,
	[Remark] [nvarchar](256) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[RoleActionGroup]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoleActionGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RoleActionGroup](
	[Role_ID] [int] NOT NULL,
	[ActionGroup_ID] [int] NOT NULL,
 CONSTRAINT [PK_RoleActionGroup] PRIMARY KEY NONCLUSTERED 
(
	[Role_ID] ASC,
	[ActionGroup_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[RoleActionInfo]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoleActionInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RoleActionInfo](
	[Role_ID] [int] NOT NULL,
	[ActionInfo_ID] [int] NOT NULL,
 CONSTRAINT [PK_RoleActionInfo] PRIMARY KEY NONCLUSTERED 
(
	[Role_ID] ASC,
	[ActionInfo_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[RoleDepartment]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoleDepartment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RoleDepartment](
	[Role_ID] [int] NOT NULL,
	[Department_ID] [int] NOT NULL,
 CONSTRAINT [PK_RoleDepartment] PRIMARY KEY NONCLUSTERED 
(
	[Role_ID] ASC,
	[Department_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[SearchDetails]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SearchDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[KeyWords] [nvarchar](255) NULL,
	[SearchDateTime] [datetime] NULL,
 CONSTRAINT [PK_SearchDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Settings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[SysFun]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SysFun]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysFun](
	[NodeId] [int] NOT NULL,
	[DisplayName] [nvarchar](50) NOT NULL,
	[NodeURL] [nvarchar](50) NULL,
	[DisplayOrder] [int] NOT NULL,
	[ParentNodeId] [int] NOT NULL,
 CONSTRAINT [PK_SysFun] PRIMARY KEY CLUSTERED 
(
	[NodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UserInfo]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](32) NOT NULL,
	[UserPass] [nvarchar](32) NOT NULL,
	[RegTime] [datetime] NOT NULL,
	[Email] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_UserInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UserInfoRole]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserInfoRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserInfoRole](
	[UserInfo_ID] [int] NOT NULL,
	[Role_ID] [int] NOT NULL,
 CONSTRAINT [PK_UserInfoRole] PRIMARY KEY NONCLUSTERED 
(
	[UserInfo_ID] ASC,
	[Role_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LoginId] [nvarchar](50) NOT NULL,
	[LoginPwd] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[Phone] [nvarchar](100) NOT NULL,
	[Mail] [nvarchar](100) NOT NULL,
	[UserStateId] [int] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UserStates]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserStates]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserStates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UserStates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[VidoFile]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VidoFile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VidoFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[FivPath] [nvarchar](255) NULL,
	[Status] [nvarchar](50) NULL,
	[FileExt] [nvarchar](50) NULL,
 CONSTRAINT [PK_VidoFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Books_ISBN]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Books]') AND name = N'IX_Books_ISBN')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Books_ISBN] ON [dbo].[Books]
(
	[ISBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Categories_Name]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Categories]') AND name = N'IX_Categories_Name')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Categories_Name] ON [dbo].[Categories]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_keyWordsRank]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[keyWordsRank]') AND name = N'IX_keyWordsRank')
CREATE NONCLUSTERED INDEX [IX_keyWordsRank] ON [dbo].[keyWordsRank]
(
	[KeyWords] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Publishers_Name]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Publishers]') AND name = N'IX_Publishers_Name')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Publishers_Name] ON [dbo].[Publishers]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_LoginId]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = N'IX_Users_LoginId')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_LoginId] ON [dbo].[Users]
(
	[LoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Mail]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = N'IX_Users_Mail')
CREATE NONCLUSTERED INDEX [IX_Users_Mail] ON [dbo].[Users]
(
	[Mail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserStates_Name]    Script Date: 2019/6/1 19:32:16 ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserStates]') AND name = N'IX_UserStates_Name')
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserStates_Name] ON [dbo].[UserStates]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Books_Clicks]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Books] ADD  CONSTRAINT [DF_Books_Clicks]  DEFAULT ((0)) FOR [Clicks]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Orders_state]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_state]  DEFAULT ((0)) FOR [state]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ActionGroupActionInfo_ActionGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[ActionGroupActionInfo]'))
ALTER TABLE [dbo].[ActionGroupActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_ActionGroupActionInfo_ActionGroup] FOREIGN KEY([ActionGroup_ID])
REFERENCES [dbo].[ActionGroup] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ActionGroupActionInfo_ActionGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[ActionGroupActionInfo]'))
ALTER TABLE [dbo].[ActionGroupActionInfo] CHECK CONSTRAINT [FK_ActionGroupActionInfo_ActionGroup]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ActionGroupActionInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[ActionGroupActionInfo]'))
ALTER TABLE [dbo].[ActionGroupActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_ActionGroupActionInfo_ActionInfo] FOREIGN KEY([ActionInfo_ID])
REFERENCES [dbo].[ActionInfo] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ActionGroupActionInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[ActionGroupActionInfo]'))
ALTER TABLE [dbo].[ActionGroupActionInfo] CHECK CONSTRAINT [FK_ActionGroupActionInfo_ActionInfo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Book_Category]') AND parent_object_id = OBJECT_ID(N'[dbo].[Books]'))
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Book_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Book_Category]') AND parent_object_id = OBJECT_ID(N'[dbo].[Books]'))
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Book_Category]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Books_Publishers]') AND parent_object_id = OBJECT_ID(N'[dbo].[Books]'))
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Publishers] FOREIGN KEY([PublisherId])
REFERENCES [dbo].[Publishers] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Books_Publishers]') AND parent_object_id = OBJECT_ID(N'[dbo].[Books]'))
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Publishers]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cart_Books]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cart]'))
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Books] FOREIGN KEY([BookId])
REFERENCES [dbo].[Books] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cart_Books]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cart]'))
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Books]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cart_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cart]'))
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cart_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cart]'))
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Users]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderBook_Book]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderBook]'))
ALTER TABLE [dbo].[OrderBook]  WITH CHECK ADD  CONSTRAINT [FK_OrderBook_Book] FOREIGN KEY([BookID])
REFERENCES [dbo].[Books] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderBook_Book]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderBook]'))
ALTER TABLE [dbo].[OrderBook] CHECK CONSTRAINT [FK_OrderBook_Book]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderBook_Order]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderBook]'))
ALTER TABLE [dbo].[OrderBook]  WITH CHECK ADD  CONSTRAINT [FK_OrderBook_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OrderBook_Order]') AND parent_object_id = OBJECT_ID(N'[dbo].[OrderBook]'))
ALTER TABLE [dbo].[OrderBook] CHECK CONSTRAINT [FK_OrderBook_Order]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Order_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Order_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Order_User]') AND parent_object_id = OBJECT_ID(N'[dbo].[Orders]'))
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Order_User]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_R_UserInfo_ActionInfoActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]'))
ALTER TABLE [dbo].[R_UserInfo_ActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_R_UserInfo_ActionInfoActionInfo] FOREIGN KEY([ActionInfo_ID])
REFERENCES [dbo].[ActionInfo] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_R_UserInfo_ActionInfoActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]'))
ALTER TABLE [dbo].[R_UserInfo_ActionInfo] CHECK CONSTRAINT [FK_R_UserInfo_ActionInfoActionInfo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoR_UserInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]'))
ALTER TABLE [dbo].[R_UserInfo_ActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_UserInfoR_UserInfo_ActionInfo] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[UserInfo] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoR_UserInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]'))
ALTER TABLE [dbo].[R_UserInfo_ActionInfo] CHECK CONSTRAINT [FK_UserInfoR_UserInfo_ActionInfo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionGroup_ActionGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionGroup]'))
ALTER TABLE [dbo].[RoleActionGroup]  WITH CHECK ADD  CONSTRAINT [FK_RoleActionGroup_ActionGroup] FOREIGN KEY([ActionGroup_ID])
REFERENCES [dbo].[ActionGroup] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionGroup_ActionGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionGroup]'))
ALTER TABLE [dbo].[RoleActionGroup] CHECK CONSTRAINT [FK_RoleActionGroup_ActionGroup]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionGroup_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionGroup]'))
ALTER TABLE [dbo].[RoleActionGroup]  WITH CHECK ADD  CONSTRAINT [FK_RoleActionGroup_Role] FOREIGN KEY([Role_ID])
REFERENCES [dbo].[Role] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionGroup_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionGroup]'))
ALTER TABLE [dbo].[RoleActionGroup] CHECK CONSTRAINT [FK_RoleActionGroup_Role]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionInfo]'))
ALTER TABLE [dbo].[RoleActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_RoleActionInfo_ActionInfo] FOREIGN KEY([ActionInfo_ID])
REFERENCES [dbo].[ActionInfo] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionInfo_ActionInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionInfo]'))
ALTER TABLE [dbo].[RoleActionInfo] CHECK CONSTRAINT [FK_RoleActionInfo_ActionInfo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionInfo_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionInfo]'))
ALTER TABLE [dbo].[RoleActionInfo]  WITH CHECK ADD  CONSTRAINT [FK_RoleActionInfo_Role] FOREIGN KEY([Role_ID])
REFERENCES [dbo].[Role] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleActionInfo_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleActionInfo]'))
ALTER TABLE [dbo].[RoleActionInfo] CHECK CONSTRAINT [FK_RoleActionInfo_Role]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleDepartment_Department]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleDepartment]'))
ALTER TABLE [dbo].[RoleDepartment]  WITH CHECK ADD  CONSTRAINT [FK_RoleDepartment_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleDepartment_Department]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleDepartment]'))
ALTER TABLE [dbo].[RoleDepartment] CHECK CONSTRAINT [FK_RoleDepartment_Department]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleDepartment_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleDepartment]'))
ALTER TABLE [dbo].[RoleDepartment]  WITH CHECK ADD  CONSTRAINT [FK_RoleDepartment_Role] FOREIGN KEY([Role_ID])
REFERENCES [dbo].[Role] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleDepartment_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleDepartment]'))
ALTER TABLE [dbo].[RoleDepartment] CHECK CONSTRAINT [FK_RoleDepartment_Role]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoRole_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserInfoRole]'))
ALTER TABLE [dbo].[UserInfoRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInfoRole_Role] FOREIGN KEY([Role_ID])
REFERENCES [dbo].[Role] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoRole_Role]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserInfoRole]'))
ALTER TABLE [dbo].[UserInfoRole] CHECK CONSTRAINT [FK_UserInfoRole_Role]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoRole_UserInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserInfoRole]'))
ALTER TABLE [dbo].[UserInfoRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInfoRole_UserInfo] FOREIGN KEY([UserInfo_ID])
REFERENCES [dbo].[UserInfo] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserInfoRole_UserInfo]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserInfoRole]'))
ALTER TABLE [dbo].[UserInfoRole] CHECK CONSTRAINT [FK_UserInfoRole_UserInfo]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UserStates]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserStates] FOREIGN KEY([UserStateId])
REFERENCES [dbo].[UserStates] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Users_UserStates]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserStates]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrder]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreateOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CreateOrder] AS' 
END
GO
ALTER proc [dbo].[CreateOrder]
@orderId nvarchar(50),--订单号
@userId int,--用户编号
@address nvarchar(255),--收货人地址
@totalMoney money output --总金额
as
begin
  declare @error int
	set @error=0
--计算总金额
 begin transaction
 select @totalMoney=sum(UnitPrice*[Count]) from Books inner join Cart on Books.Id=Cart.BookId where Cart.UserId=@userId
 set @error=@@error+@error
--向订单主表中插入数据.
insert into dbo.Orders(OrderId, OrderDate, UserId, TotalPrice, PostAddress, state) values(@orderId,getdate(),@userId,@totalMoney,@address,0)
 set @error=@@error+@error
--向明细表中插入数据
 insert into dbo.OrderBook(OrderID, BookID, Quantity, UnitPrice)select @orderId,BookId,[Count],UnitPrice from Books inner join Cart on Books.Id=Cart.BookId where Cart.UserId=@userId
 set @error=@@error+@error
--删除购物车表中当前用户的数据
  delete from Cart where UserId=@userId
   set @error=@@error+@error
  if @error>0 
   begin
	   rollback transaction
	end
  else
   begin
		commit transaction
   end
end
GO
/****** Object:  StoredProcedure [dbo].[createOrderConfirm]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[createOrderConfirm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[createOrderConfirm] AS' 
END
GO
ALTER proc [dbo].[createOrderConfirm]
@ordernumber  nvarchar(50),--订单号
@address nvarchar(255),--地址
@userId  int,--用户编号
@totalMoney money output--总价格
as
declare @error int
set @error=0--记录在生成订单的过程中是否出现错误;;
--求出当前用户在购物车表中存储的商品的总价
select @totalMoney=sum([count]*UnitPrice) from Cart inner join Books on Cart.BookId=Books.Id where UserId=@userId
if @totalMoney is null
begin
Raiserror('总价格为空!',18,1)
return
end

begin transaction ---开启事务.

--向订单主表中插入数据.
insert into  Orders(OrderId,OrderDate,UserId,TotalPrice,PostAddress,state)values(@ordernumber,getdate(),@userId,@totalMoney,@address,0)
set @error=@error+@@error--记录错误
--将Cart表中的购物商品插入到OrderBook.
insert into OrderBook(OrderID,BookID,Quantity,UnitPrice) select @ordernumber,BookId,[Count],UnitPrice from Cart inner join Books on Cart.BookId=Books.Id where UserId=@userId
set @error=@error+@@error
--删除购物车中的商品项
delete from Cart where UserId=@userId
set @error=@error+@@error
if @error=0
begin
  commit transaction--如果没有出错，提交整个事务
end
else
begin
   rollback transaction--出错，回滚整个事务。
     Raiserror('生成订单错误!',18,1)

end
GO
/****** Object:  StoredProcedure [dbo].[Pro_CreateOrder]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pro_CreateOrder]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pro_CreateOrder] AS' 
END
GO


ALTER PROCEDURE [dbo].[Pro_CreateOrder]
	-- Add the parameters for the stored procedure here
	@UserId int,
	@OrderNumber nvarchar(50),
	@PostAddress nvarchar(255),
	@TotalPrice money out
AS
BEGIN

	SET NOCOUNT ON;
	declare @error int
	declare @totalMoney money
	
	set @error=0
	begin Transaction
	--计算总价格
	select  @totalMoney=(sum([count]*unitprice))  from cart join books on cart.BookId=Books.Id where UserId=@UserId
	set @error=@error+@@error--记录上一条语句是否出错
	
	if (@totalMoney is NULL)
	begin
		rollback tran
		Raiserror ('购物车中没有书',18,18)
		return
	end
	insert into Orders(OrderId,OrderDate,UserId,TotalPrice,PostAddress,[State])
	values( @OrderNumber,GetDate(),@UserId,@totalMoney,@PostAddress,0)
	set @error=@error+@@error--记录上一条语句是否出错
	insert into OrderBook(OrderId,BookId,Quantity,UnitPrice)
	select @OrderNumber,BookId,[Count],UnitPrice from Cart join books on Cart.BookId=Books.Id where UserId=@UserId
	set @error=@error+@@error--记录上一条语句是否出错
	delete from cart  where UserId=@UserId
	set @error=@error+@@error--记录上一条语句是否出错
	if (@error>0) 
		begin
		 rollback transaction
		 Raiserror ('出错',18,18)
		 return
		 end
	else
		begin
		commit transaction
		set @TotalPrice = @totalMoney
		end

	
	set nocount off;


END

GO
/****** Object:  StoredProcedure [dbo].[Pro_createOrdersConfirm]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pro_createOrdersConfirm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pro_createOrdersConfirm] AS' 
END
GO
ALTER proc [dbo].[Pro_createOrdersConfirm]
@ordernum nvarchar(50),--订单号
@address  nvarchar(255),--收获人地址
@userid  int,--用户编号
@totalMoney money output--返回总价格
as
declare @error int
set @error=0;--记录用户在下订单过程的错误信息.
--求出当前用户放在购物车中所有商品的总价
select @totalMoney=sum([Count]*UnitPrice) from cart inner join Books on cart.BookId=Books.Id where UserId=@userid

if @totalMoney is null
begin
   Raiserror('总价为空',18,1)

end

begin transaction  ---开启事务
--向订单主表中插入信息
insert into Orders(OrderId,OrderDate,UserId,TotalPrice,PostAddress,state)values(@ordernum,getdate(),@userid,@totalMoney,@address,0)
set @error=@error+@@error--记录错误信息

--向订单明细表插入记录
insert into OrderBook(OrderId,BookId,Quantity,UnitPrice) select @ordernum,BookId,[Count],UnitPrice from cart inner join Books on cart.BookId=Books.Id where UserId=@userid

set @error=@error+@@error--记录错误信息

delete from cart where UserId=@userid--删除购物车表中记录
set @error=@error+@@error--记录错误信息

if @error=0
begin
   commit transaction --提交事务
end

else
 begin
     rollback transaction--回滚事务
 end

GO
/****** Object:  StoredProcedure [dbo].[Pro_GetPagedList]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pro_GetPagedList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pro_GetPagedList] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pro_GetPagedList]
	@start int,
	@end int,
	@category int=0,
	@order	nvarchar(20)='id'
AS
BEGIN

	SET NOCOUNT ON;

	declare @sql nvarchar(1000)
	
	
	
	set @sql = 'select * from (select *,Row_Number() over(order by '+@order+ ' ) rownumber from books where CategoryId=1) t'
	+ ' where t.rownumber>='+Convert(nvarchar(10),@start)+' and t.rownumber<='+Convert(nvarchar(10),@end)
	--EXEC (@sql)
	--EXEC SP_EXECUTESQL @sql
	EXEC (@sql)

	set Nocount off;
END
GO
/****** Object:  StoredProcedure [dbo].[Pro_OrderCreate]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pro_OrderCreate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pro_OrderCreate] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pro_OrderCreate]
	@OrderNmber nvarchar(50),
	@UserId int,
	@Address nvarchar(255),
	@TotalMoney money output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @error int;--用于记录事务中的每一个sql语句是否执行成功
	set @error=0;	
	
	SELECT @TotalMoney=sum(unitprice*count) from cart join books on cart.bookid=books.id
     where userid=@UserId
     
     if (@TotalMoney is null)
     begin
     --说明该用户在当前购物车中就没有定单
     raiserror ('购物车中没有图书',18,18)
     return;     
     end 
     
     
     
     
     --下面开始生成定单
     --开始一个事务
     begin transaction--开启一个事务
     --插入表头     
     insert into orders (OrderId,OrderDate,UserId,TotalPrice,PostAddress,state)
     values(@OrderNmber,getdate(),@UserId,@TotalMoney,@Address,0)
     set @error=@error+@@error;--检测上一句sql语句是否出错
     
     --插入表身
     insert into OrderBook
     select @OrderNmber,BookId,[Count],UnitPrice  from cart join Books on  cart.bookid=books.id where UserId=@UserId
     set @error=@error+@@error;--检测上一句sql语句是否出错
     
     delete from cart where UserId=@UserId;
     set @error=@error+@@error;--检测上一句sql语句是否出错
     
     if (@error>0)--说明在这个事务中有某个sql语句出错了我们需要回滚
     begin
		rollback transaction
		raiserror ('生成定单时出错',18,18)
		return;
     end
     else
     begin
		commit transaction
     end
     
     
     
     
     
     
     
	
	
	
	SET NOCOUNT OFF;

    -- Insert statements for procedure here
	
END
GO
/****** Object:  StoredProcedure [dbo].[Pro_Page]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pro_Page]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pro_Page] AS' 
END
GO
ALTER PROCEDURE [dbo].[Pro_Page]
(
@tblName   varchar(255),       -- 表名

@strGetFields varchar(1000) = '*',  -- 需要返回的列 

@fldName varchar(255)='',      -- 排序的字段名

@PageSize   int = 40,          -- 页尺寸

@PageIndex  int = 1,           -- 页码

@doCount  bit = 0,   -- 返回记录总数, 非 0 值则返回

@OrderType bit = 0,  -- 设置排序类型, 非 0 值则降序
@strWhere  varchar(1500)=''  -- 查询条件 (注意: 不要加 where)
)
AS

declare @strSQL   varchar(5000)       -- 主语句

declare @strTmp   varchar(110)        -- 临时变量

declare @strOrder varchar(400)        -- 排序类型

 

if @doCount != 0

  begin

    if @strWhere !=''

    set @strSQL = 'select count(*) as Total from ' + @tblName + ' where '+@strWhere

    else

    set @strSQL = 'select count(*) as Total from ' + @tblName 

end  

--以上代码的意思是如果@doCount传递过来的不是0，就执行总数统计。以下的所有代码都是@doCount为0的情况

else

begin

 

if @OrderType != 0

begin

    set @strTmp = '<(select min'

set @strOrder = ' order by ' + @fldName +' desc'

--如果@OrderType不是0，就执行降序，这句很重要！

end

else

begin

    set @strTmp = '>(select max'

    set @strOrder = ' order by ' + @fldName +' asc'

end

 

if @PageIndex = 1

begin

    if @strWhere != ''   

    set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from ' + @tblName + ' where ' + @strWhere + ' ' + @strOrder

     else

     set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from '+ @tblName + ' '+ @strOrder

--如果是第一页就执行以上代码，这样会加快执行速度

end

else

begin

--以下代码赋予了@strSQL以真正执行的SQL代码

set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from '

    + @tblName + ' where ' + @fldName + '' + @strTmp + '('+ @fldName + ') from (select top ' + str((@PageIndex-1)*@PageSize) + ' '+ @fldName + ' from ' + @tblName + '' + @strOrder + ') as tblTmp)'+ @strOrder

 

if @strWhere != ''

    set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from '

        + @tblName + ' where ' + @fldName + '' + @strTmp + '('

        + @fldName + ') from (select top ' + str((@PageIndex-1)*@PageSize) + ' '

        + @fldName + ' from ' + @tblName + ' where ' + @strWhere + ' '

        + @strOrder + ') as tblTmp) and ' + @strWhere + ' ' + @strOrder

end 

end   

exec (@strSQL)
GO
/****** Object:  StoredProcedure [dbo].[usp_createOrderConfirm]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_createOrderConfirm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_createOrderConfirm] AS' 
END
GO
ALTER proc [dbo].[usp_createOrderConfirm]
@ordernumber nvarchar(50),--订单号
@userId   int,--用户编号
@address nvarchar(255),--收获地址
@totalMoney money output--求出的总价，在网站中获得该总价，发给支付宝

as
declare @error int --记录操作过程中是否出现问题.
set @error=0

--计算出当前登录用户放在购物车中商品的总价
select @totalMoney=sum([Count]*UnitPrice) from Cart inner join Books on Cart.BookId=Books.Id where Cart.UserId=@userId

if @totalMoney is null
begin
  Raiserror('总价为空',18,1)
  return
end

begin transaction --开启事务
--向Orders表中插入数据
insert  into Orders(OrderId,OrderDate,UserId,TotalPrice,PostAddress,state)values(@ordernumber,getdate(),@userId,@totalMoney,@address,0)
set @error=@error+@@error--记录错误信息

--向OrderBook表中插入数据，由于当前用户有可能买多本书，也就是购物车表中有多条记录，我们将这多条记录都取出来，放入订单明细表中(OrderBook)
insert into OrderBook(OrderID,BookID,Quantity,UnitPrice) select @ordernumber,BookId,[Count],UnitPrice from Cart inner join Books on Cart.BookId=Books.Id where Cart.UserId=@userId
set @error=@error+@@error--记录错误信息

--清除该用户放在购物车中的商品项了.

delete from Cart where UserId=@userId
set @error=@error+@@error--记录错误信息

 if @error=0
  begin
    commit transaction --如果没有问题，提交整个事务
  end

 else

  begin
  Raiserror('订单失败',18,1)
   rollback transaction --如果出现问题，回滚整个操作
 end
  








GO
/****** Object:  StoredProcedure [dbo].[UspOutputData]    Script Date: 2019/6/1 19:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UspOutputData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UspOutputData] AS' 
END
GO
ALTER PROCEDURE [dbo].[UspOutputData]

@tablename sysname

AS

declare @column varchar(1000)

declare @columndata varchar(1000)

declare @sql varchar(4000)

declare @xtype tinyint

declare @name sysname

declare @objectId int

declare @objectname sysname

declare @ident int

set nocount on

set @objectId=object_id(@tablename)

if @objectId is null -- 判断对象是否存在

begin

print 'The object not exists'

return

end

set @objectname=rtrim(object_name(@objectId))

if @objectname is null or charindex(@objectname,@tablename)=0 --此判断不严密

begin

print 'object not in current database'

return

end

if OBJECTPROPERTY(@objectId,'IsTable') < > 1 -- 判断对象是否是table

begin

print 'The object is not table'

return

end

select @ident=status&0x80 from syscolumns where id=@objectid and status&0x80=0x80

if @ident is not null

print 'SET IDENTITY_INSERT '+@TableName+' ON'

declare syscolumns_cursor cursor

for select c.name,c.xtype from syscolumns c where c.id=@objectid order by c.colid

open syscolumns_cursor

set @column=''

set @columndata=''

fetch next from syscolumns_cursor into @name,@xtype

while @@fetch_status < >-1

begin

if @@fetch_status < >-2

begin

if @xtype not in(189,34,35,99,98) --timestamp不需处理，image,text,ntext,sql_variant 暂时不处理

begin

set @column=@column+case when len(@column)=0 then'' else ','end+@name

set @columndata=@columndata+case when len(@columndata)=0 then '' else ','','','

end

+case when @xtype in(167,175) then '''''''''+'+@name+'+''''''''' --varchar,char

when @xtype in(231,239) then '''N''''''+'+@name+'+''''''''' --nvarchar,nchar

when @xtype=61 then '''''''''+convert(char(23),'+@name+',121)+''''''''' --datetime

when @xtype=58 then '''''''''+convert(char(16),'+@name+',120)+''''''''' --smalldatetime

when @xtype=36 then '''''''''+convert(char(36),'+@name+')+''''''''' --uniqueidentifier

else @name end

end

end

fetch next from syscolumns_cursor into @name,@xtype

end

close syscolumns_cursor

deallocate syscolumns_cursor

set @sql='set nocount on select ''insert '+@tablename+'('+@column+') values(''as ''--'','+@columndata+','')'' from '+@tablename

print '--'+@sql

exec(@sql)

if @ident is not null

print 'SET IDENTITY_INSERT '+@TableName+' OFF'

GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Articel_Words', N'COLUMN',N'IsForbid'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否禁用' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Articel_Words', @level2type=N'COLUMN',@level2name=N'IsForbid'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'Articel_Words', N'COLUMN',N'IsMod'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否需要审核' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Articel_Words', @level2type=N'COLUMN',@level2name=N'IsMod'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'DefaultId' , N'SCHEMA',N'dbo', N'TABLE',N'UserStates', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'DefaultId', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserStates'
GO
USE [master]
GO
ALTER DATABASE [book_shop3] SET  READ_WRITE 
GO
