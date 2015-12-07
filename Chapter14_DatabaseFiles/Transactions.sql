USE Northwind
GO
-- Examples of working with transactions

-- Start by creating a data table to work with
SELECT * INTO tblCompanies FROM Customers
GO
PRINT @@TRANCOUNT
-- Expect 0 for 0 open transactions
BEGIN TRAN
PRINT @@TRANCOUNT
-- Expect 1 for 1 open transaction
UPDATE tblCompanies SET ContactName = 'Test'
SELECT * FROM tblCompanies
COMMIT TRAN
SELECT * FROM tblCompanies
PRINT @@TRANCOUNT
-- Expect 0 for 0 open transaction

BEGIN TRAN
PRINT @@TRANCOUNT
-- Expect 1 for 1 open transaction
UPDATE tblCompanies SET ContactName = 'Test Rollback'
SELECT * FROM tblCompanies
ROLLBACK TRAN
SELECT * FROM tblCompanies
PRINT @@TRANCOUNT
-- Expect 0 for 0 open transaction

/*
SET TRANSACTION ISOLATION LEVEL
    { READ UNCOMMITTED
    | READ COMMITTED
    | REPEATABLE READ
    | SNAPSHOT
    | SERIALIZABLE}
*/

-- Handling a Rollback from a nested transaction
CREATE PROC usp_ForceRollback
AS
BEGIN
	-- Transcation started
	BEGIN TRAN
	-- The following action would be conditional
	ROLLBACK TRAN
END
GO

-- Transaction test
	BEGIN TRAN
	PRINT @@TRANCOUNT
	EXEC usp_ForceRollback
	IF @@TRANCOUNT > 0
		COMMIT TRAN


-- Handling a Rollback generated from a trigger
CREATE TRIGGER Tr_TestRollBack ON tblCompanies
FOR DELETE
AS
BEGIN
	-- prevent any deletes
	ROLLBACK TRAN
END
GO

-- Test processing
-- Execute this as  a block of code
PRINT 'Program Running'
DELETE FROM tblCompanies
PRINT 'Code is still running'
GO


