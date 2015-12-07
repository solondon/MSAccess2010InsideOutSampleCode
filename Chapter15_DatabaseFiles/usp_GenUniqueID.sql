USE [Northwind]
GO

/****** Object:  Trigger [dbo].[T_Customers2_ITrig]    Script Date: 04/06/2011 20:58:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[T_Customers2_ITrig] ON [dbo].[Customers2] 
FOR INSERT AS
SET NOCOUNT ON
DECLARE @randc int, @newc int    /* FOR AUTONUMBER-EMULATION CODE */
/* * RANDOM AUTONUMBER EMULATION CODE FOR FIELD 'NewId' */
SELECT @randc = (SELECT convert(int, rand() * power(2, 30)))
SELECT @newc = (SELECT NewId FROM inserted) 
UPDATE Customers2 SET NewId = @randc WHERE NewId = @newc

GO

-- This will not work
CREATE FUNCTION usp_GenUniqueID()
RETURNS int
AS
BEGIN
	DECLARE @randc INT
	SELECT @randc = (SELECT convert(int, rand() * power(2, 30)))
	RETURN (@randc)
END
GO
-- Create the view
CREATE VIEW vw_Rand
AS
	SELECT convert(int, rand() * power(2, 30)) As RandomSeed
GO
-- This will work
CREATE FUNCTION usp_GenUniqueID()
RETURNS int
AS
BEGIN
	RETURN (SELECT * FROM vw_Rand)
END
GO
-- Drop the trigger
DROP Trigger T_Customers2_ITrig
GO
-- drop the default, your default name would be different to this example
ALTER TABLE [dbo].[Customers2] 
DROP CONSTRAINT [DF__Customers__NewId__2C3393D0]
GO

ALTER TABLE [dbo].[Customers2] ADD  
CONSTRAINT def_Customers2_NewID
DEFAULT dbo.usp_GenUniqueID() FOR [NewId]
GO

INSERT INTO Customers2(CompanyName)
VALUES('Test'), ('Test2')
GO

