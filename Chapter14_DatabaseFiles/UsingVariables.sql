USE Northwind
GO

-- Using variables

DECLARE @CustomerCount INT
DECLARE @EmployeeCount As INT
-- Setting an explicit value for a variable
SET @CustomerCount = 99
-- Using the SET command with SQL to load a variable
-- note the brackets are required
SET @EmployeeCount = (SELECT COUNT(*) FROM Employees)
-- Using the SELECT command with SQL to load a variable
SELECT @EmployeeCount = COUNT(*) FROM Employees
-- Printing out a value
PRINT @CustomerCount
-- Printing out a message
PRINT 'Employee count is ' + CONVERT(VARCHAR,@EmployeeCount)
GO

-- Example using a variable in a where clause
DECLARE @Country As NVARCHAR(30)
SET @Country = 'USA'
SELECT * FROM Customers
WHERE Country = @Country
GO
DECLARE @MinCount As INT
SET @MinCount = 10
SELECT Country,COUNT(*)
FROM Customers
GROUP BY Country
HAVING Count(*) > @MinCount
GO

-- Example executing an SQL String
DECLARE @Cmd As NVARCHAR(255)
DECLARE @TableName As NVARCHAR(100)
SET @TableName = 'Customers'
SET @Cmd = 'SELECT * FROM ' + @TableName
PRINT @Cmd
EXEC (@Cmd)
GO


