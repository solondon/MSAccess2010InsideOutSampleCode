use [Northwind]
GO

CREATE PROC usp_OrdersByDate @Thedate DATETIME
AS
BEGIN
	SELECT * FROM Orders
	WHERE RequiredDate = @Thedate
END
GO
-- Testing
exec usp_OrdersByDate '1996-08-16'
GO
exec usp_OrdersByDate '16 August 1996'
GO

CREATE PROC usp_CountOrdersByDate @Thedate DATETIME
AS
BEGIN
	SELECT COUNT(*) FROM Orders
	WHERE RequiredDate = @Thedate
END
GO
-- Testing
exec usp_CountOrdersByDate '16 August 1996'
go

CREATE PROC usp_CountOrdersByDate2 @Thedate DATETIME,
								   @OrderCount INT OUTPUT
AS
BEGIN
	SET @OrderCount = (SELECT COUNT(*) FROM Orders
	WHERE RequiredDate = @Thedate)
END
GO
-- Testing
DECLARE @OC INT
exec usp_CountOrdersByDate2 '16 August 1996', @OC OUTPUT
Print @oc
GO





