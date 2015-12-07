USE Northwind
GO


-- Example Schema
CREATE SCHEMA [Companies] AUTHORIZATION [dbo]
GO
-- Example Creating a table on a Schema
CREATE Table [Companies].[Company](
CompanyID	INT IDENTITY(1,1),
CompanyName	NVARCHAR(100)
)
GO
SELECT * FROM [Companies].[Company]
GO
CREATE SYNONYM [dbo].[Company] 
FOR [Companies].[Company]
GO
SELECT * FROM [Company]
GO

-- Example moving an object onto a Schema
ALTER SCHEMA Companies TRANSFER dbo.Customers
GO
CREATE SYNONYM [dbo].[Customers] 
FOR [Companies].[Customers]
GO

SELECT * FROM sys.tables
GO
sp_tables
GO




