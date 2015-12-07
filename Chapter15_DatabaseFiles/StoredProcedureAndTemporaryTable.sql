USE Northwind
GO

CREATE PROC usp_Products
AS
BEGIN
-- Drop temporary tables if they exists
IF object_id('tempdb..#TempProducts') is not null
    DROP TABLE #TempProducts
    
-- create the temporary results set
	SELECT * INTO #TempProducts
	FROM Products
-- return the temporary result set
	SELECT * from #TempProducts
END
GO

exec usp_Products