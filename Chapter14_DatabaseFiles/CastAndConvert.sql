USE Northwind
GO

SELECT CompanyName + ' : ' 
				   + CAST(COUNT(*) AS nvarchar(10)) as Orders
FROM Customers c
	INNER JOIN Orders o
		ON c.CustomerID = o.CustomerID
GROUP BY CompanyName
GO
SELECT CompanyName + ' : ' 
				   + CONVERT(nvarchar(10),COUNT(*)) as Orders
FROM Customers c
	INNER JOIN Orders o
		ON c.CustomerID = o.CustomerID
GROUP BY CompanyName
GO
DECLARE @Total Int
SELECT @Total = COUNT(*) FROM Customers
PRINT 'Total Customers ' + CONVERT(nvarchar(10),@Total)
GO