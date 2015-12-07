USE [AccessInsideOut]
GO

CREATE PROC usp_Proc1 @BatchLogId INT
AS
BEGIN
	-- Wait for a delay to simulate
	-- a batch running
	WAITFOR DELAY '00:00:15';
	SELECT @BatchLogId AS ReturnInfo
END
GO

CREATE PROC usp_Proc2 @BatchLogId INT
AS
BEGIN
	-- Wait for a delay to simulate
	-- a batch running
	WAITFOR DELAY '00:00:15';
	SELECT @BatchLogId AS ReturnInfo
END
GO