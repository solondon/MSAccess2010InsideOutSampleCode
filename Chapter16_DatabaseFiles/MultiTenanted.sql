USE NorthwindMultiple
GO
-- Tables Schema for holding user specific information
CREATE SCHEMA [Filtering_T]
GO
-- Table holding User specific choices
CREATE TABLE [Filtering_T].[Filter](
	[UserId] INT IDENTITY(1,1) PRIMARY KEY, 
	[UserName] nvarchar(255) NOT NULL
	DEFAULT SUSER_SNAME(),
	[TenantID] INT NOT NULL,
	-- List other useful user specific fields here
	[CustomerID] nvarchar(5)
	)
GO
-- Schema for using user specific information
CREATE SCHEMA [Filtering]
GO
-- User specific view returning 1 row
CREATE VIEW [Filtering].[Filter_VW]
AS
-- User only gets to see other user specific choices
SELECT [CustomerID] FROM [Filtering_T].Filter
WHERE [UserName] = SUSER_SNAME()
WITH CHECK OPTION
GO
-- Synonym to ref to users choices
CREATE SYNONYM [Filter] FOR [Filtering].Filter_VW
GO
-- Create an example record for current user
INSERT INTO Filtering_T.Filter(TenantID)
VALUES(1)
GO
SELECT * FROM Filter
GO
SELECT * FROM Filtering_T.Filter
GO
-- Next we would need 
SELECT * FROM [Filtering_T].[Filter]
GO
-- Create a function to filter by the Tenant
CREATE FUNCTION dbo.fn_GetTenant()
RETURNS INT
AS
BEGIN
	RETURN (SELECT [TenantID] FROM [Filtering_T].Filter
			WHERE [UserName] = SUSER_SNAME())
END
GO
-- Test the function
SELECT dbo.fn_GetTenant()
GO
-- Tables schema for information on companies
CREATE SCHEMA [Companies_T]
GO
-- Table holding customer information
CREATE TABLE [Companies_T].[Customers](
	[TenantID] INT NOT NULL DEFAULT dbo.fn_GetTenant(), 
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL
	CONSTRAINT pk_Customers 
	PRIMARY KEY ([TenantID],[CustomerID])
	)
GO
-- Trigger to ensure data correctly marked for the Tenant
CREATE TRIGGER TR_Customers_TenantCheck 
ON [Companies_T].[Customers]
FOR UPDATE,INSERT
AS
-- Prevent any manual changes to TenantID
IF EXISTS(SELECT TenantID FROM INSERTED
WHERE TenantID <> dbo.fn_GetTenant())
	ROLLBACK TRANSACTION
GO
-- Schema for using company information
CREATE SCHEMA [Companies]
GO
-- Restricted view showing only the users companies
CREATE VIEW [Companies].[Customers_VW]
AS
SELECT * FROM [Companies_T].[Customers]
WHERE [TenantID] = dbo.fn_GetTenant()
WITH CHECK OPTION
GO
--Synonym to refer to Customers
CREATE SYNONYM [Customers] FOR [Companies].[Customers_VW]
GO
-- Test data for an insert
INSERT INTO Customers(CustomerID,CompanyName)
VALUES('TT','Test Company')
GO
SELECT * FROM Customers
GO
-- Attempt an illegal insert, this should fail
INSERT INTO Customers(CustomerID,CompanyName,TenantID)
VALUES('TT2','Test Company2',2)
GO

-- Example adding user specific choices
UPDATE Filter
SET CustomerID = 'TT'
GO

-- Example filtering by the users choices
SELECT * 
FROM Customers
WHERE CustomerID = (SELECT CustomerID FROM Filter)
GO
-- Example using a cross joing, useful for multiple filters
SELECT c.* 
FROM Customers c
	CROSS JOIN Filter f
WHERE c.CustomerID = f.CustomerID
GO
-- Example making the filter optional
UPDATE Filter
SET CustomerID = NULL
GO
SELECT c.* 
FROM Customers c
	CROSS JOIN Filter f
WHERE c.CustomerID = COALESCE(f.CustomerID,c.CustomerID)
GO
-- Example making filter optional
-- and allowing for null values
SELECT c.* 
FROM Customers c
	CROSS JOIN Filter f
WHERE COALESCE(c.CustomerID,' ') = COALESCE(f.CustomerID,c.CustomerID,' ')
GO

-- Adding a related table
-- Table holding project information
CREATE TABLE [Companies_T].[Projects](
	[TenantID] INT NOT NULL DEFAULT dbo.fn_GetTenant(), 
	[ProjectID] INT IDENTITY(1,1) NOT NULL,
	[ProjectName] [nvarchar](40) NOT NULL,
	[CustomerID] [nchar](5) NOT NULL
	CONSTRAINT pk_Projects 
	PRIMARY KEY ([TenantID],[ProjectID])
	)
GO
-- Adding the Foreign Key Constraint
ALTER TABLE [Companies_T].[Projects]  
WITH CHECK ADD  
CONSTRAINT [FK_Projects_Customers] 
FOREIGN KEY([TenantID], [CustomerID])
REFERENCES [Companies_T].[Customers] ([TenantID], [CustomerID])
GO

-- Managing Security
CREATE ROLE ReadOnlyUser
GO
GRANT SELECT 
ON SCHEMA::Companies TO ReadOnlyUser
GO
GRANT SELECT,INSERT,UPDATE 
ON SCHEMA::Filtering TO ReadOnlyUser
GO
--------------------------------------
CREATE ROLE StandardUser
GO
GRANT SELECT,INSERT,UPDATE,DELETE 
ON SCHEMA::Companies TO StandardUser
GO
GRANT SELECT,INSERT,UPDATE 
ON SCHEMA::Filtering TO StandardUser
GO
--------------------------------------
CREATE ROLE Administrator
GO
GRANT SELECT,INSERT,UPDATE,DELETE 
ON SCHEMA::Companies TO Administrator
GO
GRANT SELECT,INSERT,UPDATE,DELETE 
ON SCHEMA::Companies_T TO Administrator
GO
GRANT SELECT,INSERT,UPDATE, DELETE 
ON SCHEMA::Filtering TO Administrator
GO
GRANT SELECT,INSERT,UPDATE,DELETE 
ON SCHEMA::Filtering_T TO Administrator
GO
---------------------------------------
sp_addrolemember 'ReadOnlyUser', 'TestLogin'
GO

