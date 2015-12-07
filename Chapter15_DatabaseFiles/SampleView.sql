USE Northwind
Go
CREATE VIEW vw_CustomersForUSA 
AS
	SELECT * FROM Customers
	WHERE Country = 'USA'
	WITH CHECK OPTION
GO