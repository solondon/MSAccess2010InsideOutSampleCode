Use Northwind
GO
-- Create a test table
SELECT * INTO TestOrders 
FROM Orders
GO
-- display any indexing on the table
sp_helpIndex [TestOrders]
GO
-- This should confirm that we have no indexes
SELECT *
FROM TestOrders
GO
-- Next create a clustered index
CREATE CLUSTERED INDEX idxTestOrdersClustered
ON TestOrders(OrderID)
GO

SELECT *
FROM TestOrders
GO

SELECT *
FROM TestOrders
WHERE OrderID between 10252 and 10254
GO

CREATE INDEX idx_TestOrders_OrderDate
ON TestOrders(OrderDate)
GO

SELECT *
FROM TestOrders
WHERE OrderDate = '3 september 1996'
GO

SELECT OrderID
FROM TestOrders
WHERE OrderDate = '3 september 1996'
GO