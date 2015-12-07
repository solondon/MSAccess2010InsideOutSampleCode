USE [Northwind]
Go

-- Inline User Defined Function
CREATE FUNCTION ufn_CustomersInACity
                 ( @City nvarchar(15) )
RETURNS table
AS
RETURN (
        SELECT * FROM Customers
        WHERE City = @City
       )
GO

SELECT * FROM ufn_CustomersInACity('London')
GO
