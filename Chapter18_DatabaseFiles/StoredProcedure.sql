Use [Northwind]
GO

CREATE PROC usp_CountOrdersByDate2 @Thedate DATETIME,
				       @OrderCount INT OUTPUT
AS
BEGIN
	SET @OrderCount = (SELECT COUNT(*) FROM Orders
	WHERE RequiredDate = @Thedate)
	RETURN(-1)
END
GO
-- Testing
DECLARE @OC INT
DECLARE @RV INT
exec @RV = usp_CountOrdersByDate2 '16 August 1996', @OC OUTPUT
-- Alternative without the return value
-- exec usp_CountOrdersByDate2 '16 August 1996', @OC OUTPUT
Print @oc 
Print @RV
GO

CREATE PROC usp_MarsFeature @Thedate DATETIME
AS
BEGIN
	SELECT * FROM Orders WHERE RequiredDate = @Thedate
	
	SELECT * FROM [Order Details]
	INNER JOIN Orders 
		ON [Order Details].OrderID = orders.OrderID
	WHERE RequiredDate = @Thedate
END
GO
exec usp_MarsFeature '16 August 1996'
go