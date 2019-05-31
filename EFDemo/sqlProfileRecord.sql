








-- 先执行插入语句
exec sp_executesql N'INSERT [dbo].[UserInfo]([UserName], [UserPass], [RegTime], [Email])
VALUES (@0, @1, @2, @3)
-- 然后执行 查询  @@ROWCOUNT > 0 AND [ID] = scope_identity() 执行刚插入那一条语句
SELECT [ID]
FROM [dbo].[UserInfo]
WHERE @@ROWCOUNT > 0 AND [ID] = scope_identity()',N'@0 nvarchar(32),@1 nvarchar(32),@2 datetime2(7),@3 nvarchar(32)',@0=N'Alan',@1=N'a123456',@2='2019-05-08 21:56:55.3014051',@3=N'652971723@163.com'



--1:添加
  insert into dbo.RoomType(TypeName, Price, AddBed, BedPrice, Remark) output inserted.ID
values('kkk',321,1,34,'oooo')

-- insert into 表明  values

-- insert into #T select * from 表  insert 语句的3中结构    批量插入 

-- insert into output inserted  
-- @@ROWCOUNT  -- 返回上一个sql语句受影响的行数

-- scope_identity() 刚插入的主键的ID的值 

--都是讲过的 。。。。忘记了 没有好好的理解

-- 不要使用 @@ROWCOUNT 这个作用域有问题 全局的不要使用了。
SELECT [ID]
FROM [dbo].[UserInfo]
WHERE @@ROWCOUNT > 0 AND [ID] = scope_identity()


-- SCOPE_IDENTITY 和 @@IDENTITY 返回在当前会话中的任何表内所生成的最后一个标识值。但是，SCOPE_IDENTITY 只返回插入到当前作用域中的值；@@IDENTITY 不受限于特定的作用域。

--例如，有两个表 T1 和 T2，并且在 T1 上定义了 INSERT 触发器。当将某行插入 T1 时，触发器被激发，并在 T2 中插入一行。 该方案演示了两个作用域：在 T1 上的插入，以及在 T2 通过触发器的插入。

--假设 T1 和 T2 都有标识列，@@IDENTITY 和 SCOPE_IDENTITY 将在 T1 上的 INSERT 语句的最后返回不同的值。@@IDENTITY 将返回在当前会话中的任何作用域内插入的最后一个标识列的值。这是在 T2 中插入的值。SCOPE_IDENTITY() 将返回在 T1 中插入的 IDENTITY 值。这是在同一个作用域内发生的最后的插入。如果在任何 INSERT 语句作用于作用域中的标识列之前调用 SCOPE_IDENTITY() 函数，则该函数将返回空值。
