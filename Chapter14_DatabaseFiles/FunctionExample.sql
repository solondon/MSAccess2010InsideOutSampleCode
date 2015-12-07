USE Northwind
GO
SELECT [UnitPrice], [Quantity], 
		LineTotal= [UnitPrice]*[Quantity],
		SalesTax = [LineTotal] * 0.20,
		Total = [SalesTax] + [LineTotal]
FROM [Order Details]
GO
SELECT [UnitPrice], [Quantity], 
		LineTotal= [UnitPrice]*[Quantity],
		SalesTax = [UnitPrice]*[Quantity] * 0.20,
		Total = [UnitPrice]*[Quantity]* 1.2
FROM [Order Details]
GO
CREATE FUNCTION ufn_SalesTax(@LineValue DECIMAL(10,2))
	RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN(@LineValue * 0.2)
END
GO
SELECT [UnitPrice], [Quantity], 
		LineTotal= [UnitPrice]*[Quantity],
		SalesTax = dbo.ufn_SalesTax([UnitPrice]*[Quantity]),
		Total = [UnitPrice]*[Quantity] + dbo.ufn_SalesTax([UnitPrice]*[Quantity])
FROM [Order Details]
GO



