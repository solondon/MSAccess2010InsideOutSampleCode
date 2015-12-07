-- Error handling
use Northwind
GO

CREATE PROC usp_NumericalError
AS
DECLARE @TotalValue As DECIMAL(10,2)
SET @TotalValue = 6 /0
-- Execution will now continue
IF @@ERROR <> 0
	PRINT 'Error processing logic'
GO
Exec usp_NumericalError
GO

USE master
GO
EXEC sp_addmessage 50001, 16, 'TestErrorMessage'
GO
USE Northwind
GO
CREATE PROC usp_RaiseCustomError @TotalValue As DECIMAL(10,2)
AS
DECLARE @ProcName AS nvarchar(126)
DECLARE @ParamValue As nvarchar(50)
IF @TotalValue < 100
BEGIN
	SET @ProcName = ERROR_PROCEDURE()
	SET @ParamValue = CONVERT(NVARCHAR,@TotalValue)
	RAISERROR (50001,
		16,				-- Severity.
		1,				-- State.
		@ProcName,		-- First argument
		@ParamValue);	-- Second argument.
END
GO
Exec usp_RaiseCustomError 10.5
GO
CREATE PROC usp_MainRoutine 
AS
BEGIN TRY
    -- Execute our stored procedure
    EXECUTE usp_NumericalError
    SELECT 0,0,0,'','',0
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;
END CATCH
GO

Exec usp_MainRoutine 
GO
