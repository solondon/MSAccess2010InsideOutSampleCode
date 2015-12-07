-- Script file ViewsAndRefreshView.SQL
-- make sure we are in the correct database
USE NorthwindTesting
GO
-- Create a view
CREATE View vw_Customers
AS
SELECT * FROM Customers
GO
-- Display the results
SELECT * FROM vw_Customers
GO
-- Add a new field
ALTER TABLE Customers 
ADD NewComments NVARCHAR(100)
GO
-- The new field will NOT be shown
SELECT * FROM vw_Customers
GO
-- Refresh the view
sp_refreshview vw_Customers
GO
-- The new field will be shown
SELECT * FROM vw_Customers
GO
-- List objects dependent on this view
-- and objects this view depends upon
sp_depends vw_Customers
GO
-- List objects dependent on the table
sp_depends Customers
GO