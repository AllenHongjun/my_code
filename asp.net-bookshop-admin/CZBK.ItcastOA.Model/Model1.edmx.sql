
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 06/05/2019 19:52:32
-- Generated from EDMX file: D:\Everything\11-dotnet教程\12 OA项目九天\2015-07-03-OA项目第九天内容\09.CZBK.ItcastOA\CZBK.ItcastOA\CZBK.ItcastOA.Model\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [OA];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_ActionInfoR_UserInfo_ActionInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[R_UserInfo_ActionInfo] DROP CONSTRAINT [FK_ActionInfoR_UserInfo_ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_DepartmentActionInfo_ActionInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[DepartmentActionInfo] DROP CONSTRAINT [FK_DepartmentActionInfo_ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_DepartmentActionInfo_Department]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[DepartmentActionInfo] DROP CONSTRAINT [FK_DepartmentActionInfo_Department];
GO
IF OBJECT_ID(N'[dbo].[FK_RoleInfoActionInfo_ActionInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[RoleInfoActionInfo] DROP CONSTRAINT [FK_RoleInfoActionInfo_ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_RoleInfoActionInfo_RoleInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[RoleInfoActionInfo] DROP CONSTRAINT [FK_RoleInfoActionInfo_RoleInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_UserInfoDepartment_Department]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[UserInfoDepartment] DROP CONSTRAINT [FK_UserInfoDepartment_Department];
GO
IF OBJECT_ID(N'[dbo].[FK_UserInfoDepartment_UserInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[UserInfoDepartment] DROP CONSTRAINT [FK_UserInfoDepartment_UserInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_UserInfoR_UserInfo_ActionInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[R_UserInfo_ActionInfo] DROP CONSTRAINT [FK_UserInfoR_UserInfo_ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_UserInfoRoleInfo_RoleInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[UserInfoRoleInfo] DROP CONSTRAINT [FK_UserInfoRoleInfo_RoleInfo];
GO
IF OBJECT_ID(N'[dbo].[FK_UserInfoRoleInfo_UserInfo]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[UserInfoRoleInfo] DROP CONSTRAINT [FK_UserInfoRoleInfo_UserInfo];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[ActionInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[Books]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Books];
GO
IF OBJECT_ID(N'[dbo].[Department]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Department];
GO
IF OBJECT_ID(N'[dbo].[DepartmentActionInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DepartmentActionInfo];
GO
IF OBJECT_ID(N'[dbo].[KeyWordsRank]', 'U') IS NOT NULL
    DROP TABLE [dbo].[KeyWordsRank];
GO
IF OBJECT_ID(N'[dbo].[R_UserInfo_ActionInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[R_UserInfo_ActionInfo];
GO
IF OBJECT_ID(N'[dbo].[RoleInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[RoleInfo];
GO
IF OBJECT_ID(N'[dbo].[RoleInfoActionInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[RoleInfoActionInfo];
GO
IF OBJECT_ID(N'[dbo].[SearchDetails]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SearchDetails];
GO
IF OBJECT_ID(N'[dbo].[UserInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserInfo];
GO
IF OBJECT_ID(N'[dbo].[UserInfoDepartment]', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserInfoDepartment];
GO
IF OBJECT_ID(N'[dbo].[UserInfoRoleInfo]', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserInfoRoleInfo];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'UserInfo'
CREATE TABLE [dbo].[UserInfo] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [UName] nvarchar(32)  NULL,
    [UPwd] nvarchar(16)  NOT NULL,
    [SubTime] datetime  NOT NULL,
    [DelFlag] smallint  NOT NULL,
    [ModifiedOn] datetime  NOT NULL,
    [Remark] nvarchar(256)  NULL,
    [Sort] nvarchar(max)  NULL
);
GO

-- Creating table 'ActionInfo'
CREATE TABLE [dbo].[ActionInfo] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [SubTime] datetime  NOT NULL,
    [DelFlag] smallint  NOT NULL,
    [ModifiedOn] nvarchar(max)  NOT NULL,
    [Remark] nvarchar(256)  NULL,
    [Url] nvarchar(512)  NOT NULL,
    [HttpMethod] nvarchar(32)  NOT NULL,
    [ActionMethodName] nvarchar(32)  NULL,
    [ControllerName] nvarchar(128)  NULL,
    [ActionInfoName] nvarchar(32)  NOT NULL,
    [Sort] nvarchar(max)  NULL,
    [ActionTypeEnum] smallint  NOT NULL,
    [MenuIcon] varchar(512)  NULL,
    [IconWidth] int  NOT NULL,
    [IconHeight] int  NOT NULL
);
GO

-- Creating table 'Department'
CREATE TABLE [dbo].[Department] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [DepName] nvarchar(32)  NOT NULL,
    [ParentId] int  NOT NULL,
    [TreePath] nvarchar(128)  NOT NULL,
    [Level] int  NOT NULL,
    [IsLeaf] bit  NOT NULL
);
GO

-- Creating table 'R_UserInfo_ActionInfo'
CREATE TABLE [dbo].[R_UserInfo_ActionInfo] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [UserInfoID] int  NOT NULL,
    [ActionInfoID] int  NOT NULL,
    [IsPass] bit  NOT NULL
);
GO

-- Creating table 'RoleInfo'
CREATE TABLE [dbo].[RoleInfo] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [RoleName] nvarchar(32)  NOT NULL,
    [DelFlag] smallint  NOT NULL,
    [SubTime] datetime  NOT NULL,
    [Remark] nvarchar(256)  NULL,
    [ModifiedOn] datetime  NOT NULL,
    [Sort] nvarchar(max)  NULL
);
GO

-- Creating table 'Books'
CREATE TABLE [dbo].[Books] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(200)  NOT NULL,
    [Author] nvarchar(200)  NOT NULL,
    [PublisherId] int  NOT NULL,
    [PublishDate] datetime  NOT NULL,
    [ISBN] nvarchar(50)  NOT NULL,
    [WordsCount] int  NOT NULL,
    [UnitPrice] decimal(19,4)  NOT NULL,
    [ContentDescription] nvarchar(max)  NULL,
    [AurhorDescription] nvarchar(max)  NULL,
    [EditorComment] nvarchar(max)  NULL,
    [TOC] nvarchar(max)  NULL,
    [CategoryId] int  NULL,
    [Clicks] int  NOT NULL
);
GO

-- Creating table 'KeyWordsRank'
CREATE TABLE [dbo].[KeyWordsRank] (
    [Id] uniqueidentifier  NOT NULL,
    [KeyWords] nvarchar(255)  NULL,
    [SearchCount] int  NULL
);
GO

-- Creating table 'SearchDetails'
CREATE TABLE [dbo].[SearchDetails] (
    [Id] uniqueidentifier  NOT NULL,
    [KeyWords] nvarchar(255)  NULL,
    [SearchDateTime] datetime  NULL
);
GO

-- Creating table 'DepartmentActionInfo'
CREATE TABLE [dbo].[DepartmentActionInfo] (
    [ActionInfo_ID] int  NOT NULL,
    [Department_ID] int  NOT NULL
);
GO

-- Creating table 'RoleInfoActionInfo'
CREATE TABLE [dbo].[RoleInfoActionInfo] (
    [ActionInfo_ID] int  NOT NULL,
    [RoleInfo_ID] int  NOT NULL
);
GO

-- Creating table 'UserInfoDepartment'
CREATE TABLE [dbo].[UserInfoDepartment] (
    [Department_ID] int  NOT NULL,
    [UserInfo_ID] int  NOT NULL
);
GO

-- Creating table 'UserInfoRoleInfo'
CREATE TABLE [dbo].[UserInfoRoleInfo] (
    [RoleInfo_ID] int  NOT NULL,
    [UserInfo_ID] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [ID] in table 'UserInfo'
ALTER TABLE [dbo].[UserInfo]
ADD CONSTRAINT [PK_UserInfo]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'ActionInfo'
ALTER TABLE [dbo].[ActionInfo]
ADD CONSTRAINT [PK_ActionInfo]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'Department'
ALTER TABLE [dbo].[Department]
ADD CONSTRAINT [PK_Department]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'R_UserInfo_ActionInfo'
ALTER TABLE [dbo].[R_UserInfo_ActionInfo]
ADD CONSTRAINT [PK_R_UserInfo_ActionInfo]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [ID] in table 'RoleInfo'
ALTER TABLE [dbo].[RoleInfo]
ADD CONSTRAINT [PK_RoleInfo]
    PRIMARY KEY CLUSTERED ([ID] ASC);
GO

-- Creating primary key on [Id] in table 'Books'
ALTER TABLE [dbo].[Books]
ADD CONSTRAINT [PK_Books]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'KeyWordsRank'
ALTER TABLE [dbo].[KeyWordsRank]
ADD CONSTRAINT [PK_KeyWordsRank]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SearchDetails'
ALTER TABLE [dbo].[SearchDetails]
ADD CONSTRAINT [PK_SearchDetails]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [ActionInfo_ID], [Department_ID] in table 'DepartmentActionInfo'
ALTER TABLE [dbo].[DepartmentActionInfo]
ADD CONSTRAINT [PK_DepartmentActionInfo]
    PRIMARY KEY CLUSTERED ([ActionInfo_ID], [Department_ID] ASC);
GO

-- Creating primary key on [ActionInfo_ID], [RoleInfo_ID] in table 'RoleInfoActionInfo'
ALTER TABLE [dbo].[RoleInfoActionInfo]
ADD CONSTRAINT [PK_RoleInfoActionInfo]
    PRIMARY KEY CLUSTERED ([ActionInfo_ID], [RoleInfo_ID] ASC);
GO

-- Creating primary key on [Department_ID], [UserInfo_ID] in table 'UserInfoDepartment'
ALTER TABLE [dbo].[UserInfoDepartment]
ADD CONSTRAINT [PK_UserInfoDepartment]
    PRIMARY KEY CLUSTERED ([Department_ID], [UserInfo_ID] ASC);
GO

-- Creating primary key on [RoleInfo_ID], [UserInfo_ID] in table 'UserInfoRoleInfo'
ALTER TABLE [dbo].[UserInfoRoleInfo]
ADD CONSTRAINT [PK_UserInfoRoleInfo]
    PRIMARY KEY CLUSTERED ([RoleInfo_ID], [UserInfo_ID] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [ActionInfoID] in table 'R_UserInfo_ActionInfo'
ALTER TABLE [dbo].[R_UserInfo_ActionInfo]
ADD CONSTRAINT [FK_ActionInfoR_UserInfo_ActionInfo]
    FOREIGN KEY ([ActionInfoID])
    REFERENCES [dbo].[ActionInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ActionInfoR_UserInfo_ActionInfo'
CREATE INDEX [IX_FK_ActionInfoR_UserInfo_ActionInfo]
ON [dbo].[R_UserInfo_ActionInfo]
    ([ActionInfoID]);
GO

-- Creating foreign key on [UserInfoID] in table 'R_UserInfo_ActionInfo'
ALTER TABLE [dbo].[R_UserInfo_ActionInfo]
ADD CONSTRAINT [FK_UserInfoR_UserInfo_ActionInfo]
    FOREIGN KEY ([UserInfoID])
    REFERENCES [dbo].[UserInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_UserInfoR_UserInfo_ActionInfo'
CREATE INDEX [IX_FK_UserInfoR_UserInfo_ActionInfo]
ON [dbo].[R_UserInfo_ActionInfo]
    ([UserInfoID]);
GO

-- Creating foreign key on [ActionInfo_ID] in table 'DepartmentActionInfo'
ALTER TABLE [dbo].[DepartmentActionInfo]
ADD CONSTRAINT [FK_DepartmentActionInfo_ActionInfo]
    FOREIGN KEY ([ActionInfo_ID])
    REFERENCES [dbo].[ActionInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [Department_ID] in table 'DepartmentActionInfo'
ALTER TABLE [dbo].[DepartmentActionInfo]
ADD CONSTRAINT [FK_DepartmentActionInfo_Department]
    FOREIGN KEY ([Department_ID])
    REFERENCES [dbo].[Department]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_DepartmentActionInfo_Department'
CREATE INDEX [IX_FK_DepartmentActionInfo_Department]
ON [dbo].[DepartmentActionInfo]
    ([Department_ID]);
GO

-- Creating foreign key on [ActionInfo_ID] in table 'RoleInfoActionInfo'
ALTER TABLE [dbo].[RoleInfoActionInfo]
ADD CONSTRAINT [FK_RoleInfoActionInfo_ActionInfo]
    FOREIGN KEY ([ActionInfo_ID])
    REFERENCES [dbo].[ActionInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [RoleInfo_ID] in table 'RoleInfoActionInfo'
ALTER TABLE [dbo].[RoleInfoActionInfo]
ADD CONSTRAINT [FK_RoleInfoActionInfo_RoleInfo]
    FOREIGN KEY ([RoleInfo_ID])
    REFERENCES [dbo].[RoleInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_RoleInfoActionInfo_RoleInfo'
CREATE INDEX [IX_FK_RoleInfoActionInfo_RoleInfo]
ON [dbo].[RoleInfoActionInfo]
    ([RoleInfo_ID]);
GO

-- Creating foreign key on [Department_ID] in table 'UserInfoDepartment'
ALTER TABLE [dbo].[UserInfoDepartment]
ADD CONSTRAINT [FK_UserInfoDepartment_Department]
    FOREIGN KEY ([Department_ID])
    REFERENCES [dbo].[Department]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [UserInfo_ID] in table 'UserInfoDepartment'
ALTER TABLE [dbo].[UserInfoDepartment]
ADD CONSTRAINT [FK_UserInfoDepartment_UserInfo]
    FOREIGN KEY ([UserInfo_ID])
    REFERENCES [dbo].[UserInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_UserInfoDepartment_UserInfo'
CREATE INDEX [IX_FK_UserInfoDepartment_UserInfo]
ON [dbo].[UserInfoDepartment]
    ([UserInfo_ID]);
GO

-- Creating foreign key on [RoleInfo_ID] in table 'UserInfoRoleInfo'
ALTER TABLE [dbo].[UserInfoRoleInfo]
ADD CONSTRAINT [FK_UserInfoRoleInfo_RoleInfo]
    FOREIGN KEY ([RoleInfo_ID])
    REFERENCES [dbo].[RoleInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [UserInfo_ID] in table 'UserInfoRoleInfo'
ALTER TABLE [dbo].[UserInfoRoleInfo]
ADD CONSTRAINT [FK_UserInfoRoleInfo_UserInfo]
    FOREIGN KEY ([UserInfo_ID])
    REFERENCES [dbo].[UserInfo]
        ([ID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_UserInfoRoleInfo_UserInfo'
CREATE INDEX [IX_FK_UserInfoRoleInfo_UserInfo]
ON [dbo].[UserInfoRoleInfo]
    ([UserInfo_ID]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------