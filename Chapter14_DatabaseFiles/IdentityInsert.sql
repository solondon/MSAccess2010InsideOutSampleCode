-- Example using the IDENTITY property
USE Northwind
GO

CREATE TABLE DataList(
AnID	INT IDENTITY(1,1) PRIMARY KEY,
Comments nvarchar(255)
)
GO
SET IDENTITY_INSERT DataList ON
GO
-- Insert into the autonumber field
INSERT INTO DataList(AnID,Comments)
VALUES(999,'Sample record')
GO
SELECT * FROM DataList
GO
SET IDENTITY_INSERT DataList OFF
GO
