IF DB_ID('testdb') IS NULL 
	CREATE	 DATABASE testdb;
GO 


USE testdb;

IF OBJECT_ID('dbo.Employee','U') IS NOT NULL
	DROP TABLE dbo.Employee;

CREATE TABLE dbo.Employee(
 empid INT NOT NULL,
 firstname VARCHAR(30) NOT NULL,
 lastname VARCHAR(30) NOT NULL,
 hiredate DATE NULL,
 mgrid INT	NULL,
 ssn VARCHAR(20) NOT NULL,
 salary MONEY NOT NULL

);

-- Primary key

ALTER TABLE dbo.Employee
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY(empid);

-- Unique

ALTER	TABLE dbo.Employee
	ADD CONSTRAINT UNQ_Employee_ssh
	UNIQUE(ssn);


IF OBJECT_ID('dbo.Orders','U') IS NOT NULL
	DROP	TABLE dbo.Orders;

CREATE TABLE	dbo.Orders
(
  orderid INT NOT NULL,
  empid INT NOT NULL,
  custid VARCHAR(10) NOT NULL	,
  orderts DATETIME NOT NULL,
  qty INT NOT NULL,
  CONSTRAINT PK_Orders
	PRIMARY KEY(orderid)
);


ALTER TABLE dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employee(empid);

ALTER TABLE dbo.Employee
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employee(empid)


ALTER TABLE	dbo.Employee
	ADD CONSTRAINT CHK_Employees_salary
	CHECK(salary > 0);


ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFT_Orders_orderts
	DEFAULT(CURRENT_TIMESTAMP) FOR	orderts;
	