USE [Northwind]
GO
-- Create a stored procedure
CREATE PROC usp_UpdateCustomersRating
AS
UPDATE Customers
SET Rating = 1
GO
-- Execute the stored procedure
 usp_UpdateCustomersRating
 GO
 -- Alternative syntax for executing the stored procedure
 EXEC usp_UpdateCustomersRating
 GO
 -- Changing the stored procedure
ALTER PROC usp_UpdateCustomersRating
AS
UPDATE Customers
SET Rating = 5
GO
-- Delete the stored procedure
DROP PROC usp_UpdateCustomersRating
GO
