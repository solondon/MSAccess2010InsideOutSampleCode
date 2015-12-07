-- Examples of program flow
USE Northwind
Go

-- IF Statement
DECLARE @Country As NVARCHAR(50)
SET @Country = 'usa'
IF EXISTS(SELECT CustomerID FROM Customers
          WHERE Country = @Country)
BEGIN
	PRINT 'We have ' + @Country + ' customers'
	SELECT * FROM Customers WHERE Country = @Country
END
ELSE
BEGIN
	PRINT 'We do not have any customers for ' + @Country
END
GO

DECLARE @Country As NVARCHAR(50)
DECLARE @CustCount As INT
SET @Country = 'usa'
SET @CustCount = (SELECT Count('*') FROM Customers
					WHERE Country = @Country)
IF @CustCount > 0
	SELECT * FROM Customers WHERE Country = @Country
ELSE
	PRINT 'We do not have any customers for ' + @Country
GO

-- While Loop
CREATE TABLE MessagesToProcess(
MsgId		INT IDENTITY(1,1) PRIMARY KEY,
Country		NVARCHAR(100)
)
GO
INSERT INTO MessagesToProcess(Country)
VALUES ('USA'),('UK')
GO
DECLARE @Country As NVARCHAR(100)
DECLARE @MsgId INT
WHILE EXISTS(SELECT MsgId FROM MessagesToProcess)
BEGIN
	SELECT @MsgId = MsgID, @Country = Country 
	FROM MessagesToProcess
	-- Process the message
	SELECT * FROM Customers WHERE Country = @Country
	-- The break statement is useful during testing
	--BREAK
	DELETE FROM MessagesToProcess WHERE MsgId = @MsgId
END
GO
-- Alternative code
DECLARE @Country As NVARCHAR(100)
DECLARE @MsgId INT
DECLARE @RowsToProcess As Int
SET @RowsToProcess = (SELECT COUNT(*) FROM MessagesToProcess)
WHILE (@RowsToProcess > 0)
BEGIN
	SELECT @MsgId = MsgID, @Country = Country 
	FROM MessagesToProcess
	-- Process the message
	SELECT * FROM Customers WHERE Country = @Country
	-- The break statement is useful during testing
	--BREAK
	DELETE FROM MessagesToProcess WHERE MsgId = @MsgId
	SET @RowsToProcess = (SELECT COUNT(*) FROM MessagesToProcess)
END
GO