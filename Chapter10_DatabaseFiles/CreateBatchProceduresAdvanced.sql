USE [AccessInsideOut]
GO

CREATE TABLE Investigate_SPExecution(
ID	INT	IDENTITY(1,1) PRIMARY KEY,
ProcName	VARCHAR(20),
ProcTime	DATETIME DEFAULT GetDate()
)

GO
ALTER PROC usp_Proc1 @BatchLogId INT
AS
BEGIN
	-- Wait for a delay to simulate
	-- a batch running
	WAITFOR DELAY '00:00:10';
	INSERT INTO Investigate_SPExecution(ProcName)
	VALUES('usp_Proc1')
	WAITFOR DELAY '00:00:10';
	INSERT INTO Investigate_SPExecution(ProcName)
	VALUES('usp_Proc1')
	SELECT @BatchLogId AS ReturnInfo
END
GO

ALTER PROC usp_Proc2 @BatchLogId INT
AS
BEGIN
	-- Wait for a delay to simulate
	-- a batch running
	WAITFOR DELAY '00:00:10';
	INSERT INTO Investigate_SPExecution(ProcName)
	VALUES('usp_Proc2')
	WAITFOR DELAY '00:00:10';
	INSERT INTO Investigate_SPExecution(ProcName)
	VALUES('usp_Proc2')
	SELECT @BatchLogId AS ReturnInfo
END
GO


SELECT * FROM Investigate_SPExecution
