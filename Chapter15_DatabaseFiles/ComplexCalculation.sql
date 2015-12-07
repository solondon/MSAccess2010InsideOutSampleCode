USE Northwind
GO

-- Access query which will not work
SELECT 
	[Order Details].OrderID, 
	[Order Details].ProductID, 
	[UnitPrice]*[Quantity] AS LinePrice, 
	[LinePrice]*0.2 AS LineItemTax, 
	[LinePrice]+[LineItemTax] AS FullPrice
FROM [Order Details]
GO
-- Restating the calculations
SELECT 
	[Order Details].OrderID, 
	[Order Details].ProductID, 
	[UnitPrice]*[Quantity] AS LinePrice, 
	([UnitPrice]*[Quantity])*0.2 AS LineItemTax, 
	[UnitPrice]*[Quantity]+
	([UnitPrice]*[Quantity])*0.2 AS FullPrice
FROM [Order Details]
GO
-- using functions
CREATE FUNCTION fn_CalculateLinePrice(@Quantity INT, 
									  @Price MONEY)
RETURNS
	DECIMAL(16,4)
AS
BEGIN
	RETURN(@Quantity * @Price)
END
GO
CREATE FUNCTION fn_CalculateTax(@Quantity INT, 
									  @Price MONEY)
RETURNS
	DECIMAL(16,4)
AS
BEGIN
	RETURN(@Quantity * @Price *0.2)
END
GO
SELECT 
	[Order Details].OrderID, 
	[Order Details].ProductID, 
	dbo.fn_CalculateLinePrice([Quantity],[UnitPrice]) AS LinePrice, 
	dbo.fn_CalculateTax([Quantity],[UnitPrice]) AS LineItemTax,  
	dbo.fn_CalculateTax([Quantity],[UnitPrice]) +
	dbo.fn_CalculateLinePrice([Quantity],[UnitPrice]) AS FullPrice
FROM [Order Details]
GO
-- using a nested query
SELECT
	LinePrice,
	LineItemTax,
	LinePrice + LinePrice AS FullPrice
	FROM
		(SELECT LinePrice, LinePrice* 0.2 AS LineItemTax
		FROM 
			(SELECT 	
			[UnitPrice]*[Quantity] AS LinePrice
			FROM [Order Details] 
			) As Nested1
		) As Nested2
GO


