-- Examples using System variables
USE Northwind
GO

-- @@Version
CREATE PROC usp_GetSQLServerVersion
AS
SELECT @@VERSION as 'SQLServerVersion'
GO
EXEC usp_GetSQLServerVersion
GO

-- @@IDENTITY
CREATE TABLE InsertTest(
AnID INT IDENTITY(1,1),
Comment nvarchar(30)
)
GO
INSERT INTO InsertTest(Comment)
VALUES ('Test Record')
GO
SELECT @@IDENTITY
GO
SELECT SCOPE_IDENTITY()
GO
SELECT IDENT_CURRENT('InsertTest')
GO
CREATE PROC usp_LastIdentity @TableName VARCHAR(255)
AS
EXEC ('SELECT IDENT_CURRENT(''' + @TableName + ''')')
GO
EXEC usp_LastIdentity 'InsertTest'
GO



